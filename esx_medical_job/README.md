# 🔬 Médecin Scientifique - Job ESX

Script de job médical scientifique **FULL OX** (ox_inventory + ox_target + ox_lib) avec NUI 3D custom ultra moderne !

---

## 🚀 Installation Rapide

### 1️⃣ Copier le script
```bash
cd resources
git clone [URL] esx_medical_job
```

### 2️⃣ SQL - Base de données
```bash
mysql -u root -p nom_base < esx_medical_job/sql/install.sql
```

### 3️⃣ OX_INVENTORY - Items
Ouvrir `ox_inventory/data/items.lua` et copier le contenu de `ox_inventory_items.lua` dedans.

**OU** remplacer directement :
```bash
cp esx_medical_job/ox_inventory_items.lua ox_inventory/data/items.lua
```

### 4️⃣ server.cfg
```cfg
ensure es_extended
ensure oxmysql
ensure ox_lib
ensure ox_inventory
ensure ox_target

ensure esx_medical_job
```

### 5️⃣ Redémarrer
```
restart ox_inventory
restart esx_medical_job
```

---

## ✅ Fonctionnalités

### 🩺 Actions Légales
| Action | Grade | Item | Prix |
|--------|-------|------|------|
| Soigner | 0+ | medikit_advanced | +$800 |
| Réanimer | 1+ | defib_pro | +$1500 |
| Examiner | 0+ | stethoscope_digital | +$300 |
| Prélever sang | 1+ | syringe_sterile | +$500 |

### ⚠️ Actions Illégales (Marché Noir)
| Action | Grade | Item | Prix |
|--------|-------|------|------|
| Endormir | 2+ | sedative_heavy | +$400 |
| Prélever peau | 3+ | surgical_kit_basic | +$2500 |
| Prélever os | 4+ | surgical_kit_advanced | +$3500 |
| Prélever organe | 5+ | surgical_kit_advanced | +$5000 |
| Blesser | 2+ | Aucun | Illégal |

### 🎨 Effets 3D Custom
- ✨ Notifications NUI glass morphism
- 📊 Progress bars 3D néon cyan
- 💥 Particules (électricité, sang, vapeur)
- 📺 Screen effects (flash, blur, shake)
- 🎬 Animations réalistes
- 🌈 Design cyberpunk medical

### 🏥 Système Complet
- **3 Hôpitaux** (LS, Sandy, Paleto)
- **Vestiaires** avec 3 tenues
- **Pharmacie** 25+ items
- **Laboratoire** analyses
- **Garage** véhicules
- **Boss menu** grade 5+
- **2 Marchés noirs** (cachés)

---

## 🎯 Grades du Job

```
0. Stagiaire Médical      ($250/h)
1. Infirmier              ($500/h)
2. Médecin                ($800/h)
3. Chirurgien             ($1200/h)
4. Scientifique           ($1500/h)
5. Chef Scientifique      ($2000/h)
6. Directeur Médical      ($2500/h)
```

**Donner le job :**
```sql
UPDATE users SET job = 'medecin_scientifique', job_grade = 0 WHERE identifier = 'char1:xxx';
```

---

## 📦 Structure

```
esx_medical_job/
├── fxmanifest.lua
├── config/
│   └── config.lua              # Configuration complète
├── client/
│   ├── utils.lua               # Utilitaires 3D
│   └── main.lua                # Code principal
├── server/
│   └── main.lua                # Serveur
├── html/
│   ├── ui.html                 # NUI
│   ├── style.css               # CSS futuriste
│   └── script.js               # JavaScript
├── sql/
│   └── install.sql             # Base de données
└── ox_inventory_items.lua      # Items pour ox_inventory
```

---

## 📊 Base de Données

**Job créé :**
- `medecin_scientifique` (whitelist)
- 7 grades
- Society account $50,000

**Tables créées :**
- `medecin_samples` - Prélèvements
- `medecin_black_market` - Ventes marché noir
- `medecin_stats` - Statistiques
- `medecin_interventions` - Interventions
- `medecin_lab_analysis` - Analyses

**30+ items ox_inventory :**
- Équipement médical
- Médicaments/sédatifs
- Équipement chirurgical
- Matériel de prélèvement
- Échantillons biologiques
- Soins
- Protection

---

## ⚙️ Configuration

Modifier `config/config.lua` :

```lua
-- Job
Config.JobName = 'medecin_scientifique'

-- Prix
Config.Prices = {
    heal = 800,
    revive = 1500,
    boneSample = 3500,  -- Marché noir
    -- ...
}

-- Effets 3D
Config.Effects3D = {
    text = { enabled = true },
    progressBar = { enabled = true },
    particles = { enabled = true },
    -- ...
}

-- NUI
Config.NUI = {
    enabled = true,
    position = 'top-right',
    -- ...
}
```

---

## 🎮 Utilisation

### In-Game

1. **Prendre service** : Vestiaire → Changer tenue
2. **Acheter équipement** : Pharmacie → Acheter items
3. **Soigner patients** : ox_target sur joueur → Choisir action

### Interactions

Toutes les actions se font via **ox_target** (œil) :
- Viser un joueur
- Menu s'affiche
- Cliquer sur l'action
- Progress bar 3D + effets

### Marché Noir

Localisations secrètes (pas de blip) :
- Nord de Sandy Shores
- Docks Sud

Vendre échantillons illégaux → Argent sale

---

## 🐛 Dépannage

**Interactions ox_target ne marchent pas :**
```bash
ensure ox_target
restart esx_medical_job
```

**Items n'apparaissent pas :**
1. Vérifier ox_inventory_items.lua copié
2. Redémarrer ox_inventory
3. Vérifier F8 pour erreurs

**Notifications 3D invisibles :**
1. Vérifier ox_lib installé
2. F8 → Erreurs JavaScript ?
3. Config.NUI.enabled = true ?

**Erreur SQL :**
```bash
# Vérifier ordre de chargement server.cfg
# ESX → oxmysql → ox → esx_medical_job
```

---

## 📝 Prérequis

**Obligatoires :**
- ✅ [es_extended](https://github.com/esx-framework/esx_core) v1.9+
- ✅ [ox_inventory](https://github.com/overextended/ox_inventory) v2.0+
- ✅ [ox_target](https://github.com/overextended/ox_target) v1.0+
- ✅ [ox_lib](https://github.com/overextended/ox_lib) v3.0+
- ✅ [oxmysql](https://github.com/overextended/oxmysql)

**Recommandées :**
- esx_ambulancejob (réanimation)
- skinchanger (tenues)
- esx_billing (factures)

---

## 🔐 Sécurité

**Actions illégales enregistrées :**
- Prélèvements os/peau/organes
- Ventes marché noir
- Sédations

**Logs SQL :**
```sql
SELECT * FROM medecin_illegal_activity;
SELECT * FROM medecin_black_market;
```

**Anti-cheat :**
- Vérifications côté serveur
- Vérification grades
- Anti-spam intégré

---

## 📊 Statistiques

**Top médecins :**
```sql
CALL GetTopMedics(10);
```

**Performance :**
```sql
SELECT * FROM medecin_performance_stats WHERE medic_identifier = 'char1:xxx';
```

**Marché noir :**
```sql
SELECT * FROM medecin_black_market_stats;
```

---

## 💡 Features

✅ **Job complet** - 7 grades avec salaires
✅ **OX Full** - ox_inventory + ox_target + ox_lib
✅ **30+ items** - Équipement médical/chirurgical
✅ **NUI 3D** - Notifications + Progress bars custom
✅ **Glass morphism** - Design moderne
✅ **Marché noir** - Vente échantillons illégaux
✅ **SQL avancé** - Triggers + Procédures + Vues
✅ **Anti-cheat** - Vérifications serveur
✅ **Logs complets** - Tracking toutes actions
✅ **3 Hôpitaux** - LS + Sandy + Paleto
✅ **Effets 3D** - Particules + Animations

---

## 📞 Support

Pour aide :
1. Lire cette doc
2. Vérifier INSTALL.md
3. Checker les logs (F8 + serveur)
4. Créer une issue GitHub

---

**Made with ❤️ for FiveM ESX Community**

🎮 **Ready to use - Plug & Play !**
