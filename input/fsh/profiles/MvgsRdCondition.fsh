Profile: MvgsRdCondition
Id: mvgs-rd-condition
Parent: https://www.medizininformatik-initiative.de/fhir/core/modul-diagnose/StructureDefinition/Diagnose
Title: "MVGS Seltene-Erkrankungen-Diagnose"
Description: "Diagnoseprofil für seltene Erkrankungen im Modellvorhaben Genomsequenzierung."
// MII Parent brings: code 1..1, code.coding slicing (icd10-gm, alpha-id, sct, orphanet), recordedDate 1..1, subject MS, onset[x] MS
// MVGS overrides: make icd10-gm, orphanet, alpha-id mandatory (1..1)
* code.coding[icd10-gm] 1..1
* code.coding[orphanet] 1..1
* code.coding[alpha-id] 1..1
* extension contains MvgsDiagnosticAssessment named diagnosticAssessment 0..1 MS
