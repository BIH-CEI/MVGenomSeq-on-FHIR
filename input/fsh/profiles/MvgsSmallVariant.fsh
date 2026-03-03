Profile: MvgsOncologySmallVariant
Id: mvgs-oncology-small-variant
Parent: https://www.medizininformatik-initiative.de/fhir/ext/modul-mtb/StructureDefinition/mii-pr-mtb-einfache-variante
Title: "MVGS Kleine Variante (Onkologie)"
Description: "Profil für kleine genomische Varianten (SNV/Indel) in der Onkologie."
// MII Parent brings: code = LOINC 69548-6, category 2..* (laboratory + GE), subject 1..1, all component slices (gene-studied, representative-coding-hgvs, representative-protein-hgvs, genomic-source-class, etc.), value[x]
// MVGS-specific: variant localization extension
* extension contains MvgsVariantLocalization named variantLocalization 0..1 MS
