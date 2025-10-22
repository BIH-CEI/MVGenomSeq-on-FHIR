# MVGENOMSEQ on FHIR Implementation Guide

## Einleitung

Dieser Implementation Guide beschreibt die Integration des **MVGENOMSEQ-Datensatzes** (Modellvorhaben Genomsequenzierung) mit **FHIR** (Fast Healthcare Interoperability Resources).

Das Modellvorhaben Genomsequenzierung ist eine Initiative des Bundesinstituts für Arzneimittel und Medizinprodukte (BfArM) zur Standardisierung genomischer Daten in Deutschland. Dieser IG zeigt, wie MVGENOMSEQ-Daten mit FHIR-Standards und insbesondere dem MII-Kerndatensatz integriert werden können.

## Drei Integrationsansätze

Dieser IG präsentiert drei komplementäre Ansätze mit unterschiedlichen Zeithorizonten:

### 🚀 Quick Wins (Sofort umsetzbar)

1. **[Ansatz 1: FHIR → MVGENOMSEQ](integration-fhir-to-mvgenomseq.html)**
   Generierung von MVGENOMSEQ-JSON-Datensätzen aus existierenden FHIR-Daten (MII-Kerndatensatz)

2. **[Ansatz 2: MVGENOMSEQ → DIZ](integration-diz-repository.html)**
   Integration von MVGENOMSEQ-Daten in bestehende DIZ-FHIR-Repositorien unter Nutzung des Broad Consent

### 🔮 Zukunftsstrategie (2027-2028)

3. **[Ansatz 3: FHIR R6 Native](integration-fhir-submission.html)**
   FHIR-native Meldung mit GA4GH-Alignment, wartend auf FHIR R6 mit verbesserter Genomik-Unterstützung

## Für wen ist dieser IG?

- **Krankenhäuser und Kliniken**: Die an MVGENOMSEQ teilnehmen und bereits FHIR-Systeme betreiben
- **Datenintegrationszentren (DIZ)**: Die MVGENOMSEQ-Daten in ihre Forschungsinfrastruktur integrieren möchten
- **Genomreferenzzentren (GRZ)**: Die zukünftig FHIR-basierte Einreichungen unterstützen möchten
- **Forschende**: Die einheitlichen Zugriff auf klinische und genomische Daten benötigen
- **Softwareentwickler**: Die Transformations- und Integrationslösungen implementieren

## Technische Grundlagen

### Standards
- **FHIR R4**: Aktuelle Basisversion (4.0.1)
- **FHIR R6**: Zukünftige Version mit verbesserter Genomik-Unterstützung (ab 2026)
- **MII-Kerndatensatz**: Deutsche FHIR-Profile für medizinische Forschungsdaten
- **MVGENOMSEQ**: JSON Schema Draft 2020-12 basierte Datenstrukturen
- **GA4GH**: Global Alliance for Genomics and Health Standards

### Abhängigkeiten
Dieser IG nutzt die folgenden MII-Module:
- Person (2025.x)
- Diagnose (2025.x)
- Molekulargenetik (2026.0.0-ballot)
- Onkologie (2026.0.0-ballot)
- Seltene Erkrankungen (2026.0.0-ballot)

## Nächste Schritte

1. **[Überblick lesen](integration.html)**: Verstehen Sie die drei Integrationsansätze
2. **Ansatz wählen**: Entscheiden Sie basierend auf Ihren Anforderungen und Zeithorizont
3. **Implementierung**: Nutzen Sie die detaillierten technischen Beschreibungen und Beispiele

## Ressourcen

- [BfArM MVGENOMSEQ Technische Spezifikation](https://www.bfarm.de/SharedDocs/Downloads/DE/Forschung/modellvorhaben-genomsequenzierung/Techn-spezifikation-datensatz-mvgenomseq.pdf)
- [MVGenomseq_KDK Repository](https://github.com/BfArM-MVH/MVGenomseq_KDK)
- [MVGenomseq_GRZ Repository](https://github.com/BfArM-MVH/MVGenomseq_GRZ)
- [MII Kerndatensatz](https://www.medizininformatik-initiative.de/de/der-kerndatensatz-der-medizininformatik-initiative)

## Kontakt und Beitragen

Dieses ist ein Community-Projekt. Feedback und Beiträge sind willkommen!