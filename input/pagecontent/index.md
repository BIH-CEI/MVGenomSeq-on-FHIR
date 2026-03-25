# MVGenomSeq on FHIR Implementation Guide

## Einleitung

Dieser Implementation Guide ist eine **Community-Vorarbeit** zur Unterstützung von Mapping-Aktivitäten rund um das Modellvorhaben Genomsequenzierung (§ 64e SGB V). Er ist **nicht normativ** — die verbindliche Spezifikation des Übermittlungsformats liegt beim BfArM.

Ziel dieses IG ist es:

1. **Community-Mapping-Aktivitäten zu unterstützen**: Einrichtungen, die bestehende MII-KDS-Daten für MVGenomSeq-Einreichungen nutzen oder MVGenomSeq-Daten in ihre FHIR-Infrastruktur integrieren möchten, erhalten hier eine strukturierte Referenz für die Datenabbildung.

2. **Vorarbeit für eine künftige FHIR-basierte Meldung zu leisten**: Perspektivisch könnte die Meldung an MVGenomSeq direkt in FHIR erfolgen. Dieser IG dokumentiert, wie eine solche Abbildung aussehen könnte — als Diskussionsgrundlage und Vorbereitung.

Das Modellvorhaben Genomsequenzierung wird durch das Bundesinstitut für Arzneimittel und Medizinprodukte (BfArM) koordiniert und definiert standardisierte Datenstrukturen für die genomische Diagnostik in Deutschland — für die Onkologie und für Seltene Erkrankungen.

## Integrationsansätze

Dieser IG beschreibt drei komplementäre Ansätze mit unterschiedlichen Zeithorizonten:

### Kurzfristig umsetzbar

1. **[Ansatz 1: MII-KDS als Datenquelle](integration-fhir-to-mvgenomseq.html)**
   Befüllung des MVGenomSeq-Datenkranzes (KDK/GRZ) aus bestehenden MII-KDS-FHIR-Daten, ergänzt durch neu erfasste MTB-spezifische Daten (FHIR-first).

2. **[Ansatz 2: MVGenomSeq-Patienten ins DIZ](integration-diz-repository.html)**
   Integration von MVGenomSeq-Patienten in das FHIR-Repository des DIZ auf Basis des Broad Consent — für Forschung und Genotyp-Phänotyp-Analysen.

### Langfristige Perspektive

3. **[Ansatz 3: FHIR-native Meldung](integration-fhir-submission.html)**
   Vollständig FHIR-basierte Einreichung an MVGenomSeq, perspektivisch mit FHIR R6 und GA4GH-Alignment.

## Für wen ist dieser IG?

- **Krankenhäuser und Kliniken**: Die an MVGenomSeq teilnehmen und MII-konforme FHIR-Infrastruktur betreiben
- **Datenintegrationszentren (DIZ)**: Die MVGenomSeq-Patienten in ihre Forschungsinfrastruktur integrieren möchten
- **Genomreferenzzentren (GRZ)**: Die zukünftig FHIR-basierte Einreichungen unterstützen möchten
- **Softwareentwickler**: Die Transformations- und Integrationslösungen implementieren

## Technische Grundlagen

### Standards
- **FHIR R4** (4.0.1) — Basisversion dieses IG
- **MII-Kerndatensatz 2026** — Deutsche FHIR-Profile für medizinische Forschungsdaten
- **MVGenomSeq** — JSON-Schema-Draft-2020-12-basiertes Übermittlungsformat (KDK + GRZ)

### MII-Abhängigkeiten

| MII-Paket | Version |
|---|---|
| `base` (Person, Diagnose, Prozedur, Fall) | 2026.0.0 |
| `consent` | 2026.0.1-rc-1 |
| `molgen` | 2026.0.4 |
| `onkologie` | 2026.0.3-rc.1 |
| `seltene` | 2026.0.0 |
| `mtb` | 2026.0.0 |

## Ressourcen

- [BfArM MVGenomSeq Technische Spezifikation](https://www.bfarm.de/SharedDocs/Downloads/DE/Forschung/modellvorhaben-genomsequenzierung/Techn-spezifikation-datensatz-mvgenomseq.pdf)
- [MVGenomseq_KDK Repository](https://github.com/BfArM-MVH/MVGenomseq_KDK)
- [MVGenomseq_GRZ Repository](https://github.com/BfArM-MVH/MVGenomseq_GRZ)
- [MII Kerndatensatz](https://www.medizininformatik-initiative.de/de/der-kerndatensatz-der-medizininformatik-initiative)

## Kontakt und Beitragen

Dieses ist ein Community-Projekt. Feedback und Beiträge sind willkommen über das [GitHub-Repository](https://github.com/BIH-CEI/MVGenomSeq-on-FHIR).
