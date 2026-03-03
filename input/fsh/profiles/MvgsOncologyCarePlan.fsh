Profile: MvgsOncologyCarePlan
Id: mvgs-oncology-care-plan
Parent: https://www.medizininformatik-initiative.de/fhir/ext/modul-mtb/StructureDefinition/mii-pr-mtb-therapieplan
Title: "MVGS MTB-Therapieplan"
Description: "Therapieplan-Profil für Empfehlungen des molekularen Tumorboards."
// MII Parent brings: intent = #plan, subject 1..1 MS, created 1..1 MS, category 1..1, addresses restricted to onko-diagnose-primaertumor, activity slicing (obds/extended)
// MVGS-specific: boolean extensions for recommendation flags
* status MS
* extension contains
    MvgsStudyRecommended named studyRecommended 0..1 MS and
    MvgsCounsellingRecommended named counsellingRecommended 0..1 MS and
    MvgsReEvaluationRecommended named reEvaluationRecommended 0..1 MS and
    MvgsInterventionRecommended named interventionRecommended 0..1 MS
