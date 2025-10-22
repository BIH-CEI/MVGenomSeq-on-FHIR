# Integration von FHIR und MVGENOMSEQ

## Überblick

Dieses Implementation Guide beschreibt drei verschiedene Ansätze zur Integration des MVGENOMSEQ-Datensatzes (Modellvorhaben Genomsequenzierung) mit FHIR (Fast Healthcare Interoperability Resources). Der MVGENOMSEQ-Datensatz wurde vom Bundesinstitut für Arzneimittel und Medizinprodukte (BfArM) entwickelt und definiert standardisierte Datenstrukturen für die Genomsequenzierung in Deutschland.

## Hintergrund zu MVGENOMSEQ

Das Modellvorhaben Genomsequenzierung umfasst zwei Hauptkomponenten:

### KDK (Klinischer Datensatz)
Der KDK-Datensatz enthält klinische Daten, die in zwei Indikationsgebieten strukturiert sind:
- **Onkologie**: Falldaten, molekulare Befunde, Therapiepläne und Verlaufsinformationen
- **Seltene Erkrankungen**: Parallele Schemastruktur für genetische Erkrankungen

### GRZ (Genomische Referenzzentren)
Der GRZ-Datensatz definiert strukturelle und Validierungsanforderungen für genomische Dateneinreichungen, einschließlich allgemeiner Metadaten-Anforderungen.

Beide Datensätze verwenden JSON Schema Draft 2020-12 zur Validierung und definieren präzise Strukturen für Dateneinreichungen, Prüfberichte und Konsensdokumentation.

## Die drei Integrationsansätze

Diese Implementation Guide präsentiert drei komplementäre Ansätze zur Integration von MVGENOMSEQ mit FHIR, die unterschiedliche Anwendungsfälle und Zeithorizonte adressieren:

### 1. Generierung von MVGENOMSEQ-Daten aus existierenden FHIR-Daten
**Quick Win** - Aufbereitung bestehender FHIR-Daten (MII-Kerndatensatz) für MVGENOMSEQ-Einreichungen.

**Anwendungsfall:**
Krankenhäuser, die bereits FHIR-basierte Systeme betreiben und ihre Daten für das Modellvorhaben Genomsequenzierung aufbereiten müssen.

**Vorteile:**
- Wiederverwendung bestehender FHIR-Daten
- Keine Doppelerfassung
- Automatisierte Transformation
- Sofort umsetzbar

**Richtung:** FHIR (MII KDS) → MVGENOMSEQ JSON

[Detaillierte Beschreibung →](integration-fhir-to-mvgenomseq.html)

### 2. Integration von MVGENOMSEQ-Daten in bestehende DIZ-Repositorien
**Quick Win** - Einspeisung von MVGENOMSEQ-Daten in FHIR-basierte Forschungsdatenbanken der Datenintegrationszentren, ermöglicht durch den Broad Consent.

**Anwendungsfall:**
DIZs möchten genomische Daten aus MVGENOMSEQ in ihre bestehenden FHIR-Repositorien integrieren und mit klinischen MII-Daten verknüpfen.

**Vorteile:**
- Einheitlicher Forschungszugang via FHIR
- Rechtlich abgesichert durch Broad Consent
- Verknüpfung von Genotyp und Phänotyp
- Sofort umsetzbar

**Richtung:** MVGENOMSEQ JSON → FHIR Repository (DIZ)

[Detaillierte Beschreibung →](integration-diz-repository.html)

### 3. FHIR-basierte Meldung für MVGENOMSEQ
**Zukunftsstrategie** - Vollständig FHIR-native Einreichung an MVGENOMSEQ, wartend auf FHIR R6 mit verbesserter GA4GH-Alignment für genomische Daten.

**Anwendungsfall:**
Langfristige Standardisierung, bei der KDK und GRZ direkt als FHIR-Ressourcen gemeldet werden können.

**Strategische Bedeutung:**
- Wartet auf FHIR R6 (2026+) mit GA4GH-Standards
- GenomicStudy Resource (neu in R6)
- Internationale Interoperabilität
- Langfristige Vision (2027-2028)

**Richtung:** FHIR R6 native → MVGENOMSEQ (FHIR-basiert)

[Detaillierte Beschreibung →](integration-fhir-submission.html)

## Strategische Roadmap

```
2025-2026: Quick Wins
┌─────────────────────────────────────┐
│ Ansatz 1: FHIR → MVGENOMSEQ JSON   │
│ Ansatz 2: MVGENOMSEQ JSON → FHIR   │
└─────────────────────────────────────┘
                ↓
2026-2027: R6 Vorbereitung
┌─────────────────────────────────────┐
│ - R6 Ballot Teilnahme              │
│ - Proof-of-Concepts                │
│ - Profil-Entwicklung               │
└─────────────────────────────────────┘
                ↓
2027-2028: FHIR-native Submission
┌─────────────────────────────────────┐
│ Ansatz 3: FHIR R6 native           │
│ - GA4GH-Alignment                  │
│ - GenomicStudy Resource            │
│ - Internationale Interoperabilität │
└─────────────────────────────────────┘
```

## Vergleich der Ansätze

| Kriterium | Ansatz 1: FHIR→MV | Ansatz 2: MV→FHIR | Ansatz 3: FHIR-native |
|-----------|-------------------|-------------------|----------------------|
| **Zeithorizont** | Sofort | Sofort | 2027-2028 |
| **Komplexität** | Mittel | Mittel | Hoch (R6) |
| **Datenquelle** | FHIR-Server | MVGENOMSEQ | FHIR R6 |
| **Ziel** | MVGENOMSEQ JSON | DIZ FHIR Repo | MVGENOMSEQ FHIR |
| **Standards** | MII KDS + JSON Schema | MII KDS | MII KDS + GA4GH |
| **Interoperabilität** | National | National | International |
| **Forschungszugang** | Extern (BfArM) | DIZ (FHIR API) | Beide |

## Empfehlungen

### Kurzfristig (2025-2026): Quick Wins umsetzen

**Ansatz 1** für Einrichtungen, die:
- Bereits FHIR-Server betreiben
- An MVGENOMSEQ teilnehmen möchten
- Bestehende Daten aufbereiten müssen

**Ansatz 2** für DIZs, die:
- MVGENOMSEQ-Daten in Forschung integrieren möchten
- Broad Consent vorliegt
- Verknüpfung mit MII-Daten benötigen

### Langfristig (2027+): FHIR R6 vorbereiten

**Ansatz 3** als strategische Vision:
- Teilnahme an R6-Entwicklung
- Internationale Kollaborationen
- GA4GH-Standards nutzen

## Technische Grundlagen

Alle drei Ansätze nutzen die folgenden MII-Kerndatensatz-Module:
- `de.medizininformatikinitiative.kerndatensatz.person`
- `de.medizininformatikinitiative.kerndatensatz.diagnose`
- `de.medizininformatikinitiative.kerndatensatz.molgen`
- `de.medizininformatikinitiative.kerndatensatz.onkologie`
- `de.medizininformatikinitiative.kerndatensatz.seltene`

## Weiterführende Ressourcen

- [MVGENOMSEQ Technische Spezifikation](https://www.bfarm.de/SharedDocs/Downloads/DE/Forschung/modellvorhaben-genomsequenzierung/Techn-spezifikation-datensatz-mvgenomseq.pdf)
- [MVGenomseq_KDK Repository](https://github.com/BfArM-MVH/MVGenomseq_KDK)
- [MVGenomseq_GRZ Repository](https://github.com/BfArM-MVH/MVGenomseq_GRZ)
- [MII Kerndatensatz](https://www.medizininformatik-initiative.de/de/der-kerndatensatz-der-medizininformatik-initiative)
