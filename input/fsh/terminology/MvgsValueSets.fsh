ValueSet: MvgsSubmissionTypeVS
Id: mvgs-submission-type-vs
Title: "MVGS Übermittlungsart"
Description: "Art der Datenübermittlung."
* include codes from system MvgsSubmissionTypeCS

ValueSet: MvgsDiseaseTypeVS
Id: mvgs-disease-type-vs
Title: "MVGS Erkrankungstyp"
Description: "Typ der Erkrankung."
* include codes from system MvgsDiseaseTypeCS

ValueSet: MvgsCoverageTypeVS
Id: mvgs-coverage-type-vs
Title: "MVGS Versicherungsart"
Description: "Art der Krankenversicherung."
* include codes from system MvgsCoverageTypeCS

ValueSet: MvgsConsentDomainVS
Id: mvgs-consent-domain-vs
Title: "MVGS Einwilligungsdomänen"
Description: "Domänen der Einwilligung."
* include codes from system MvgsConsentDomainCS

ValueSet: MvgsLocalizationVS
Id: mvgs-localization-vs
Title: "MVGS Varianten-Lokalisierung (Onkologie)"
Description: "Lokalisierung einer Variante (Onkologie)."
* include codes from system MvgsLocalizationCS

ValueSet: MvgsLocalizationRdVS
Id: mvgs-localization-rd-vs
Title: "MVGS Varianten-Lokalisierung (SE)"
Description: "Lokalisierung einer Variante (Seltene Erkrankungen)."
* include codes from system MvgsLocalizationRdCS

ValueSet: MvgsAcmgClassVS
Id: mvgs-acmg-class-vs
Title: "MVGS ACMG-Klassifikation"
Description: "ACMG/AMP-Klassen 1-5."
* include codes from system MvgsAcmgClassCS

ValueSet: MvgsEvidenceLevelVS
Id: mvgs-evidence-level-vs
Title: "MVGS Evidenzlevel"
Description: "Evidenzlevel für therapeutische Empfehlungen."
* include codes from system MvgsEvidenceLevelCS

ValueSet: MvgsTherapeuticStrategyVS
Id: mvgs-therapeutic-strategy-vs
Title: "MVGS Therapiestrategie"
Description: "Empfohlene therapeutische Strategien."
* include codes from system MvgsTherapeuticStrategyCS

ValueSet: MvgsZygosityVS
Id: mvgs-zygosity-vs
Title: "MVGS Zygotie"
Description: "Zygotie einer Variante. Kombiniert LOINC Allelic State (LL381-5) und MVGS-spezifische Codes."
// LOINC LL381-5 — Allelic State
* $LOINC#LA6703-8 "Heteroplasmic"
* $LOINC#LA6704-6 "Homoplasmic"
* $LOINC#LA6705-3 "Homozygous"
* $LOINC#LA6706-1 "Heterozygous"
* $LOINC#LA6707-9 "Hemizygous"
// MVGS-spezifische Codes
* include codes from system MvgsZygosityCS

ValueSet: MvgsSegregationAnalysisVS
Id: mvgs-segregation-analysis-vs
Title: "MVGS Segregationsanalyse"
Description: "Ergebnis der Segregationsanalyse."
* include codes from system MvgsSegregationAnalysisCS

ValueSet: MvgsModeOfInheritanceVS
Id: mvgs-mode-of-inheritance-vs
Title: "MVGS Vererbungsmodus"
Description: "Vererbungsmodus einer Variante. Kombiniert LOINC Variant Inheritance (LL5489-1) und MVGS-spezifische Codes."
// LOINC LL5489-1 — Origin of Genetic Variance
* $LOINC#LA26320-4 "Maternal"
* $LOINC#LA26321-2 "Paternal"
* $LOINC#LA26807-0 "De novo"
* $LOINC#LA4489-6 "Unknown"
* $LOINC#LA30680-5 "Parental"
// MVGS-spezifische Codes
* include codes from system MvgsModeOfInheritanceCS

ValueSet: MvgsDiagnosticSignificanceVS
Id: mvgs-diagnostic-significance-vs
Title: "MVGS Diagnostische Signifikanz"
Description: "Diagnostische Signifikanz einer Variante."
* include codes from system MvgsDiagnosticSignificanceCS

ValueSet: MvgsDiagnosticAssessmentVS
Id: mvgs-diagnostic-assessment-vs
Title: "MVGS Diagnostische Bewertung"
Description: "Diagnostische Bewertung der Erkrankung."
* include codes from system MvgsDiagnosticAssessmentCS

ValueSet: MvgsGenomicSourceVS
Id: mvgs-genomic-source-vs
Title: "MVGS Genomische Herkunft"
Description: "Genomische Herkunft der Variante (somatisch/Keimbahn)."
* $LOINC#LA6683-2 "Germline"
* $LOINC#LA6684-0 "Somatic"

ValueSet: MvgsRelationshipVS
Id: mvgs-relationship-vs
Title: "MVGS Verwandtschaftsbeziehung"
Description: "Verwandtschaftsbeziehung zum Index-Patienten für Trio-WES/WGS."
// HL7 v3 RoleCode
* $V3RoleCode#MTH "mother"
* $V3RoleCode#FTH "father"
* $V3RoleCode#NBRO "natural brother"
* $V3RoleCode#NSIS "natural sister"
* $V3RoleCode#SIB "sibling"
* $V3RoleCode#CHILD "child"
// SNOMED CT
* $SCT#72705000 "Mother"
* $SCT#66839005 "Father"
* $SCT#70924004 "Brother"
* $SCT#27733009 "Sister"
* $SCT#375005 "Sibling"
* $SCT#67822003 "Child"

ValueSet: MvgsChromosomeVS
Id: mvgs-chromosome-vs
Title: "MVGS Chromosomen"
Description: "Menschliche Chromosomen."
* $LOINC#LA21254-7 "Chromosome 1"
* $LOINC#LA21255-4 "Chromosome 2"
* $LOINC#LA21256-2 "Chromosome 3"
* $LOINC#LA21257-0 "Chromosome 4"
* $LOINC#LA21258-8 "Chromosome 5"
* $LOINC#LA21259-6 "Chromosome 6"
* $LOINC#LA21260-4 "Chromosome 7"
* $LOINC#LA21261-2 "Chromosome 8"
* $LOINC#LA21262-0 "Chromosome 9"
* $LOINC#LA21263-8 "Chromosome 10"
* $LOINC#LA21264-6 "Chromosome 11"
* $LOINC#LA21265-3 "Chromosome 12"
* $LOINC#LA21266-1 "Chromosome 13"
* $LOINC#LA21267-9 "Chromosome 14"
* $LOINC#LA21268-7 "Chromosome 15"
* $LOINC#LA21269-5 "Chromosome 16"
* $LOINC#LA21270-3 "Chromosome 17"
* $LOINC#LA21271-1 "Chromosome 18"
* $LOINC#LA21272-9 "Chromosome 19"
* $LOINC#LA21273-7 "Chromosome 20"
* $LOINC#LA21274-5 "Chromosome 21"
* $LOINC#LA21275-2 "Chromosome 22"
* $LOINC#LA21276-0 "Chromosome X"
* $LOINC#LA21277-8 "Chromosome Y"
