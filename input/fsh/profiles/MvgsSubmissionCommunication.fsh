// Parent: Communication (TODO: Switch to MII Basis Communication when available in base package)
Profile: MvgsSubmissionCommunication
Id: mvgs-submission-communication
Parent: Communication
Title: "MVGS Meldung"
Description: "Kommunikationsressource zur Abbildung einer Meldung im Modellvorhaben Genomsequenzierung. Trägt alle Übermittlungsmetadaten (Meldungstyp, Datum, Software, Vorgangsnummer)."
* status = #completed
* category 1..1 MS
  * coding 1..1 MS
    * system 1..1
    * code 1..1
  * coding from MvgsSubmissionTypeVS (required)
* sent 1..1 MS
  * ^short = "Übermittlungsdatum"
* subject 1..1 MS
  * ^short = "Referenz auf den Patienten"
* identifier 1..1 MS
  * ^short = "Vorgangsnummer"
  * system 1..1 MS
  * value 1..1 MS
* extension contains
    MvgsSubmissionMetadata named submissionMetadata 0..1 MS
