# Car Maintenance OCR – Refactor en cours

Ce projet est une application Ruby on Rails permettant d'analyser des factures automobiles (OCR),
d'en extraire les informations importantes (voiture, garage, opérations d'entretien)
et de générer automatiquement un historique structuré.

## ⚠️ Refactor en cours

Le code actuel contient une première version fonctionnelle mais expérimentale
(i.e. logique métier concentrée dans un seul contrôleur, prototypes de méthodes, etc.).

Une refonte complète est en cours sur la branche `wizard_refactor` :

- mise en place d'un **wizard multi-étapes propre**
- séparation claire entre contrôleurs, services et formulaires
- réécriture du workflow d'analyse d'image → voiture → entretien → garage_stop
- nettoyage du code prototype (déplacé dans `/legacy`)

L'objectif : rendre le code plus clair, modulaire, testable et maintenable.

## Branches importantes

- **main** : version prototype actuelle
- **wizard_refactor** : version propre en cours d'implémentation

---

## Objectifs techniques

- OCR + parsing
- Matching intelligent des items d’entretien
- Système de wizard multi-step
- Services isolés (SOLID)
- Rails + Stimulus + ActiveStorage

---

## Contribution

Le projet est en cours de refactor.
Toute suggestion architecturale ou améliorations sont les bienvenues !
