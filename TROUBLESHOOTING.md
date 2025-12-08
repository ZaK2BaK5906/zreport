# 🔧 Guide de Dépannage - ZReport

## ❌ Problème: "Vous n'avez pas la permission d'utiliser cette commande"

### Solution 1: Vérifier votre groupe ESX (RECOMMANDÉ)

1. **Activez le mode debug** dans `config.lua`:
```lua
Config.Debug = true
```

2. **Redémarrez le script**:
```
restart zreport
```

3. **Tapez `/zreportadmin` dans le jeu** - Vous verrez dans le chat et F8:
```
[ZReport Debug] Statut Admin: true/false
[ZReport Debug] Framework: ESX
```

4. **Regardez votre console serveur (F8)** quand vous rejoignez le serveur:
```
[ZReport] Groupe du joueur 1: admin
[ZReport] Joueur 1 est admin (groupe: admin)
```

### Solution 2: Vérifier votre configuration

Dans `config.lua`, assurez-vous que:

```lua
Config.Framework = 'ESX'  -- Doit être ESX

Config.UseNewStaffCheckMethod = true  -- DOIT être true pour ESX !

Config.AdminGroups = {  -- Vos groupes admin
    'god',
    'superadmin',
    'admin',
    'mod'
}
```

**IMPORTANT**: Votre groupe ESX dans la base de données doit correspondre EXACTEMENT à un des groupes listés ci-dessus !

### Solution 3: Vérifier votre base de données

1. Ouvrez votre base de données MySQL
2. Allez dans la table `users`
3. Trouvez votre ligne (avec votre identifier)
4. Regardez la colonne `group`
5. Assurez-vous qu'elle contient: `admin`, `superadmin`, `mod`, ou `god`

**Exemple**:
```sql
SELECT identifier, group FROM users WHERE identifier = 'steam:110000XXXXXXX';
```

Si votre groupe est `user`, changez-le:
```sql
UPDATE users SET `group` = 'admin' WHERE identifier = 'steam:110000XXXXXXX';
```

### Solution 4: Utiliser les ACE Permissions (Alternative)

Si votre serveur utilise les ACE permissions au lieu de la base de données ESX:

1. Dans `config.lua`:
```lua
Config.UseAcePermissions = true
```

2. Dans votre `server.cfg`, ajoutez:
```cfg
# Donnez les permissions aux admins
add_ace group.admin zreport.admin allow
add_ace group.superadmin zreport.admin allow

# Ajoutez-vous au groupe admin (remplacez steam:110000XXXXXXX par votre ID)
add_principal identifier.steam:110000XXXXXXX group.admin
```

3. Redémarrez le serveur

### Solution 5: Mode Standalone

Si ESX ne fonctionne pas du tout, utilisez le mode Standalone:

1. Dans `config.lua`:
```lua
Config.Framework = 'STANDALONE'

Config.StandaloneStaffIdentifiers = {
    'license:VOTRE_LICENSE_ICI',  -- Remplacez par votre license
    'steam:110000XXXXXXX',         -- Ou votre steam ID
}
```

2. **Pour trouver votre identifier**, tapez en console serveur:
```
zreport_getidentifiers VOTRE_ID_SERVEUR
```

Ou regardez dans F8 quand vous rejoignez:
```lua
RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    print('Mon identifier: ' .. xPlayer.identifier)
end)
```

## 🐛 Problème: Les messages ne s'envoient pas

### Solution:

1. **Activez le debug**:
```lua
Config.Debug = true
```

2. **Ouvrez F8** et tapez un message dans un report

3. **Vous devriez voir**:
```
[ZReport] Envoi du message: Bonjour - pour le report: 1
[ZReport] Réponse sendMessage: [Object]
```

4. **Côté serveur**, vous devriez voir:
```
[ZReport] Message envoyé sur le report #1 par AdminName
```

5. Si rien ne s'affiche:
   - Vérifiez que vous avez bien un report ouvert
   - Vérifiez que `currentReportId` n'est pas null
   - Regardez la console serveur pour des erreurs

## ℹ️ Commandes de Debug

- `/zreportadmin` - Affiche votre statut admin et revérifie auprès du serveur
- `/report` - Créer/voir votre report (joueurs)
- `/reports` - Voir tous les reports (admins uniquement)
- `/rn` - Toggle les notifications (admins uniquement)

## 📋 Checklist de Vérification

- [ ] `Config.Framework = 'ESX'`
- [ ] `Config.UseNewStaffCheckMethod = true`
- [ ] `Config.Debug = true` (pour tester)
- [ ] Votre groupe dans la BDD correspond à `Config.AdminGroups`
- [ ] ESX est bien démarré avant ZReport dans `server.cfg`
- [ ] Vous avez redémarré le script après les changements
- [ ] Vous avez utilisé `/zreportadmin` pour vérifier
- [ ] Vous avez regardé F8 et la console serveur

## 🆘 Toujours pas résolu ?

1. **Partagez vos logs** - Copiez ce que vous voyez dans F8 et console serveur
2. **Vérifiez votre config** - Envoyez votre `config.lua` (sans les identifiers sensibles)
3. **Version ESX** - Assurez-vous d'utiliser ESX Legacy (es_extended 1.9.0+)

## ✅ Configuration Recommandée pour ESX

```lua
-- config.lua
Config.Debug = true  -- Pour tester
Config.Framework = 'ESX'
Config.UseNewStaffCheckMethod = true  -- IMPORTANT !
Config.UseAcePermissions = false  -- Sauf si vous utilisez ACE

Config.AdminGroups = {
    'god',
    'superadmin',
    'admin',
    'mod'
}
```

```cfg
# server.cfg - Ordre important !
ensure es_extended
ensure zreport  # APRÈS ESX
```

---

Si tout est correctement configuré, vous devriez voir dans le chat au démarrage:
```
[ZReport] Vous êtes administrateur - Utilisez /reports
```

Et quand vous tapez `/zreportadmin`:
```
[ZReport Debug] Statut Admin: true
```
