# Ansatz 1: Generierung von MVGENOMSEQ-Daten aus existierenden FHIR-Daten

## Übersicht

Dieser Ansatz beschreibt die **Transformation von bereits vorhandenen FHIR-Ressourcen** (insbesondere MII-Kerndatensatz) in den standardisierten MVGENOMSEQ-Datensatz. Dies ist besonders relevant für Einrichtungen, die bereits FHIR-basierte Systeme betreiben und ihre Daten für das Modellvorhaben Genomsequenzierung aufbereiten müssen.

## Anwendungsfälle

### Primäranwendungsfall
Krankenhäuser und medizinische Einrichtungen, die:
- Bereits FHIR-Server (z.B. HAPI FHIR) betreiben
- MII-Kerndatensatz-konforme Daten vorhalten
- An MVGENOMSEQ teilnehmen möchten
- Ihre bestehenden FHIR-Daten für MVGENOMSEQ-Einreichungen aufbereiten müssen

### Beispielszenario
Ein Universitätsklinikum hat im Rahmen der Medizininformatik-Initiative bereits alle onkologischen und genomischen Daten in FHIR strukturiert (Patient, Condition, Observation mit Genomik-Profilen, MedicationStatement). Für die Teilnahme am MVGENOMSEQ-Programm müssen diese Daten in das vorgeschriebene JSON-Schema-Format konvertiert werden.

## Architekturprinzipien

### Prozessübersicht

{% include img.html img="approach1-fhir-to-mvgenomseq.png" caption="Abbildung 1: Prozessablauf für die Generierung von MVGENOMSEQ-Daten aus FHIR" %}

### 1. FHIR als Datenquelle
```
FHIR Server (MII KDS)  →  Transformation Engine  →  MVGENOMSEQ JSON
```

### 2. Zweistufiger Prozess
1. **Datenextraktion**: Abruf relevanter FHIR-Ressourcen via FHIR Search
2. **Transformation**: Konvertierung in MVGENOMSEQ JSON-Schema-konforme Strukturen

### 3. Qualitätssicherung
- Validierung der Quell-FHIR-Daten gegen MII-Profile
- Validierung der Ziel-MVGENOMSEQ-Daten gegen JSON Schema
- Vollständigkeitsprüfung (Required Fields)

## MII Oncology LogicalModel

Das MII Oncology Modul enthält bereits ein **LogicalModel für MVGENOMSEQ Onkologie**:

- **Canonical URL**: `https://www.medizininformatik-initiative.de/fhir/ext/modul-onko/StructureDefinition/LogicalModel/mii-lm-mvgenomseq-onkologie`
- **Package**: `de.medizininformatikinitiative.kerndatensatz.onkologie` (2026.0.0-ballot)
- **Simplifier**: [MII LM MVGENOMSEQ Onkologie](https://simplifier.net/packages/de.medizininformatikinitiative.kerndatensatz.onkologie/2026.0.0-ballot/files/2957340)

Dieses LogicalModel definiert die Struktur für MVGENOMSEQ-Onkologie-Daten und dient als Referenz für die Transformation.

## Detailliertes Mapping: FHIR → MVGENOMSEQ

### KDK-Onkologie Transformation

#### Patient-Daten

**FHIR Quelle** (MII KDS Person):
```json
{
  "resourceType": "Patient",
  "id": "mii-patient-123",
  "identifier": [
    {
      "system": "http://hospital.example.org/patient-id",
      "value": "PAT-123456"
    }
  ],
  "gender": "female",
  "birthDate": "1965-07-22"
}
```

**MVGENOMSEQ KDK Output**:
```json
{
  "patientenId": "PAT-123456",
  "geburtsdatum": "1965-07-22",
  "geschlecht": "W"
}
```

**Transformationslogik**:
```typescript
function extractPatientDataForMVGenomSeq(fhirPatient: Patient): MVGenomSeqPatient {
  return {
    patientenId: fhirPatient.identifier.find(
      id => id.system.includes('patient-id')
    )?.value,
    geburtsdatum: fhirPatient.birthDate,
    geschlecht: mapGenderToMVGenomSeq(fhirPatient.gender) // male→M, female→W
  };
}
```

#### Diagnose-Daten

**FHIR Quelle** (MII KDS Diagnose):
```json
{
  "resourceType": "Condition",
  "id": "condition-breast-cancer",
  "meta": {
    "profile": [
      "https://www.medizininformatik-initiative.de/fhir/core/modul-diagnose/StructureDefinition/Diagnose"
    ]
  },
  "subject": {
    "reference": "Patient/mii-patient-123"
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
}
```

**MVGENOMSEQ KDK Output**:
```json
{
  "diagnose": {
    "icd10Code": "C50.9",
    "icd10Version": "2024",
    "diagnoseDatum": "2024-01-15",
    "tumorStadium": {
      "tnm": "pT2 pN1 M0"
    }
  }
}
```

**Transformationslogik**:
```typescript
function extractDiagnoseForMVGenomSeq(fhirCondition: Condition): MVGenomSeqDiagnose {
  const icdCoding = fhirCondition.code.coding.find(
    c => c.system.includes('icd-10-gm')
  );

  return {
    icd10Code: icdCoding?.code,
    icd10Version: icdCoding?.version,
    diagnoseDatum: fhirCondition.onsetDateTime,
    tumorStadium: {
      tnm: fhirCondition.stage?.[0]?.summary?.text
    }
  };
}
```

#### Molekulargenetische Befunde

**FHIR Quelle** (MII KDS Molekulargenetik):
```json
{
  "resourceType": "Observation",
  "id": "variant-brca2",
  "meta": {
    "profile": [
      "https://www.medizininformatik-initiative.de/fhir/ext/modul-molgen/StructureDefinition/variante"
    ]
  },
  "status": "final",
  "code": {
    "coding": [
      {
        "system": "http://loinc.org",
        "code": "69548-6"
      }
    ]
  },
  "subject": {
    "reference": "Patient/mii-patient-123"
  },
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
            "code": "48004-6",
            "display": "DNA change (c.HGVS)"
          }
        ]
      },
      "valueCodeableConcept": {
        "text": "c.7397C>T"
      }
    },
    {
      "code": {
        "coding": [
          {
            "system": "http://loinc.org",
            "code": "53037-8"
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
}
```

**MVGENOMSEQ KDK Output**:
```json
{
  "molekulareBefunde": [
    {
      "gen": "BRCA2",
      "genId": "HGNC:1101",
      "hgvsCoding": "c.7397C>T",
      "interpretation": "pathogenic",
      "befundDatum": "2024-01-20"
    }
  ]
}
```

**Transformationslogik**:
```typescript
function extractMolekularBefundForMVGenomSeq(
  fhirObservation: Observation
): MVGenomSeqMolekularBefund {
  const genComponent = fhirObservation.component.find(
    c => c.code.coding[0].code === '48018-6'
  );
  const hgvsComponent = fhirObservation.component.find(
    c => c.code.coding[0].code === '48004-6'
  );
  const interpComponent = fhirObservation.component.find(
    c => c.code.coding[0].code === '53037-8'
  );

  return {
    gen: genComponent?.valueCodeableConcept?.coding[0]?.display,
    genId: genComponent?.valueCodeableConcept?.coding[0]?.code,
    hgvsCoding: hgvsComponent?.valueCodeableConcept?.text,
    interpretation: mapInterpretation(
      interpComponent?.valueCodeableConcept?.coding[0]?.display
    ),
    befundDatum: fhirObservation.effectiveDateTime
  };
}
```

#### Therapiedaten

**FHIR Quelle** (MII KDS Onkologie):
```json
{
  "resourceType": "MedicationStatement",
  "id": "chemo-treatment",
  "meta": {
    "profile": [
      "https://www.medizininformatik-initiative.de/fhir/ext/modul-onko/StructureDefinition/onkologie-systemtherapie"
    ]
  },
  "status": "completed",
  "medicationCodeableConcept": {
    "coding": [
      {
        "system": "http://fhir.de/CodeSystem/bfarm/atc",
        "code": "L01CD01",
        "display": "Paclitaxel"
      }
    ]
  },
  "subject": {
    "reference": "Patient/mii-patient-123"
  },
  "effectivePeriod": {
    "start": "2024-02-01",
    "end": "2024-08-01"
  }
}
```

**MVGENOMSEQ KDK Output**:
```json
{
  "therapien": [
    {
      "therapieArt": "Systemtherapie",
      "wirkstoff": {
        "atcCode": "L01CD01",
        "bezeichnung": "Paclitaxel"
      },
      "startDatum": "2024-02-01",
      "endDatum": "2024-08-01"
    }
  ]
}
```

### KDK-Seltene Erkrankungen Transformation

#### Phenotypische Merkmale

**FHIR Quelle**:
```json
{
  "resourceType": "Observation",
  "id": "phenotype-obs",
  "meta": {
    "profile": [
      "https://www.medizininformatik-initiative.de/fhir/ext/modul-seltene/StructureDefinition/phenotypic-feature"
    ]
  },
  "code": {
    "coding": [
      {
        "system": "http://purl.obolibrary.org/obo/hp.owl",
        "code": "HP:0001263",
        "display": "Global developmental delay"
      }
    ]
  },
  "valueCodeableConcept": {
    "text": "severe"
  }
}
```

**MVGENOMSEQ KDK Output**:
```json
{
  "phaenotyp": [
    {
      "hpoCode": "HP:0001263",
      "bezeichnung": "Global developmental delay",
      "auspraegung": "severe"
    }
  ]
}
```

### GRZ-Daten Transformation

#### Sequenzierungs-Metadaten

**FHIR Quelle**:
```json
{
  "resourceType": "DiagnosticReport",
  "id": "sequencing-report",
  "code": {
    "coding": [
      {
        "system": "http://loinc.org",
        "code": "51969-4"
      }
    ]
  },
  "effectiveDateTime": "2024-03-20",
  "extension": [
    {
      "url": "http://example.org/fhir/StructureDefinition/sequencing-method",
      "valueCodeableConcept": {
        "text": "WGS"
      }
    },
    {
      "url": "http://example.org/fhir/StructureDefinition/coverage",
      "valueQuantity": {
        "value": 30,
        "unit": "x"
      }
    },
    {
      "url": "http://example.org/fhir/StructureDefinition/reference-genome",
      "valueString": "GRCh38"
    }
  ]
}
```

**MVGENOMSEQ GRZ Output**:
```json
{
  "sequenzierung": {
    "datum": "2024-03-20",
    "methode": "WGS",
    "abdeckung": "30x",
    "referenzgenom": "GRCh38"
  }
}
```

## Implementierung: End-to-End Pipeline

### Schritt 1: FHIR-Datenextraktion

```typescript
class MVGenomSeqDataExtractor {
  constructor(private fhirClient: FhirClient) {}

  async extractPatientData(patientId: string): Promise<MVGenomSeqSubmission> {
    // 1. Patient abrufen
    const patient = await this.fhirClient.read('Patient', patientId);

    // 2. Alle Diagnosen für Patient abrufen
    const conditions = await this.fhirClient.search('Condition', {
      subject: `Patient/${patientId}`,
      category: 'encounter-diagnosis'
    });

    // 3. Molekulargenetische Befunde abrufen
    const genomicObservations = await this.fhirClient.search('Observation', {
      subject: `Patient/${patientId}`,
      category: 'laboratory',
      code: '69548-6' // LOINC für Genetic variant assessment
    });

    // 4. Therapiedaten abrufen
    const medications = await this.fhirClient.search('MedicationStatement', {
      subject: `Patient/${patientId}`
    });

    // 5. Sequenzierungs-Reports abrufen
    const diagnosticReports = await this.fhirClient.search('DiagnosticReport', {
      subject: `Patient/${patientId}`,
      code: '51969-4' // LOINC für Genetic analysis summary
    });

    return {
      patient,
      conditions,
      genomicObservations,
      medications,
      diagnosticReports
    };
  }
}
```

### Schritt 2: Transformation

```typescript
class FHIRToMVGenomSeqTransformer {
  transformToKDKOnkologie(fhirData: FHIRPatientData): MVGenomSeqKDKOnkologie {
    return {
      metadaten: this.extractMetadata(),
      patient: this.transformPatient(fhirData.patient),
      diagnosen: fhirData.conditions.map(c => this.transformDiagnose(c)),
      molekulareBefunde: fhirData.genomicObservations.map(
        o => this.transformMolekularBefund(o)
      ),
      therapien: fhirData.medications.map(m => this.transformTherapie(m)),
      verlauf: this.extractVerlauf(fhirData)
    };
  }

  transformToGRZ(fhirData: FHIRPatientData): MVGenomSeqGRZ {
    return {
      metadaten: this.extractGRZMetadata(),
      sequenzierung: this.transformSequenzierung(fhirData.diagnosticReports),
      qualitaetsmetriken: this.extractQualityMetrics(fhirData.diagnosticReports),
      annotationen: this.extractAnnotations(fhirData.genomicObservations)
    };
  }

  private transformPatient(patient: Patient): MVGenomSeqPatient {
    return {
      patientenId: this.extractPatientId(patient),
      geburtsdatum: patient.birthDate,
      geschlecht: this.mapGender(patient.gender),
      einwilligung: this.extractConsent(patient)
    };
  }

  private transformDiagnose(condition: Condition): MVGenomSeqDiagnose {
    const icd = condition.code.coding.find(
      c => c.system.includes('icd-10-gm')
    );

    return {
      icd10Code: icd?.code,
      icd10Version: icd?.version,
      diagnoseDatum: condition.onsetDateTime,
      tumorStadium: this.extractTumorStage(condition),
      histologie: this.extractHistology(condition),
      grading: this.extractGrading(condition)
    };
  }

  private transformMolekularBefund(
    observation: Observation
  ): MVGenomSeqMolekularBefund {
    return {
      gen: this.extractGeneStudied(observation),
      genId: this.extractGeneId(observation),
      hgvsCoding: this.extractHGVS(observation),
      interpretation: this.extractInterpretation(observation),
      allelfrequenz: this.extractAllelicFrequency(observation),
      zygosity: this.extractZygosity(observation),
      befundDatum: observation.effectiveDateTime
    };
  }

  private mapGender(fhirGender: string): string {
    const mapping = {
      'male': 'M',
      'female': 'W',
      'other': 'D',
      'unknown': 'U'
    };
    return mapping[fhirGender] || 'U';
  }
}
```

### Schritt 3: Validierung

```typescript
class MVGenomSeqValidator {
  constructor(
    private kdkSchema: JSONSchema,
    private grzSchema: JSONSchema
  ) {}

  async validateKDK(data: MVGenomSeqKDK): Promise<ValidationResult> {
    const ajv = new Ajv({ strict: false });
    const validate = ajv.compile(this.kdkSchema);
    const valid = validate(data);

    return {
      valid,
      errors: validate.errors || []
    };
  }

  async validateGRZ(data: MVGenomSeqGRZ): Promise<ValidationResult> {
    const ajv = new Ajv({ strict: false });
    const validate = ajv.compile(this.grzSchema);
    const valid = validate(data);

    return {
      valid,
      errors: validate.errors || []
    };
  }
}
```

### Schritt 4: Vollständige Pipeline

```typescript
class MVGenomSeqExportPipeline {
  constructor(
    private extractor: MVGenomSeqDataExtractor,
    private transformer: FHIRToMVGenomSeqTransformer,
    private validator: MVGenomSeqValidator
  ) {}

  async exportPatient(patientId: string): Promise<MVGenomSeqExportResult> {
    try {
      // 1. FHIR-Daten extrahieren
      console.log('Extrahiere FHIR-Daten...');
      const fhirData = await this.extractor.extractPatientData(patientId);

      // 2. KDK transformieren
      console.log('Transformiere zu KDK...');
      const kdkData = this.transformer.transformToKDKOnkologie(fhirData);

      // 3. GRZ transformieren
      console.log('Transformiere zu GRZ...');
      const grzData = this.transformer.transformToGRZ(fhirData);

      // 4. Validieren
      console.log('Validiere KDK...');
      const kdkValidation = await this.validator.validateKDK(kdkData);
      if (!kdkValidation.valid) {
        throw new Error(`KDK-Validierung fehlgeschlagen: ${JSON.stringify(kdkValidation.errors)}`);
      }

      console.log('Validiere GRZ...');
      const grzValidation = await this.validator.validateGRZ(grzData);
      if (!grzValidation.valid) {
        throw new Error(`GRZ-Validierung fehlgeschlagen: ${JSON.stringify(grzValidation.errors)}`);
      }

      // 5. Export
      return {
        success: true,
        kdk: kdkData,
        grz: grzData,
        validationResults: {
          kdk: kdkValidation,
          grz: grzValidation
        }
      };

    } catch (error) {
      return {
        success: false,
        error: error.message
      };
    }
  }
}
```

## Praktisches Beispiel: Batch-Export

```typescript
// Beispiel: Export aller onkologischen Patienten
async function exportAllOnkologiePatienten() {
  const pipeline = new MVGenomSeqExportPipeline(
    new MVGenomSeqDataExtractor(fhirClient),
    new FHIRToMVGenomSeqTransformer(),
    new MVGenomSeqValidator(kdkSchema, grzSchema)
  );

  // Alle Patienten mit onkologischen Diagnosen finden
  const patientBundle = await fhirClient.search('Patient', {
    _has: 'Condition:subject:code=http://fhir.de/CodeSystem/bfarm/icd-10-gm|C*'
  });

  const results = [];

  for (const patient of patientBundle.entry) {
    const patientId = patient.resource.id;
    console.log(`Exportiere Patient ${patientId}...`);

    const result = await pipeline.exportPatient(patientId);
    results.push(result);

    if (result.success) {
      // KDK-Datei speichern
      await fs.writeFile(
        `output/kdk-${patientId}.json`,
        JSON.stringify(result.kdk, null, 2)
      );

      // GRZ-Datei speichern
      await fs.writeFile(
        `output/grz-${patientId}.json`,
        JSON.stringify(result.grz, null, 2)
      );

      console.log(`✓ Patient ${patientId} erfolgreich exportiert`);
    } else {
      console.error(`✗ Fehler bei Patient ${patientId}: ${result.error}`);
    }
  }

  return results;
}
```

## Mapping-Tabellen

### Ressourcen-Mapping

| FHIR Resource | MII Profil | MVGENOMSEQ KDK Ziel |
|---------------|------------|---------------------|
| Patient | MII KDS Person | patient |
| Condition | MII KDS Diagnose | diagnosen[] |
| Observation (Genomics) | MII KDS Molekulargenetik - Variante | molekulareBefunde[] |
| MedicationStatement | MII KDS Onkologie - Systemtherapie | therapien[] |
| Observation (Follow-up) | MII KDS Onkologie - Verlauf | verlauf[] |
| Consent | MII KDS Consent | einwilligung |
| DiagnosticReport | Custom | GRZ.sequenzierung |

### Datenfeld-Mapping

| FHIR Element | MVGENOMSEQ Feld | Transformation |
|--------------|-----------------|----------------|
| Patient.identifier.value | patient.patientenId | Direkt (primäre ID) |
| Patient.gender | patient.geschlecht | Code-Mapping |
| Condition.code (ICD-10-GM) | diagnose.icd10Code | Code extrahieren |
| Observation.component[gene-studied] | molekulareBefunde[].gen | Display extrahieren |
| Observation.component[genomic-hgvs] | molekulareBefunde[].hgvsCoding | Text extrahieren |
| MedicationStatement.medication (ATC) | therapien[].wirkstoff.atcCode | Code extrahieren |

## Vorteile

### Wiederverwendung bestehender Daten
- Keine Doppelerfassung notwendig
- FHIR-Daten als Single Source of Truth
- Automatisierte Datenaufbereitung

### Konsistenz
- Ein Datenmodell (FHIR) als Basis
- Validierte Quelldaten (MII-Profile)
- Nachvollziehbare Transformation

### Effizienz
- Automatisierter Export-Prozess
- Batch-Verarbeitung möglich
- Wiederholbare Pipeline

## Herausforderungen

### Unvollständige FHIR-Daten
**Problem**: Nicht alle MVGENOMSEQ-Pflichtfelder sind in FHIR vorhanden

**Lösung**:
- Pflichtfeld-Check vor Transformation
- Manuelle Nacherfassung fehlender Daten
- Fehlerberichte mit fehlenden Feldern

### Unterschiedliche Granularität
**Problem**: FHIR und MVGENOMSEQ haben unterschiedliche Detailgrade

**Lösung**:
- Aggregation oder Disaggregation je nach Bedarf
- Verwendung von Extensions für zusätzliche Details
- Mapping-Regeln dokumentieren

### Datenqualität
**Problem**: FHIR-Quelldaten können inkonsistent sein

**Lösung**:
- Validierung vor Transformation
- Datenqualitäts-Checks
- Fehlerbehandlung und Logging

## Testing

```typescript
describe('FHIR to MVGENOMSEQ Transformation', () => {
  let transformer: FHIRToMVGenomSeqTransformer;

  beforeEach(() => {
    transformer = new FHIRToMVGenomSeqTransformer();
  });

  it('should transform MII Patient to MVGENOMSEQ patient', () => {
    const fhirPatient: Patient = {
      resourceType: 'Patient',
      id: 'test-123',
      identifier: [
        {
          system: 'http://hospital.example.org/patient-id',
          value: 'PAT-123'
        }
      ],
      gender: 'female',
      birthDate: '1970-01-01'
    };

    const mvPatient = transformer.transformPatient(fhirPatient);

    expect(mvPatient.patientenId).toBe('PAT-123');
    expect(mvPatient.geschlecht).toBe('W');
    expect(mvPatient.geburtsdatum).toBe('1970-01-01');
  });

  it('should handle missing optional fields gracefully', () => {
    const fhirCondition: Condition = {
      resourceType: 'Condition',
      subject: { reference: 'Patient/test-123' },
      code: {
        coding: [
          {
            system: 'http://fhir.de/CodeSystem/bfarm/icd-10-gm',
            code: 'C50.9'
          }
        ]
      }
      // Keine stage oder onset
    };

    const mvDiagnose = transformer.transformDiagnose(fhirCondition);

    expect(mvDiagnose.icd10Code).toBe('C50.9');
    expect(mvDiagnose.diagnoseDatum).toBeUndefined();
    expect(mvDiagnose.tumorStadium).toBeUndefined();
  });
});
```

## Werkzeuge und Bibliotheken

### Empfohlene Tools
- **HAPI FHIR Client**: Java/TypeScript Client für FHIR-Server-Zugriff
- **Ajv (Another JSON Schema Validator)**: JSON Schema Validierung
- **fhir-kit-client**: JavaScript FHIR Client
- **TypeScript**: Type-Safety für Transformationen

### JSON Schemas laden
```typescript
import * as fs from 'fs';

// KDK Schema laden
const kdkOnkologieSchema = JSON.parse(
  fs.readFileSync('node_modules/mvgenomseq-kdk/schemas/onkologie.schema.json', 'utf-8')
);

const kdkSelteneSchema = JSON.parse(
  fs.readFileSync('node_modules/mvgenomseq-kdk/schemas/seltene.schema.json', 'utf-8')
);

// GRZ Schema laden
const grzSchema = JSON.parse(
  fs.readFileSync('node_modules/mvgenomseq-grz/schemas/grz-schema.json', 'utf-8')
);
```

## Zusammenfassung

Dieser Ansatz eignet sich besonders für Einrichtungen, die bereits FHIR-basierte Infrastrukturen betreiben und ihre existierenden MII-konformen Daten für MVGENOMSEQ aufbereiten möchten. Die Transformation ermöglicht eine automatisierte, wiederholbare und validierbare Konvertierung von FHIR zu MVGENOMSEQ.

**Zentrale Vorteile:**
- Nutzung bestehender FHIR-Daten
- Automatisierte Transformation
- Vollständige Validierung beider Standards
- Batch-Verarbeitung möglich

**Ideal für:**
- MII-Standorte mit FHIR-Servern
- Einrichtungen mit etablierten FHIR-Workflows
- Organisationen, die MVGENOMSEQ-Daten aus Bestandsdaten generieren müssen
