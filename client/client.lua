-- ============================================
-- VARIABLES GLOBALES
-- ============================================

ESX = nil
local isAdmin = false
local allReports = {}
local playerPosition = nil
local uiOpen = false

-- ============================================
-- INITIALISATION DU FRAMEWORK
-- ============================================

if Config.Framework == 'ESX' then
    Citizen.CreateThread(function()
        while ESX == nil do
            ESX = exports['es_extended']:getSharedObject()
            Citizen.Wait(0)
        end

        while not ESX.IsPlayerLoaded() do
            Citizen.Wait(100)
        end

        TriggerServerEvent('zreport:server:checkAdmin')
    end)
elseif Config.Framework == 'QB' then
    Citizen.CreateThread(function()
        while ESX == nil do
            ESX = exports['qb-core']:GetCoreObject()
            Citizen.Wait(0)
        end

        while not ESX.Functions.GetPlayerData() do
            Citizen.Wait(100)
        end

        TriggerServerEvent('zreport:server:checkAdmin')
    end)
else
    Citizen.CreateThread(function()
        Citizen.Wait(1000)
        TriggerServerEvent('zreport:server:checkAdmin')
    end)
end

-- ============================================
-- FONCTIONS UTILITAIRES
-- ============================================

function ShowNotification(data)
    -- Toujours envoyer à l'UI NUI aussi
    SendNUIMessage({
        action = 'showNotification',
        data = data
    })

    -- Framework notifications
    if Config.Framework == 'ESX' and ESX then
        ESX.ShowNotification(data.text)
    elseif Config.Framework == 'QB' and Config.NewReportNotifyType == 'QB' and ESX then
        ESX.Functions.Notify(data.text, data.type, data.time)
    end
end

function OpenReportUI(mode, reportId)
    if uiOpen then
        return
    end

    uiOpen = true
    SetNuiFocus(true, true)

    SendNUIMessage({
        action = 'openUI',
        mode = mode,
        isAdmin = isAdmin,
        reports = allReports,
        reportId = reportId,
        config = Config.Locale
    })

    if Config.Debug then
        print('[ZReport] UI ouverte - Mode: ' .. mode)
    end
end

function CloseReportUI()
    if not uiOpen then
        return
    end

    uiOpen = false
    SetNuiFocus(false, false)

    SendNUIMessage({
        action = 'closeUI'
    })

    if Config.Debug then
        print('[ZReport] UI fermée')
    end
end

-- ============================================
-- EVENTS CLIENT
-- ============================================

-- Recevoir le statut admin
RegisterNetEvent('zreport:client:setAdminStatus', function(status)
    isAdmin = status

    if Config.Debug then
        print('[ZReport Client] ========================================')
        print('[ZReport Client] STATUT ADMIN: ' .. tostring(isAdmin))
        print('[ZReport Client] ========================================')
    end

    -- Afficher aussi dans le chat
    if status then
        TriggerEvent('chat:addMessage', {
            color = {52, 199, 89},
            multiline = true,
            args = {"ZReport", "Vous êtes administrateur - Utilisez /reports"}
        })
    end
end)

-- Notification
RegisterNetEvent('zreport:client:notify', function(data)
    ShowNotification(data)
end)

-- Mise à jour des reports
RegisterNetEvent('zreport:client:updateReports', function(reports)
    allReports = reports

    if uiOpen then
        SendNUIMessage({
            action = 'updateReports',
            reports = allReports
        })
    end
end)

-- Fermer l'UI
RegisterNetEvent('zreport:client:closeUI', function()
    CloseReportUI()
end)

-- Téléporter au joueur
RegisterNetEvent('zreport:client:teleportToPlayer', function(targetPlayerId)
    local targetPed = GetPlayerPed(GetPlayerFromServerId(targetPlayerId))
    local targetCoords = GetEntityCoords(targetPed)

    SetEntityCoords(PlayerPedId(), targetCoords.x, targetCoords.y, targetCoords.z, false, false, false, true)

    if Config.Debug then
        print('[ZReport] Téléporté au joueur: ' .. targetPlayerId)
    end
end)

-- Téléporter à l'admin
RegisterNetEvent('zreport:client:teleportToAdmin', function(adminId)
    local adminPed = GetPlayerPed(GetPlayerFromServerId(adminId))
    local adminCoords = GetEntityCoords(adminPed)

    SetEntityCoords(PlayerPedId(), adminCoords.x, adminCoords.y, adminCoords.z, false, false, false, true)

    if Config.Debug then
        print('[ZReport] Téléporté à l\'admin: ' .. adminId)
    end
end)

-- Sauvegarder la position
RegisterNetEvent('zreport:client:savePosition', function()
    local ped = PlayerPedId()
    playerPosition = GetEntityCoords(ped)

    if Config.Debug then
        print('[ZReport] Position sauvegardée')
    end
end)

-- Téléporter à la position sauvegardée
RegisterNetEvent('zreport:client:teleportBack', function()
    if playerPosition then
        SetEntityCoords(PlayerPedId(), playerPosition.x, playerPosition.y, playerPosition.z, false, false, false, true)
        playerPosition = nil

        if Config.Debug then
            print('[ZReport] Téléporté à la position d\'origine')
        end
    end
end)

-- ============================================
-- NUI CALLBACKS
-- ============================================

-- Fermer l'UI
RegisterNUICallback('closeUI', function(data, cb)
    CloseReportUI()
    cb('ok')
end)

-- Créer un report
RegisterNUICallback('createReport', function(data, cb)
    TriggerServerEvent('zreport:server:createReport', data.category, data.description)
    CloseReportUI()
    cb('ok')
end)

-- Annuler un report
RegisterNUICallback('cancelReport', function(data, cb)
    TriggerServerEvent('zreport:server:cancelReport', data.reportId)
    cb('ok')
end)

-- Envoyer un message
RegisterNUICallback('sendMessage', function(data, cb)
    TriggerServerEvent('zreport:server:sendMessage', data.reportId, data.message)
    cb('ok')
end)

-- Admin: Téléporter le joueur
RegisterNUICallback('bringPlayer', function(data, cb)
    TriggerServerEvent('zreport:server:bringPlayer', data.reportId)
    cb('ok')
end)

-- Admin: Se téléporter au joueur
RegisterNUICallback('gotoPlayer', function(data, cb)
    TriggerServerEvent('zreport:server:gotoPlayer', data.reportId)
    cb('ok')
end)

-- Admin: Conclure le report
RegisterNUICallback('concludeReport', function(data, cb)
    TriggerServerEvent('zreport:server:concludeReport', data.reportId)
    cb('ok')
end)

-- Obtenir les reports
RegisterNUICallback('getReports', function(data, cb)
    TriggerServerEvent('zreport:server:getReports')
    cb('ok')
end)

-- ============================================
-- COMMANDES
-- ============================================

-- Commande pour créer/voir son report
RegisterCommand(Config.ReportCommand, function()
    TriggerServerEvent('zreport:server:getReports')
    Citizen.Wait(100)
    OpenReportUI('player', nil)
end, false)

-- Commande pour les admins
RegisterCommand(Config.AdminReportCommand, function()
    if isAdmin then
        TriggerServerEvent('zreport:server:getReports')
        Citizen.Wait(100)
        OpenReportUI('admin', nil)
    else
        ShowNotification({
            title = 'ERREUR',
            text = 'Vous n\'avez pas la permission d\'utiliser cette commande',
            time = 5000,
            type = 'error'
        })
    end
end, false)

-- Commande pour toggle les notifications
RegisterCommand(Config.NotificationToggleCommand, function()
    if isAdmin then
        TriggerServerEvent('zreport:server:toggleNotifications')
    else
        ShowNotification({
            title = 'ERREUR',
            text = 'Vous n\'avez pas la permission d\'utiliser cette commande',
            time = 5000,
            type = 'error'
        })
    end
end, false)

-- Commande de debug pour tester le statut admin
RegisterCommand('zreportadmin', function()
    print('[ZReport Debug] ========================================')
    print('[ZReport Debug] Statut Admin: ' .. tostring(isAdmin))
    print('[ZReport Debug] Framework: ' .. Config.Framework)
    print('[ZReport Debug] ========================================')

    TriggerEvent('chat:addMessage', {
        color = {0, 122, 255},
        multiline = true,
        args = {"ZReport Debug", "Statut Admin: " .. tostring(isAdmin) .. " - Voir F8 pour plus de détails"}
    })

    -- Revérifier auprès du serveur
    TriggerServerEvent('zreport:server:checkAdmin')
end, false)

-- ============================================
-- SUGGESTIONS DE COMMANDES
-- ============================================

TriggerEvent('chat:addSuggestion', '/' .. Config.ReportCommand, Config.CommandSuggestions['report'].text)
TriggerEvent('chat:addSuggestion', '/' .. Config.AdminReportCommand, Config.CommandSuggestions['adm_report'].text)
TriggerEvent('chat:addSuggestion', '/' .. Config.NotificationToggleCommand, Config.CommandSuggestions['adm_notifications'].text)

-- ============================================
-- CONTRÔLES CLAVIER (FERMER L'UI AVEC ESC)
-- ============================================

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if uiOpen then
            DisableControlAction(0, 1, true) -- LookLeftRight
            DisableControlAction(0, 2, true) -- LookUpDown
            DisableControlAction(0, 24, true) -- Attack
            DisableControlAction(0, 25, true) -- Aim
            DisableControlAction(0, 142, true) -- MeleeAttackAlternate
            DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
        else
            Citizen.Wait(500)
        end
    end
end)

if Config.Debug then
    print('[ZReport] Client chargé avec succès !')
end
