# 🔬 Installation - Médecin Scientifique

Guide d'installation complet pour le script **Médecin Scientifique** ESX avec ox_inventory.

---

## 📋 Prérequis

Assurez-vous d'avoir les ressources suivantes installées et configurées :

### Obligatoires
- ✅ **[es_extended](https://github.com/esx-framework/esx_core)** - ESX Legacy v1.9+
- ✅ **[ox_inventory](https://github.com/overextended/ox_inventory)** - Inventaire moderne
- ✅ **[ox_target](https://github.com/overextended/ox_target)** - Système de ciblage
- ✅ **[ox_lib](https://github.com/overextended/ox_lib)** - Librairie UI
- ✅ **[oxmysql](https://github.com/overextended/oxmysql)** - MySQL moderne

### Recommandées
- 📦 **[esx_ambulancejob](https://github.com/esx-framework/esx_core)** - Pour compatibilité réanimation
- 📦 **[skinchanger](https://github.com/esx-framework/esx-legacy)** - Pour changement de tenues
- 📦 **[esx_billing](https://github.com/esx-framework/esx-legacy)** - Pour factures patients

---

## 🚀 Installation

### 1️⃣ Téléchargement

Clonez ou téléchargez le script dans votre dossier `resources` :

```bash
cd resources
git clone [URL_REPO] esx_medical_job
```

### 2️⃣ Base de données

Importez le fichier SQL dans votre base de données :

**Méthode 1 : CLI**
```bash
mysql -u root -p nom_base_de_donnees < esx_medical_job/sql/install.sql
```

**Méthode 2 : phpMyAdmin**
1. Ouvrez phpMyAdmin
2. Sélectionnez votre base de données
3. Allez dans "Importer"
4. Sélectionnez `sql/install.sql`
5. Cliquez sur "Exécuter"

✅ **Vérification** : Vous devriez voir apparaître :
- Job `medecin_scientifique` dans la table `jobs`
- 7 grades dans `job_grades`
- 30+ items dans `items`
- 5 nouvelles tables (`medecin_*`)

### 3️⃣ Configuration ox_inventory

Ajoutez les items dans le fichier `ox_inventory/data/items.lua` :

```lua
-- Médecin Scientifique Items
['medikit_advanced'] = {
    label = 'Kit Médical Avancé',
    weight = 500,
    stack = true,
    close = true,
},

['defib_pro'] = {
    label = 'Défibrillateur Professionnel',
    weight = 1000,
    stack = false,
    close = true,
},

['stethoscope_digital'] = {
    label = 'Stéthoscope Numérique',
    weight = 200,
    stack = true,
    close = true,
},

-- ... (Ajoutez tous les items depuis sql/install.sql)
```

**OU** utilisez le fichier automatique (recommandé) :
```bash
# Copiez le fichier items pré-configuré
cp esx_medical_job/ox_inventory_items.lua ox_inventory/data/items.lua
```

### 4️⃣ Configuration server.cfg

Ajoutez la ressource dans votre `server.cfg` :

```cfg
# ESX Core
ensure es_extended
ensure oxmysql
ensure ox_lib

# OX Stack
ensure ox_inventory
ensure ox_target

# Medical Job
ensure esx_medical_job
```

⚠️ **IMPORTANT** : L'ordre de chargement est crucial !

### 5️⃣ Permissions & Whitelist

Le job est **whitelist** par défaut. Pour donner le job à un joueur :

**Méthode SQL** :
```sql
UPDATE users
SET job = 'medecin_scientifique', job_grade = 0
WHERE identifier = 'char1:IDENTIFIANT';
```

**Méthode In-Game** (avec esx_admin) :
```
/setjob [id] medecin_scientifique [grade]
```

**Grades disponibles** :
- 0 : Stagiaire Médical ($250)
- 1 : Infirmier ($500)
- 2 : Médecin ($800)
- 3 : Chirurgien ($1200)
- 4 : Scientifique ($1500)
- 5 : Chef Scientifique ($2000)
- 6 : Directeur Médical ($2500)

---

## ⚙️ Configuration

### Fichier principal : `config/config.lua`

#### Modifier le nom du job
```lua
Config.JobName = 'medecin_scientifique'  -- Changez si besoin
```

#### Activer/Désactiver les fonctionnalités
```lua
Config.UseOxInventory = true  -- Utiliser ox_inventory
Config.UseOxTarget = true  -- Utiliser ox_target
Config.UseOxLib = true  -- Utiliser ox_lib
```

#### Prix et gains
```lua
Config.Prices = {
    heal = 800,
    revive = 1500,
    boneSample = 3500,  -- Marché noir
    -- ...
}
```

#### Effets 3D
```lua
Config.Effects3D = {
    text = { enabled = true, scale = 0.4 },
    progressBar = { enabled = true, width = 0.2 },
    particles = { enabled = true },
    screenEffects = { enabled = true },
    -- ...
}
```

#### NUI Custom
```lua
Config.NUI = {
    enabled = true,
    position = 'top-right',
    maxNotifications = 5,
    -- ...
}
```

### Coordonnées des hôpitaux

Modifiez dans `Config.Hospitals` pour adapter à votre serveur :

```lua
{
    name = "Mon Hôpital",
    blip = {coords = vector3(x, y, z), sprite = 61, color = 3},
    cloakroom = {coords = vector3(x, y, z), size = vector3(2.5, 2.5, 2.5)},
    pharmacy = {coords = vector3(x, y, z), size = vector3(2.5, 2.5, 2.5)},
    laboratory = {coords = vector3(x, y, z), size = vector3(4, 4, 2.5)},
    -- ...
}
```

---

## 🎯 Utilisation

### Pour les joueurs

1. **Prendre son service** :
   - Allez au vestiaire (icône 👔)
   - Utilisez ox_target sur la zone
   - Sélectionnez une tenue

2. **Acheter de l'équipement** :
   - Allez à la pharmacie (icône 💊)
   - Utilisez ox_target
   - Achetez vos items

3. **Soigner des patients** :
   - Visez un joueur avec ox_target (œil)
   - Sélectionnez l'action désirée
   - Profitez des effets 3D !

### Actions disponibles

| Action | Grade min | Item requis | Légal | Prix |
|--------|-----------|-------------|-------|------|
| 🩹 Soigner | 0 | medikit_advanced | ✅ | +$800 |
| ⚡ Réanimer | 1 | defib_pro | ✅ | +$1500 |
| 🩺 Examiner | 0 | stethoscope_digital | ✅ | +$300 |
| 💉 Endormir | 2 | sedative_heavy | ⚠️ | +$400 |
| 🩸 Prélever sang | 1 | syringe_sterile | ✅ | +$500 |
| ✋ Prélever peau | 3 | surgical_kit_basic | ❌ | +$2500* |
| 🦴 Prélever os | 4 | surgical_kit_advanced | ❌ | +$3500* |
| 🧬 Prélever organe | 5 | surgical_kit_advanced | ❌ | +$5000* |

_* = Marché noir seulement_

### Marché noir

Localisations secrètes (cachées) :
1. **Nord de Sandy Shores** (désert)
2. **Docks Sud** (zone industrielle)

Vendez vos échantillons illégaux pour de l'argent sale !

---

## 🐛 Dépannage

### Les interactions ox_target ne fonctionnent pas

```bash
# Vérifiez que ox_target est démarré
ensure ox_target

# Redémarrez le script
restart esx_medical_job
```

### Les items n'apparaissent pas

1. Vérifiez que les items sont dans la table `items`
2. Redémarrez `ox_inventory`
3. Vérifiez les logs serveur

### Les notifications 3D ne s'affichent pas

1. Vérifiez que ox_lib est installé
2. Ouvrez F8 et cherchez des erreurs JavaScript
3. Vérifiez que `Config.NUI.enabled = true`

### Erreur "attempt to index a nil value"

```bash
# Vérifiez l'ordre de chargement dans server.cfg
# ESX doit être chargé AVANT esx_medical_job
```

### Les prélèvements ne se sauvegardent pas

1. Vérifiez les tables dans la base de données
2. Vérifiez que oxmysql est configuré
3. Regardez les logs serveur pour erreurs SQL

---

## 📚 Structure des fichiers

```
esx_medical_job/
├── fxmanifest.lua          # Manifest
├── config/
│   └── config.lua          # Configuration principale
├── client/
│   ├── utils.lua           # Utilitaires 3D
│   └── main.lua            # Code client
├── server/
│   └── main.lua            # Code serveur
├── html/
│   ├── ui.html             # Interface NUI
│   ├── style.css           # Styles CSS
│   └── script.js           # JavaScript NUI
├── sql/
│   └── install.sql         # Base de données
└── README.md               # Documentation
```

---

## 🔐 Sécurité

### Actions illégales

Toutes les actions illégales sont enregistrées :
- Prélèvements d'os/peau/organes
- Ventes au marché noir
- Sédations

**Accès aux logs** :
```sql
SELECT * FROM medecin_illegal_activity;
SELECT * FROM medecin_black_market;
```

### Protection anti-cheat

- Vérification côté serveur pour tous les items
- Vérification des grades
- Logs de toutes les actions
- Anti-spam intégré

---

## 📊 Statistiques

### Top médecins
```sql
CALL GetTopMedics(10);
```

### Revenus du marché noir
```sql
SELECT * FROM medecin_black_market_stats;
```

### Performance par médecin
```sql
SELECT * FROM medecin_performance_stats
WHERE medic_identifier = 'char1:xxx';
```

---

## 🆘 Support

### Problèmes courants

1. **"You don't have permission"**
   - Vérifiez que vous avez le job `medecin_scientifique`

2. **"No item required"**
   - Achetez l'item à la pharmacie
   - Vérifiez ox_inventory

3. **"No players nearby"**
   - Rapprochez-vous du joueur (< 3m)

### Logs utiles

```bash
# Logs serveur
tail -f server.log | grep "medical"

# Logs client (F8 in-game)
setr debugmode 1
```

---

## 📝 Notes importantes

⚠️ **Versions compatibles** :
- ESX Legacy 1.9.0+
- ox_inventory 2.0+
- ox_target 1.0+
- ox_lib 3.0+

⚠️ **Performance** :
- Utilise ox_lib pour UI (optimisé)
- NUI custom avec animations CSS (performant)
- ox_target optimisé (pas de boucles)

⚠️ **Multilingue** :
- Français par défaut
- Modifiable dans `config.lua` (Messages)

---

## 📞 Contact

Pour toute question ou problème :
1. Vérifiez cette documentation
2. Consultez les logs
3. Créez une issue sur GitHub

---

**Bon jeu ! 🎮🔬**
