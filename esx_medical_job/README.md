# 🏥 ESX Medical Job - Script Médical Scientifique

> Script de job médical complet pour FiveM ESX avec ox_target, effets 3D, et système de prélèvements scientifiques légaux/illégaux.

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![FiveM](https://img.shields.io/badge/FiveM-Ready-green.svg)
![ESX](https://img.shields.io/badge/ESX-Legacy-orange.svg)

---

## 📋 Table des matières

- [Fonctionnalités](#-fonctionnalités)
- [Prérequis](#-prérequis)
- [Installation](#-installation)
- [Configuration](#️-configuration)
- [Utilisation](#-utilisation)
- [Commandes](#-commandes)
- [Actions disponibles](#-actions-disponibles)
- [Captures d'écran](#-captures-décran)
- [Support](#-support)

---

## ✨ Fonctionnalités

### 🩺 Actions Médicales Légales
- **Soigner** - Restaure la santé d'un joueur
- **Réanimer** - Ramène un joueur inconscient à la vie
- **Examiner** - Diagnostique l'état de santé d'un patient
- **Prélèvement de sang** - Collecte des échantillons sanguins

### 🔬 Actions Scientifiques Illégales
- **Endormir** - Met un joueur inconscient avec un sédatif
- **Blesser** - Inflige des dégâts à un joueur
- **Prélèvement d'os** - Collecte des échantillons osseux (marché noir)
- **Prélèvement de peau** - Collecte des échantillons cutanés (marché noir)

### 🎨 Effets Visuels 3D
- **Texte 3D** flottant pour les interactions
- **Barres de progression 3D** animées avec pourcentages
- **Notifications NUI 3D** avec effets de glow
- **Particules** et effets spéciaux
- **Animations** réalistes pour chaque action
- **Effets d'écran** (tremblements, flous, etc.)

### 🏢 Système Complet
- **Vestiaires** - Changement de tenue
- **Pharmacie** - Achat d'équipement médical
- **Laboratoire** - Analyse d'échantillons
- **Garage** - Véhicules d'ambulance
- **Marché noir** - Vente d'échantillons illégaux

### 📊 Tracking & Statistiques
- Suivi des actions médicales
- Historique des prélèvements
- Statistiques par médecin
- Logs des ventes au marché noir

---

## 📦 Prérequis

Assurez-vous d'avoir installé les ressources suivantes :

- **[es_extended](https://github.com/esx-framework/esx-legacy)** (ESX Legacy)
- **[ox_target](https://github.com/overextended/ox_target)** (Système de ciblage)
- **[ox_lib](https://github.com/overextended/ox_lib)** (Librairie UI)
- **[oxmysql](https://github.com/overextended/oxmysql)** (MySQL)
- **[skinchanger](https://github.com/esx-framework/esx-legacy)** (Changement de tenues)
- **[esx_ambulancejob](https://github.com/esx-framework/esx-legacy)** (Pour la réanimation)

---

## 🚀 Installation

### 1. Téléchargement

Clonez ou téléchargez ce dépôt dans votre dossier `resources` :

```bash
cd resources
git clone [votre-repo] esx_medical_job
```

### 2. Base de données

Importez le fichier SQL dans votre base de données :

```bash
mysql -u root -p votre_base < esx_medical_job/sql/install.sql
```

Ou via phpMyAdmin :
- Ouvrez phpMyAdmin
- Sélectionnez votre base de données
- Allez dans "Importer"
- Sélectionnez le fichier `sql/install.sql`
- Cliquez sur "Exécuter"

### 3. Configuration du serveur

Ajoutez la ressource dans votre `server.cfg` :

```cfg
ensure esx_medical_job
```

⚠️ **Important** : Assurez-vous que la ressource est chargée APRÈS les dépendances :

```cfg
ensure es_extended
ensure ox_target
ensure ox_lib
ensure oxmysql

ensure esx_medical_job
```

### 4. Redémarrage

Redémarrez votre serveur ou utilisez :

```
restart esx_medical_job
```

---

## ⚙️ Configuration

Éditez le fichier `config/config.lua` pour personnaliser le script :

### Paramètres généraux

```lua
Config.JobName = 'ambulance'  -- Nom du job
Config.EnableLegalActions = true  -- Activer les actions légales
Config.EnableIllegalActions = true  -- Activer les actions illégales
```

### Prix et gains

```lua
Config.Prices = {
    heal = 500,           -- Prix pour soigner
    revive = 1000,        -- Prix pour réanimer
    boneSample = 2500,    -- Gain marché noir (os)
    skinSample = 1500,    -- Gain marché noir (peau)
}
```

### Hôpitaux

Ajoutez ou modifiez les positions des hôpitaux dans `Config.Hospitals` :

```lua
{
    name = "Mon Hôpital",
    blip = {coords = vector3(x, y, z), sprite = 61, color = 2},
    cloakroom = {coords = vector3(x, y, z), size = vector3(2, 2, 2)},
    pharmacy = {coords = vector3(x, y, z), size = vector3(2, 2, 2)},
    -- ...
}
```

---

## 🎮 Utilisation

### En jeu - Pour les médecins

1. **Prendre son service** : Allez au vestiaire et équipez-vous
2. **Acheter de l'équipement** : Rendez-vous à la pharmacie
3. **Interagir avec les patients** : Utilisez **ox_target** (œil) sur un joueur
4. **Choisir une action** : Sélectionnez l'action dans le menu

### Actions disponibles

| Action | Touche | Condition |
|--------|--------|-----------|
| Soigner | ox_target | Patient vivant |
| Réanimer | ox_target | Patient mort |
| Examiner | ox_target | Tout patient |
| Endormir | ox_target | Patient vivant |
| Prélèvement | ox_target | Selon le type |

### Marché noir

1. Rendez-vous au point de marché noir (coordonnées dans config)
2. Interagissez avec le PED scientifique
3. Vendez vos échantillons illégaux

---

## 💻 Commandes

### Commandes Admin

```
/medicheal [id]    - Soigner un joueur (Admin)
/medicrevive [id]  - Réanimer un joueur (Admin)
```

---

## 🎯 Actions disponibles

### 🩺 Actions Légales

#### Soigner
- **Item requis** : `medikit`
- **Durée** : 8 secondes
- **Effet** : Restaure 100% de santé
- **Rémunération** : $500
- **Animations** : Soin médical
- **Effets** : Particules électriques, barre de progression 3D

#### Réanimer
- **Item requis** : `defib`
- **Durée** : 15 secondes
- **Effet** : Réanime le joueur
- **Rémunération** : $1000
- **Animations** : RCP + Défibrillateur
- **Effets** : Écran électrique, vibrations, particules

#### Examiner
- **Item requis** : `stethoscope`
- **Durée** : 6 secondes
- **Effet** : Affiche un rapport médical complet
- **Rémunération** : $200
- **Informations** : Santé, armure, état général

#### Prélèvement sanguin
- **Item requis** : `syringe`
- **Durée** : 7 secondes
- **Effet** : Donne 1x `blood_sample`
- **Rémunération** : $800

### ⚠️ Actions Illégales

#### Endormir
- **Item requis** : `sedative`
- **Durée** : 5 secondes
- **Effet** : Met le joueur en ragdoll pendant 10s
- **Effets** : Écran hallucinatoire

#### Blesser
- **Item requis** : Aucun
- **Durée** : 4 secondes
- **Effet** : -50 HP
- **Conséquences** : Alerte police

#### Prélèvement d'os
- **Item requis** : `surgical_kit`
- **Durée** : 12 secondes
- **Effet** : Donne 1x `bone_sample`
- **Vente** : $2500 (marché noir)
- **Conséquences** : Enregistré dans la base de données

#### Prélèvement de peau
- **Item requis** : `surgical_kit`
- **Durée** : 10 secondes
- **Effet** : Donne 1x `skin_sample`
- **Vente** : $1500 (marché noir)
- **Conséquences** : Enregistré dans la base de données

---

## 📸 Captures d'écran

### Effets Visuels

- ✅ Texte 3D flottant au-dessus des patients
- ✅ Barre de progression 3D avec pourcentage animé
- ✅ Notifications NUI 3D avec effets de glow
- ✅ Particules et effets spéciaux
- ✅ Animations réalistes
- ✅ Effets d'écran (tremblements, flous)

---

## 🗂️ Structure des fichiers

```
esx_medical_job/
│
├── fxmanifest.lua           # Manifest du script
│
├── config/
│   └── config.lua           # Configuration complète
│
├── client/
│   ├── utils.lua            # Utilitaires 3D (texte, progress bar, effets)
│   └── main.lua             # Code client principal
│
├── server/
│   └── main.lua             # Code serveur
│
├── html/
│   ├── ui.html              # Interface NUI
│   ├── style.css            # Styles CSS modernes
│   └── script.js            # JavaScript NUI
│
├── sql/
│   └── install.sql          # Base de données
│
└── README.md                # Documentation
```

---

## 🔧 Dépannage

### Les interactions ox_target ne fonctionnent pas
- Vérifiez que `ox_target` est bien démarré
- Assurez-vous d'être dans le job `ambulance`
- Redémarrez la ressource : `restart esx_medical_job`

### Les notifications ne s'affichent pas
- Vérifiez que `ox_lib` est installé et démarré
- Vérifiez les erreurs dans la console F8

### Les items ne s'ajoutent pas
- Vérifiez que les items sont bien dans votre base de données
- Importez à nouveau le fichier SQL
- Redémarrez le serveur

### Erreur "attempt to index a nil value"
- Vérifiez que tous les prérequis sont installés
- Assurez-vous que `es_extended` est en version Legacy
- Vérifiez l'ordre de chargement dans `server.cfg`

---

## 📝 Base de données

### Tables créées

- `medical_samples` - Suivi des prélèvements
- `medical_black_market` - Historique des ventes
- `medical_stats` - Statistiques des médecins

### Vues créées

- `medical_stats_view` - Statistiques agrégées
- `medical_illegal_samples_view` - Prélèvements illégaux
- `medical_black_market_view` - Vue du marché noir

### Procédures stockées

- `GetMedicStats(medic_id)` - Récupère les stats d'un médecin
- `GetMedicSamples(medic_id)` - Récupère les prélèvements
- `CleanOldMedicalData()` - Nettoie les données >30 jours

---

## 🤝 Support

Pour toute question ou problème :

1. Vérifiez la section [Dépannage](#-dépannage)
2. Consultez les logs serveur et console F8
3. Créez une issue sur GitHub

---

## 📜 Licence

Ce script est distribué sous licence MIT.

---

## 👨‍💻 Auteur

Créé avec ❤️ pour la communauté FiveM ESX

---

## 🙏 Remerciements

- **ESX Framework** pour le framework
- **Overextended** pour ox_target et ox_lib
- La communauté FiveM pour le support

---

## 📅 Changelog

### Version 1.0.0 (2026-01-12)
- ✨ Release initiale
- ✅ Actions médicales complètes (soigner, réanimer, examiner)
- ✅ Système de prélèvements scientifiques
- ✅ Marché noir fonctionnel
- ✅ Effets 3D (texte, barres, notifications)
- ✅ Intégration ox_target
- ✅ Système de statistiques
- ✅ Base de données complète

---

**Bon jeu ! 🎮**
