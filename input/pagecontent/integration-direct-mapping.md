# Ansatz 1: Direktes Mapping von MVGENOMSEQ zu FHIR

## Übersicht

Der direkte Mapping-Ansatz transformiert die MVGENOMSEQ JSON-Strukturen direkt in native FHIR-Ressourcen. Dieser Ansatz nutzt die bestehenden Profile der Medizininformatik-Initiative (MII) und erstellt spezifische Mappings zwischen MVGENOMSEQ-Datenfeldern und FHIR-Elementen.

## Architekturprinzipien

### Basisprinzipien
1. **Nutzung von MII-Profilen**: Maximale Wiederverwendung bestehender deutscher FHIR-Profile
2. **Semantische Treue**: Erhaltung der klinischen Bedeutung bei der Transformation
3. **Bidirektionalität**: Möglichkeit der Rücktransformation von FHIR zu MVGENOMSEQ
4. **Validierung**: Beide Standards werden vollständig validiert

## Detailliertes Mapping

### KDK-Onkologie Mapping

#### Fall-Daten (Case Data)
MVGENOMSEQ JSON-Struktur → FHIR-Ressourcen

**Patient**
```json
// MVGENOMSEQ KDK
{
  "patientenId": "12345",
  "geburtsdatum": "1970-01-01",
  "geschlecht": "M"
}
```

Wird gemappt zu:
```
// FHIR Patient (MII KDS Person)
* identifier.value = "12345"
* birthDate = "1970-01-01"
* gender = #male
* meta.profile = "https://www.medizininformatik-initiative.de/fhir/core/modul-person/StructureDefinition/Patient"
```

**Diagnose**
```json
// MVGENOMSEQ KDK
{
  "diagnoseCode": "C50.9",
  "diagnoseDatum": "2024-03-15",
  "tumorStadium": "II"
}
```

Wird gemappt zu:
```
// FHIR Condition (MII KDS Diagnose)
* code.coding.system = "http://fhir.de/CodeSystem/bfarm/icd-10-gm"
* code.coding.code = #C50.9
* onsetDateTime = "2024-03-15"
* stage.summary.coding = #II
* meta.profile = "https://www.medizininformatik-initiative.de/fhir/core/modul-diagnose/StructureDefinition/Diagnose"
```

#### Molekulare Befunde
```json
// MVGENOMSEQ KDK
{
  "genVariante": "BRCA1 c.5266dupC",
  "variationTyp": "Insertion",
  "zygosity": "heterozygot",
  "allelicFrequency": 0.48
}
```

Wird gemappt zu:
```
// FHIR Observation (MII KDS Molekulargenetik)
* code = $loinc#69548-6 "Genetic variant assessment"
* component[gene-studied].valueCodeableConcept.coding = $HGNC#1100 "BRCA1"
* component[genomic-hgvs].valueCodeableConcept.coding.display = "c.5266dupC"
* component[variation-code].valueCodeableConcept = $SO#SO:0000667 "insertion"
* component[allelic-frequency].valueQuantity.value = 0.48
* meta.profile = "https://www.medizininformatik-initiative.de/fhir/ext/modul-molgen/StructureDefinition/variante"
```

#### Therapieplan
```json
// MVGENOMSEQ KDK
{
  "therapieArt": "Chemotherapie",
  "wirkstoff": "Paclitaxel",
  "startDatum": "2024-04-01",
  "endDatum": "2024-10-01"
}
```

Wird gemappt zu:
```
// FHIR MedicationStatement (MII KDS Onkologie)
* medicationCodeableConcept.coding.system = "http://fhir.de/CodeSystem/bfarm/atc"
* medicationCodeableConcept.coding.code = #L01CD01 "Paclitaxel"
* effectivePeriod.start = "2024-04-01"
* effectivePeriod.end = "2024-10-01"
* meta.profile = "https://www.medizininformatik-initiative.de/fhir/ext/modul-onko/StructureDefinition/onkologie-systemtherapie"
```

### KDK-Seltene Erkrankungen Mapping

#### Phenotypische Merkmale
```json
// MVGENOMSEQ KDK
{
  "hpoTerm": "HP:0001263",
  "bezeichnung": "Global developmental delay",
  "auspraegung": "severe"
}
```

Wird gemappt zu:
```
// FHIR Observation
* code = $HPO#HP:0001263 "Global developmental delay"
* valueCodeableConcept.text = "severe"
* meta.profile = "https://www.medizininformatik-initiative.de/fhir/ext/modul-seltene/StructureDefinition/phenotypic-feature"
```

### GRZ-Daten Mapping

#### Sequenzierungs-Metadaten
```json
// MVGENOMSEQ GRZ
{
  "sequenzierungsDatum": "2024-03-20",
  "methode": "WGS",
  "abdeckung": "30x",
  "referenzgenom": "GRCh38"
}
```

Wird gemappt zu:
```
// FHIR Observation (Genomics)
* code = $loinc#51969-4 "Genetic analysis summary report"
* effectiveDateTime = "2024-03-20"
* method.text = "Whole Genome Sequencing"
* component[coverage].valueQuantity.value = 30
* component[reference-sequence].valueCodeableConcept.text = "GRCh38"
```

## Mapping-Tabellen

### Zentrale Entitäten

| MVGENOMSEQ KDK | FHIR Resource | MII Profil |
|----------------|---------------|------------|
| Patient | Patient | MII KDS Person |
| Diagnose | Condition | MII KDS Diagnose |
| Molekularer Befund | Observation | MII KDS Molekulargenetik - Variante |
| Therapie | MedicationStatement | MII KDS Onkologie - Systemtherapie |
| Verlauf | Observation | MII KDS Onkologie - Verlauf |
| Einwilligung | Consent | MII KDS Consent |

### Datenfelder (Beispiele)

| MVGENOMSEQ Feld | FHIR Element | Transformation |
|-----------------|--------------|----------------|
| patientenId | Patient.identifier.value | Direkt |
| geschlecht | Patient.gender | Wertemapping (M→male, W→female) |
| diagnoseCode | Condition.code | CodeSystem-Mapping |
| genVariante | Observation.component[genomic-hgvs] | HGVS-Format |
| therapieArt | MedicationStatement.category | CodeableConcept |

## Implementierungsschritte

### Schritt 1: Profil-Definition
```fsh
// FSH Definition eines spezifischen Profils
Profile: MVGenomSeqPatient
Parent: https://www.medizininformatik-initiative.de/fhir/core/modul-person/StructureDefinition/Patient
Id: mvgenomseq-patient
Title: "MVGENOMSEQ Patient Profile"
Description: "Patient-Profil für MVGENOMSEQ-Daten basierend auf MII KDS Person"

* identifier 1..* MS
* identifier ^slicing.discriminator.type = #pattern
* identifier ^slicing.discriminator.path = "type"
* identifier ^slicing.rules = #open

* identifier contains mvgenomseqId 1..1 MS
* identifier[mvgenomseqId].type = $v2-0203#MR
* identifier[mvgenomseqId].system = "http://example.org/mvgenomseq/patient-id"
* identifier[mvgenomseqId].value 1..1
```

### Schritt 2: Transformation Logic
```typescript
// Beispiel-Transformationslogik (Pseudocode)
function transformMVGenomSeqToFHIR(mvgenomseqData: MVGenomSeqKDK): Bundle {
  const bundle: Bundle = {
    resourceType: "Bundle",
    type: "transaction",
    entry: []
  };

  // Patient transformieren
  const patient = transformPatient(mvgenomseqData.patient);
  bundle.entry.push({
    resource: patient,
    request: { method: "POST", url: "Patient" }
  });

  // Diagnosen transformieren
  mvgenomseqData.diagnosen.forEach(diagnose => {
    const condition = transformDiagnose(diagnose, patient.id);
    bundle.entry.push({
      resource: condition,
      request: { method: "POST", url: "Condition" }
    });
  });

  // Molekulare Befunde transformieren
  mvgenomseqData.molekulareBefunde.forEach(befund => {
    const observation = transformMolekulareVariante(befund, patient.id);
    bundle.entry.push({
      resource: observation,
      request: { method: "POST", url: "Observation" }
    });
  });

  return bundle;
}
```

### Schritt 3: Validierung
```bash
# Validierung der generierten FHIR-Ressourcen
java -jar validator_cli.jar \
  -version 4.0.1 \
  -ig de.medizininformatikinitiative.kerndatensatz.person \
  -ig de.medizininformatikinitiative.kerndatensatz.molgen \
  -profile http://example.org/fhir/StructureDefinition/mvgenomseq-patient \
  patient-example.json
```

## Vorteile im Detail

### Maximale FHIR-Konformität
- Vollständige Nutzung des FHIR-Ökosystems
- Standardisierte REST API für Zugriffe
- Unterstützung für FHIR Search
- Kompatibilität mit FHIR-Tools (Validator, IG Publisher, etc.)

### Wiederverwendung von MII-Profilen
- Alignment mit deutscher MI-Initiative
- Interoperabilität mit anderen deutschen Gesundheitsprojekten
- Nutzung etablierter Terminologien (ICD-10-GM, OPS, ATC, etc.)

### Semantische Interoperabilität
- Maschinenlesbare Semantik
- Standardisierte Code-Systeme
- FHIR-konforme Erweiterungen

## Herausforderungen im Detail

### Komplexe Mappings

**Problem**: MVGENOMSEQ-Strukturen passen nicht immer 1:1 zu FHIR-Ressourcen

**Lösung**:
- Verwendung von Extensions für MVGENOMSEQ-spezifische Felder
- Mapping-Dokumentation in ConceptMaps
- Transformationsregeln in StructureMaps

**Beispiel Extension**:
```fsh
Extension: MVGenomSeqSubmissionMetadata
Id: mvgenomseq-submission-metadata
Title: "MVGENOMSEQ Submission Metadata"
Description: "Zusätzliche Metadaten aus der MVGENOMSEQ-Einreichung"
* value[x] only Reference or Identifier
* ^context[0].type = #element
* ^context[0].expression = "Patient"
```

### Informationsverlust

**Problem**: Manche MVGENOMSEQ-Strukturen sind reicher als FHIR-Äquivalente

**Lösung**:
- Verwendung von contained resources für zusätzliche Kontexte
- Extensions für MVGENOMSEQ-spezifische Attribute
- Provenance-Ressourcen zur Nachverfolgung der Transformation

### Wartungsaufwand

**Problem**: Beide Standards entwickeln sich weiter

**Lösung**:
- Versionierung der Mapping-Spezifikationen
- Automatisierte Tests für Mappings
- CI/CD-Pipeline für Validierung

## Implementierungsbeispiel

### Vollständiges Beispiel: Onkologie-Fall

```json
// MVGENOMSEQ Input
{
  "patient": {
    "id": "PAT-12345",
    "geburtsdatum": "1965-07-22",
    "geschlecht": "W"
  },
  "diagnose": {
    "icd10": "C50.9",
    "datum": "2024-01-15",
    "stadium": "pT2 pN1 M0"
  },
  "molekularbefund": {
    "gen": "BRCA2",
    "hgvs": "c.7397C>T",
    "interpretation": "pathogenic"
  },
  "therapie": {
    "art": "Systemtherapie",
    "regime": "AC-T",
    "startdatum": "2024-02-01"
  }
}
```

```xml
<!-- FHIR Bundle Output -->
<Bundle xmlns="http://hl7.org/fhir">
  <type value="transaction"/>

  <!-- Patient -->
  <entry>
    <resource>
      <Patient>
        <id value="PAT-12345"/>
        <meta>
          <profile value="http://example.org/fhir/StructureDefinition/mvgenomseq-patient"/>
        </meta>
        <identifier>
          <system value="http://example.org/mvgenomseq/patient-id"/>
          <value value="PAT-12345"/>
        </identifier>
        <gender value="female"/>
        <birthDate value="1965-07-22"/>
      </Patient>
    </resource>
    <request>
      <method value="PUT"/>
      <url value="Patient/PAT-12345"/>
    </request>
  </entry>

  <!-- Diagnose -->
  <entry>
    <resource>
      <Condition>
        <id value="COND-12345-1"/>
        <meta>
          <profile value="https://www.medizininformatik-initiative.de/fhir/core/modul-diagnose/StructureDefinition/Diagnose"/>
        </meta>
        <subject>
          <reference value="Patient/PAT-12345"/>
        </subject>
        <code>
          <coding>
            <system value="http://fhir.de/CodeSystem/bfarm/icd-10-gm"/>
            <version value="2024"/>
            <code value="C50.9"/>
          </coding>
        </code>
        <onsetDateTime value="2024-01-15"/>
        <stage>
          <summary>
            <text value="pT2 pN1 M0"/>
          </summary>
        </stage>
      </Condition>
    </resource>
  </entry>

  <!-- Molekularbefund -->
  <entry>
    <resource>
      <Observation>
        <id value="OBS-12345-1"/>
        <meta>
          <profile value="https://www.medizininformatik-initiative.de/fhir/ext/modul-molgen/StructureDefinition/variante"/>
        </meta>
        <status value="final"/>
        <subject>
          <reference value="Patient/PAT-12345"/>
        </subject>
        <code>
          <coding>
            <system value="http://loinc.org"/>
            <code value="69548-6"/>
          </coding>
        </code>
        <component>
          <code>
            <coding>
              <system value="http://loinc.org"/>
              <code value="48018-6"/>
              <display value="Gene studied [ID]"/>
            </coding>
          </code>
          <valueCodeableConcept>
            <coding>
              <system value="http://www.genenames.org/geneId"/>
              <code value="HGNC:1101"/>
              <display value="BRCA2"/>
            </coding>
          </valueCodeableConcept>
        </component>
        <component>
          <code>
            <coding>
              <system value="http://loinc.org"/>
              <code value="48004-6"/>
              <display value="DNA change (c.HGVS)"/>
            </coding>
          </code>
          <valueCodeableConcept>
            <text value="c.7397C>T"/>
          </valueCodeableConcept>
        </component>
        <component>
          <code>
            <coding>
              <system value="http://loinc.org"/>
              <code value="53037-8"/>
              <display value="Genetic variation clinical significance [Imp]"/>
            </coding>
          </code>
          <valueCodeableConcept>
            <coding>
              <system value="http://loinc.org"/>
              <code value="LA6668-3"/>
              <display value="Pathogenic"/>
            </coding>
          </valueCodeableConcept>
        </component>
      </Observation>
    </resource>
  </entry>
</Bundle>
```

## Testing und Qualitätssicherung

### Unit Tests
```typescript
describe('MVGENOMSEQ to FHIR Transformation', () => {
  it('should transform patient correctly', () => {
    const mvInput = {
      id: "PAT-001",
      geburtsdatum: "1970-01-01",
      geschlecht: "M"
    };

    const fhirPatient = transformPatient(mvInput);

    expect(fhirPatient.resourceType).toBe('Patient');
    expect(fhirPatient.gender).toBe('male');
    expect(fhirPatient.birthDate).toBe('1970-01-01');
  });
});
```

### Integration Tests
```bash
# Vollständige End-to-End-Transformation testen
npm run test:integration -- --scenario=onkologie-vollstaendig
```

## Werkzeuge und Ressourcen

### Empfohlene Tools
- **FHIR Validator**: Validierung der generierten Ressourcen
- **SUSHI**: FSH-basierte Profil-Entwicklung
- **MatchBox**: Mapping und Transformation
- **HAPI FHIR**: FHIR-Server-Implementierung

### Mapping-Spezifikationen
- ConceptMaps für Code-System-Mappings
- StructureMaps für strukturelle Transformationen
- Implementierungsleitfäden mit Beispielen

## Zusammenfassung

Der direkte Mapping-Ansatz bietet die höchste FHIR-Konformität und Interoperabilität, erfordert jedoch substanziellen Entwicklungsaufwand für die Erstellung und Wartung der Mappings. Er ist ideal für Organisationen, die vollständig in FHIR-Ökosysteme integriert sind und maximale semantische Interoperabilität benötigen.
