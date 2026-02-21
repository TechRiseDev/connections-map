local showOverlay = false
local overlayText = ""

local playerStates = {
    inService = false,
    handcuffed = false,
    inRP = false,
    inCombat = false
}


CreateThread(function()
    while true do
        TriggerServerEvent("logs:heartbeat", playerStates)
        Wait(15000)
    end
end)


AddEventHandler("playerSpawned", function()
    Wait(3000)
    local coords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent("logs:playerPosition", coords)
end)


AddEventHandler("gameEventTriggered", function(name)
    if name == "CEventNetworkEntityDamage" then
        playerStates.inCombat = true
        SetTimeout(30000, function()
            playerStates.inCombat = false
        end)
    end
end)


CreateThread(function()
    while true do
        Wait(0)
        if showOverlay then
            SetTextFont(4)
            SetTextScale(0.45, 0.45)
            SetTextColour(255, 0, 0, 255)
            SetTextOutline()
            BeginTextCommandDisplayText("STRING")
            AddTextComponentSubstringPlayerName(overlayText)
            EndTextCommandDisplayText(0.02, 0.92)
        end
    end
end)


RegisterNetEvent("logs:takeScreenshots")
AddEventHandler("logs:takeScreenshots", function(webhook)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    overlayText = string.format(
        "JOUEUR: %s | ID: %s | POS: %.2f %.2f %.2f | %s",
        GetPlayerName(PlayerId()),
        GetPlayerServerId(PlayerId()),
        coords.x, coords.y, coords.z,
        os.date("%d/%m/%Y %H:%M:%S")
    )

    showOverlay = true

    
    local safeShots = {0, 500, 1000}
    for _, delay in ipairs(safeShots) do
        Wait(delay)
        exports["screenshot-basic"]:requestScreenshotUpload(webhook, "files[]", function() end)
    end

    
    for i = 1, 10 do
        Wait(120) 
        exports["screenshot-basic"]:requestScreenshotUpload(webhook, "files[]", function() end)
    end

    Wait(300)
    showOverlay = false
end)
