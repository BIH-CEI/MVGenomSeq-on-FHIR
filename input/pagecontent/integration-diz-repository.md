# Ansatz 2: MVGenomSeq-Patienten in das DIZ-Repository integrieren

## Übersicht

Patienten, die am Modellvorhaben Genomsequenzierung teilnehmen, haben in der Regel einen MII-Broad-Consent erteilt. Dieser erlaubt die Sekundärnutzung ihrer Daten für Forschungszwecke. Dieser Ansatz beschreibt, wie die MVGenomSeq-Daten dieser Patienten in das bestehende FHIR-Repository des DIZ integriert werden, sodass genomische und klinische Daten gemeinsam auswertbar sind.

## Datenfluss

```
┌─────────────────────────────────────────────────────────┐
│         MVGenomSeq-Übermittlungsdaten (KDK + GRZ)       │
└─────────────────────────┬───────────────────────────────┘
                          │ Broad Consent geprüft
                          ▼
┌─────────────────────────────────────────────────────────┐
│        Transformation → MII-konforme FHIR-Ressourcen    │
└─────────────────────────┬───────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│         DIZ FHIR-Repository (Blaze, SMILE CDR, ...)     │
│   MII-KDS-Bestand  ◄── verknüpft ──►  MVGenomSeq-Daten │
└─────────────────────────┬───────────────────────────────┘
                          │
                          ▼
              Forschungszugriff via FHIR Search / CQL
```

## Szenario

Ein Patient wird im Rahmen des Modellvorhabens genomsequenziert und hat den MII-Broad-Consent erteilt. Seine KDK-Daten (klinisch) und GRZ-Daten (genomisch) werden nach der Übermittlung an das BfArM vom DIZ abgerufen und als MII-konforme FHIR-Ressourcen in das lokale Repository importiert. Dort stehen sie — verknüpft mit bereits vorhandenen MII-KDS-Daten desselben Patienten — für die Forschung zur Verfügung.

{% include img.html img="approach2-mvgenomseq-to-diz.png" caption="Abbildung 1: Integration von MVGenomSeq-Patienten in das DIZ-Repository" %}

## Datenmapping: MVGenomSeq → FHIR

| MVGenomSeq-Datenelement | FHIR-Ressource | MII-Profil |
|---|---|---|
| Patient (pseudonymisiert) | `Patient` | PatientPseudonymisiert (`base`) |
| Einwilligung | `Consent` | MII PR Consent Einwilligung (`consent`) |
| Diagnose | `Condition` | MII PR MTB Diagnose Primärtumor (`mtb`) |
| Molekulargenetische Variante | `Observation` | MII PR MTB Einfache Variante (`mtb`) |
| MTB-Therapieplan | `CarePlan` | MII PR MTB Therapieplan (`mtb`) |
| Sequenzierungsbericht | `DiagnosticReport` | MII PR MolGen Diagnostik (`molgen`) |

## Rechtliche Grundlage: Broad Consent

Der Broad Consent (MII-Mustertext) ermöglicht im Kontext dieses Ansatzes:

| Zweck | Beschreibung |
|---|---|
| Sekundärnutzung | Verwendung genomischer Daten für Forschung über den Behandlungskontext hinaus |
| Datenzusammenführung | Verknüpfung von MVGenomSeq-Daten mit MII-KDS-Bestandsdaten |
| Langfristige Speicherung | Aufbewahrung in den FHIR-Repositorien der DIZs |
| Datenweitergabe | Bereitstellung für genehmigte Forschungsprojekte über die MII-Datennutzungsinfrastruktur |

## Forschungszugriff

Nach der Integration sind die Daten über standardisierte FHIR-Schnittstellen abfragbar. Beispiele:

**Patienten mit pathogener BRCA2-Variante und Mammakarzinom:**
```
GET /Patient
  ?_has:Condition:patient:code=http://fhir.de/CodeSystem/bfarm/icd-10-gm|C50
  &_has:Observation:patient:component-code=http://loinc.org|48018-6
  &_has:Observation:patient:component-value-concept=http://www.genenames.org/geneId|HGNC:1101
```

**Nur Patienten mit aktivem Broad Consent:**
```
GET /Patient
  ?_has:Consent:patient:status=active
  &_has:Consent:patient:scope=research
```

## Zu beachten

| Thema | Hinweis |
|---|---|
| Pseudonymisierung | MVGenomSeq-Pseudonyme müssen auf DIZ-interne Pseudonyme gemappt werden (gPAS o.ä.) |
| Consent-Verwaltung | Widerrufe müssen zeitnah verarbeitet und Daten entsprechend gesperrt werden |
| Datenvolumen | Rohe Sequenzdaten (BAM/VCF) werden nicht in FHIR gespeichert — nur Metadaten und interpretierte Varianten |
| Dubletten | Bereits vorhandene MII-KDS-Daten des Patienten nicht doppelt anlegen — Linking-Strategie erforderlich |
| Consent-Gültigkeit | Vor jeder Datennutzung Consent-Status prüfen |
