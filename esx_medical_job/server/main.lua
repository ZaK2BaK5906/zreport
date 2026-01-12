-- ===========================================
-- ESX MEDICAL JOB - SERVEUR
-- ===========================================

ESX = exports['es_extended']:getSharedObject()

-- ===========================================
-- ACTIONS MÉDICALES
-- ===========================================
-- Les événements et callbacks sont définis dans server/actions.lua

-- ===========================================
-- MARCHÉ NOIR
-- ===========================================

RegisterNetEvent('esx_medical:sellSample')
AddEventHandler('esx_medical:sellSample', function(sampleType)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then return end

    local itemName = Config.SampleItems[sampleType]
    local price = Config.Prices[sampleType .. 'Sample']

    -- Retirer l'item avec ox_inventory
    local removed = exports.ox_inventory:RemoveItem(source, itemName, 1)

    if removed then
        -- Donner l'argent sale
        xPlayer.addAccountMoney('black_money', price)

        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Marché Noir',
            description = 'Échantillon vendu pour $' .. price .. ' (argent sale)',
            type = 'success'
        })

        -- Log
        print(('[^1BLACK MARKET^7] %s sold %s sample for $%d'):format(
            xPlayer.identifier,
            sampleType,
            price
        ))

        -- Ajouter à la base de données
        MySQL.insert('INSERT INTO medecin_black_market (seller_identifier, seller_name, sample_type, price, location, timestamp) VALUES (?, ?, ?, ?, ?, ?)', {
            xPlayer.identifier,
            xPlayer.getName(),
            sampleType,
            price,
            json.encode(GetEntityCoords(GetPlayerPed(source))),
            os.time()
        })
    else
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Erreur',
            description = 'Vous n\'avez pas d\'échantillon de ce type',
            type = 'error'
        })
    end
end)

-- ===========================================
-- PHARMACIE
-- ===========================================

RegisterNetEvent('esx_medical:buyItem')
AddEventHandler('esx_medical:buyItem', function(itemName, quantity, price)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then return end

    -- Vérifier le job
    if xPlayer.job.name ~= Config.JobName then
        print(('[^3WARNING^7] Player ^5%s^7 attempted to buy pharmacy item without permission'):format(xPlayer.identifier))
        return
    end

    local totalPrice = price * quantity

    -- Vérifier si le joueur peut porter les items
    local canCarry = exports.ox_inventory:CanCarryItem(source, itemName, quantity)

    if not canCarry then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Pharmacie',
            description = 'Inventaire plein !',
            type = 'error'
        })
        return
    end

    -- Vérifier l'argent
    if xPlayer.getMoney() >= totalPrice then
        xPlayer.removeMoney(totalPrice)

        -- Ajouter avec ox_inventory
        local added = exports.ox_inventory:AddItem(source, itemName, quantity)

        if added then
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'Pharmacie',
                description = 'Achat : ' .. quantity .. 'x ' .. itemName,
                type = 'success'
            })

            -- Log
            print(('[^2Pharmacy^7] %s bought %dx %s for $%d'):format(
                xPlayer.identifier,
                quantity,
                itemName,
                totalPrice
            ))
        end
    else
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Pharmacie',
            description = 'Argent insuffisant !',
            type = 'error'
        })
    end
end)

-- ===========================================
-- COMMANDES ADMIN
-- ===========================================

ESX.RegisterCommand('medicheal', 'admin', function(xPlayer, args, showError)
    local targetId = args.playerId

    if targetId then
        local xTarget = ESX.GetPlayerFromId(targetId)

        if xTarget then
            TriggerClientEvent('esx_medical:applyHeal', targetId)
            xPlayer.showNotification('Joueur ' .. xTarget.getName() .. ' soigné')
        else
            showError('Joueur introuvable')
        end
    else
        showError('Utilisation: /medicheal [id]')
    end
end, true, {help = 'Soigner un joueur (Admin)', validate = true, arguments = {
    {name = 'playerId', help = 'ID du joueur', type = 'player'}
}})

ESX.RegisterCommand('medicrevive', 'admin', function(xPlayer, args, showError)
    local targetId = args.playerId

    if targetId then
        local xTarget = ESX.GetPlayerFromId(targetId)

        if xTarget then
            TriggerClientEvent('esx_ambulancejob:revive', targetId)
            xPlayer.showNotification('Joueur ' .. xTarget.getName() .. ' réanimé')
        else
            showError('Joueur introuvable')
        end
    else
        showError('Utilisation: /medicrevive [id]')
    end
end, true, {help = 'Réanimer un joueur (Admin)', validate = true, arguments = {
    {name = 'playerId', help = 'ID du joueur', type = 'player'}
}})

-- ===========================================
-- LOGS & STATISTIQUES
-- ===========================================

-- Sauvegarder les stats du médecin
RegisterNetEvent('esx_medical:saveMedicStats')
AddEventHandler('esx_medical:saveMedicStats', function(action)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then return end

    MySQL.insert('INSERT INTO medical_stats (medic_identifier, action_type, timestamp) VALUES (?, ?, ?)', {
        xPlayer.identifier,
        action,
        os.time()
    }, function(id)
        if id then
            print(('[^2INFO^7] Saved medical stat for ^5%s^7: %s'):format(xPlayer.identifier, action))
        end
    end)
end)

-- Récupérer les stats
ESX.RegisterServerCallback('esx_medical:getStats', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        cb({})
        return
    end

    MySQL.query('SELECT action_type, COUNT(*) as count FROM medical_stats WHERE medic_identifier = ? GROUP BY action_type', {
        xPlayer.identifier
    }, function(result)
        cb(result or {})
    end)
end)

-- ===========================================
-- ÉVÉNEMENTS DE DÉMARRAGE
-- ===========================================

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    print('^2[ESX Medical Job]^7 Démarrage du script...')

    -- Vérifier les tables de la base de données
    MySQL.ready(function()
        print('^2[ESX Medical Job]^7 Base de données connectée')
    end)
end)

-- ===========================================
-- SYSTÈME BOÎTE MÉDICALE
-- ===========================================

RegisterNetEvent('esx_medical:removeMedicalBox')
AddEventHandler('esx_medical:removeMedicalBox', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    -- Retirer le medikit_advanced de l'inventaire
    exports.ox_inventory:RemoveItem(source, 'medikit_advanced', 1)

    print(('[^2Medical Box^7] Player ^5%s^7 placed a medical box'):format(xPlayer.identifier))
end)

RegisterNetEvent('esx_medical:returnMedicalBox')
AddEventHandler('esx_medical:returnMedicalBox', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    -- Rendre le medikit_advanced
    exports.ox_inventory:AddItem(source, 'medikit_advanced', 1)

    print(('[^3Medical Box^7] Player ^5%s^7 picked up a medical box'):format(xPlayer.identifier))
end)

RegisterNetEvent('esx_medical:takeFromBox')
AddEventHandler('esx_medical:takeFromBox', function(itemName, quantity)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    -- Vérifier le job
    if xPlayer.job.name ~= Config.JobName then
        print(('[^3WARNING^7] Player ^5%s^7 attempted to take from medical box without permission'):format(xPlayer.identifier))
        return
    end

    -- Vérifier si le joueur peut porter l'item
    local canCarry = exports.ox_inventory:CanCarryItem(source, itemName, quantity)

    if canCarry then
        -- Donner l'item
        exports.ox_inventory:AddItem(source, itemName, quantity)

        -- Notification
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Boîte Médicale',
            description = 'Item pris : ' .. itemName,
            type = 'success',
            icon = 'briefcase-medical'
        })

        print(('[^2Medical Box^7] Player ^5%s^7 took %dx %s from medical box'):format(
            xPlayer.identifier,
            quantity,
            itemName
        ))
    else
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Boîte Médicale',
            description = 'Inventaire plein !',
            type = 'error',
            icon = 'briefcase-medical'
        })
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    print('^3[ESX Medical Job]^7 Arrêt du script...')
end)

print('^2═══════════════════════════════════════════════════════^7')
print('^2║     ESX Medical Job - Version 1.0.0                ║^7')
print('^2║     Script chargé avec succès !                    ║^7')
print('^2═══════════════════════════════════════════════════════^7')
