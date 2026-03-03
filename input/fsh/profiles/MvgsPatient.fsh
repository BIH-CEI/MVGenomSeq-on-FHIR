Profile: MvgsPatient
Id: mvgs-patient
Parent: https://www.medizininformatik-initiative.de/fhir/core/modul-person/StructureDefinition/PatientPseudonymisiert
Title: "MVGS Patient"
Description: "Patientenprofil für das Modellvorhaben Genomsequenzierung."
// MII Parent brings: identifier 1..* with type/assigner, gender MS, birthDate MS, address[Strassenanschrift] with postalCode 1..1 and destatis/ags extension
// MVGS overrides: gender and birthDate mandatory (1..1)
* gender 1..1
* birthDate 1..1
  * ^short = "Geburtsdatum (YYYY-MM)"
  * ^comment = "Im Modellvorhaben wird nur Jahr und Monat übermittelt."
* extension contains MvgsCoverageType named coverageType 0..1 MS
