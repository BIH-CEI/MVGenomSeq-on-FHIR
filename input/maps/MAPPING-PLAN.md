# KDK → MII KDS — Mapping-Architektur (StructureMaps)

Richtung: **BfArM-KDK-Submission (JSON) → MII-KDS FHIR-Ressourcen**. Quelle sind die
generierten Logical Models (`input/fsh/logical-models/Kdk*.fsh`), Ziel die MII-Profile,
von denen die MVGenomSeq-Profile bereits erben.

Status: **Draft / Phase 1.** metaData→Person+Consent ist konkret ausformuliert;
case/plan/molecular/followUp sind gerüstet (Kern-Elemente + TODOs). Validierung via
Matchbox steht aus.

## Quell-Logical-Models (aus KDK-Schema v2.3 generiert)

| Model | Wurzelschema | Zweck |
|-------|-------------|-------|
| `KdkOncologyModel` | Oncology.json | Onkologie-Einreichung (Quelle) |
| `KdkRareDiseasesModel` | RareDiseases.json | Seltene-Einreichung (Quelle) |
| `KdkSubmissionMetaData` | Submission.json | metaData (Doku; in beiden Roots als `metaData` eingebettet) |

Neu erzeugen: `python3 tools/kdk_schema_to_fsh_logical.py <KDK-Schema-Dir> input/fsh/logical-models`

## StructureMaps

| Datei | Quelle → Ziel |
|-------|---------------|
| `kdk-oncology-to-mii-kds.fml` | KdkOncologyModel → Bundle (MII Person, Consent, MTB) |
| `kdk-rarediseases-to-mii-kds.fml` | KdkRareDiseasesModel → Bundle (MII Person, Consent, Seltene, MolGen) |

## Routing: metaData → Person + Consent  (gemeinsam beide Indikationen)

| KDK (`metaData.…`) | MII-Ziel | Element | Status |
|---|---|---|---|
| `gender` (male/female/other/unknown) | Person `PatientPseudonymisiert` | `Patient.gender` | ✓ direkt (Enum identisch) |
| `birthDate` (YYYY-MM) | Person | `Patient.birthDate` | ✓ direkt |
| `tanC` (KDK-TAN, RKI/KDK-Domäne) | Person | `Patient.identifier` (**eigenes** system, NICHT MII-Pseudonym-Slot) | ⚠ Pseudonym-Domäne, s.u. |
| *(MII-Pseudonym)* | Person | `Patient.identifier` (Pseudonym-Slot) | ✗ nicht aus KDK ableitbar → DIZ |
| `localCaseId` | Person | `Patient.identifier` (weiterer) | ○ optional |
| `addressAGS` | Person | `Patient.address` + destatis/ags-Extension | ⚠ Extension-URL prüfen |
| `coverageType` (GKV/PKV/…) | **Coverage** (nicht Person) | `Coverage.type` | ⚠ eigene Ressource, TODO |
| `mvConsent.version` | Consent `mii-pr-consent-einwilligung` | `Consent.sourceReference`/policy | ⚠ MVGS-Domänen offen |
| `mvConsent.scope[].type` (permit/deny) | Consent | `provision.type` | ✓ Kern |
| `mvConsent.scope[].domain` (mvSequencing/reIdentification/caseIdentification) | Consent | `provision.provision.code` | ⚠ Policy-CodeSystem-Registrierung offen |
| `mvConsent.scope[].date` | Consent | `provision.period` | ✓ Kern |
| `researchConsents[].scope` (eingebettetes MII-Consent-FHIR) | Consent (MII Broad Consent) | Pass-through | ⚠ separate Ressource |

## Routing: case/plan/molecular/followUp (Onkologie → MTB)

| KDK | MII-Ziel-Profil | Status |
|---|---|---|
| `case.diagnosisOd` | `mii-pr-mtb-diagnose-primaertumor` (Condition) | Gerüst |
| `case.diagnosisOd.mainDiagnosis` (ICD-10-GM) | `Condition.code` | Kern |
| `case.diagnosisOd.histology`/`topography` (ICD-O-3) | Condition-Extensions Morphologie/Topographie | TODO |
| `case.diagnosisOd.ecogPerformanceStatusScore` | MTB ECOG Observation | TODO |
| `molecular.smallVariants[]` | `mii-pr-mtb-einfache-variante` (Observation) | Gerüst |
| `molecular.copyNumberVariants[]` / `structuralVariants[]` | MTB CNV/SV Observations | TODO |
| `plan.recommendedSystemicTherapies[]` | `mii-pr-mtb-therapieplan` (CarePlan) + Empfehlungen | Gerüst |
| `plan.recommendedStudies[]` | MTB Studienempfehlung | TODO |
| `followUp.followUpOds[]` | `mii-pr-mtb-verlauf` (Observation) | TODO |

## Routing: case/plan/molecular/followUp (Seltene → MII Seltene / MolGen)

| KDK | MII-Ziel-Profil | Status |
|---|---|---|
| `case.diagnosis*` | `mii-pr-diagnose-condition` (Diagnose) | Gerüst |
| `case` HPO-Terme | `mii-pr-seltene-hpo-assessment` | TODO |
| `molecular.*variants[]` | `mii-pr-molgen-variante` (Observation) | Gerüst |
| `plan.recommendedTherapies[]` | `mii-pr-seltene-therapieempfehlung` | TODO |
| `plan.recommendedStudies[]` | Seltene Studienempfehlung | TODO |

## Offene Punkte
- MVGS-Consent-Domänen (mvSequencing/reIdentification/caseIdentification) noch nicht im MII-Consent-Policy-CodeSystem registriert → `provision.code`-Mapping vorläufig.
- `addressAGS`: exakte destatis/ags-Extension-URL des MII-Person-Moduls verifizieren.
- `coverageType` erzeugt eine Coverage-Ressource (außerhalb Person-Profil) — Entscheidung nötig.
- Matchbox-Validierung gegen lokale synthetische Testdaten (DNPM/NSE) ausstehend.
