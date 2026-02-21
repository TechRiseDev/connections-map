# 📸 Système avancé de journalisation logs et de capture d'écran FiveM

`Ce script est entièrement modifiable et adaptable le selon vos besoins.`

Système avancé de **logs joueur + screenshots automatiques** pour FiveM.

Ce script permet :

- 📡 D’envoyer un heartbeat serveur régulier
- 📍 D’enregistrer la position du joueur au spawn
- ⚔️ De détecter les combats
- 📸 De prendre plusieurs screenshots automatiquement
- 📝 D’afficher un overlay d’informations sur les captures
- 🔗 D’envoyer les images vers un webhook (Discord ou autre)

Idéal pour :

- Serveurs RP
- Staff & modération
- Surveillance admin

---

## 🚀 Fonctionnalités

- ✅ Heartbeat automatique toutes les 15 secondes
- ✅ Envoi de la position au spawn
- ✅ Détection automatique des dégâts (combat)
- ✅ Overlay personnalisé sur les screenshots
- ✅ Prise de screenshots multiples sécurisées
- ✅ Envoi vers webhook
- ✅ Optimisé et léger

---

 📦 Dépendances

- 🔹 **screenshot-basic**  
  👉 https://github.com/citizenfx/screenshot-basic

- 🔹 **ESX**  
  👉 https://github.com/mitlight/es_extended

- 🔹 **QBCore**  
  👉 https://github.com/qbcore-framework/qb-core

- 🔹 FXServer (FiveM)

⚠️ Assurez-vous que `es_extended` et `qb-core` sont installés et démarrés avant le dossier.

---

## ⚙️ Compatibilité Framework

- ✔️ cerulean
- ✔️ Standalone
- ✔️ Serveur RP
- ✔️ qb-core
- ✔️ es_extended

---

## 📍 Configuration du weboock notification

Ajouter votre weboock configurables dans :

```serveur.lua
local webhook = "#Lien du webhooks#" <--Remplacer (#Lien du webhooks#) part votre Lien

local function sendEmbed(title, color, description)
    PerformHttpRequest(webhook, function() end, "POST", json.encode({
        username = "LOGS Name MAP", <--Remplacer (Name) part votre nom de serveur RP
        embeds = {{
            title = title,
            description = description,
            color = color,
            icon_url = "#Image du webhooks#", <--Remplacer (#Image du webhooks#) part votre Image
            footer = { text = "📅 " .. getDateTime() }
        }}
    }), { ["Content-Type"] = "application/json" })
end
```

---

## 📥 Installation

### 1️⃣ Télécharger le dossier

Placez le dossier dans votre `resources/`

---

### 2️⃣ Ajouter au server.cfg

Ajoutez les lignes suivantes dans votre `server.cfg` :

```cfg
ensure qb-core
ensure es_extended
ensure logsconnect
```
