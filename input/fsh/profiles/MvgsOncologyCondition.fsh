Profile: MvgsOncologyCondition
Id: mvgs-oncology-condition
Parent: https://www.medizininformatik-initiative.de/fhir/ext/modul-mtb/StructureDefinition/mii-pr-mtb-diagnose-primaertumor
Title: "MVGS Onkologische Diagnose"
Description: "Diagnoseprofil für onkologische Erkrankungen im Modellvorhaben Genomsequenzierung."
// MII Parent brings: code.coding slicing (icd10-gm 0..1, alpha-id, sct, orphanet), Feststellungsdatum 1..1, subject MS, stage slicing, onset slicing
// MVGS overrides: icd10-gm mandatory, ICD-O-3 slices, onset restricted to dateTime
* code.coding[icd10-gm] 1..1
// ICD-O-3 Histologie liegt in der MII-Extension mii-ex-onko-histologie-morphologie-icdo3
// ICD-O-3 Topographie liegt in Condition.bodySite (MII-Modell)
* onset[x] only dateTime
* onsetDateTime 1..1 MS
