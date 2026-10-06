# KDK → MII KDS — Vollständige Mappingtabelle

Quellseitig **lückenlos** aus den generierten Logical Models (`KdkOncologyModel`,
`KdkRareDiseasesModel`, KDK-Schema v2.3). Zielseitig aus den vorhandenen MII-Referenz-
mappings (`dnpm-lm-mapping-mii-fhir`, `mii-cm-onkologie-to-mvgenomseq`) + MII-Profilen.

**Konfidenz:** ✓ = Ziel klar · ~ = Ziel plausibel, Element-Pfad zu verifizieren ·
⚠ = offene Design-/Terminologie-Frage · ✗ = kein MII-Ziel / nur KDK-intern.

**Identität/Referenzen:** Jede Ressource `subject` → *ein* provisorischer Patient
(TAN-identifiziert). MII-Pseudonym nicht aus KDK ableitbar → DIZ-Record-Linkage.
Siehe `MAPPING-PLAN.md`.

---

## A. metaData → Person + Consent (beide Indikationen identisch)

| KDK `metaData.…` | Card | MII-Ziel-Profil | Element | K |
|---|---|---|---|---|
| `gender` | 1..1 | Person `PatientPseudonymisiert` | `Patient.gender` (Enum identisch) | ✓ |
| `birthDate` (YYYY-MM) | 1..1 | Person | `Patient.birthDate` | ✓ |
| `tanC` (KDK-TAN) | 1..1 | Person | `Patient.identifier` (eigenes system, **nicht** Pseudonym-Slot) | ⚠ |
| `addressAGS` | 1..1 | Person | `Patient.address.city.extension(destatis/ags)` | ~ |
| `localCaseId` | 0..1 | Person | `Patient.identifier` (LE-lokal) | ~ |
| `coverageType` (GKV/PKV/…) | 1..1 | **Coverage** | `Coverage.type` (fhir.de) | ⚠ eigene Ressource |
| `mvConsent.version` | 1..1 | Consent `mii-pr-consent-einwilligung` | `Consent.policy`/`sourceReference` | ~ |
| `mvConsent.presentationDate` | 0..1 | Consent | `Consent.dateTime` | ~ |
| `mvConsent.scope.type` (permit/deny) | 1..1 | Consent | `provision.type` | ✓ |
| `mvConsent.scope.domain` (mvSequencing/…) | 1..1 | Consent | `provision.provision.code` | ⚠ Policy-CS-Registrierung |
| `mvConsent.scope.date` | 1..1 | Consent | `provision.period.start` | ✓ |
| `researchConsents.scope` (eingebettetes MII-Consent-FHIR) | 0..1 | Consent (Broad Consent) | Pass-through eigene Ressource | ~ |
| `researchConsents.presentationDate` | 1..1 | Consent | `Consent.dateTime` | ~ |
| `researchConsents.schemaVersion` | 0..1 | — | (Metadatum) | ✗ |
| `researchConsents.noScopeJustification` | 0..1 | Consent | `provision`-Begründung/Extension | ⚠ |
| `submission.date/type/submitterId/…Ids` | 1..1 | Bundle/Provenance | `MessageHeader`/`Provenance`/`Bundle.meta` | ~ Metadaten |
| `submission.diseaseType` | 1..1 | (Routing) | wählt Onko- vs. Seltene-Strecke | ✓ |
| `decisionToInclude` | 1..1 | MTB Behandlungsepisode | `EpisodeOfCare.status`/Beschluss | ⚠ |
| `molecularBoardDecisionDate` | 1..1 | MTB | Board-Beschlussdatum (s. plan) | ~ |
| `rejectionJustification` | 0..1 | MTB | Ablehnungsgrund-Extension | ⚠ |

---

## B. Onkologie — `case` → MTB Diagnose / Onkologie / Pathologie

| KDK `case.diagnosisOd.…` | Card | MII-Ziel | Element | K |
|---|---|---|---|---|
| `mainDiagnosis` (ICD-10-GM) | 1..1 | MTB `mii-pr-mtb-diagnose-primaertumor` | `Condition.code` | ✓ |
| `additionalDiagnoses` | 0..* | MTB | weitere `Condition` | ~ |
| `germlineDiagnoses` | 0..* | MTB/Diagnose | `Condition` (Keimbahn) | ~ |
| `germlineDiagnosisConfirmed` | 1..1 | MTB | `Condition.verificationStatus`/Extension | ~ |
| `histology` (ICD-O-3-M) | 1..1 | Onkologie | Histologie-Observation (ICD-O-3) | ✓ |
| `topography` (ICD-O-3-T) | 1..1 | MTB | `Condition.bodySite` | ✓ |
| `grading` | 0..1 | Onkologie | Grading-Observation | ✓ |
| `tnmClassifications` | 0..* | Onkologie | Staging-Observation (TNM, SNOMED) | ✓ |
| `additionalClassification.system/key` | 0..* | Onkologie | Staging-Alternative (String-TNM) | ~ |
| `ecogPerformanceStatusScore` | 1..1 | Onkologie | ECOG-Observation (LOINC 89247-1) | ✓ |
| `hpoTerms` | 0..* | Mol.gen/Seltene | HPO-Observation | ~ |
| `libraryType` | 1..1 | MTB/GenomicStudy | `GenomicStudy`-Art / Sequenzierungsart | ~ |
| `diagnosticAssessment` | 0..1 | MTB | Beurteilung-Extension | ⚠ |
| `case.priorDiagnostics.type/date` | 0..* | MTB/Pathologie | `DiagnosticReport` (Vordiagnostik) | ~ |
| `case.priorDiagnostics.simpleVariants.*` | 0..* | MTB | Einfache Variante (Vorbefund) → s. Variant-Komponenten | ~ |
| `case.priorDiagnostics.complexVariants` | 0..* | MTB | freitextliche Variante | ⚠ |
| `case.priorProcedures.treatmentType` | 0..* | MTB | Systemische Vortherapie `MedicationStatement`/`Procedure` | ✓ |
| `case.priorProcedures.intention` | 0..1 | MTB | `.extension(Intention)` | ~ |
| `case.priorProcedures.substances.code/name` | 0..* | MTB | `MedicationStatement.medication[x]` (ATC) | ✓ |
| `case.priorProcedures.therapyStartDate/EndDate` | | MTB | `.effectivePeriod` | ✓ |
| `case.priorProcedures.terminationReasonOBDS` | 0..1 | MTB | `.statusReason` | ✓ |
| `case.priorProcedures.therapyResponse/Date` | 0..1 | MTB | Response-Observation (RECIST) | ✓ |

---

## C. Onkologie — `molecular` → MTB Varianten

Alle Varianten → `Observation` (MTB `mii-pr-mtb-einfache-variante` bzw. CNV/Fusion),
Sub-Felder → `Observation.component` (genomics-reporting-Codes).

| KDK `molecular.smallVariants.…` | Card | MII-Ziel | Element | K |
|---|---|---|---|---|
| `identifier` | 1..1 | MTB Einfache Variante | `Observation.identifier` (KDK-intern → urn:uuid für Referenzen!) | ⚠ |
| `gene` (HGNC) | 1..1 | | `component[gene-studied]` | ✓ |
| `transcriptId` | 0..1 | | `component[transcript-ref-seq]` | ~ |
| `dnaChange` (HGVSc) | 1..1 | | `component[representative-coding-hgvs]` | ✓ |
| `proteinChange` (HGVSp) | 0..1 | | `component[representative-protein-hgvs]` | ✓ |
| `genomicSource` (somatic/germline) | 1..1 | | `component[genomic-source-class]` | ✓ |
| `chromosome` | 1..1 | | `component[chromosome-identifier]` | ✓ |
| `startPosition`/`endPosition` | 1..1 | | `component[exact-start-end]` (Range) | ✓ |
| `ref`/`alt` | 1..1 | | `component[ref-allele]`/`[alt-allele]` | ✓ |
| `variantTypes` | 0..* | | `component[variant-type]` (SO) | ~ |
| `localization` | 1..1 | | `component[feature-consequence]`/Region | ~ |
| `loh` | 0..1 | | `component[loss-of-heterozygosity]` | ⚠ |
| `molecular.copyNumberVariants.*` | 0..* | MTB CNV-Observation | `cnvType`→`component[copy-number]`, `gene`/`chromosome`/Positionen | ✓ |
| `molecular.structuralVariants.*` | 0..* | MTB Fusion-Observation | `geneA`/`geneB`→Fusionspartner, `structureType`/`sequenceType` | ~ |
| `molecular.expressionVariants.*` | 0..* | MTB Expression-Observation | `gene`/`expressionType`/`reference` | ~ |
| `molecular.complexBiomarkers.tmb` | 0..1 | MTB | Tumor Mutational Burden (Observation) | ✓ |
| `molecular.complexBiomarkers.hrdHigh` | 0..1 | MTB | HRD-Score (Observation) | ✓ |
| `molecular.complexBiomarkers.ploidy/lstHigh/taiHigh` | 0..1 | MTB | Biomarker-Observations | ~ |
| `molecular.sbsSignatures.name/version` | 0..* | MTB | Mutationssignatur-Observation | ⚠ |

---

## D. Onkologie — `plan` → MTB Therapieplan

| KDK `plan.…` | Card | MII-Ziel | Element | K |
|---|---|---|---|---|
| `carePlanOd` | 1..1 | MTB `mii-pr-mtb-therapieplan` | `CarePlan` | ✓ |
| `carePlanOd.molecularBoardDecisionDate` | 1..1 | | `CarePlan.created` | ✓ |
| `carePlanOd.studyRecommended` | 1..1 | | Vorhandensein Studieneinschluss-`ServiceRequest` | ~ |
| `carePlanOd.counsellingRecommended` | 1..1 | | Humangenetische Beratung (`ServiceRequest`) | ✓ |
| `carePlanOd.reEvaluationRecommended` | 1..1 | | Re-Evaluation-Empfehlung | ~ |
| `carePlanOd.interventionRecommended` | 1..1 | | präventive Intervention | ~ |
| `carePlanOd.suitableInterventions.*` | 0..* | | Präventionsempfehlung (`type.code`) | ~ |
| `recommendedSystemicTherapies.identifier` | 1..1 | MTB Therapieempfehlung | `MedicationRequest` (KDK-intern → urn:uuid) | ⚠ |
| `recommendedSystemicTherapies.substances.code/name` | 1..* | | `MedicationRequest.medication[x]` (ATC) | ✓ |
| `recommendedSystemicTherapies.priority` | 1..1 | | `.extension(Prioritaet)` | ✓ |
| `recommendedSystemicTherapies.evidenceLevel(+Details)` | 1..1 | | `.extension(Evidenzgraduierung)` | ✓ |
| `recommendedSystemicTherapies.variants` | 0..* | | `.supportingInfo` → Varianten-Observation-Ref | ⚠ Ref-Auflösung |
| `recommendedSystemicTherapies.type`/`therapeuticStrategy` | 1..1 | | `.intent`/Strategie-Extension | ~ |
| `recommendedStudies.register/name/id` | 0..* | MTB Studieneinschluss | `ServiceRequest` (Register/NCT) | ✓ |
| `recommendedStudies.evidenceLevel(+Details)` | 1..1 | | Evidenz-Extension | ~ |
| `recommendedStudies.variants` | 0..* | | `.supportingInfo` | ⚠ |
| `preventiveMeasures.identifier/type` | 0..* | MTB | Präventionsmaßnahme (`ServiceRequest`/`Procedure`) | ~ |

---

## E. Onkologie — `followUp` → MTB Follow-Up / Verlauf

| KDK `followUp.followUpOds.…` | Card | MII-Ziel | Element | K |
|---|---|---|---|---|
| `followUpDate` | 1..1 | MTB Follow-Up (`ClinicalImpression`) | `.effectiveDateTime` | ✓ |
| `vitalStatus` | 1..1 | MTB | Vitalstatus-Observation / `Patient.deceased[x]` | ✓ |
| `lastContactDate` | 0..1 | MTB | letzter Kontakt | ~ |
| `deathDate` | 0..1 | Person/MTB | `Patient.deceasedDateTime` | ✓ |
| `ecogPerformanceStatusScore` | 1..1 | Onkologie | ECOG-Observation | ✓ |
| `metachroneDiagnoses` | 1..1 | MTB | metachrone Diagnose-Flag | ~ |
| `additionalDiagnoses`/`phenotypes` | 0..* | MTB/Mol.gen | Condition / HPO-Observation | ~ |
| `therapies.reference` | 1..1 | MTB | Ref auf Therapieempfehlung (urn:uuid) | ⚠ Ref-Auflösung |
| `therapies.substances.code/name` | 0..* | MTB Systemische Therapie | `MedicationStatement.medication[x]` | ✓ |
| `therapies.therapyStartDate/EndDate` | | MTB | `.effectivePeriod` | ✓ |
| `therapies.terminationReasonOBDS` | 0..1 | MTB | `.statusReason` | ✓ |
| `therapies.therapyResponse/Date/Source` | 0..1 | MTB | Response-Observation (RECIST) | ✓ |
| `preventiveMeasures.reference/Date/Result/type` | 0..* | MTB | Präventions-`Procedure` + Ergebnis | ~ |

---

## F. Seltene — `case` → MII Diagnose / HPO

| KDK `case.diagnosisRd.…` | Card | MII-Ziel | Element | K |
|---|---|---|---|---|
| `diagnoses` (ICD-10-GM/ORPHA/AlphaID) | 1..* | `mii-pr-diagnose-condition` | `Condition.code` | ✓ |
| `noMatchingCodeExists` | 0..1 | Diagnose | `Condition.code`-Absentreason | ~ |
| `diagnosisGmfcs` | 0..1 | Seltene | GMFCS-Observation | ~ |
| `phenotypes` (HPO) | 1..* | Seltene `mii-pr-seltene-hpo-assessment` | HPO-Observation | ✓ |
| `symptomOnsetDate` | 1..1 | Diagnose | `Condition.onset[x]` | ✓ |
| `molecularBoardDecisionDate` | 1..1 | Seltene | Board-Datum | ~ |
| `diagnosticExtent` | 1..1 | Mol.gen/GenomicStudy | Umfang-Extension | ~ |
| `libraryType` | 1..1 | Mol.gen | Sequenzierungsart | ~ |
| `diagnosticAssessment` | 1..1 | Seltene | Beurteilung | ⚠ |
| `case.priorRds.genomicTestType/StudyType` | 0..* | Mol.gen | Vordiagnostik `GenomicStudy` | ~ |
| `case.priorRds.diagnosticDate/Result` | | Mol.gen | Ergebnis-Observation | ~ |
| `case.priorRds.hospitalization*`/`zseContactDate` | | Fall/Encounter | Versorgungskontext | ⚠ |

---

## G. Seltene — `molecular` → MolGen Variante

Alle Varianten → `Observation` (`mii-pr-molgen-variante`), Sub-Felder → `component`.
Zygosität/Vererbung → MVGS-Extensions bzw. MolGen allelic-state/variant-inheritance.

| KDK `molecular.smallVariants.…` | Card | MII-Ziel | Element | K |
|---|---|---|---|---|
| `identifier` | 1..1 | MolGen Variante | `Observation.identifier` (KDK-intern → urn:uuid) | ⚠ |
| `genes.code` | 0..* | | `component[gene-studied]` | ✓ |
| `cdnaChange` (HGVSc) | 0..1 | | `component[representative-coding-hgvs]` | ✓ |
| `proteinChange` (HGVSp) | 0..1 | | `component[representative-protein-hgvs]` | ✓ |
| `gdnaChange` (HGVSg) | 0..1 | | `component[representative-genomic-hgvs]` | ✓ |
| `chromosome`/`startPosition`/`endPosition` | 1..1 | | `component[chromosome-identifier]`/`[exact-start-end]` | ✓ |
| `ref`/`alt` | 1..1 | | `component[ref-allele]`/`[alt-allele]` | ✓ |
| `localization.code` | 0..* | | `component[feature-consequence]` | ~ |
| `acmgClass` | 0..1 | | `component[acmg]` / ValueSet `mvgs-acmg-class-vs` | ✓ |
| `acmgCriteria.value/modifier` | 0..* | | `component[acmg-criteria]` | ~ |
| `zygosity` | 0..1 | | MVGS `MvgsZygosity` / MolGen `component[allelic-state]` | ⚠ |
| `modeOfInheritance` | 0..1 | | MVGS `MvgsModeOfInheritance` / `component[variant-inheritance]` | ⚠ |
| `segregationAnalysis` | 0..1 | | `component[segregation]` / CS `mvgs-segregation-analysis` | ~ |
| `diagnosticSignificance` | 0..1 | | CS `mvgs-diagnostic-significance` | ~ |
| `externalId`/`publications` | 0..* | | `Observation.derivedFrom`/`.note` (PMID) | ~ |
| `molecular.structuralVariants.*` | 0..* | MolGen SV-Observation | analog + `structureType` | ~ |
| `molecular.copyNumberVariants.*` | 0..* | MolGen CNV-Observation | analog + `type` (gain/loss) | ~ |

---

## H. Seltene — `plan` + `followUp`

| KDK | Card | MII-Ziel | Element | K |
|---|---|---|---|---|
| `plan.carePlanRd.*` (studyRecommended/therapyRecommended/…) | 1..1 | Seltene CarePlan | `CarePlan` + Empfehlungs-Flags | ~ |
| `plan.carePlanRd.clinicalManagementDescriptions` | 0..* | Seltene | klinisches Management (Freitext-Code) | ~ |
| `plan.recommendedTherapies.type/strategy/…` | 0..* | `mii-pr-seltene-therapieempfehlung` | Therapieempfehlung | ✓ |
| `plan.recommendedTherapies.variants` | 0..* | | `.supportingInfo` → Varianten-Ref | ⚠ |
| `plan.recommendedStudies.register/name/id` | 0..* | Seltene Studieneinschluss | `ServiceRequest` | ✓ |
| `followUp.followUpRds.followUpDate` | 1..1 | Seltene Verlauf | `ClinicalImpression.effectiveDateTime` | ✓ |
| `followUp.followUpRds.phenotypes` | 1..* | Seltene | HPO-Verlaufs-Observation | ✓ |
| `followUp.followUpRds.diagnosisEstablished` | 1..1 | Seltene | Diagnose-gesichert-Flag | ~ |
| `followUp.followUpRds.diseaseProgression` | 0..1 | Seltene | Verlaufsbeurteilung | ~ |
| `followUp.followUpRds.vitalStatus`/`deathDate` | 1..1 | Person/Seltene | `Patient.deceased[x]` | ✓ |
| `followUp.followUpRds.gmfcs` | 0..1 | Seltene | GMFCS-Observation | ~ |

---

## Zusammenfassung Abdeckung

| Bereich | KDK-Elemente | ✓ klar | ~ zu verifizieren | ⚠ offen |
|---|---|---|---|---|
| metaData → Person/Consent | ~28 | Kern | Metadaten/Address | Pseudonym, Consent-Domänen, coverageType |
| Onko case/molecular/plan/followUp | ~156 | Diagnose, Varianten-Kern, Therapie | Fusion/Expression, Prävention | Ref-Auflösung, Biomarker-Signaturen |
| Seltene case/molecular/plan/followUp | ~120 | Diagnose, HPO, Varianten-Kern | Vordiagnostik, CarePlan | Zygosität/Vererbung-Ziel, Encounter |

**Querschnittsthemen (alle Bereiche):** (1) KDK-interne `identifier` (Varianten↔Therapie/
Follow-up-Referenzen) → deterministische `urn:uuid`-Auflösung; (2) `subject`-Achse zum
provisorischen Patienten; (3) Terminologie-Validierung der `Coding`-Felder gegen die
gebundenen ValueSets steht aus.
