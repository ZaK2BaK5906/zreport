# 📦 Système de Boîte Médicale

Guide d'utilisation du système de boîte médicale portable.

---

## 🎯 Concept

Le **medikit_advanced** n'est plus un simple item de soin, c'est maintenant une **boîte médicale portable** que vous pouvez poser au sol et qui contient TOUS les équipements médicaux !

---

## 🚀 Utilisation

### 1️⃣ Poser la boîte

1. Avoir un `medikit_advanced` dans votre inventaire
2. Appuyez sur **E** (ou utilisez l'item)
3. Animation de pose (3 secondes)
4. La boîte apparaît devant vous au sol

### 2️⃣ Ouvrir la boîte

1. Visez la boîte avec **ox_target** (œil)
2. Cliquez sur "**Ouvrir la boîte médicale**"
3. Un menu s'ouvre avec TOUS les items disponibles
4. Cliquez sur l'item que vous voulez prendre

### 3️⃣ Ramasser la boîte

1. Visez la boîte avec **ox_target**
2. Cliquez sur "**Ramasser la boîte**"
3. Animation de ramassage (2 secondes)
4. Vous récupérez le `medikit_advanced`

---

## 📦 Items Disponibles

### 🩺 Équipement Médical
- Kit Médical Avancé
- Défibrillateur Pro
- Stéthoscope Numérique
- Scanner Médical

### 💊 Médicaments
- Sédatif Léger
- Sédatif Puissant
- Morphine
- Adrénaline

### 🔪 Chirurgie
- Kit Chirurgical Basique
- Kit Chirurgical Avancé
- Scalpel

### 💉 Prélèvements
- Seringue Stérile
- Poche de Sang
- Conteneur à Échantillon
- Aiguille de Biopsie

### 🩹 Soins
- Bandage Stérile
- Antibiotique
- Antidouleur

### 🥽 Protection
- Masque Chirurgical
- Gants Latex

---

## 🎨 Features

✅ **Props 3D** - Boîte visible au sol (`prop_ld_health_pack`)
✅ **Menu ox_lib** - Menu moderne avec icônes couleurs
✅ **Animations** - Pose et ramassage animés
✅ **ox_target** - Interactions fluides
✅ **ox_inventory** - Vérification inventaire plein
✅ **Job check** - Réservé aux médecins
✅ **Logs** - Toutes les actions enregistrées
✅ **Auto-cleanup** - Suppression auto au restart

---

## 🔧 Technique

### Props
- **Model** : `prop_ld_health_pack`
- **Position** : Devant le joueur (1m)
- **Freeze** : Oui
- **Ground** : Posé automatiquement

### Export ox_inventory
```lua
client = {
    export = 'esx_medical_job.useMedikitAdvanced',
    usetime = 1000,
}
```

### Events serveur
- `esx_medical:removeMedicalBox` - Retire l'item lors de la pose
- `esx_medical:returnMedicalBox` - Rend l'item au ramassage
- `esx_medical:takeFromBox` - Prend un item de la boîte

---

## 📝 Configuration

Dans `ox_inventory_items.lua` :

```lua
['medikit_advanced'] = {
    label = 'Boîte Médicale',
    weight = 5000,
    stack = false,
    close = true,
    description = 'Boîte médicale portable - Appuyez sur E pour poser',
    client = {
        image = 'medikit.png',
        export = 'esx_medical_job.useMedikitAdvanced',
        usetime = 1000,
    }
},
```

---

## 🎮 Workflow Médecin

### Scénario 1 : Intervention sur place
1. Arrivez sur les lieux
2. Posez la boîte médicale au sol
3. Prenez les items dont vous avez besoin
4. Soignez les patients
5. Ramassez la boîte avant de partir

### Scénario 2 : Ambulance
1. Gardez la boîte dans l'ambulance
2. À chaque intervention, posez-la
3. Équipez-vous rapidement
4. Remettez la boîte dans l'ambulance

### Scénario 3 : Hôpital
1. Posez une boîte dans chaque salle
2. Les médecins se servent quand besoin
3. Rechargez les boîtes à la pharmacie

---

## 💡 Avantages

✅ **Gain de place** - 1 item au lieu de 20+
✅ **Rapidité** - Accès instantané aux items
✅ **Organisation** - Menu clair et structuré
✅ **Réalisme** - Vrai props médical visible
✅ **Flexibilité** - Posez où vous voulez
✅ **Teamplay** - Partageable entre médecins

---

## 🚨 Important

⚠️ **La boîte contient des items illimités !**
Les items sont créés quand vous les prenez, pas stockés dans la boîte.

⚠️ **Vérifiez votre inventaire !**
Si votre inventaire est plein, vous ne pourrez pas prendre d'item.

⚠️ **Réservé aux médecins !**
Seuls les joueurs avec le job `medecin_scientifique` peuvent utiliser la boîte.

⚠️ **Les échantillons ne sont PAS dans la boîte !**
Les prélèvements (os, peau, sang, organes) doivent être obtenus sur les patients.

---

## 🐛 Troubleshooting

**La boîte ne se pose pas**
- Vérifiez que vous avez le medikit_advanced
- Assurez-vous d'avoir de l'espace devant vous
- Regardez les logs serveur (F8)

**Le menu ne s'ouvre pas**
- Vérifiez que vous avez le job medecin_scientifique
- Assurez-vous que ox_lib est installé
- Redémarrez esx_medical_job

**Items ne sont pas donnés**
- Vérifiez que ox_inventory est démarré
- Vérifiez que les items existent dans ox_inventory
- Regardez les logs serveur

**La boîte reste après restart**
- Normal, elle se supprime automatiquement
- Si problème : restart esx_medical_job

---

## 📊 Statistiques

| Métrique | Valeur |
|----------|--------|
| Items disponibles | 24 |
| Catégories | 6 |
| Poids boîte | 5000 |
| Durée pose | 3s |
| Durée ramassage | 2s |
| Durée utilisation | 1s |

---

**Profitez du nouveau système ! 🔥**
