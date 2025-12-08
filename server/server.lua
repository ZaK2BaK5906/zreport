-- ============================================
-- VARIABLES GLOBALES
-- ============================================

ESX = nil
local Reports = {}
local ReportIdCounter = 1
local AdminNotifications = {}

-- ============================================
-- INITIALISATION DU FRAMEWORK
-- ============================================

if Config.Framework == 'ESX' then
    ESX = exports['es_extended']:getSharedObject()
elseif Config.Framework == 'QB' then
    ESX = exports['qb-core']:GetCoreObject()
end

-- ============================================
-- FONCTIONS UTILITAIRES
-- ============================================

function IsPlayerAdmin(source)
    if Config.Framework == 'STANDALONE' then
        local identifiers = GetPlayerIdentifiers(source)
        for _, identifier in pairs(identifiers) do
            for _, staffId in pairs(Config.StandaloneStaffIdentifiers) do
                if identifier == staffId then
                    return true
                end
            end
        end
        return false
    elseif Config.Framework == 'ESX' then
        local xPlayer = ESX.GetPlayerFromId(source)

        -- Méthode 1: Vérifier avec xPlayer.getGroup() (RECOMMANDÉ pour ESX)
        if xPlayer then
            local playerGroup = xPlayer.getGroup()
            if Config.Debug then
                print('[ZReport] Groupe du joueur ' .. source .. ': ' .. tostring(playerGroup))
            end

            for _, group in pairs(Config.AdminGroups) do
                if playerGroup == group then
                    if Config.Debug then
                        print('[ZReport] Joueur ' .. source .. ' est admin (groupe: ' .. playerGroup .. ')')
                    end
                    return true
                end
            end
        end

        -- Méthode 2: Vérifier avec ACE permissions (optionnel)
        if Config.UseAcePermissions then
            for _, group in pairs(Config.AdminGroups) do
                if IsPlayerAceAllowed(source, 'group.' .. group) then
                    if Config.Debug then
                        print('[ZReport] Joueur ' .. source .. ' est admin (ACE: group.' .. group .. ')')
                    end
                    return true
                end
            end
        end

        if Config.Debug then
            print('[ZReport] Joueur ' .. source .. ' N\'EST PAS admin')
        end
        return false
    elseif Config.Framework == 'QB' then
        local Player = ESX.Functions.GetPlayer(source)
        if Player then
            for _, group in pairs(Config.AdminGroups) do
                if Player.PlayerData.job.name == group or (Config.QBPermissionsUpdate and Player.PlayerData.permission and Player.PlayerData.permission == group) then
                    return true
                end
            end
        end
        return false
    end
end

function GetPlayerName(source)
    if Config.UseSteamNames then
        return GetPlayerName(source)
    else
        if Config.Framework == 'ESX' then
            local xPlayer = ESX.GetPlayerFromId(source)
            return xPlayer and xPlayer.getName() or GetPlayerName(source)
        elseif Config.Framework == 'QB' then
            local Player = ESX.Functions.GetPlayer(source)
            return Player and Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname or GetPlayerName(source)
        else
            return GetPlayerName(source)
        end
    end
end

function GetPlayerIdentifier(source)
    local identifiers = GetPlayerIdentifiers(source)
    for _, identifier in pairs(identifiers) do
        if string.match(identifier, 'license:') then
            return identifier
        end
    end
    return nil
end

function GetOnlineAdmins()
    local admins = {}
    local players = GetPlayers()

    for _, playerId in ipairs(players) do
        if IsPlayerAdmin(tonumber(playerId)) then
            table.insert(admins, tonumber(playerId))
        end
    end

    return admins
end

function PlayerHasReport(source)
    for id, report in pairs(Reports) do
        if report.playerId == source and report.status ~= 'concluded' then
            return true, id
        end
    end
    return false, nil
end

function NotifyAdmins(message, reportId)
    local admins = GetOnlineAdmins()

    for _, adminId in ipairs(admins) do
        if AdminNotifications[adminId] == nil or AdminNotifications[adminId] == true then
            TriggerClientEvent('zreport:client:notify', adminId, {
                title = 'REPORT',
                text = message,
                time = 5000,
                type = 'info'
            })
        end
    end
end

-- ============================================
-- EVENTS SERVEUR
-- ============================================

-- Créer un nouveau report
RegisterNetEvent('zreport:server:createReport', function(category, description)
    local source = source
    local hasReport, reportId = PlayerHasReport(source)

    if hasReport then
        TriggerClientEvent('zreport:client:notify', source, Config.Notifications['already_have_report'])
        return
    end

    local playerName = GetPlayerName(source)
    local identifier = GetPlayerIdentifier(source)

    ReportIdCounter = ReportIdCounter + 1
    local newReportId = ReportIdCounter

    Reports[newReportId] = {
        id = newReportId,
        playerId = source,
        playerName = playerName,
        identifier = identifier,
        category = category,
        description = description,
        status = 'waiting',
        adminAssisting = nil,
        adminInteracted = false,
        messages = {},
        createdAt = os.time()
    }

    -- Notification au joueur
    TriggerClientEvent('zreport:client:notify', source, Config.Notifications['success_rep'])

    -- Notification aux admins
    NotifyAdmins('Nouveau report #' .. newReportId .. ' de ' .. playerName, newReportId)

    -- Log Discord
    local webhookType = category .. '_report'
    local color = Config.playerReportWebhookColor

    if category == 'bug' then
        color = Config.bugReportWebhookColor
    elseif category == 'question' then
        color = Config.questionReportWebhookColor
    end

    local message = FormatDiscordMessage(
        Config.WebhookMessages[webhookType].action,
        playerName,
        source,
        newReportId,
        Config.ReportCategoriesTranslation[category],
        description
    )

    SendToDiscord(Config.BotName, message, tonumber(color))

    -- Envoyer les reports mis à jour aux admins
    TriggerClientEvent('zreport:client:updateReports', -1, Reports)

    if Config.Debug then
        print('[ZReport] Nouveau report créé: #' .. newReportId .. ' par ' .. playerName)
    end
end)

-- Annuler un report
RegisterNetEvent('zreport:server:cancelReport', function(reportId)
    local source = source
    local report = Reports[reportId]

    if not report then
        TriggerClientEvent('zreport:client:notify', source, Config.Notifications['rep_not_exist'])
        return
    end

    if report.playerId ~= source then
        return
    end

    if report.adminInteracted then
        TriggerClientEvent('zreport:client:notify', source, Config.Notifications['cannot_cancel'])
        return
    end

    -- Log Discord
    local message = FormatDiscordMessage(
        Config.WebhookMessages['p_cancel_report'].action,
        report.playerName,
        source,
        reportId,
        Config.ReportCategoriesTranslation[report.category],
        report.description
    )

    SendToDiscord(Config.BotName, message, tonumber(Config.playerWebhookColor))

    Reports[reportId] = nil

    TriggerClientEvent('zreport:client:notify', source, Config.Notifications['rep_canceled'])
    TriggerClientEvent('zreport:client:updateReports', -1, Reports)
    TriggerClientEvent('zreport:client:closeUI', source)

    if Config.Debug then
        print('[ZReport] Report annulé: #' .. reportId)
    end
end)

-- Répondre à un report (joueur)
RegisterNetEvent('zreport:server:sendMessage', function(reportId, message)
    local source = source
    local report = Reports[reportId]

    if not report then
        return
    end

    if report.playerId ~= source and not IsPlayerAdmin(source) then
        return
    end

    local playerName = GetPlayerName(source)
    local isAdmin = IsPlayerAdmin(source)

    table.insert(report.messages, {
        sender = playerName,
        senderId = source,
        message = message,
        isAdmin = isAdmin,
        timestamp = os.time()
    })

    -- Notification
    if isAdmin then
        TriggerClientEvent('zreport:client:notify', report.playerId, Config.Notifications['adm_answered'])

        -- Log Discord
        local discordMessage = FormatDiscordMessage(
            Config.WebhookMessages['a_answer_report'].action,
            playerName,
            source,
            reportId,
            nil,
            message
        )

        SendToDiscord(Config.BotName, discordMessage, tonumber(Config.adminWebhookColor))
    else
        -- Notifier les admins
        if report.adminAssisting then
            local notif = Config.Notifications['player_answered']
            notif.text = string.gsub(notif.text, '${id}', reportId)
            notif.text = string.gsub(notif.text, '${name}', playerName)
            TriggerClientEvent('zreport:client:notify', report.adminAssisting, notif)
        end

        -- Log Discord
        local discordMessage = FormatDiscordMessage(
            Config.WebhookMessages['p_answer_report'].action,
            playerName,
            source,
            reportId,
            nil,
            message
        )

        SendToDiscord(Config.BotName, discordMessage, tonumber(Config.playerWebhookColor))
    end

    TriggerClientEvent('zreport:client:updateReports', -1, Reports)

    if Config.Debug then
        print('[ZReport] Message envoyé sur le report #' .. reportId .. ' par ' .. playerName)
    end
end)

-- Admin: Téléporter le joueur à l'admin
RegisterNetEvent('zreport:server:bringPlayer', function(reportId)
    local source = source
    local report = Reports[reportId]

    if not report or not IsPlayerAdmin(source) then
        return
    end

    report.adminInteracted = true
    report.adminAssisting = source
    report.status = 'in_progress'

    TriggerClientEvent('zreport:client:teleportToAdmin', report.playerId, source)
    TriggerClientEvent('zreport:client:notify', report.playerId, Config.Notifications['adm_assist'])

    -- Log Discord
    local adminName = GetPlayerName(source)
    local message = FormatDiscordMessage(
        Config.WebhookMessages['a_bring_report'].action,
        adminName,
        source,
        reportId,
        nil,
        'Joueur: ' .. report.playerName
    )

    SendToDiscord(Config.BotName, message, tonumber(Config.adminWebhookColor))

    TriggerClientEvent('zreport:client:updateReports', -1, Reports)

    if Config.Debug then
        print('[ZReport] Admin ' .. adminName .. ' a téléporté le joueur du report #' .. reportId)
    end
end)

-- Admin: Se téléporter au joueur
RegisterNetEvent('zreport:server:gotoPlayer', function(reportId)
    local source = source
    local report = Reports[reportId]

    if not report or not IsPlayerAdmin(source) then
        return
    end

    report.adminInteracted = true
    report.adminAssisting = source
    report.status = 'in_progress'

    TriggerClientEvent('zreport:client:savePosition', source)
    TriggerClientEvent('zreport:client:teleportToPlayer', source, report.playerId)
    TriggerClientEvent('zreport:client:notify', report.playerId, Config.Notifications['adm_assist'])

    -- Log Discord
    local adminName = GetPlayerName(source)
    local message = FormatDiscordMessage(
        Config.WebhookMessages['a_goto_report'].action,
        adminName,
        source,
        reportId,
        nil,
        'Joueur: ' .. report.playerName
    )

    SendToDiscord(Config.BotName, message, tonumber(Config.adminWebhookColor))

    TriggerClientEvent('zreport:client:updateReports', -1, Reports)

    if Config.Debug then
        print('[ZReport] Admin ' .. adminName .. ' s\'est téléporté au joueur du report #' .. reportId)
    end
end)

-- Admin: Conclure un report
RegisterNetEvent('zreport:server:concludeReport', function(reportId)
    local source = source
    local report = Reports[reportId]

    if not report or not IsPlayerAdmin(source) then
        return
    end

    TriggerClientEvent('zreport:client:notify', report.playerId, Config.Notifications['rep_concluded'])
    TriggerClientEvent('zreport:client:closeUI', report.playerId)

    local notif = Config.Notifications['adm_rep_concluded']
    notif.text = string.gsub(notif.text, '${id}', reportId)
    TriggerClientEvent('zreport:client:notify', source, notif)

    if Config.TeleportBackAfterConcluding then
        TriggerClientEvent('zreport:client:teleportBack', source)
    end

    -- Log Discord
    local adminName = GetPlayerName(source)
    local message = FormatDiscordMessage(
        Config.WebhookMessages['a_closed_report'].action,
        adminName,
        source,
        reportId,
        nil,
        'Joueur: ' .. report.playerName
    )

    SendToDiscord(Config.BotName, message, tonumber(Config.adminWebhookColor))

    Reports[reportId] = nil
    TriggerClientEvent('zreport:client:updateReports', -1, Reports)

    if Config.Debug then
        print('[ZReport] Report #' .. reportId .. ' conclu par ' .. adminName)
    end
end)

-- Toggle notifications
RegisterNetEvent('zreport:server:toggleNotifications', function()
    local source = source

    if not IsPlayerAdmin(source) then
        return
    end

    if AdminNotifications[source] == nil or AdminNotifications[source] == true then
        AdminNotifications[source] = false
        TriggerClientEvent('zreport:client:notify', source, Config.Notifications['rep_not_off'])
    else
        AdminNotifications[source] = true
        TriggerClientEvent('zreport:client:notify', source, Config.Notifications['rep_not_on'])
    end
end)

-- Obtenir les reports
RegisterNetEvent('zreport:server:getReports', function()
    local source = source
    TriggerClientEvent('zreport:client:updateReports', source, Reports)
end)

-- Vérifier si le joueur est admin
RegisterNetEvent('zreport:server:checkAdmin', function()
    local source = source
    local isAdmin = IsPlayerAdmin(source)

    if Config.Debug then
        print('[ZReport Server] Vérification admin pour joueur ' .. source .. ': ' .. tostring(isAdmin))
    end

    TriggerClientEvent('zreport:client:setAdminStatus', source, isAdmin)
end)

-- ============================================
-- EVENTS DE DÉCONNEXION
-- ============================================

AddEventHandler('playerDropped', function()
    local source = source
    local hasReport, reportId = PlayerHasReport(source)

    if hasReport then
        Reports[reportId] = nil
        TriggerClientEvent('zreport:client:updateReports', -1, Reports)

        if Config.Debug then
            print('[ZReport] Report #' .. reportId .. ' supprimé car le joueur s\'est déconnecté')
        end
    end
end)

-- ============================================
-- COMMANDES
-- ============================================

if Config.Debug then
    print('[ZReport] Script chargé avec succès !')
end
