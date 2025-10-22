# MVGENOMSEQ on FHIR Implementation Guide

Dieser Implementation Guide beschreibt die Integration des MVGENOMSEQ-Datensatzes (Modellvorhaben Genomsequenzierung) mit FHIR (Fast Healthcare Interoperability Resources).

## Überblick

Das Modellvorhaben Genomsequenzierung ist eine Initiative des Bundesinstituts für Arzneimittel und Medizinprodukte (BfArM) zur Standardisierung genomischer Daten in Deutschland. Dieser IG zeigt drei verschiedene Ansätze zur Integration mit FHIR-Standards und dem MII-Kerndatensatz.

## Die drei Integrationsansätze

### 🚀 Quick Wins (Sofort umsetzbar)

1. **Ansatz 1: FHIR → MVGENOMSEQ**
   - Generierung von MVGENOMSEQ-JSON-Datensätzen aus existierenden FHIR-Daten
   - Für Krankenhäuser mit FHIR-Servern, die an MVGENOMSEQ teilnehmen möchten

2. **Ansatz 2: MVGENOMSEQ → DIZ**
   - Integration von MVGENOMSEQ-Daten in bestehende DIZ-FHIR-Repositorien
   - Nutzt Broad Consent für Forschungszwecke
   - Ermöglicht Verknüpfung von Genotyp und Phänotyp

### 🔮 Zukunftsstrategie (2027-2028)

3. **Ansatz 3: FHIR R6 Native**
   - Vollständig FHIR-native Meldung mit GA4GH-Alignment
   - Wartet auf FHIR R6 mit verbesserter Genomik-Unterstützung (GenomicStudy Resource)
   - Internationale Interoperabilität

## Projekt-Struktur

```
mvgenomseq-on-fhir/
├── .github/
│   └── workflows/
│       └── build-ig.yml          # GitHub Actions für automatisches IG Building
├── input/
│   ├── pagecontent/
│   │   ├── index.md              # Hauptseite
│   │   ├── integration.md        # Überblick über alle Ansätze
│   │   ├── integration-fhir-to-mvgenomseq.md    # Ansatz 1
│   │   ├── integration-diz-repository.md        # Ansatz 2
│   │   └── integration-fhir-submission.md       # Ansatz 3
│   └── images/
│       ├── approach1-fhir-to-mvgenomseq.plantuml
│       ├── approach2-mvgenomseq-to-diz.plantuml
│       ├── approach3-fhir-native-r6.plantuml
│       └── strategic-roadmap.plantuml
├── sushi-config.yaml             # SUSHI Konfiguration
└── README.md                     # Diese Datei
```

## Entwicklung

### Voraussetzungen

- Node.js (v20+)
- Java JDK 17+
- SUSHI (`npm install -g fsh-sushi`)

### Lokales Building

1. Repository klonen:
   ```bash
   git clone https://github.com/[username]/mvgenomseq-on-fhir.git
   cd mvgenomseq-on-fhir
   ```

2. SUSHI ausführen:
   ```bash
   sushi .
   ```

3. IG Publisher herunterladen (einmalig):
   ```bash
   mkdir -p input-cache
   curl -L https://github.com/HL7/fhir-ig-publisher/releases/latest/download/publisher.jar -o input-cache/publisher.jar
   ```

4. IG Publisher ausführen:
   ```bash
   java -jar input-cache/publisher.jar -ig .
   ```

5. Öffne `output/index.html` im Browser

### GitHub Pages Deployment

Das IG wird automatisch gebaut und auf GitHub Pages deployed bei jedem Push zum `main` Branch.

**Setup:**
1. In Repository Settings → Pages → Source: "GitHub Actions" auswählen
2. Push zum main Branch
3. GitHub Action baut und deployed automatisch

Das IG ist dann verfügbar unter: `https://[username].github.io/mvgenomseq-on-fhir/`

## Abhängigkeiten

Dieser IG nutzt folgende MII-Kerndatensatz-Module:

- `de.medizininformatikinitiative.kerndatensatz.person` (2025.x)
- `de.medizininformatikinitiative.kerndatensatz.diagnose` (2025.x)
- `de.medizininformatikinitiative.kerndatensatz.molgen` (2026.0.0-ballot)
- `de.medizininformatikinitiative.kerndatensatz.onkologie` (2026.0.0-ballot)
- `de.medizininformatikinitiative.kerndatensatz.seltene` (2026.0.0-ballot)

## PlantUML Diagramme

Die PlantUML-Diagramme befinden sich in `input/images/`. Um sie lokal zu rendern:

```bash
# Installation von PlantUML
npm install -g node-plantuml

# Diagramme rendern
plantuml input/images/*.plantuml
```

Die gerenderten PNGs werden automatisch vom IG Publisher eingebunden.

## Ressourcen

- [BfArM MVGENOMSEQ Technische Spezifikation](https://www.bfarm.de/SharedDocs/Downloads/DE/Forschung/modellvorhaben-genomsequenzierung/Techn-spezifikation-datensatz-mvgenomseq.pdf)
- [MVGenomseq_KDK Repository](https://github.com/BfArM-MVH/MVGenomseq_KDK) - Klinischer Datensatz
- [MVGenomseq_GRZ Repository](https://github.com/BfArM-MVH/MVGenomseq_GRZ) - Genomreferenzzentren Datensatz
- [MII Kerndatensatz](https://www.medizininformatik-initiative.de/de/der-kerndatensatz-der-medizininformatik-initiative)
- [HL7 FHIR R4](http://hl7.org/fhir/R4/)
- [HL7 FHIR R6 (Preview)](http://hl7.org/fhir/)
- [GA4GH Standards](https://www.ga4gh.org/)

## Beitragen

Beiträge sind willkommen! Bitte:

1. Fork das Repository
2. Erstelle einen Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Committe deine Änderungen (`git commit -m 'Add some AmazingFeature'`)
4. Push zum Branch (`git push origin feature/AmazingFeature`)
5. Öffne einen Pull Request

## Lizenz

[Lizenz hier einfügen]

## Kontakt

[Kontaktinformationen hier einfügen]

## Acknowledgments

- BfArM für die MVGENOMSEQ-Spezifikation
- Medizininformatik-Initiative für den MII-Kerndatensatz
- HL7 Deutschland und HL7 International
- GA4GH für genomische Standards
