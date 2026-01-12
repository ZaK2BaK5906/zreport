-- ===========================================
-- UTILITAIRES POUR EFFETS 3D
-- ===========================================

Utils = {}

-- =================== TEXTE 3D ===================
function Utils.Draw3DText(coords, text, scale, font)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(px, py, pz) - coords)

    scale = (scale or 0.35) * (1 / dist) * 2
    font = font or 4

    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(font)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

-- =================== BARRE DE PROGRESSION 3D ===================
local activeProgressBar = nil

function Utils.StartProgressBar3D(coords, duration, label)
    activeProgressBar = {
        coords = coords,
        duration = duration,
        label = label or "En cours...",
        startTime = GetGameTimer(),
        endTime = GetGameTimer() + duration,
    }

    CreateThread(function()
        while activeProgressBar do
            local currentTime = GetGameTimer()
            local progress = math.min(100, ((currentTime - activeProgressBar.startTime) / activeProgressBar.duration) * 100)

            if progress >= 100 then
                activeProgressBar = nil
                break
            end

            -- Dessiner le fond de la barre
            Utils.DrawProgressBar3D(activeProgressBar.coords, progress, activeProgressBar.label)

            Wait(0)
        end
    end)
end

function Utils.StopProgressBar3D()
    activeProgressBar = nil
end

function Utils.DrawProgressBar3D(coords, progress, label)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z + 0.5)

    if onScreen then
        -- Label au dessus de la barre
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(label)
        DrawText(_x, _y - 0.05)

        -- Fond de la barre
        DrawRect(_x, _y, 0.15, 0.015, 0, 0, 0, 180)

        -- Barre de progression
        local barWidth = 0.15 * (progress / 100)
        local color = {
            r = math.floor(255 - (progress * 2.55)),
            g = math.floor(progress * 2.55),
            b = 50
        }
        DrawRect(_x - (0.15 - barWidth) / 2, _y, barWidth, 0.012, color.r, color.g, color.b, 220)

        -- Pourcentage
        SetTextScale(0.25, 0.25)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(string.format("%.0f%%", progress))
        DrawText(_x, _y + 0.015)
    end
end

-- =================== MARQUEUR 3D ===================
function Utils.DrawMarker3D(coords, markerType, scale, color)
    markerType = markerType or 1
    scale = scale or vector3(1.0, 1.0, 1.0)
    color = color or {r = 0, g = 150, b = 255, a = 200}

    DrawMarker(
        markerType,
        coords.x, coords.y, coords.z,
        0.0, 0.0, 0.0,
        0.0, 0.0, 0.0,
        scale.x, scale.y, scale.z,
        color.r, color.g, color.b, color.a,
        false, true, 2, false, nil, nil, false
    )
end

-- =================== NOTIFICATION 3D (NUI) ===================
function Utils.ShowNotification3D(message, type, duration)
    SendNUIMessage({
        action = 'showNotification',
        message = message,
        type = type or 'info',
        duration = duration or 5000
    })
end

-- =================== EFFETS VISUELS ===================
function Utils.PlayScreenEffect(effectName, duration)
    StartScreenEffect(effectName, duration or 5000, false)

    if duration then
        SetTimeout(duration, function()
            StopScreenEffect(effectName)
        end)
    end
end

function Utils.ShakeCamera(intensity, duration)
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', intensity or 0.15)

    if duration then
        SetTimeout(duration, function()
            StopGameplayCamShaking(true)
        end)
    end
end

-- =================== ANIMATIONS ===================
function Utils.PlayAnimation(ped, dict, anim, duration, flag)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end

    TaskPlayAnim(ped, dict, anim, 8.0, -8.0, duration or -1, flag or 49, 0, false, false, false)

    if duration and duration > 0 then
        SetTimeout(duration, function()
            ClearPedTasks(ped)
        end)
    end
end

function Utils.PlayScenario(ped, scenario, duration)
    TaskStartScenarioInPlace(ped, scenario, 0, true)

    if duration and duration > 0 then
        SetTimeout(duration, function()
            ClearPedTasks(ped)
        end)
    end
end

-- =================== PARTICULES ===================
function Utils.StartParticleEffect(dict, name, coords, scale, duration)
    RequestNamedPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
        Wait(10)
    end

    UseParticleFxAsset(dict)
    local particle = StartParticleFxLoopedAtCoord(name, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, scale or 1.0, false, false, false, false)

    if duration then
        SetTimeout(duration, function()
            StopParticleFxLooped(particle, 0)
        end)
    end

    return particle
end

-- =================== SON ===================
function Utils.PlaySound(soundName, soundSet)
    PlaySoundFrontend(-1, soundName, soundSet or "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end

-- =================== VÉRIFICATIONS ===================
function Utils.GetClosestPlayer()
    local players = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 3.0)
    local closestPlayer = nil
    local closestDistance = 3.0

    for _, player in pairs(players) do
        if player ~= PlayerId() then
            local targetPed = GetPlayerPed(player)
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(GetEntityCoords(PlayerPedId()) - targetCoords)

            if distance < closestDistance then
                closestDistance = distance
                closestPlayer = player
            end
        end
    end

    return closestPlayer, GetPlayerServerId(closestPlayer or 0)
end

function Utils.IsPlayerDead(playerId)
    local targetPed = GetPlayerPed(GetPlayerFromServerId(playerId))
    return IsEntityDead(targetPed) or IsPedDeadOrDying(targetPed, true)
end

-- =================== HELPERS ===================
function Utils.HasItem(item)
    local hasItem = false
    ESX.TriggerServerCallback('esx_medical:hasItem', function(result)
        hasItem = result
    end, item)

    while hasItem == false do
        Wait(10)
    end

    return hasItem
end

function Utils.Notify(message, type)
    if GetResourceState('ox_lib') == 'started' then
        lib.notify({
            title = 'EMS',
            description = message,
            type = type or 'info'
        })
    else
        ESX.ShowNotification(message)
    end
end

-- =================== ZONE HELPERS ===================
function Utils.CreateBlip(coords, sprite, color, scale, label)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, scale or 0.8)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(label)
    EndTextCommandSetBlipName(blip)
    return blip
end

return Utils
