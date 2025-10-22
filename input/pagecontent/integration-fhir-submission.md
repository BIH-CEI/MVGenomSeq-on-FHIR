# Ansatz 3: FHIR-basierte Meldung für MVGENOMSEQ (Zukunftsstrategie)

## Übersicht

Dieser Ansatz beschreibt eine **zukunftsweisende Strategie**, bei der die Meldung des Klinischen Datensatzes (KDK) und des Genomreferenzzentren-Datensatzes (GRZ) ganz oder größtenteils direkt in FHIR erfolgen kann. Während die ersten beiden Ansätze als "Quick Wins" umgesetzt werden können, positioniert dieser Ansatz MVGENOMSEQ für langfristige Interoperabilität.

## Strategische Bedeutung: Warten auf FHIR R6

### Warum FHIR R6?

FHIR R6 (Version 6.0.0) bringt wesentliche Verbesserungen für genomische Daten, die auf den **GA4GH-Standards** (Global Alliance for Genomics and Health) basieren:

#### Kernverbesserungen in R6
1. **Genomics Reporting IG Integration**: Direkte Integration des HL7 Genomics Reporting IG in den Core Standard
2. **GA4GH-Alignment**:
   - Variante Representation Standard (VRS)
   - Phenopackets-Kompatibilität
   - Molecular Sequence v2 mit GA4GH-Alignment
3. **Verbesserte Strukturen**:
   - `GenomicStudy` Resource (neue Ressource)
   - Überarbeitete `MolecularSequence` Resource
   - Erweiterte `Observation`-Profile für Genomik

### Langfristige Interoperabilitätsstrategie

```
Aktueller Zustand (R4):           Zukünftiger Zustand (R6):
┌─────────────────────┐          ┌─────────────────────┐
│  MVGENOMSEQ JSON    │          │  FHIR R6 Genomics   │
│  (Proprietär)       │   →→→    │  (GA4GH-aligned)    │
└─────────────────────┘          └─────────────────────┘
         ↕                                  ↕
┌─────────────────────┐          ┌─────────────────────┐
│  FHIR R4 Genomics   │          │    GA4GH APIs       │
│  (Begrenzt)         │          │  (Phenopackets,     │
└─────────────────────┘          │   VRS, etc.)        │
                                 └─────────────────────┘
```

## Visionäre Architektur: FHIR-native MVGENOMSEQ

### Ziel-Szenario
Anstatt JSON-Schema-basierte MVGENOMSEQ-Datensätze zu erstellen, würden Teilnehmer direkt FHIR-Ressourcen einreichen, die den MVGENOMSEQ-Anforderungen entsprechen.

### Prozessübersicht

{% include img.html img="approach3-fhir-native-r6.png" caption="Abbildung 1: FHIR R6 Native Submission Prozess" %}

### Systemarchitektur

```
┌─────────────────────────────────────────────────────────────┐
│              Datenquelle (Krankenhaus/Labor)                │
│  ┌──────────────────────────────────────────────────────┐  │
│  │         FHIR R6 Server mit MVGENOMSEQ Profilen       │  │
│  └────────────────────────┬─────────────────────────────┘  │
└───────────────────────────┼─────────────────────────────────┘
                            │ FHIR Bundle
                            │ (statt JSON)
                            ▼
┌─────────────────────────────────────────────────────────────┐
│              MVGENOMSEQ Submission Gateway                  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  1. FHIR R6 Validierung                              │  │
│  │  2. MVGENOMSEQ-Profil-Konformität                   │  │
│  │  3. Geschäftslogik-Validierung                       │  │
│  │  4. Consent-Prüfung                                  │  │
│  └──────────────────────────────────────────────────────┘  │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│              BfArM MVGENOMSEQ Central Repository            │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │  FHIR R6     │  │  Analytics   │  │  Export zu   │     │
│  │  Store       │  │  Engine      │  │  Forschern   │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
└─────────────────────────────────────────────────────────────┘
```

## FHIR R6 Ressourcen für MVGENOMSEQ

### KDK-Klinischer Datensatz

#### Patient
```fsh
Profile: MVGenomSeqPatientR6
Parent: http://hl7.org/fhir/StructureDefinition/Patient
Id: mvgenomseq-patient-r6
Title: "MVGENOMSEQ Patient Profile (R6)"
Description: "Patient-Profil für MVGENOMSEQ-Einreichungen auf Basis von FHIR R6"

* identifier 1..* MS
  * ^short = "Eindeutige Patienten-ID"
* gender 1..1 MS
* birthDate 1..1 MS

* extension contains
    ResearchSubjectExtension named researchSubject 0..1 MS

Extension: ResearchSubjectExtension
Id: mvgenomseq-research-subject
Title: "Research Subject Information"
Description: "Verknüpfung zu ResearchSubject für Studienkontex"
* value[x] only Reference(ResearchSubject)
```

#### Diagnose (unverändert zu R4, bereits gut etabliert)
```fsh
Profile: MVGenomSeqDiagnoseR6
Parent: https://www.medizininformatik-initiative.de/fhir/core/modul-diagnose/StructureDefinition/Diagnose
Id: mvgenomseq-diagnose-r6
Title: "MVGENOMSEQ Diagnose Profile (R6)"

* code 1..1 MS
  * coding ^slicing.discriminator.type = #pattern
  * coding ^slicing.discriminator.path = "system"
  * coding ^slicing.rules = #open
  * coding contains icd10gm 1..1 MS
  * coding[icd10gm].system = "http://fhir.de/CodeSystem/bfarm/icd-10-gm"
  * coding[icd10gm].version 1..1 MS
  * coding[icd10gm].code 1..1 MS

* stage MS
  * summary MS
  * type MS
```

### GRZ-Genomischer Datensatz mit R6

#### Neue Ressource: GenomicStudy
```fsh
Profile: MVGenomSeqGenomicStudyR6
Parent: http://hl7.org/fhir/StructureDefinition/GenomicStudy
Id: mvgenomseq-genomic-study-r6
Title: "MVGENOMSEQ Genomic Study Profile (R6)"
Description: "Beschreibt die gesamte Sequenzierungsstudie - NEU in FHIR R6!"

* status 1..1 MS
* type 1..1 MS
  * coding from GenomicStudyTypeVS
* subject 1..1 MS
  * ^short = "Patient, für den sequenziert wurde"
* startDate 1..1 MS
  * ^short = "Datum der Sequenzierung"

* analysis 1..* MS
  * ^short = "Sequenzierungsanalysen"
  * methodType 1..* MS
    * ^short = "WGS, WES, Panel"
  * genomeBuild 1..1 MS
    * ^short = "z.B. GRCh38"
  * performer 1..1 MS
    * ^short = "Genomreferenzzentrum"
  * device 0..* MS
    * ^short = "Sequenzierungsgerät"
  * input 0..* MS
    * ^short = "Input-Specimen"
    * file
      * url 1..1
        * ^short = "URL zu FASTQ/BAM"
  * output 0..* MS
    * ^short = "Output-Daten (VCF, etc.)"
    * file
      * url 1..1
        * ^short = "URL zu VCF"

// Beispiel-ValueSet
ValueSet: GenomicStudyTypeVS
Id: genomic-study-type-vs
Title: "Genomic Study Types for MVGENOMSEQ"
* include codes from system http://terminology.hl7.org/CodeSystem/genomic-study-type
* ^experimental = false
```

#### Verbesserte MolecularSequence (R6)
```fsh
Profile: MVGenomSeqMolecularSequenceR6
Parent: http://hl7.org/fhir/StructureDefinition/MolecularSequence
Id: mvgenomseq-molecular-sequence-r6
Title: "MVGENOMSEQ Molecular Sequence Profile (R6)"
Description: "Verbesserte MolecularSequence in R6 mit GA4GH VRS Alignment"

* type 1..1 MS
  * ^short = "dna | rna | protein"

* subject 1..1 MS

// NEU in R6: Direkte GA4GH VRS Integration
* relative 0..* MS
  * ^short = "Varianten relativ zur Referenz"
  * startingSequence 1..1 MS
    * ^short = "Referenzsequenz"
    * sequenceCodeableConcept MS
      * coding from ReferenceGenomeVS
  * edit 0..* MS
    * ^short = "Änderungen (SNV, Insertion, Deletion)"
    * start 1..1 MS
    * end 1..1 MS
    * replacementSequence MS
    * replacedSequence MS

* focus 0..* MS
  * ^short = "Verknüpfung zu Observations mit Interpretation"
```

#### Genomic Variant Observation (Erweitert in R6)
```fsh
Profile: MVGenomSeqVariantR6
Parent: http://hl7.org/fhir/uv/genomics-reporting/StructureDefinition/variant
Id: mvgenomseq-variant-r6
Title: "MVGENOMSEQ Genetic Variant (R6)"
Description: "Genetische Variante mit vollem GA4GH-Alignment in R6"

* status 1..1 MS
* code = $LNC#69548-6 "Genetic variant assessment"
* subject 1..1 MS
* effectiveDateTime 1..1 MS

// Strukturierter als in R4
* component ^slicing.discriminator.type = #pattern
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    geneStudied 1..1 MS and
    cytogeneticLocation 0..1 MS and
    genomicHGVS 0..1 MS and
    genomicSourceClass 0..1 MS and
    allelicFrequency 0..1 MS and
    copyNumber 0..1 MS and
    zygosity 0..1 MS and
    clinicalSignificance 1..1 MS and
    therapeuticImplication 0..* MS and
    molecularConsequence 0..* MS

// Gene Studied
* component[geneStudied]
  * code = $LNC#48018-6 "Gene studied [ID]"
  * value[x] only CodeableConcept
  * valueCodeableConcept from HGNCGeneVS (extensible)

// Genomic HGVS
* component[genomicHGVS]
  * code = $LNC#81290-9 "Genomic DNA change (gHGVS)"
  * value[x] only CodeableConcept
  * valueCodeableConcept.text 1..1
    * ^short = "z.B. NC_000017.11:g.43092919C>T"

// Clinical Significance (verbessert in R6)
* component[clinicalSignificance]
  * code = $LNC#53037-8 "Genetic variation clinical significance"
  * value[x] only CodeableConcept
  * valueCodeableConcept from ClinicalSignificanceVS (required)

// NEU in R6: Therapeutic Implication
* component[therapeuticImplication]
  * code = $LNC#93044-6 "Therapeutic implication"
  * value[x] only CodeableConcept

// NEU in R6: Molecular Consequence
* component[molecularConsequence]
  * code = $LNC#81259-4 "Molecular consequence"
  * value[x] only CodeableConcept
  * valueCodeableConcept from MolecularConsequenceVS

// Verknüpfung zur MolecularSequence
* derivedFrom 0..* MS
  * ^short = "Referenz zu MolecularSequence"
```

#### DiagnosticReport für Genomsequenzierung
```fsh
Profile: MVGenomSeqGenomicsReportR6
Parent: http://hl7.org/fhir/uv/genomics-reporting/StructureDefinition/genomics-report
Id: mvgenomseq-genomics-report-r6
Title: "MVGENOMSEQ Genomics Report (R6)"
Description: "Übergeordneter Bericht für alle genomischen Befunde"

* basedOn 0..* MS
  * ^short = "ServiceRequest für die Sequenzierung"

* status 1..1 MS

* category 1..* MS
  * coding contains genomics 1..1 MS
  * coding[genomics] = $OBSCAT#laboratory

* code = $LNC#81247-9 "Master HL7 genetic variant reporting panel"

* subject 1..1 MS

* effectiveDateTime 1..1 MS
  * ^short = "Datum der Sequenzierung"

* issued 1..1 MS
  * ^short = "Datum der Berichterstellung"

* performer 1..* MS
  * ^short = "Genomreferenzzentrum"

* result 0..* MS
  * ^short = "Alle Varianten-Observations"

// NEU in R6: Direkter Link zu GenomicStudy
* extension contains
    GenomicStudyReference named genomicStudy 0..1 MS

Extension: GenomicStudyReference
Id: genomic-study-reference
Title: "Genomic Study Reference"
* value[x] only Reference(GenomicStudy)
```

### Therapie und Follow-up
```fsh
Profile: MVGenomSeqTherapieR6
Parent: https://www.medizininformatik-initiative.de/fhir/ext/modul-onko/StructureDefinition/onkologie-systemtherapie
Id: mvgenomseq-therapie-r6
Title: "MVGENOMSEQ Systemtherapie (R6)"

* status 1..1 MS
* medication[x] 1..1 MS
* subject 1..1 MS
* effectivePeriod MS
  * start 1..1 MS
  * end 0..1 MS

// Verknüpfung zu genomischen Befunden
* reasonReference MS
  * ^short = "Kann auf Varianten referenzieren"
```

## MVGENOMSEQ-spezifische Profile und Extensions

### Extension: GRZ Metadaten
```fsh
Extension: GRZSubmissionMetadata
Id: grz-submission-metadata
Title: "GRZ Submission Metadata"
Description: "Metadaten der Einreichung an das Genomreferenzzentrum"

* extension contains
    submissionId 1..1 MS and
    submissionDate 1..1 MS and
    grzCenter 1..1 MS and
    qualityMetrics 0..1 MS

* extension[submissionId]
  * value[x] only Identifier
  * ^short = "Eindeutige Einreichungs-ID"

* extension[submissionDate]
  * value[x] only dateTime
  * ^short = "Datum der Einreichung"

* extension[grzCenter]
  * value[x] only Reference(Organization)
  * ^short = "Referenzzentrum"

* extension[qualityMetrics]
  * value[x] only Reference(Observation)
  * ^short = "Qualitätsmetriken (Coverage, etc.)"
```

### Extension: Sequencing Coverage
```fsh
Profile: SequencingCoverageObservation
Parent: Observation
Id: sequencing-coverage
Title: "Sequencing Coverage Metrics"

* status = #final
* category = $OBSCAT#laboratory
* code = $LNC#82121-5 "Sequencing coverage"

* component ^slicing.discriminator.type = #pattern
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    meanCoverage 1..1 MS and
    medianCoverage 0..1 MS and
    percentageAbove20x 0..1 MS

* component[meanCoverage]
  * code = $LNC#82665-1 "Mean sequencing coverage"
  * value[x] only Quantity
  * valueQuantity.unit = "x"

* component[percentageAbove20x]
  * code.text = "Percentage of genome covered at 20x"
  * value[x] only Quantity
  * valueQuantity.unit = "%"
```

## Submission Bundle Format

### Vollständiges FHIR-Einreichungsbundle
```json
{
  "resourceType": "Bundle",
  "type": "transaction",
  "meta": {
    "profile": [
      "http://example.org/fhir/StructureDefinition/mvgenomseq-submission-bundle-r6"
    ]
  },
  "entry": [
    {
      "fullUrl": "urn:uuid:patient-001",
      "resource": {
        "resourceType": "Patient",
        "meta": {
          "profile": [
            "http://example.org/fhir/StructureDefinition/mvgenomseq-patient-r6"
          ]
        },
        "identifier": [
          {
            "system": "http://hospital.example.org/patient-id",
            "value": "PAT-123456"
          }
        ],
        "gender": "female",
        "birthDate": "1965-07"
      },
      "request": {
        "method": "POST",
        "url": "Patient"
      }
    },
    {
      "fullUrl": "urn:uuid:consent-001",
      "resource": {
        "resourceType": "Consent",
        "meta": {
          "profile": [
            "https://www.medizininformatik-initiative.de/fhir/modul-consent/StructureDefinition/mii-pr-consent-einwilligung"
          ]
        },
        "status": "active",
        "scope": {
          "coding": [
            {
              "system": "http://terminology.hl7.org/CodeSystem/consentscope",
              "code": "research"
            }
          ]
        },
        "patient": {
          "reference": "urn:uuid:patient-001"
        },
        "dateTime": "2024-01-10",
        "policy": [
          {
            "uri": "https://www.medizininformatik-initiative.de/broad-consent/v1.6.f"
          }
        ]
      },
      "request": {
        "method": "POST",
        "url": "Consent"
      }
    },
    {
      "fullUrl": "urn:uuid:condition-001",
      "resource": {
        "resourceType": "Condition",
        "meta": {
          "profile": [
            "http://example.org/fhir/StructureDefinition/mvgenomseq-diagnose-r6"
          ]
        },
        "subject": {
          "reference": "urn:uuid:patient-001"
        },
        "code": {
          "coding": [
            {
              "system": "http://fhir.de/CodeSystem/bfarm/icd-10-gm",
              "version": "2024",
              "code": "C50.9"
            }
          ]
        },
        "onsetDateTime": "2024-01-15",
        "stage": [
          {
            "summary": {
              "text": "pT2 pN1 M0"
            }
          }
        ]
      },
      "request": {
        "method": "POST",
        "url": "Condition"
      }
    },
    {
      "fullUrl": "urn:uuid:genomic-study-001",
      "resource": {
        "resourceType": "GenomicStudy",
        "meta": {
          "profile": [
            "http://example.org/fhir/StructureDefinition/mvgenomseq-genomic-study-r6"
          ]
        },
        "status": "completed",
        "type": {
          "coding": [
            {
              "system": "http://terminology.hl7.org/CodeSystem/genomic-study-type",
              "code": "wgs",
              "display": "Whole Genome Sequencing"
            }
          ]
        },
        "subject": {
          "reference": "urn:uuid:patient-001"
        },
        "startDate": "2024-03-20",
        "analysis": [
          {
            "methodType": [
              {
                "coding": [
                  {
                    "system": "http://loinc.org",
                    "code": "LA26398-0",
                    "display": "Sequencing"
                  }
                ]
              }
            ],
            "genomeBuild": {
              "coding": [
                {
                  "system": "http://loinc.org",
                  "code": "LA26806-2",
                  "display": "GRCh38"
                }
              ]
            },
            "performer": [
              {
                "reference": "Organization/grz-center-001"
              }
            ]
          }
        ]
      },
      "request": {
        "method": "POST",
        "url": "GenomicStudy"
      }
    },
    {
      "fullUrl": "urn:uuid:variant-001",
      "resource": {
        "resourceType": "Observation",
        "meta": {
          "profile": [
            "http://example.org/fhir/StructureDefinition/mvgenomseq-variant-r6"
          ]
        },
        "status": "final",
        "category": [
          {
            "coding": [
              {
                "system": "http://terminology.hl7.org/CodeSystem/observation-category",
                "code": "laboratory"
              }
            ]
          }
        ],
        "code": {
          "coding": [
            {
              "system": "http://loinc.org",
              "code": "69548-6",
              "display": "Genetic variant assessment"
            }
          ]
        },
        "subject": {
          "reference": "urn:uuid:patient-001"
        },
        "effectiveDateTime": "2024-03-25",
        "component": [
          {
            "code": {
              "coding": [
                {
                  "system": "http://loinc.org",
                  "code": "48018-6",
                  "display": "Gene studied [ID]"
                }
              ]
            },
            "valueCodeableConcept": {
              "coding": [
                {
                  "system": "http://www.genenames.org/geneId",
                  "code": "HGNC:1101",
                  "display": "BRCA2"
                }
              ]
            }
          },
          {
            "code": {
              "coding": [
                {
                  "system": "http://loinc.org",
                  "code": "81290-9",
                  "display": "Genomic DNA change (gHGVS)"
                }
              ]
            },
            "valueCodeableConcept": {
              "text": "NC_000013.11:g.32379932G>A"
            }
          },
          {
            "code": {
              "coding": [
                {
                  "system": "http://loinc.org",
                  "code": "53037-8",
                  "display": "Genetic variation clinical significance"
                }
              ]
            },
            "valueCodeableConcept": {
              "coding": [
                {
                  "system": "http://loinc.org",
                  "code": "LA6668-3",
                  "display": "Pathogenic"
                }
              ]
            }
          }
        ]
      },
      "request": {
        "method": "POST",
        "url": "Observation"
      }
    },
    {
      "fullUrl": "urn:uuid:diagnostic-report-001",
      "resource": {
        "resourceType": "DiagnosticReport",
        "meta": {
          "profile": [
            "http://example.org/fhir/StructureDefinition/mvgenomseq-genomics-report-r6"
          ]
        },
        "status": "final",
        "code": {
          "coding": [
            {
              "system": "http://loinc.org",
              "code": "81247-9",
              "display": "Master HL7 genetic variant reporting panel"
            }
          ]
        },
        "subject": {
          "reference": "urn:uuid:patient-001"
        },
        "effectiveDateTime": "2024-03-20",
        "issued": "2024-04-01T10:00:00Z",
        "performer": [
          {
            "reference": "Organization/grz-center-001"
          }
        ],
        "result": [
          {
            "reference": "urn:uuid:variant-001"
          }
        ],
        "extension": [
          {
            "url": "http://example.org/fhir/StructureDefinition/genomic-study-reference",
            "valueReference": {
              "reference": "urn:uuid:genomic-study-001"
            }
          }
        ]
      },
      "request": {
        "method": "POST",
        "url": "DiagnosticReport"
      }
    }
  ]
}
```

## Vorteile der FHIR-basierten Meldung

### 1. Standardisierung
- Nutzung etablierter FHIR-Standards
- GA4GH-Alignment für globale Interoperabilität
- Keine proprietären JSON-Schemas mehr erforderlich

### 2. Tooling und Ökosystem
- Validatoren, IGs, Viewer bereits vorhanden
- Breite Tool-Unterstützung (HAPI, Blaze, IBM FHIR, etc.)
- Entwickler-Community und Dokumentation

### 3. API-Standardisierung
- RESTful FHIR API statt Custom Endpoints
- Standardisierte Search-Parameter
- GraphQL-Unterstützung möglich

### 4. Forschungseffizienz
- Direkte Nutzbarkeit in FHIR-basierten Analyse-Tools
- Integration mit CQL, FHIRPath
- Kompatibilität mit HL7 CPG (Clinical Practice Guidelines)

### 5. Zukunftssicherheit
- R6 bringt langfristige Stabilität für Genomik
- GA4GH-Alignment bedeutet internationale Kompatibilität
- Phased Migration Path von R4 zu R6

## Migrationsstrategie

### Phase 1: Vorbereitung (2025)
- Analyse der R6-Kandidaten-Spezifikation
- Proof-of-Concept-Implementierungen
- Feedback an HL7 Genomics Working Group

### Phase 2: R6 Ballot und Finalisierung (2026)
- Teilnahme am R6 Ballot-Prozess
- Anpassung der MVGENOMSEQ-Profile an finalen R6-Standard
- Entwicklung von Migrations-Tooling

### Phase 3: Pilotierung (2027)
- Pilotprojekte mit ausgewählten GRZs
- Parallelbetrieb von JSON und FHIR-Einreichung
- Sammlung von Implementierungserfahrungen

### Phase 4: Rollout (2028+)
- Schrittweise Umstellung aller Einreichenden
- JSON-Format als Legacy-Option
- Vollständige FHIR-native Meldung als Standard

## Herausforderungen

### 1. R6-Timing
**Problem**: R6 ist noch nicht finalisiert

**Lösung**:
- Aktive Beteiligung an HL7-Prozessen
- Frühzeitige PoCs mit R6 Candidate
- Rückwärtskompatibilität zu R4 sicherstellen

### 2. Komplexität
**Problem**: FHIR ist komplexer als einfaches JSON Schema

**Lösung**:
- Bereitstellung von Templates und Beispielen
- Entwicklung von Libraries und SDKs
- Schulungen für Implementierer

### 3. Performance bei großen Genomdaten
**Problem**: VCF-Dateien können sehr groß sein

**Lösung**:
- Binäre Daten extern speichern (Binary-Ressource mit URL)
- Nur interpretierte Varianten in FHIR
- Bulk Data Export für große Datensätze

## Zusammenfassung

Dieser Ansatz repräsentiert eine **langfristige Vision** für MVGENOMSEQ, die auf maximaler Interoperabilität und Standardisierung basiert. Während die ersten beiden Ansätze als Quick Wins umgesetzt werden können, positioniert dieser Ansatz Deutschland als Vorreiter in FHIR- und GA4GH-basierter genomischer Datenintegration.

**Zentrale Vorteile:**
- GA4GH-Alignment durch FHIR R6
- Internationale Interoperabilität
- Zukunftssichere Architektur
- Maximale Tool-Unterstützung

**Zeitrahmen:**
- Quick Wins (Ansatz 1 & 2): Sofort umsetzbar
- FHIR-native Submission: 2027-2028

**Ideal für:**
- Langfristige strategische Planung
- Internationale Kollaborationen
- Forschungsinfrastruktur-Entwicklung
