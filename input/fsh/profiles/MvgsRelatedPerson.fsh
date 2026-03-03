Profile: MvgsRelatedPerson
Id: mvgs-related-person
Parent: RelatedPerson
Title: "MVGS Angehöriger"
Description: "Verwandtschaftsbeziehung zum Index-Patienten für Trio-WES/WGS. Eltern und Geschwister werden als eigene MvgsPatient-Ressourcen geführt (da sie selbst sequenziert werden); dieses Profil stellt die Beziehung zum Index-Patienten her."
// No MII parent — neither MolGen, Seltene, nor Base define a RelatedPerson profile
// MII uses FamilyMemberHistory for family history (different purpose)
* patient 1..1 MS
  * reference 1..1
* patient only Reference(MvgsPatient)
* relationship 1..1 MS
* relationship from MvgsRelationshipVS (required)
* identifier 1..* MS
