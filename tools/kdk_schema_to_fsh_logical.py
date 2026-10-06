#!/usr/bin/env python3
"""Konvertiert die BfArM-KDK JSON-Schemas (Draft 2020-12) in quelltreue
FSH Logical Models, die als StructureMap-QUELLE (KDK -> MII KDS) dienen.

Aufruf:
  python3 tools/kdk_schema_to_fsh_logical.py <SCHEMA_DIR> <OUT_DIR>

<SCHEMA_DIR> = .../MVGenomseq_KDK-2.3/KDK  (enthält Oncology.json, RareDiseases.json,
Submission.json, data-types/). Erzeugt je Wurzelschema eine .fsh-Datei.

Bewusst pragmatisch: deckt die KDK-Schemapatterns ab (object/array/enum/$ref/allOf,
data-types Coding/Identifier/Substance). Kein vollständiger JSON-Schema-Compiler.
"""
import json, os, re, sys

SCALAR = {"string": "string", "boolean": "boolean", "integer": "integer", "number": "decimal"}

def clean(s, maxlen=220):
    if not s: return ""
    s = re.sub(r"\s+", " ", str(s)).strip().replace('"', "'")
    return s[:maxlen]

class Gen:
    def __init__(self, schema_dir):
        self.dir = schema_dir
        self.cache = {}

    def load(self, name):
        if name not in self.cache:
            with open(os.path.join(self.dir, name), encoding="utf-8") as f:
                self.cache[name] = json.load(f)
        return self.cache[name]

    def ref_parts(self, ref):
        """(dateiname|None, json_pointer|None). Interner Pointer -> (None, ptr)."""
        filepart, frag = (ref.split("#", 1) + [None])[:2]
        name = None
        if filepart:
            m = re.search(r"/KDK/(.+\.json)", filepart)
            name = m.group(1) if m else filepart.split("/")[-1]
        return name, frag

    def deref_pointer(self, doc, pointer):
        cur = doc
        for tok in pointer.strip("/").split("/"):
            if tok == "": continue
            tok = tok.replace("~1", "/").replace("~0", "~")
            cur = cur[tok]
        return cur

    def resolve(self, node, doc):
        """allOf zusammenführen + $ref (extern/intern) auflösen.
        -> (schema_dict, ref_dateiname|None, doc_kontext)."""
        if "$ref" in node:
            name, frag = self.ref_parts(node["$ref"])
            if name:                      # externe Datei (ggf. mit Fragment)
                newdoc = self.load(name)
                target = self.deref_pointer(newdoc, frag) if frag else newdoc
                return target, name, newdoc
            target = self.deref_pointer(doc, frag)   # interner Pointer
            return self.resolve(target, doc)
        if "allOf" in node:
            merged, refname, ctx = {}, None, doc
            for part in node["allOf"]:
                sub, rn, subdoc = self.resolve(part, doc)
                if rn: refname, ctx = rn, subdoc
                self._merge(merged, sub)
            self._merge(merged, {k: v for k, v in node.items() if k != "allOf"})
            return merged, refname, ctx
        return node, None, doc

    @staticmethod
    def _merge(merged, sub):
        for k, v in sub.items():
            if k == "properties":
                merged.setdefault("properties", {}).update(v)
            elif k == "required":
                merged.setdefault("required", []).extend(v)
            else:
                merged.setdefault(k, v)

    def fhir_type(self, refname):
        base = os.path.basename(refname)
        if base == "Coding.json": return "Coding"
        if base == "Identifier.json": return "string"   # KDK Identifier ist type:string
        return None  # Substance u.a. -> als BackboneElement rekursiv

    def emit(self, path, prop, schema, required, lines, depth, doc):
        if depth > 12:
            return
        node, refname, ctx = self.resolve(schema, doc)
        typ = node.get("type")
        card_min = 1 if required else 0
        desc = clean(node.get("description") or schema.get("description") or prop)
        short = clean(prop, 60)

        # data-type Kurzschluss (Coding/Identifier)
        if refname:
            ft = self.fhir_type(refname)
            if ft:
                lines.append(f'* {path} {card_min}..1 {ft} "{short}" "{desc}"')
                return

        if typ == "array":
            items = node.get("items", {})
            inode, irefname, ictx = self.resolve(items, ctx)
            ift = self.fhir_type(irefname) if irefname else None
            itype = SCALAR.get(inode.get("type"))
            if inode.get("enum"): itype = "code"
            if ift:
                lines.append(f'* {path} {card_min}..* {ift} "{short}" "{desc}"')
            elif itype:
                lines.append(f'* {path} {card_min}..* {itype} "{short}" "{desc}"')
            else:
                # Array von Objekten -> BackboneElement + Kinder
                lines.append(f'* {path} {card_min}..* BackboneElement "{short}" "{desc}"')
                self.emit_props(path, inode, lines, depth + 1, ictx)
            return

        if typ == "object" or "properties" in node:
            lines.append(f'* {path} {card_min}..1 BackboneElement "{short}" "{desc}"')
            self.emit_props(path, node, lines, depth + 1, ctx)
            return

        if node.get("enum"):
            lines.append(f'* {path} {card_min}..1 code "{short}" "{desc}"')
            return

        ftype = SCALAR.get(typ, "string")
        if typ == "string" and node.get("format") in ("date",):
            ftype = "date"
        elif typ == "string" and node.get("format") in ("date-time",):
            ftype = "dateTime"
        lines.append(f'* {path} {card_min}..1 {ftype} "{short}" "{desc}"')

    def emit_props(self, base, node, lines, depth, doc):
        props = node.get("properties", {})
        req = set(node.get("required", []))
        for name, sub in props.items():
            safe = re.sub(r"[^A-Za-z0-9]", "", name)
            path = f"{base}.{safe}" if base else safe
            self.emit(path, name, sub, name in req, lines, depth, doc)

    def generate(self, root_file, model_id, title, description):
        root = self.load(root_file)
        node, _, ctx = self.resolve(root, root)
        lines = [
            f"Logical: {model_id}",
            f"Id: {to_id(model_id)}",
            f'Title: "{title}"',
            f'Description: "{description}"',
            "* ^status = #draft",
        ]
        self.emit_props("", node, lines, 0, ctx)
        return "\n".join(lines) + "\n"

def to_id(name):
    s = re.sub(r"([a-z0-9])([A-Z])", r"\1-\2", name).lower()
    return re.sub(r"[^a-z0-9-]", "-", s)

def main():
    schema_dir, out_dir = sys.argv[1], sys.argv[2]
    os.makedirs(out_dir, exist_ok=True)
    g = Gen(schema_dir)
    jobs = [
        ("Oncology.json", "KdkOncologyModel", "KDK Onkologie – Quellmodell (BfArM MVGenomSeq)",
         "Quelltreues Logical Model der KDK-Onkologie-Einreichung (BfArM MVGenomSeq, Schema v2.3). Quelle fuer StructureMaps KDK -> MII KDS."),
        ("RareDiseases.json", "KdkRareDiseasesModel", "KDK Seltene Erkrankungen – Quellmodell (BfArM MVGenomSeq)",
         "Quelltreues Logical Model der KDK-Seltene-Erkrankungen-Einreichung (BfArM MVGenomSeq, Schema v2.3). Quelle fuer StructureMaps KDK -> MII KDS."),
        ("Submission.json", "KdkSubmissionMetaData", "KDK Submission/MetaData – Quellmodell (BfArM MVGenomSeq)",
         "Quelltreues Logical Model der KDK-Submission-Metadaten (metaData). Quelle fuer StructureMap metaData -> MII Person + Consent."),
    ]
    for root_file, mid, title, desc in jobs:
        fsh = g.generate(root_file, mid, title, desc)
        out = os.path.join(out_dir, mid + ".fsh")
        with open(out, "w", encoding="utf-8") as f:
            f.write(fsh)
        print(f"  {mid}: {fsh.count(chr(10))} Zeilen -> {out}")

if __name__ == "__main__":
    main()
