// ============================================================================
// Onkologie-Bundle-Profile für die vier Meldungstypen
// Parent: Bundle (TODO: Switch to MII Basis Bundle when available in base package)
// ============================================================================
// Jedes Bundle enthält eine MvgsSubmissionCommunication als ersten Entry,
// die alle Übermittlungsmetadaten (Meldungstyp, Datum, Vorgangsnummer) trägt.
// ============================================================================

// ---------------------------------------------------------------------------
// Erstmeldung (initial)
// ---------------------------------------------------------------------------
Profile: MvgsOncologyInitialBundle
Id: mvgs-oncology-initial-bundle
Parent: Bundle
Title: "MVGS Onkologie Erstmeldung"
Description: "Bundle-Profil für die Erstmeldung eines onkologischen Falls im Modellvorhaben Genomsequenzierung."
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
    carePlan 0..1 MS
* entry[communication].resource only MvgsSubmissionCommunication
* entry[communication].fullUrl 1..1 MS
* entry[patient].resource only MvgsPatient
* entry[patient].fullUrl 1..1 MS
* entry[consent].resource only MvgsConsent
* entry[consent].fullUrl 1..1 MS
* entry[condition].resource only MvgsOncologyCondition
* entry[condition].fullUrl 1..1 MS
* entry[smallVariant].resource only MvgsOncologySmallVariant
* entry[smallVariant].fullUrl 1..1 MS
* entry[carePlan].resource only MvgsOncologyCarePlan
* entry[carePlan].fullUrl 1..1 MS

// ---------------------------------------------------------------------------
// Verlaufsmeldung (followup)
// ---------------------------------------------------------------------------
Profile: MvgsOncologyFollowUpBundle
Id: mvgs-oncology-followup-bundle
Parent: Bundle
Title: "MVGS Onkologie Verlaufsmeldung"
Description: "Bundle-Profil für die Verlaufsmeldung eines onkologischen Falls."
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
    carePlan 0..1 MS
* entry[communication].resource only MvgsSubmissionCommunication
* entry[communication].fullUrl 1..1 MS
* entry[patient].resource only MvgsPatient
* entry[patient].fullUrl 1..1 MS
* entry[condition].resource only MvgsOncologyCondition
* entry[condition].fullUrl 1..1 MS
* entry[smallVariant].resource only MvgsOncologySmallVariant
* entry[smallVariant].fullUrl 1..1 MS
* entry[carePlan].resource only MvgsOncologyCarePlan
* entry[carePlan].fullUrl 1..1 MS

// ---------------------------------------------------------------------------
// Ergänzung (addition)
// ---------------------------------------------------------------------------
Profile: MvgsOncologyAdditionBundle
Id: mvgs-oncology-addition-bundle
Parent: Bundle
Title: "MVGS Onkologie Ergänzungsmeldung"
Description: "Bundle-Profil für eine ergänzende Meldung zu einem bestehenden onkologischen Fall."
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
    carePlan 0..1 MS
* entry[communication].resource only MvgsSubmissionCommunication
* entry[communication].fullUrl 1..1 MS
* entry[patient].resource only MvgsPatient
* entry[patient].fullUrl 1..1 MS
* entry[condition].resource only MvgsOncologyCondition
* entry[condition].fullUrl 1..1 MS
* entry[smallVariant].resource only MvgsOncologySmallVariant
* entry[smallVariant].fullUrl 1..1 MS
* entry[carePlan].resource only MvgsOncologyCarePlan
* entry[carePlan].fullUrl 1..1 MS

// ---------------------------------------------------------------------------
// Korrektur (correction)
// ---------------------------------------------------------------------------
Profile: MvgsOncologyCorrectionBundle
Id: mvgs-oncology-correction-bundle
Parent: Bundle
Title: "MVGS Onkologie Korrekturmeldung"
Description: "Bundle-Profil für die Korrektur einer vorherigen onkologischen Meldung."
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
    carePlan 0..1
* entry[communication].resource only MvgsSubmissionCommunication
* entry[communication].fullUrl 1..1 MS
* entry[patient].resource only MvgsPatient
* entry[patient].fullUrl 1..1 MS
* entry[consent].resource only MvgsConsent
* entry[consent].fullUrl 1..1 MS
* entry[condition].resource only MvgsOncologyCondition
* entry[condition].fullUrl 1..1 MS
* entry[smallVariant].resource only MvgsOncologySmallVariant
* entry[smallVariant].fullUrl 1..1 MS
* entry[carePlan].resource only MvgsOncologyCarePlan
* entry[carePlan].fullUrl 1..1 MS
