CodeSystem: MvgsSubmissionTypeCS
Id: mvgs-submission-type
Title: "MVGS Übermittlungsart"
Description: "Art der Datenübermittlung an die Vertrauensstelle."
* ^caseSensitive = true
* ^content = #complete
* #initial "Erstübermittlung" "Erstmalige Übermittlung eines Falls"
* #followup "Verlaufsübermittlung" "Übermittlung von Verlaufsdaten"
* #addition "Ergänzung" "Ergänzende Übermittlung zu einem bestehenden Fall"
* #correction "Korrektur" "Korrektur einer vorherigen Übermittlung"
* #test "Testübermittlung" "Testübermittlung (nicht produktiv)"

CodeSystem: MvgsDiseaseTypeCS
Id: mvgs-disease-type
Title: "MVGS Erkrankungstyp"
Description: "Typ der Erkrankung im Modellvorhaben."
* ^caseSensitive = true
* ^content = #complete
* #oncological "Onkologisch" "Onkologische Erkrankung"
* #rare "Seltene Erkrankung" "Seltene Erkrankung"
* #hereditary "Erblich" "Hereditäre Tumorerkrankung"

CodeSystem: MvgsCoverageTypeCS
Id: mvgs-coverage-type
Title: "MVGS Versicherungsart"
Description: "Art der Krankenversicherung."
* ^caseSensitive = true
* ^content = #complete
* #GKV "Gesetzliche Krankenversicherung"
* #PKV "Private Krankenversicherung"
* #BG "Berufsgenossenschaft"
* #SEL "Selbstzahler"
* #SOZ "Sozialamt"
* #GPV "Gesetzliche Pflegeversicherung"
* #PPV "Private Pflegeversicherung"
* #BEI "Beihilfe"
* #SKT "Sonstige Kostenträger"
* #UNK "Unbekannt"

CodeSystem: MvgsConsentDomainCS
Id: mvgs-consent-domain
Title: "MVGS Einwilligungsdomänen"
Description: "Domänen der Einwilligung im Modellvorhaben Genomsequenzierung."
* ^caseSensitive = true
* ^content = #complete
* #mvSequencing "MV Genomsequenzierung" "Einwilligung zur Teilnahme am Modellvorhaben Genomsequenzierung"
* #reIdentification "Re-Identifizierung" "Einwilligung zur Re-Identifizierung"
* #caseIdentification "Fallidentifizierung" "Einwilligung zur Fallidentifizierung"

CodeSystem: MvgsLocalizationCS
Id: mvgs-localization
Title: "MVGS Varianten-Lokalisierung (Onkologie)"
Description: "Lokalisierung einer Variante im Genom (Onkologie)."
* ^caseSensitive = true
* ^content = #complete
* #coding "Kodierend" "Variante in kodierender Region"
* #inRegulatoryElements "In regulatorischen Elementen" "Variante in regulatorischen Elementen"
* #notInCodingAndNotInRegulatoryElements "Weder kodierend noch regulatorisch" "Variante weder in kodierender noch in regulatorischer Region"

CodeSystem: MvgsLocalizationRdCS
Id: mvgs-localization-rd
Title: "MVGS Varianten-Lokalisierung (Seltene Erkrankungen)"
Description: "Lokalisierung einer Variante im Genom (Seltene Erkrankungen)."
* ^caseSensitive = true
* ^content = #complete
* #codingRegion "Kodierende Region" "Variante in kodierender Region"
* #splicingRegion "Splicing-Region" "Variante in Splicing-Region"
* #regulatoryRegion "Regulatorische Region" "Variante in regulatorischer Region"
* #intronic "Intronisch" "Variante in intronischer Region"
* #intergenic "Intergenisch" "Variante in intergenischer Region"

CodeSystem: MvgsAcmgClassCS
Id: mvgs-acmg-class
Title: "MVGS ACMG-Klassifikation"
Description: "ACMG/AMP-Klassifikation für Varianten (Klasse 1-5)."
* ^caseSensitive = true
* ^content = #complete
* #1 "Benign" "Klasse 1 – Benigne"
* #2 "Likely Benign" "Klasse 2 – Wahrscheinlich benigne"
* #3 "Uncertain Significance" "Klasse 3 – Variante unklarer Signifikanz (VUS)"
* #4 "Likely Pathogenic" "Klasse 4 – Wahrscheinlich pathogen"
* #5 "Pathogenic" "Klasse 5 – Pathogen"

CodeSystem: MvgsEvidenceLevelCS
Id: mvgs-evidence-level
Title: "MVGS Evidenzlevel"
Description: "Evidenzlevel für therapeutische Empfehlungen."
* ^caseSensitive = true
* ^content = #complete
* #m1A "m1A" "Evidenzlevel m1A"
* #m1B "m1B" "Evidenzlevel m1B"
* #m1C "m1C" "Evidenzlevel m1C"
* #m2A "m2A" "Evidenzlevel m2A"
* #m2B "m2B" "Evidenzlevel m2B"
* #m2C "m2C" "Evidenzlevel m2C"
* #m3 "m3" "Evidenzlevel m3"
* #m4 "m4" "Evidenzlevel m4"
* #undefined "Nicht definiert" "Evidenzlevel nicht definiert"

CodeSystem: MvgsTherapeuticStrategyCS
Id: mvgs-therapeutic-strategy
Title: "MVGS Therapiestrategie"
Description: "Empfohlene therapeutische Strategien."
* ^caseSensitive = true
* ^content = #complete
* #CH "Chemotherapie" "Chemotherapie"
* #HO "Hormontherapie" "Hormontherapie"
* #IM "Immuntherapie" "Immuntherapie"
* #ZS "Zielgerichtete Substanz" "Zielgerichtete Therapie"
* #CI "Chemo + Immun" "Chemotherapie in Kombination mit Immuntherapie"
* #CZ "Chemo + Zielgerichtet" "Chemotherapie in Kombination mit zielgerichteter Therapie"
* #CIZ "Chemo + Immun + Zielgerichtet" "Kombinationstherapie"
* #IZ "Immun + Zielgerichtet" "Immuntherapie in Kombination mit zielgerichteter Therapie"
* #SZ "Sonstige zielgerichtete Substanzen" "Sonstige zielgerichtete Substanzen"
* #SO "Sonstige" "Sonstige Therapiestrategien"

CodeSystem: MvgsZygosityCS
Id: mvgs-zygosity
Title: "MVGS Zygotie"
Description: "Zygotie einer Variante."
* ^caseSensitive = true
* ^content = #complete
* #heterozygous "Heterozygot" "Heterozygote Variante"
* #homozygous "Homozygot" "Homozygote Variante"
* #compHet "Compound heterozygot" "Compound heterozygote Variante"
* #hemi "Hemizygot" "Hemizygote Variante"
* #homoplasmic "Homoplasmatisch" "Homoplasmatische (mitochondriale) Variante"
* #heteroplasmic "Heteroplasmatisch" "Heteroplasmatische (mitochondriale) Variante"

CodeSystem: MvgsSegregationAnalysisCS
Id: mvgs-segregation-analysis
Title: "MVGS Segregationsanalyse"
Description: "Ergebnis der Segregationsanalyse."
* ^caseSensitive = true
* ^content = #complete
* #notPerformed "Nicht durchgeführt" "Segregationsanalyse nicht durchgeführt"
* #deNovo "De novo" "Variante de novo entstanden"
* #fromFather "Vom Vater" "Variante vom Vater vererbt"
* #fromMother "Von der Mutter" "Variante von der Mutter vererbt"
* #fromMotherAndFather "Von beiden Elternteilen" "Variante von beiden Elternteilen vererbt"

CodeSystem: MvgsModeOfInheritanceCS
Id: mvgs-mode-of-inheritance
Title: "MVGS Vererbungsmodus"
Description: "Vererbungsmodus einer Variante."
* ^caseSensitive = true
* ^content = #complete
* #dominant "Autosomal dominant" "Autosomal dominanter Erbgang"
* #recessive "Autosomal rezessiv" "Autosomal rezessiver Erbgang"
* #XLinked "X-chromosomal" "X-chromosomaler Erbgang"
* #mitochondrial "Mitochondrial" "Mitochondrialer Erbgang"
* #unclear "Unklar" "Vererbungsmodus unklar"

CodeSystem: MvgsDiagnosticSignificanceCS
Id: mvgs-diagnostic-significance
Title: "MVGS Diagnostische Signifikanz"
Description: "Diagnostische Signifikanz einer Variante."
* ^caseSensitive = true
* ^content = #complete
* #primary "Primärbefund" "Variante ist Primärbefund"
* #incidental "Zusatzbefund" "Variante ist Zusatzbefund (Incidental Finding)"
* #candidate "Kandidat" "Variante ist Kandidat"

CodeSystem: MvgsDiagnosticAssessmentCS
Id: mvgs-diagnostic-assessment
Title: "MVGS Diagnostische Bewertung"
Description: "Diagnostische Bewertung der Erkrankung."
* ^caseSensitive = true
* ^content = #complete
* #noGeneticDiagnosis "Keine genetische Diagnose" "Keine genetische Diagnose gestellt"
* #suspected "Verdacht" "Verdachtsdiagnose"
* #furtherRecommended "Weitere Diagnostik empfohlen" "Weitere Diagnostik empfohlen"
* #confirmed "Bestätigt" "Genetische Diagnose bestätigt"
* #partial "Teilweise bestätigt" "Genetische Diagnose teilweise bestätigt"
