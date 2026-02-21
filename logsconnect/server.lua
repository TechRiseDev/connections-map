local webhook = "#Lien du webhooks#"

local heartbeats = {}
local states = {}



local function getDateTime()
    return os.date("%d/%m/%Y à %H:%M:%S")
end

local function getPlayerIdentifiersFull(src)
    local ids = {
        steam = "N/A",
        license = "N/A",
        discord = "N/A"
    }

    for _, id in ipairs(GetPlayerIdentifiers(src)) do
        if id:find("steam:") then
            ids.steam = id
        elseif id:find("license:") then
            ids.license = id
        elseif id:find("discord:") then
            ids.discord = "<@" .. id:gsub("discord:", "") .. ">"
        end
    end

    return ids
end

local function sendEmbed(title, color, description)
    PerformHttpRequest(webhook, function() end, "POST", json.encode({
        username = "LOGS Name MAP",
        embeds = {{
            title = title,
            description = description,
            color = color,
            icon_url = "#Image du webhooks#",
            footer = { text = "📅 " .. getDateTime() }
        }}
    }), { ["Content-Type"] = "application/json" })
end

local function isCrashOrAltF4(reason, lastBeat)
    if not reason then return true end
    if os.time() - lastBeat > 30 then return true end

    local r = string.lower(reason)
    local triggers = { "quit", "exiting", "disconnected", "crash" }

    for _, v in ipairs(triggers) do
        if r:find(v) then return true end
    end

    return false
end



RegisterNetEvent("logs:heartbeat")
AddEventHandler("logs:heartbeat", function(playerStates)
    heartbeats[source] = os.time()
    states[source] = playerStates
end)



RegisterNetEvent("logs:playerPosition")
AddEventHandler("logs:playerPosition", function(coords)
    local ids = getPlayerIdentifiersFull(source)

    sendEmbed(
        "📍 Position à la connexion",
        3447003,
        "**Joueur :** "..GetPlayerName(source)..
        string.format("\n**Position :** %.2f %.2f %.2f", coords.x, coords.y, coords.z)..
        "\n**ID :** "..source..
        "\n\n🧾 **Identifiants**"..
        "\nSteam : "..ids.steam..
        "\nLicense : "..ids.license..
        "\nDiscord : "..ids.discord
    )
end)



AddEventHandler("playerConnecting", function(name)
    local ids = getPlayerIdentifiersFull(source)

    sendEmbed(
        "🟢 Connexion joueur",
        3066993,
        "**Joueur :** "..name..
        "\n\n🧾 **Identifiants**"..
        "\nSteam : "..ids.steam..
        "\nLicense : "..ids.license..
        "\nDiscord : "..ids.discord
    )
end)



RegisterNetEvent("logs:requestScreenshots")
AddEventHandler("logs:requestScreenshots", function()
    TriggerClientEvent("logs:takeScreenshots", source, webhook)
end)



AddEventHandler("playerDropped", function(reason)
    local src = source
    local name = GetPlayerName(src) or "Inconnu"
    local ids = getPlayerIdentifiersFull(src)
    local lastBeat = heartbeats[src] or 0
    local st = states[src] or {}

    local flags = {}

    if os.time() - lastBeat > 30 then table.insert(flags, "⏱️ **Timeout / crash suspect**") end
    if st.inRP then table.insert(flags, "🎭 **En scène RP**") end
    if st.handcuffed then table.insert(flags, "🔗 **Menotté**") end
    if st.inService then table.insert(flags, "🛂 **En service**") end
    if st.inCombat then table.insert(flags, "⚔️ **COMBAT LOG**") end

    if isCrashOrAltF4(reason, lastBeat) then
        TriggerClientEvent("logs:takeScreenshots", src, webhook)
        Wait(2000)
    end

    sendEmbed(
        "🔴 Déconnexion joueur",
        15158332,
        "**Joueur :** "..name..
        "\n**ID :** "..src..
        "\n**Raison :** "..(reason or "Aucune")..
        "\n\n🧾 **Identifiants**"..
        "\nSteam : "..ids.steam..
        "\nLicense : "..ids.license..
        "\nDiscord : "..ids.discord..
        "\n\n"..(#flags > 0 and table.concat(flags, "\n") or "RAS")
    )

    heartbeats[src] = nil
    states[src] = nil
end)
