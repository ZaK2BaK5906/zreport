# 🎮 ZReport - Système de Report In-Game pour FiveM

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![ESX](https://img.shields.io/badge/ESX-Ready-success.svg)
![QBCore](https://img.shields.io/badge/QBCore-Ready-success.svg)
![Standalone](https://img.shields.io/badge/Standalone-Ready-success.svg)

Un système de report in-game moderne et optimisé pour FiveM avec une interface utilisateur fluide et élégante.

## ✨ Fonctionnalités

- ✅ **100% Fonctionnel** avec ESX, QBCore et en mode Standalone
- ✅ **Interface Moderne** - Design fluide inspiré de Quasar et OKOK
- ✅ **Notifications Admins** - Les admins sont notifiés lors de nouveaux reports
- ✅ **Gestion des Notifications** - Les admins peuvent activer/désactiver les notifications
- ✅ **Un Report par Joueur** - Les joueurs ne peuvent avoir qu'un seul report ouvert
- ✅ **Chat Intégré** - Communication directe entre joueur et admin
- ✅ **Actions Admin** - Téléporter le joueur, aller vers le joueur, conclure le report
- ✅ **Système d'Annulation** - Les joueurs peuvent annuler leur report (si aucun admin n'a interagi)
- ✅ **Traduction Française** - Entièrement en français
- ✅ **Logs Discord** - Tous les événements sont enregistrés dans Discord
- ✅ **Catégories** - Signaler un joueur, signaler un bug, poser une question
- ✅ **Responsive** - Interface adaptée à toutes les résolutions

## 📦 Installation

### 1. Téléchargement
```bash
git clone https://github.com/votre-repo/zreport.git
```

### 2. Installation du Script
1. Placez le dossier `zreport` dans votre dossier `resources`
2. Ajoutez `ensure zreport` dans votre `server.cfg`

### 3. Configuration Discord (Optionnel)
1. Ouvrez `webhook.lua`
2. Remplacez `DISCORD_WEBHOOK` par votre URL de webhook Discord
   ```lua
   local DISCORD_WEBHOOK = 'https://discord.com/api/webhooks/VOTRE_WEBHOOK_ICI'
   ```

### 4. Configuration SQL (Optionnel)
Si vous voulez sauvegarder les statistiques des admins :
1. Importez le fichier `sql/install.sql` dans votre base de données
2. Dans `config.lua`, mettez `Config.SaveRespondedReports = true`

### 5. Configuration du Framework
Ouvrez `config.lua` et ajustez selon votre serveur :
```lua
Config.Framework = 'ESX' -- ESX / QB / STANDALONE

Config.AdminGroups = { -- Groupes d'administrateurs
    'god',
    'superadmin',
    'admin',
    'mod'
}
```

## 🎮 Utilisation

### Commandes Joueur
- `/report` - Créer ou consulter votre report

### Commandes Admin
- `/reports` - Voir tous les reports ouverts
- `/rn` - Activer/Désactiver les notifications de nouveaux reports

## 🎨 Personnalisation

### Couleurs Discord
Dans `config.lua`, vous pouvez modifier les couleurs des webhooks :
```lua
Config.playerReportWebhookColor = '65280' -- Vert
Config.bugReportWebhookColor = '16711680' -- Rouge
Config.questionReportWebhookColor = '49151' -- Bleu
```

### Textes de l'Interface
Tous les textes sont dans `config.lua` sous `Config.Locale` :
```lua
Config.Locale = {
    ['ui_title'] = 'Système de Report',
    ['ui_create_report'] = 'Créer un Report',
    -- ... etc
}
```

### Catégories
Modifiez les catégories dans `config.lua` :
```lua
Config.ReportCategoriesTranslation = {
    player = "SIGNALER UN JOUEUR",
    bug = "SIGNALER UN BUG",
    question = "POSER UNE QUESTION"
}
```

## 🛠️ Configuration Avancée

### Pour ESX
```lua
Config.Framework = 'ESX'
Config.UseNewStaffCheckMethod = false -- true si problèmes avec /reports
```

### Pour QBCore
```lua
Config.Framework = 'QB'
Config.QBPermissionsUpdate = false -- true si dernière version permissions
```

### Pour Standalone
```lua
Config.Framework = 'STANDALONE'

Config.StandaloneStaffIdentifiers = {
    'license:votre_license_ici',
    'license:autre_license_ici'
}
```

## 📋 Catégories de Reports

1. **Signaler un Joueur** - Pour rapporter un comportement inapproprié
2. **Signaler un Bug** - Pour informer d'un problème technique
3. **Poser une Question** - Pour obtenir de l'aide du staff

## 🔧 Actions Admin Disponibles

- **Répondre** - Envoyer un message au joueur via le chat intégré
- **Téléporter ici** - Amener le joueur à votre position
- **Aller vers** - Se téléporter à la position du joueur
- **Conclure** - Fermer le report et (optionnel) revenir à votre position

## 📊 Logs Discord

Le script enregistre automatiquement dans Discord :
- Création de reports
- Annulation de reports
- Messages envoyés
- Actions admin (téléportations, conclusions)

## 🎯 Fonctionnement du Système

1. **Joueur crée un report** → Notification envoyée aux admins
2. **Admin répond/agit** → Le joueur ne peut plus annuler
3. **Chat en temps réel** → Communication fluide
4. **Admin conclut** → Report fermé, logs Discord envoyés

## 🐛 Debug

Activez le mode debug dans `config.lua` :
```lua
Config.Debug = true
```

Cela affichera des informations dans la console serveur et F8.

## 💡 Conseils

- Utilisez des webhooks Discord différents pour chaque type de report
- Configurez vos groupes admin correctement selon votre framework
- Testez d'abord en mode debug
- Les joueurs ne peuvent avoir qu'un seul report ouvert à la fois
- Les reports sont automatiquement supprimés si le joueur se déconnecte

## 📝 Support

Pour toute question ou problème :
1. Vérifiez que votre configuration est correcte
2. Activez le mode debug
3. Consultez les logs serveur (F8)

## 🔄 Mises à Jour

Version 1.0.0 (Septembre 2025)
- Release initiale
- Support ESX, QBCore et Standalone
- Interface moderne et fluide
- Système de chat intégré
- Logs Discord complets

## 📜 Licence

Ce script est fourni tel quel. Vous êtes libre de le modifier selon vos besoins.

## 🌟 Crédits

Développé avec ❤️ pour la communauté FiveM

---

**Bon jeu ! 🎮**
