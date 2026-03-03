Profile: MvgsConsent
Id: mvgs-consent
Parent: https://www.medizininformatik-initiative.de/fhir/modul-consent/StructureDefinition/mii-pr-consent-einwilligung
Title: "MVGS Einwilligung"
Description: "Einwilligungsprofil für das Modellvorhaben Genomsequenzierung."
// MII Parent brings: scope = research, patient 1..1, dateTime 1..1, category 2..* (LOINC 57016-8 + MII module), policy 1..* with uri 1..1, provision with type+period mandatory, provision.provision with code from MII policy VS (required binding)
// MVGS consent domains (mvSequencing, reIdentification, caseIdentification) must be registered in MII Consent Policy CodeSystem for use as provision.provision.code values.
// Currently inheriting MII provision structure as-is.
* status MS
