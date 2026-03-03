// --- Patient Extensions ---
// MvgsAddressAgs removed — replaced by MII destatis/ags extension inherited from PatientPseudonymisiert (address[Strassenanschrift].city.extension[gemeindeschluessel])

Extension: MvgsCoverageType
Id: mvgs-coverage-type
Title: "MVGS Versicherungsart"
Description: "Art der Krankenversicherung des Patienten (GKV, PKV etc.)."
Context: Patient
* value[x] only code
* valueCode from MvgsCoverageTypeVS (required)

// --- Submission Extensions ---
Extension: MvgsSubmissionMetadata
Id: mvgs-submission-metadata
Title: "MVGS Übermittlungsmetadaten"
Description: "Zusätzliche Metadaten zur Datenübermittlung (Software-Informationen). Meldungstyp und Datum werden direkt auf der Communication-Ressource abgebildet."
Context: Communication
* extension contains
    softwareName 0..1 and
    softwareVersion 0..1
* extension[softwareName].value[x] only string
* extension[softwareVersion].value[x] only string

Extension: MvgsTransactionNumber
Id: mvgs-transaction-number
Title: "MVGS Vorgangsnummer"
Description: "Eindeutige Vorgangsnummer der Übermittlung."
Context: Communication, Patient
* value[x] only string

// --- Observation (Variant) Extensions ---
Extension: MvgsVariantLocalization
Id: mvgs-variant-localization
Title: "MVGS Varianten-Lokalisierung"
Description: "Lokalisierung der Variante (kodierend, regulatorisch, sonstig)."
Context: Observation
* value[x] only code
* valueCode from MvgsLocalizationVS (required)

// MvgsVariantIdentifier removed — replaced by MII variation-code component (LOINC 81252-9) inherited from MolGen/MTB parent

// --- CarePlan Extensions ---
Extension: MvgsStudyRecommended
Id: mvgs-study-recommended
Title: "MVGS Studienempfehlung"
Description: "Empfehlung zur Studienteilnahme durch das molekulare Tumorboard."
Context: CarePlan
* value[x] only boolean

Extension: MvgsCounsellingRecommended
Id: mvgs-counselling-recommended
Title: "MVGS Beratungsempfehlung"
Description: "Empfehlung zur genetischen Beratung."
Context: CarePlan
* value[x] only boolean

Extension: MvgsReEvaluationRecommended
Id: mvgs-re-evaluation-recommended
Title: "MVGS Re-Evaluierungsempfehlung"
Description: "Empfehlung zur erneuten Evaluation."
Context: CarePlan
* value[x] only boolean

Extension: MvgsInterventionRecommended
Id: mvgs-intervention-recommended
Title: "MVGS Interventionsempfehlung"
Description: "Empfehlung zur therapeutischen Intervention."
Context: CarePlan
* value[x] only boolean

// --- Rare Disease Observation Extensions ---
Extension: MvgsAcmgClass
Id: mvgs-acmg-class
Title: "MVGS ACMG-Klassifikation"
Description: "ACMG/AMP-Klassifikation der Variante (Klasse 1-5)."
Context: Observation
* value[x] only code
* valueCode from MvgsAcmgClassVS (required)

Extension: MvgsAcmgCriteria
Id: mvgs-acmg-criteria
Title: "MVGS ACMG-Kriterien"
Description: "Angewendete ACMG/AMP-Kriterien mit optionalem Stärke-Modifier."
Context: Observation
* extension contains
    criterion 1..1 MS and
    modifier 0..1
* extension[criterion].value[x] only string
* extension[modifier].value[x] only string

// MvgsZygosity removed — replaced by MII allelic-state component (LOINC 53034-5) inherited from MolGen parent

Extension: MvgsSegregationAnalysis
Id: mvgs-segregation-analysis
Title: "MVGS Segregationsanalyse"
Description: "Ergebnis der Segregationsanalyse."
Context: Observation
* value[x] only code
* valueCode from MvgsSegregationAnalysisVS (required)

// MvgsModeOfInheritance removed — replaced by MII variant-inheritance component (LOINC 51958-7) inherited from MolGen parent

Extension: MvgsDiagnosticSignificance
Id: mvgs-diagnostic-significance
Title: "MVGS Diagnostische Signifikanz"
Description: "Diagnostische Signifikanz der Variante."
Context: Observation
* value[x] only code
* valueCode from MvgsDiagnosticSignificanceVS (required)

// --- Rare Disease Condition Extension ---
Extension: MvgsDiagnosticAssessment
Id: mvgs-diagnostic-assessment
Title: "MVGS Diagnostische Bewertung"
Description: "Diagnostische Bewertung der Erkrankung (bestätigt, Verdacht etc.)."
Context: Condition
* value[x] only code
* valueCode from MvgsDiagnosticAssessmentVS (required)
