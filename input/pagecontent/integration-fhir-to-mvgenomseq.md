# Ansatz 1: MII-KDS als Datenquelle für die MVGenomSeq-Einreichung

## Übersicht

Einrichtungen, die am Modellvorhaben Genomsequenzierung teilnehmen, halten einen Großteil der benötigten klinischen Daten bereits in ihren FHIR-Servern vor — strukturiert nach dem MII-Kerndatensatz. Dieser Ansatz beschreibt, wie diese Bestandsdaten genutzt werden, um den MVGenomSeq-Datenkranz (KDK + GRZ) zu befüllen, und welche Daten zusätzlich erfasst werden müssen.

## Datenfluss

```
┌─────────────────────────────────────────────────────────┐
│              MII-KDS FHIR-Server (Bestand)              │
│  Patient  │  Condition  │  MolGen-Observation  │  ...   │
└─────────────────────────┬───────────────────────────────┘
                          │ vorhanden
                          ▼
┌─────────────────────────────────────────────────────────┐
│           Zusätzliche Dokumentation (FHIR-first)        │
│     MTB-Therapieplan  │  Verlauf  │  Einwilligung       │
└─────────────────────────┬───────────────────────────────┘
                          │ neu erfasst, konform zu MII-MTB-Profilen
                          ▼
┌─────────────────────────────────────────────────────────┐
│              Transformation → MVGenomSeq JSON           │
│              KDK (Onkologie / Seltene Erkrankungen)     │
│              GRZ (Genomische Referenzzentren)           │
└─────────────────────────────────────────────────────────┘
```

## Was liegt vor — was muss ergänzt werden?

| Datenelement | MII-KDS-Quelle | Status |
|---|---|---|
| Patientendaten (pseudonymisiert) | `Patient` (PatientPseudonymisiert, `base`) | vorhanden |
| Diagnose (ICD-10-GM, Onkologie) | `Condition` (MII PR MTB Diagnose Primärtumor, `mtb`) | vorhanden |
| Diagnose (Seltene Erkrankungen) | `Condition` (MII PR Diagnose Condition, `base`) | vorhanden |
| Molekulargenetische Variante (Onko) | `Observation` (MII PR MTB Einfache Variante, `mtb`) | vorhanden |
| Molekulargenetische Variante (SE) | `Observation` (MII PR MolGen Variante, `molgen`) | vorhanden |
| Sequenzierungsmetadaten | `DiagnosticReport` (MII PR MolGen Diagnostik, `molgen`) | vorhanden |
| Einwilligung (Broad Consent) | `Consent` (MII PR Consent Einwilligung, `consent`) | vorhanden |
| MTB-Therapieempfehlung | `CarePlan` (MII PR MTB Therapieplan, `mtb`) | **neu zu erfassen** |
| Verlauf nach MTB-Beschluss | `Observation` (MII PR MTB Verlauf, `mtb`) | **neu zu erfassen** |

Die neu zu erfassenden Daten werden direkt als MII-konforme FHIR-Ressourcen dokumentiert (FHIR-first), um Doppelerfassung zu vermeiden und die Nachnutzbarkeit im DIZ sicherzustellen.

## Szenario

Ein Universitätsklinikum betreibt im Rahmen der MII bereits einen FHIR-Server (z.B. Blaze) mit MII-KDS-konformen Daten. Patientenstammdaten, onkologische Diagnosen, molekulargenetische Befunde und Sequenzierungsberichte liegen strukturiert vor. Für die Teilnahme am Modellvorhaben Genomsequenzierung wurde beschlossen, auf einen **FHIR-first-Ansatz** zu setzen: Die fehlenden MTB-spezifischen Daten (Therapieplan, Verlauf) werden direkt als FHIR-Ressourcen — konform zu den MII-MTB-Profilen (z.B. `mii-pr-mtb-therapieplan`) — erfasst und anschließend gemeinsam mit den Bestandsdaten in das Übermittlungsformat transformiert.

{% include img.html img="approach1-fhir-to-mvgenomseq.png" caption="Abbildung 1: Prozessablauf für die Generierung von MVGenomSeq-Daten aus dem MII-KDS" %}

## Referenz: MII Logical Model MVGenomSeq Onkologie

Das MII-Onkologie-Modul enthält ein Logical Model, das die Abbildung des MVGenomSeq-Datensatzes auf FHIR formal beschreibt:

- **Package**: `de.medizininformatikinitiative.kerndatensatz.onkologie` (2026.0.3-rc.1)
- **Canonical**: `https://www.medizininformatik-initiative.de/fhir/ext/modul-onko/StructureDefinition/LogicalModel/mii-lm-mvgenomseq-onkologie`

## Ressourcen-Mapping

| FHIR-Ressource | MII-Profil | MVGenomSeq-Ziel |
|---|---|---|
| `Patient` | PatientPseudonymisiert (`base`) | `patient` |
| `Condition` (Onkologie) | MTB Diagnose Primärtumor (`mtb`) | `diagnosen[]` |
| `Condition` (Seltene Erkrankungen) | Diagnose Condition (`base`) | `diagnosen[]` |
| `Observation` (Variante, Onko) | MTB Einfache Variante (`mtb`) | `molekulareBefunde[]` |
| `Observation` (Variante, SE) | MolGen Variante (`molgen`) | `molekulareBefunde[]` |
| `Observation` (Follow-up) | MTB Verlauf (`mtb`) | `verlauf[]` |
| `CarePlan` | MTB Therapieplan (`mtb`) | `therapieplan` |
| `Consent` | Consent Einwilligung (`consent`) | `einwilligung` |
| `DiagnosticReport` | MolGen Diagnostik (`molgen`) | GRZ `sequenzierung` |

## Datenfeld-Mapping (Auswahl)

| FHIR-Element | MVGenomSeq-Feld | Hinweis |
|---|---|---|
| `Patient.identifier[PseudonymisierterIdentifier].value` | `patient.patientenId` | |
| `Patient.gender` | `patient.geschlecht` | male→M, female→W, other→D |
| `Patient.birthDate` | `patient.geburtsdatum` | Format YYYY-MM |
| `Condition.code.coding[icd10-gm].code` | `diagnose.icd10Code` | inkl. Version |
| `Condition.onsetDateTime` | `diagnose.diagnoseDatum` | |
| `Observation.component[gene-studied]` | `molekulareBefunde[].gen` | HGNC-Symbol |
| `Observation.component[representative-coding-hgvs]` | `molekulareBefunde[].hgvsC` | |
| `Observation.component[genomic-source-class]` | `molekulareBefunde[].genomicSource` | somatisch / Keimbahn |

## Beispiel: Diagnose-Mapping

FHIR-Quelle (`Condition`, MII PR MTB Diagnose Primärtumor):
```json
{
  "resourceType": "Condition",
  "code": {
    "coding": [
      {
        "system": "http://fhir.de/CodeSystem/bfarm/icd-10-gm",
        "version": "2024",
        "code": "C50.9"
      }
    ]
  },
  "onsetDateTime": "2024-01-15"
}
```

MVGenomSeq KDK Ziel:
```json
{
  "diagnose": {
    "icd10Code": "C50.9",
    "icd10Version": "2024",
    "diagnoseDatum": "2024-01-15"
  }
}
```

## Zu beachten

| Thema | Hinweis |
|---|---|
| Fehlende MTB-Daten | Therapieplan und Verlauf liegen meist noch nicht strukturiert vor — FHIR-first-Erfassung empfohlen |
| Pseudonymisierung | MVGenomSeq-Pseudonym muss konsistent mit dem DIZ-Pseudonymisierungsdienst verwaltet werden |
| ICD-10-GM-Version | Muss explizit pro Coding mitgeführt werden |
| Datenqualität | MII-KDS-Daten vor Transformation gegen MII-Profile validieren |
| Consent-Prüfung | Vor der Transformation sicherstellen, dass ein gültiger MVGenomSeq-Consent vorliegt |
