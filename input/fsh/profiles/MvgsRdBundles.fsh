// ============================================================================
// Seltene-Erkrankungen-Bundle-Profile für die vier Meldungstypen
// Parent: Bundle (TODO: Switch to MII Basis Bundle when available in base package)
// ============================================================================
// Jedes Bundle enthält eine MvgsSubmissionCommunication als ersten Entry,
// die alle Übermittlungsmetadaten (Meldungstyp, Datum, Vorgangsnummer) trägt.
// ============================================================================

// ---------------------------------------------------------------------------
// Erstmeldung (initial)
// ---------------------------------------------------------------------------
Profile: MvgsRdInitialBundle
Id: mvgs-rd-initial-bundle
Parent: Bundle
Title: "MVGS Seltene Erkrankungen Erstmeldung"
Description: "Bundle-Profil für die Erstmeldung eines Falls seltener Erkrankungen im Modellvorhaben Genomsequenzierung."
* type = #collection
* timestamp 1..1 MS
* entry MS
  * ^slicing.discriminator.type = #profile
  * ^slicing.discriminator.path = "resource"
  * ^slicing.rules = #open
* entry contains
    communication 1..1 MS and
    patient 1..1 MS and
    consent 1..1 MS and
    condition 1..1 MS and
    smallVariant 0..* MS and
    phenotype 0..* MS
* entry[communication].resource only MvgsSubmissionCommunication
* entry[communication].fullUrl 1..1 MS
* entry[patient].resource only MvgsPatient
* entry[patient].fullUrl 1..1 MS
* entry[consent].resource only MvgsConsent
* entry[consent].fullUrl 1..1 MS
* entry[condition].resource only MvgsRdCondition
* entry[condition].fullUrl 1..1 MS
* entry[smallVariant].resource only MvgsRdSmallVariant
* entry[smallVariant].fullUrl 1..1 MS
* entry[phenotype].resource only Observation
* entry[phenotype].fullUrl 1..1 MS

// ---------------------------------------------------------------------------
// Verlaufsmeldung (followup)
// ---------------------------------------------------------------------------
Profile: MvgsRdFollowUpBundle
Id: mvgs-rd-followup-bundle
Parent: Bundle
Title: "MVGS Seltene Erkrankungen Verlaufsmeldung"
Description: "Bundle-Profil für die Verlaufsmeldung eines Falls seltener Erkrankungen."
* type = #collection
* timestamp 1..1 MS
* entry MS
  * ^slicing.discriminator.type = #profile
  * ^slicing.discriminator.path = "resource"
  * ^slicing.rules = #open
* entry contains
    communication 1..1 MS and
    patient 1..1 MS and
    condition 0..1 and
    smallVariant 0..* MS and
    phenotype 0..* MS
* entry[communication].resource only MvgsSubmissionCommunication
* entry[communication].fullUrl 1..1 MS
* entry[patient].resource only MvgsPatient
* entry[patient].fullUrl 1..1 MS
* entry[condition].resource only MvgsRdCondition
* entry[condition].fullUrl 1..1 MS
* entry[smallVariant].resource only MvgsRdSmallVariant
* entry[smallVariant].fullUrl 1..1 MS
* entry[phenotype].resource only Observation
* entry[phenotype].fullUrl 1..1 MS

// ---------------------------------------------------------------------------
// Ergänzung (addition)
// ---------------------------------------------------------------------------
Profile: MvgsRdAdditionBundle
Id: mvgs-rd-addition-bundle
Parent: Bundle
Title: "MVGS Seltene Erkrankungen Ergänzungsmeldung"
Description: "Bundle-Profil für eine ergänzende Meldung zu einem bestehenden Fall seltener Erkrankungen."
* type = #collection
* timestamp 1..1 MS
* entry MS
  * ^slicing.discriminator.type = #profile
  * ^slicing.discriminator.path = "resource"
  * ^slicing.rules = #open
* entry contains
    communication 1..1 MS and
    patient 1..1 MS and
    condition 0..1 and
    smallVariant 0..* MS and
    phenotype 0..*
* entry[communication].resource only MvgsSubmissionCommunication
* entry[communication].fullUrl 1..1 MS
* entry[patient].resource only MvgsPatient
* entry[patient].fullUrl 1..1 MS
* entry[condition].resource only MvgsRdCondition
* entry[condition].fullUrl 1..1 MS
* entry[smallVariant].resource only MvgsRdSmallVariant
* entry[smallVariant].fullUrl 1..1 MS
* entry[phenotype].resource only Observation
* entry[phenotype].fullUrl 1..1 MS

// ---------------------------------------------------------------------------
// Korrektur (correction)
// ---------------------------------------------------------------------------
Profile: MvgsRdCorrectionBundle
Id: mvgs-rd-correction-bundle
Parent: Bundle
Title: "MVGS Seltene Erkrankungen Korrekturmeldung"
Description: "Bundle-Profil für die Korrektur einer vorherigen Meldung seltener Erkrankungen."
* type = #collection
* timestamp 1..1 MS
* entry MS
  * ^slicing.discriminator.type = #profile
  * ^slicing.discriminator.path = "resource"
  * ^slicing.rules = #open
* entry contains
    communication 1..1 MS and
    patient 1..1 MS and
    consent 0..1 and
    condition 0..1 and
    smallVariant 0..* and
    phenotype 0..*
* entry[communication].resource only MvgsSubmissionCommunication
* entry[communication].fullUrl 1..1 MS
* entry[patient].resource only MvgsPatient
* entry[patient].fullUrl 1..1 MS
* entry[consent].resource only MvgsConsent
* entry[consent].fullUrl 1..1 MS
* entry[condition].resource only MvgsRdCondition
* entry[condition].fullUrl 1..1 MS
* entry[smallVariant].resource only MvgsRdSmallVariant
* entry[smallVariant].fullUrl 1..1 MS
* entry[phenotype].resource only Observation
* entry[phenotype].fullUrl 1..1 MS
