Profile: MvgsRdSmallVariant
Id: mvgs-rd-small-variant
Parent: https://www.medizininformatik-initiative.de/fhir/ext/modul-molgen/StructureDefinition/variante
Title: "MVGS Kleine Variante (Seltene Erkrankungen)"
Description: "Profil für kleine genomische Varianten (SNV/Indel) bei seltenen Erkrankungen mit ACMG-Klassifikation."
// MII Parent brings: code = LOINC 69548-6, category 2..* (laboratory + GE), subject 1..1, all component slices, value[x]
// MVGS overrides: gene-studied + genomic-source-class mandatory, zygosity/inheritance bindings tightened
* component[gene-studied] 1..1 MS
* component[genomic-source-class] 1..1 MS
* component[allelic-state].valueCodeableConcept from MvgsZygosityVS (required)
* component[variant-inheritance].valueCodeableConcept from MvgsModeOfInheritanceVS (required)
* extension contains
    MvgsAcmgClass named acmgClass 0..1 MS and
    MvgsAcmgCriteria named acmgCriteria 0..* MS and
    MvgsSegregationAnalysis named segregationAnalysis 0..1 MS and
    MvgsDiagnosticSignificance named diagnosticSignificance 0..1 MS
