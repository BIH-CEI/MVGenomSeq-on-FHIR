Instance: ExampleRdPatient
InstanceOf: MvgsPatient
Usage: #example
Title: "Beispiel: SE-Patient"
Description: "Beispielpatient mit Entwicklungsverzögerung (Seltene Erkrankung)."
* identifier[PseudonymisierterIdentifier].type = http://terminology.hl7.org/CodeSystem/v3-ObservationValue#PSEUDED
* identifier[PseudonymisierterIdentifier].system = "http://example.org/fhir/sid/pseudonym"
* identifier[PseudonymisierterIdentifier].value = "SE-2024-001"
* identifier[PseudonymisierterIdentifier].assigner.identifier.system = "http://example.org/fhir/sid/org"
* identifier[PseudonymisierterIdentifier].assigner.identifier.value = "Charite"
* gender = #male
* birthDate = "2020-03"

Instance: ExampleRdPhenotype
InstanceOf: Observation
Usage: #example
Title: "Beispiel: HPO-Phänotyp"
Description: "Beispiel einer HPO-Phänotyp-Beobachtung (Global developmental delay)."
* status = #final
* category = $ObsCat#laboratory
* code = $HPO#HP:0001263 "Global developmental delay"
* subject = Reference(ExampleRdPatient)
* valueCodeableConcept.coding.system = $SCT
* valueCodeableConcept.coding.code = #52101004
* valueCodeableConcept.coding.display = "Present"
