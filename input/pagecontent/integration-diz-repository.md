# Ansatz 2: Integration von MVGENOMSEQ-Daten in bestehende DIZ-Datenrepositorien

## Übersicht

Dieser Ansatz beschreibt die **Integration von MVGENOMSEQ-Daten in bestehende FHIR-basierte Datenrepositorien der Datenintegrationszentren (DIZ)**, ermöglicht durch den Broad Consent. Dadurch werden genomische Daten aus dem Modellvorhaben Genomsequenzierung in die bestehende Forschungsinfrastruktur der Medizininformatik-Initiative integriert.

## Anwendungsfall

### Primärszenario
DIZs möchten:
- MVGENOMSEQ-Daten in ihre bestehenden FHIR-Repositorien integrieren
- Genomische Daten mit klinischen MII-KDS-Daten verknüpfen
- Forschern einheitlichen Zugriff auf klinische und genomische Daten ermöglichen
- Den Broad Consent für Sekundärnutzung genomischer Daten nutzen

### Beispielszenario
Ein DIZ hat bereits ein umfangreiches FHIR-basiertes Data Warehouse mit MII-Kerndatensatz-Daten (Person, Diagnose, Prozeduren, Laborbefunde). Durch die Teilnahme am MVGENOMSEQ-Programm kommen nun standardisierte genomische Datensätze hinzu. Diese sollen in das bestehende Repository integriert werden, sodass Forscher über eine einheitliche FHIR-API auf beide Datenquellen zugreifen können.

## Rechtliche Grundlagen: Broad Consent

### Was ermöglicht der Broad Consent?

Der Broad Consent (Breite Einwilligung) im Kontext der MII ermöglicht:

1. **Sekundärnutzung**: Verwendung von klinischen und genomischen Daten für Forschungszwecke über den ursprünglichen Behandlungskontext hinaus
2. **Datenzusammenführung**: Verknüpfung verschiedener Datenquellen (MVGENOMSEQ + MII-KDS)
3. **Langfristige Speicherung**: Aufbewahrung in Forschungsdatenbanken der DIZs
4. **Datenweitergabe**: Bereitstellung für genehmigte Forschungsprojekte

### Integration der Einwilligungsdokumentation

```json
// MVGENOMSEQ KDK Einwilligung
{
  "einwilligung": {
    "datum": "2024-01-10",
    "umfang": "broad_consent_mii",
    "version": "1.6.f",
    "zwecke": [
      "forschung_allgemein",
      "genomsequenzierung",
      "datenweitergabe_forschung"
    ]
  }
}
```

Wird integriert als FHIR Consent:

```json
{
  "resourceType": "Consent",
  "id": "broad-consent-mvgenomseq-001",
  "meta": {
    "profile": [
      "http://fhir.de/ConsentManagement/StructureDefinition/Consent",
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
  "category": [
    {
      "coding": [
        {
          "system": "http://loinc.org",
          "code": "59284-0",
          "display": "Consent Document"
        }
      ]
    }
  ],
  "patient": {
    "reference": "Patient/mvgenomseq-patient-001"
  },
  "dateTime": "2024-01-10",
  "policy": [
    {
      "authority": "https://www.medizininformatik-initiative.de/",
      "uri": "https://www.medizininformatik-initiative.de/sites/default/files/2020-04/MII_AG-Consent_Einheitlicher-Mustertext_v1.6.f.pdf"
    }
  ],
  "provision": {
    "type": "permit",
    "period": {
      "start": "2024-01-10"
    },
    "purpose": [
      {
        "system": "http://terminology.hl7.org/CodeSystem/v3-ActReason",
        "code": "HRESCH",
        "display": "healthcare research"
      }
    ],
    "data": [
      {
        "meaning": "related",
        "reference": {
          "reference": "Patient/mvgenomseq-patient-001"
        }
      }
    ]
  }
}
```

## Architektur

### Systemübersicht

```
┌─────────────────────────────────────────────────────────────┐
│                     MVGENOMSEQ Quellen                      │
│  ┌──────────────┐              ┌──────────────┐            │
│  │  KDK JSON    │              │  GRZ JSON    │            │
│  │  (Klinisch)  │              │  (Genomisch) │            │
│  └──────┬───────┘              └──────┬───────┘            │
└─────────┼──────────────────────────────┼──────────────────┘
          │                              │
          ▼                              ▼
┌─────────────────────────────────────────────────────────────┐
│              FHIR Transformation Pipeline                   │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  - JSON Schema Validierung                           │  │
│  │  - MVGENOMSEQ → FHIR Mapping                        │  │
│  │  - MII-Profil-Konformität                           │  │
│  │  - Consent-Integration                               │  │
│  │  - Pseudonymisierung                                 │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────┬───────────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────────┐
│                   DIZ FHIR Repository                       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │  MII-KDS     │  │  MVGENOMSEQ  │  │   Consent    │     │
│  │  Bestand     │◄─┤   Daten      │  │   Store      │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│                                                             │
│              FHIR Server (HAPI, IBM, Blaze...)             │
└─────────────────────────┬───────────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────────┐
│              Forschungszugriff (Use & Access)               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │  FHIR Search │  │  CQL Queries │  │  Analytics   │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
└─────────────────────────────────────────────────────────────┘
```

## Detaillierte Integrationsstrategie

### Phase 1: Dateneingang und Validierung

#### 1.1 MVGENOMSEQ-Daten empfangen
```typescript
class MVGenomSeqIngestionService {
  async ingestKDKData(kdkJson: string): Promise<ValidationResult> {
    // 1. JSON Schema Validierung
    const kdkData = JSON.parse(kdkJson);
    const schemaValidation = await this.validateAgainstSchema(
      kdkData,
      'KDK-Onkologie' // oder 'KDK-SelteneErkrankungen'
    );

    if (!schemaValidation.valid) {
      throw new Error(`KDK-Validierung fehlgeschlagen: ${schemaValidation.errors}`);
    }

    // 2. Geschäftslogik-Validierung
    await this.validateBusinessRules(kdkData);

    // 3. Consent-Prüfung
    await this.validateConsent(kdkData.einwilligung);

    return { valid: true, data: kdkData };
  }

  async ingestGRZData(grzJson: string): Promise<ValidationResult> {
    const grzData = JSON.parse(grzJson);
    const validation = await this.validateAgainstSchema(grzData, 'GRZ');

    if (!validation.valid) {
      throw new Error(`GRZ-Validierung fehlgeschlagen: ${validation.errors}`);
    }

    return { valid: true, data: grzData };
  }

  private async validateConsent(einwilligung: any): Promise<void> {
    // Prüfen, ob Broad Consent vorliegt
    if (!einwilligung || !einwilligung.umfang.includes('broad_consent')) {
      throw new Error('Erforderlicher Broad Consent nicht vorhanden');
    }

    // Prüfen, ob Einwilligung noch gültig ist
    if (einwilligung.widerruf) {
      throw new Error('Einwilligung wurde widerrufen');
    }
  }
}
```

### Phase 2: Transformation zu FHIR

#### 2.1 Patient und Consent
```typescript
class MVGenomSeqToFHIRTransformer {
  async transformPatientWithConsent(
    mvPatient: MVGenomSeqPatient,
    mvEinwilligung: MVGenomSeqEinwilligung
  ): Promise<Bundle> {
    const patientId = this.generateOrResolvePseudonym(mvPatient.patientenId);

    const patient: Patient = {
      resourceType: 'Patient',
      id: patientId,
      meta: {
        profile: [
          'https://www.medizininformatik-initiative.de/fhir/core/modul-person/StructureDefinition/Patient'
        ],
        tag: [
          {
            system: 'http://example.org/fhir/CodeSystem/data-source',
            code: 'mvgenomseq',
            display: 'MVGENOMSEQ Import'
          }
        ]
      },
      identifier: [
        {
          type: {
            coding: [
              {
                system: 'http://terminology.hl7.org/CodeSystem/v2-0203',
                code: 'ANON'
              }
            ]
          },
          system: 'http://diz.example.org/fhir/sid/pseudonym',
          value: patientId
        }
      ],
      gender: this.mapGender(mvPatient.geschlecht),
      birthDate: this.obfuscateBirthDate(mvPatient.geburtsdatum) // Datenschutz
    };

    const consent: Consent = {
      resourceType: 'Consent',
      id: `${patientId}-broad-consent`,
      meta: {
        profile: [
          'https://www.medizininformatik-initiative.de/fhir/modul-consent/StructureDefinition/mii-pr-consent-einwilligung'
        ]
      },
      status: 'active',
      scope: {
        coding: [
          {
            system: 'http://terminology.hl7.org/CodeSystem/consentscope',
            code: 'research'
          }
        ]
      },
      category: [
        {
          coding: [
            {
              system: 'http://loinc.org',
              code: '59284-0'
            }
          ]
        }
      ],
      patient: { reference: `Patient/${patientId}` },
      dateTime: mvEinwilligung.datum,
      policy: [
        {
          uri: 'https://www.medizininformatik-initiative.de/broad-consent/v1.6.f'
        }
      ],
      provision: {
        type: 'permit',
        purpose: [
          {
            system: 'http://terminology.hl7.org/CodeSystem/v3-ActReason',
            code: 'HRESCH'
          }
        ]
      }
    };

    return {
      resourceType: 'Bundle',
      type: 'transaction',
      entry: [
        {
          resource: patient,
          request: { method: 'PUT', url: `Patient/${patientId}` }
        },
        {
          resource: consent,
          request: { method: 'PUT', url: `Consent/${consent.id}` }
        }
      ]
    };
  }

  private generateOrResolvePseudonym(originalId: string): string {
    // Integration mit bestehendem Pseudonymisierungsdienst des DIZ
    return pseudonymService.getPseudonym(originalId, 'mvgenomseq-domain');
  }

  private obfuscateBirthDate(birthDate: string): string {
    // Datenschutz: Nur Jahr und Monat, kein Tag
    const date = new Date(birthDate);
    return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}`;
  }
}
```

#### 2.2 Klinische Daten (Diagnosen, Therapien)
```typescript
async transformKlinischeDaten(
  kdkData: MVGenomSeqKDK,
  patientId: string
): Promise<Bundle> {
  const entries = [];

  // Diagnosen transformieren
  for (const diagnose of kdkData.diagnosen) {
    const condition: Condition = {
      resourceType: 'Condition',
      meta: {
        profile: [
          'https://www.medizininformatik-initiative.de/fhir/core/modul-diagnose/StructureDefinition/Diagnose'
        ],
        tag: [
          {
            system: 'http://example.org/fhir/CodeSystem/data-source',
            code: 'mvgenomseq-kdk'
          }
        ]
      },
      subject: { reference: `Patient/${patientId}` },
      code: {
        coding: [
          {
            system: 'http://fhir.de/CodeSystem/bfarm/icd-10-gm',
            version: diagnose.icd10Version,
            code: diagnose.icd10Code
          }
        ]
      },
      onsetDateTime: diagnose.diagnoseDatum,
      stage: diagnose.tumorStadium ? [
        {
          summary: { text: diagnose.tumorStadium.tnm },
          type: {
            coding: [
              {
                system: 'http://loinc.org',
                code: '21908-9',
                display: 'Stage group.clinical Cancer'
              }
            ]
          }
        }
      ] : undefined
    };

    entries.push({
      resource: condition,
      request: { method: 'POST', url: 'Condition' }
    });
  }

  // Therapien transformieren
  for (const therapie of kdkData.therapien) {
    const medicationStatement: MedicationStatement = {
      resourceType: 'MedicationStatement',
      meta: {
        profile: [
          'https://www.medizininformatik-initiative.de/fhir/ext/modul-onko/StructureDefinition/onkologie-systemtherapie'
        ],
        tag: [
          {
            system: 'http://example.org/fhir/CodeSystem/data-source',
            code: 'mvgenomseq-kdk'
          }
        ]
      },
      status: 'completed',
      medicationCodeableConcept: {
        coding: [
          {
            system: 'http://fhir.de/CodeSystem/bfarm/atc',
            code: therapie.wirkstoff.atcCode,
            display: therapie.wirkstoff.bezeichnung
          }
        ]
      },
      subject: { reference: `Patient/${patientId}` },
      effectivePeriod: {
        start: therapie.startDatum,
        end: therapie.endDatum
      }
    };

    entries.push({
      resource: medicationStatement,
      request: { method: 'POST', url: 'MedicationStatement' }
    });
  }

  return { resourceType: 'Bundle', type: 'transaction', entry: entries };
}
```

#### 2.3 Genomische Daten
```typescript
async transformGenomischeDaten(
  kdkData: MVGenomSeqKDK,
  grzData: MVGenomSeqGRZ,
  patientId: string
): Promise<Bundle> {
  const entries = [];

  // Sequenzierungsbericht erstellen
  const diagnosticReport: DiagnosticReport = {
    resourceType: 'DiagnosticReport',
    meta: {
      profile: [
        'http://hl7.org/fhir/uv/genomics-reporting/StructureDefinition/genomics-report'
      ],
      tag: [
        {
          system: 'http://example.org/fhir/CodeSystem/data-source',
          code: 'mvgenomseq-grz'
        }
      ]
    },
    status: 'final',
    code: {
      coding: [
        {
          system: 'http://loinc.org',
          code: '81247-9',
          display: 'Master HL7 genetic variant reporting panel'
        }
      ]
    },
    subject: { reference: `Patient/${patientId}` },
    effectiveDateTime: grzData.sequenzierung.datum,
    issued: grzData.einreichungsdatum,
    result: [] // Wird mit Observations befüllt
  };

  // Molekulare Varianten transformieren
  for (const befund of kdkData.molekulareBefunde) {
    const variantObs: Observation = {
      resourceType: 'Observation',
      meta: {
        profile: [
          'https://www.medizininformatik-initiative.de/fhir/ext/modul-molgen/StructureDefinition/variante',
          'http://hl7.org/fhir/uv/genomics-reporting/StructureDefinition/variant'
        ],
        tag: [
          {
            system: 'http://example.org/fhir/CodeSystem/data-source',
            code: 'mvgenomseq-kdk'
          }
        ]
      },
      status: 'final',
      category: [
        {
          coding: [
            {
              system: 'http://terminology.hl7.org/CodeSystem/observation-category',
              code: 'laboratory'
            }
          ]
        }
      ],
      code: {
        coding: [
          {
            system: 'http://loinc.org',
            code: '69548-6',
            display: 'Genetic variant assessment'
          }
        ]
      },
      subject: { reference: `Patient/${patientId}` },
      effectiveDateTime: befund.befundDatum,
      component: [
        {
          code: {
            coding: [
              {
                system: 'http://loinc.org',
                code: '48018-6',
                display: 'Gene studied [ID]'
              }
            ]
          },
          valueCodeableConcept: {
            coding: [
              {
                system: 'http://www.genenames.org/geneId',
                code: befund.genId,
                display: befund.gen
              }
            ]
          }
        },
        {
          code: {
            coding: [
              {
                system: 'http://loinc.org',
                code: '48004-6',
                display: 'DNA change (c.HGVS)'
              }
            ]
          },
          valueCodeableConcept: {
            text: befund.hgvsCoding
          }
        },
        {
          code: {
            coding: [
              {
                system: 'http://loinc.org',
                code: '53037-8',
                display: 'Genetic variation clinical significance'
              }
            ]
          },
          valueCodeableConcept: {
            coding: [
              {
                system: 'http://loinc.org',
                code: this.mapInterpretationToLOINC(befund.interpretation)
              }
            ]
          }
        }
      ]
    };

    const variantId = this.generateId();
    variantObs.id = variantId;

    entries.push({
      resource: variantObs,
      request: { method: 'POST', url: 'Observation' }
    });

    diagnosticReport.result.push({
      reference: `Observation/${variantId}`
    });
  }

  // DiagnosticReport hinzufügen
  entries.push({
    resource: diagnosticReport,
    request: { method: 'POST', url: 'DiagnosticReport' }
  });

  return { resourceType: 'Bundle', type: 'transaction', entry: entries };
}
```

### Phase 3: Persistierung im DIZ-Repository

```typescript
class DIZRepositoryIntegration {
  constructor(private fhirClient: FHIRClient) {}

  async integratePatient(
    mvgenomseqData: {
      kdk: MVGenomSeqKDK;
      grz: MVGenomSeqGRZ;
    }
  ): Promise<IntegrationResult> {
    const transformer = new MVGenomSeqToFHIRTransformer();

    try {
      // 1. Patient und Consent
      const patientBundle = await transformer.transformPatientWithConsent(
        mvgenomseqData.kdk.patient,
        mvgenomseqData.kdk.einwilligung
      );
      const patientResult = await this.fhirClient.batch(patientBundle);
      const patientId = this.extractPatientId(patientResult);

      // 2. Klinische Daten
      const clinicalBundle = await transformer.transformKlinischeDaten(
        mvgenomseqData.kdk,
        patientId
      );
      await this.fhirClient.batch(clinicalBundle);

      // 3. Genomische Daten
      const genomicBundle = await transformer.transformGenomischeDaten(
        mvgenomseqData.kdk,
        mvgenomseqData.grz,
        patientId
      );
      await this.fhirClient.batch(genomicBundle);

      // 4. Provenance tracking
      await this.createProvenanceRecord(patientId, mvgenomseqData);

      return {
        success: true,
        patientId: patientId,
        resourcesCreated: this.countResources([
          patientBundle,
          clinicalBundle,
          genomicBundle
        ])
      };

    } catch (error) {
      console.error('Integration fehlgeschlagen:', error);
      // Rollback-Mechanismus
      await this.rollback(patientId);
      throw error;
    }
  }

  private async createProvenanceRecord(
    patientId: string,
    sourceData: any
  ): Promise<void> {
    const provenance: Provenance = {
      resourceType: 'Provenance',
      target: [
        { reference: `Patient/${patientId}` }
      ],
      recorded: new Date().toISOString(),
      agent: [
        {
          type: {
            coding: [
              {
                system: 'http://terminology.hl7.org/CodeSystem/provenance-participant-type',
                code: 'assembler',
                display: 'Assembler'
              }
            ]
          },
          who: {
            display: 'MVGENOMSEQ Integration Pipeline'
          }
        }
      ],
      entity: [
        {
          role: 'source',
          what: {
            identifier: {
              system: 'http://example.org/mvgenomseq/submission-id',
              value: sourceData.kdk.metadaten.einreichungsId
            }
          }
        }
      ]
    };

    await this.fhirClient.create('Provenance', provenance);
  }
}
```

## Datenschutz und Pseudonymisierung

### Pseudonymisierungskonzept

```typescript
class PseudonymizationService {
  constructor(private gpasClient: GPASClient) {} // gPAS = generic Pseudonymization and Anonymization Service

  async pseudonymizePatient(
    mvgenomseqPatientId: string,
    contextDomain: string = 'mvgenomseq'
  ): Promise<string> {
    // 1. Prüfen, ob Pseudonym bereits existiert
    const existing = await this.gpasClient.getPseudonymFor(
      mvgenomseqPatientId,
      contextDomain
    );

    if (existing) {
      return existing;
    }

    // 2. Neues Pseudonym generieren
    const pseudonym = await this.gpasClient.getOrCreatePseudonymFor(
      mvgenomseqPatientId,
      contextDomain,
      'diz-research-domain' // Ziel-Domain im DIZ
    );

    return pseudonym;
  }

  async depseudonymize(
    pseudonym: string,
    targetDomain: string
  ): Promise<string> {
    // Nur für autorisierte Use Cases (z.B. Rückmeldung an Klinik)
    return await this.gpasClient.getOriginalValue(pseudonym, targetDomain);
  }
}
```

## Forschungszugriff

### FHIR Search Queries

Forscher können nun über standardisierte FHIR-APIs auf die integrierten Daten zugreifen:

#### Beispiel 1: Alle Patienten mit BRCA-Varianten finden
```http
GET /Observation?code=http://loinc.org|69548-6
    &component-code=http://loinc.org|48018-6
    &component-value-concept=http://www.genenames.org/geneId|HGNC:1100
    &_include=Observation:subject
```

#### Beispiel 2: Onkologische Patienten mit genomischen Befunden
```http
GET /Patient?_has:Condition:patient:code=http://fhir.de/CodeSystem/bfarm/icd-10-gm|C50
    &_has:Observation:patient:code=http://loinc.org|69548-6
    &_revinclude=Condition:subject
    &_revinclude=Observation:subject
    &_revinclude=MedicationStatement:subject
```

#### Beispiel 3: Nur Patienten mit gültigem Broad Consent
```http
GET /Patient?_has:Consent:patient:status=active
    &_has:Consent:patient:scope=research
    &_tag=http://example.org/fhir/CodeSystem/data-source|mvgenomseq
```

### CQL-basierte Analyse

```cql
library MVGenomSeqCohortDefinition version '1.0.0'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'

codesystem "LOINC": 'http://loinc.org'
codesystem "ICD10GM": 'http://fhir.de/CodeSystem/bfarm/icd-10-gm'

code "GeneticVariant": '69548-6' from "LOINC"
code "BreastCancer": 'C50' from "ICD10GM"

context Patient

define "HasBreastCancerDiagnosis":
  exists([Condition: code in "BreastCancer"])

define "HasPathogenicVariant":
  exists(
    [Observation: code in "GeneticVariant"] O
      where O.component
        .where(code.coding.exists(c | c.code = '53037-8' and c.display contains 'Pathogenic'))
        .exists()
  )

define "HasBroadConsent":
  exists(
    [Consent] C
      where C.status = 'active'
        and C.scope.coding.exists(c | c.code = 'research')
  )

define "InCohort":
  "HasBreastCancerDiagnosis"
    and "HasPathogenicVariant"
    and "HasBroadConsent"
```

## Monitoring und Qualitätssicherung

### Dashboard-Metriken

```typescript
class MVGenomSeqIntegrationMonitoring {
  async getIntegrationStats(): Promise<IntegrationStats> {
    return {
      totalPatientsIntegrated: await this.countPatients(),
      patientsWithConsent: await this.countPatientsWithActiveConsent(),
      genomicVariantsImported: await this.countGenomicVariants(),
      diagnosesLinked: await this.countLinkedDiagnoses(),
      therapiesLinked: await this.countLinkedTherapies(),
      dataQualityScore: await this.calculateDataQuality(),
      lastImportDate: await this.getLastImportDate(),
      failedImports: await this.getFailedImports()
    };
  }

  private async countPatients(): Promise<number> {
    const result = await this.fhirClient.search('Patient', {
      _tag: 'http://example.org/fhir/CodeSystem/data-source|mvgenomseq',
      _summary: 'count'
    });
    return result.total;
  }

  private async calculateDataQuality(): Promise<number> {
    // Prüft Vollständigkeit, Konsistenz, Aktualität
    const checks = await Promise.all([
      this.checkCompleteness(),
      this.checkConsistency(),
      this.checkValidity()
    ]);

    return checks.reduce((a, b) => a + b, 0) / checks.length;
  }
}
```

## Vorteile

### 1. Einheitlicher Forschungszugang
- Eine FHIR-API für alle Daten (klinisch + genomisch)
- Standardisierte Abfragesprache (FHIR Search, CQL)
- Konsistente Datenmodelle

### 2. Datenschutzkonformität
- Broad Consent als rechtliche Grundlage
- Pseudonymisierung über etablierte DIZ-Services
- Granulare Zugriffskontrolle über Consent-Ressourcen

### 3. Forschungseffizienz
- Verknüpfung von Genotyp und Phänotyp
- Longitudinale Analysen möglich
- Integration mit bestehenden MII-Daten

### 4. Nachnutzung bestehender Infrastruktur
- DIZ-FHIR-Server werden weitergenutzt
- Pseudonymisierungsdienste (gPAS) integriert
- Bestehende Governance-Prozesse anwendbar

## Herausforderungen

### 1. Datenvolumen
**Problem**: Genomische Daten können sehr groß werden

**Lösung**:
- Binäre Sequenzdaten (BAM/VCF) extern speichern (z.B. S3)
- Nur Metadaten und interpretierte Varianten in FHIR
- DocumentReference für Verweise auf externe Dateien

### 2. Performance
**Problem**: Viele verknüpfte Ressourcen können Abfragen verlangsamen

**Lösung**:
- Indizierung optimieren
- Materialized Views für häufige Queries
- Caching-Strategien

### 3. Consent-Management
**Problem**: Widerrufe und Änderungen müssen zeitnah verarbeitet werden

**Lösung**:
- Event-basierte Architektur für Consent-Updates
- Automatische Datenbereinigung bei Widerruf
- Audit-Trail für alle Zugriffe

## Testing

```typescript
describe('MVGENOMSEQ DIZ Integration', () => {
  it('should integrate patient with valid broad consent', async () => {
    const mvData = loadTestData('valid-kdk-onko.json');
    const result = await dizIntegration.integratePatient(mvData);

    expect(result.success).toBe(true);
    expect(result.patientId).toBeDefined();

    // Verify FHIR resources created
    const patient = await fhirClient.read('Patient', result.patientId);
    expect(patient).toBeDefined();

    const consent = await fhirClient.search('Consent', {
      patient: result.patientId,
      status: 'active'
    });
    expect(consent.entry.length).toBeGreaterThan(0);
  });

  it('should reject patient without broad consent', async () => {
    const mvData = loadTestData('missing-consent.json');

    await expect(
      dizIntegration.integratePatient(mvData)
    ).rejects.toThrow('Erforderlicher Broad Consent nicht vorhanden');
  });
});
```

## Zusammenfassung

Dieser Ansatz ermöglicht die nahtlose Integration von MVGENOMSEQ-Daten in bestehende DIZ-FHIR-Repositorien unter Nutzung des Broad Consent. Dadurch entsteht eine einheitliche Forschungsinfrastruktur, die klinische und genomische Daten zusammenführt und über standardisierte FHIR-APIs zugänglich macht.

**Zentrale Vorteile:**
- Rechtlich abgesichert durch Broad Consent
- Wiederverwendung bestehender DIZ-Infrastruktur
- Einheitlicher Forschungszugang via FHIR
- Datenschutzkonform durch Pseudonymisierung

**Ideal für:**
- DIZs mit etablierten FHIR-Repositorien
- Forschungsprojekte, die klinische und genomische Daten verbinden
- Langfristige Datenhaltung für Sekundärnutzung
