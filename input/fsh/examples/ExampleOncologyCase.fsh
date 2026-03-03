Instance: ExampleOncologyPatient
InstanceOf: MvgsPatient
Usage: #example
Title: "Beispiel: Onkologische Patientin"
Description: "Beispielpatientin mit Mammakarzinom."
* identifier[PseudonymisierterIdentifier].type = http://terminology.hl7.org/CodeSystem/v3-ObservationValue#PSEUDED
* identifier[PseudonymisierterIdentifier].system = "http://example.org/fhir/sid/pseudonym"
* identifier[PseudonymisierterIdentifier].value = "ONKO-2024-001"
* identifier[PseudonymisierterIdentifier].assigner.identifier.system = "http://example.org/fhir/sid/org"
* identifier[PseudonymisierterIdentifier].assigner.identifier.value = "Charite"
* gender = #female
* birthDate = "1965-07"

Instance: ExampleOncologyCondition
InstanceOf: MvgsOncologyCondition
Usage: #example
Title: "Beispiel: Mammakarzinom-Diagnose"
Description: "Beispieldiagnose Mammakarzinom mit ICD-10-GM-Kodierung."
* clinicalStatus = http://terminology.hl7.org/CodeSystem/condition-clinical#active "Active"
* category = $CondCat#encounter-diagnosis "Encounter Diagnosis"
* extension[Feststellungsdatum].valueDateTime = "2024-01-10"
* code.coding[icd10-gm].system = $ICD10GM
* code.coding[icd10-gm].version = "2024"
* code.coding[icd10-gm].code = #C50.9
* code.coding[icd10-gm].display = "Bösartige Neubildung der Brustdrüse, nicht näher bezeichnet"
* subject = Reference(ExampleOncologyPatient)
* onsetDateTime = "2024-01-15"
* recordedDate = "2024-01-15"

Instance: ExampleOncologyBRCA2Variant
InstanceOf: MvgsOncologySmallVariant
Usage: #example
Title: "Beispiel: BRCA2-Variante"
Description: "Beispiel einer somatischen BRCA2-Variante bei Mammakarzinom."
* status = #final
* category[labCategory] = $ObsCat#laboratory
* category[geCategory] = http://terminology.hl7.org/CodeSystem/v2-0074#GE
* subject = Reference(ExampleOncologyPatient)
* valueCodeableConcept = $LOINC#LA9633-4 "Present"
* component[gene-studied].valueCodeableConcept.coding.system = $HGNC
* component[gene-studied].valueCodeableConcept.coding.code = #HGNC:1101
* component[gene-studied].valueCodeableConcept.coding.display = "BRCA2"
* component[representative-coding-hgvs].valueCodeableConcept.coding.system = "http://varnomen.hgvs.org"
* component[representative-coding-hgvs].valueCodeableConcept.coding.code = #c.7397C>T
* component[representative-protein-hgvs].valueCodeableConcept.coding.system = "http://varnomen.hgvs.org"
* component[representative-protein-hgvs].valueCodeableConcept.coding.code = #p.Ser2466Leu
* component[genomic-source-class].valueCodeableConcept = $LOINC#LA6684-0 "Somatic"
* component[chromosome-identifier].valueCodeableConcept = $LOINC#LA21266-1 "Chromosome 13"
