-- ===========================================
-- ESX MEDICAL JOB - SERVEUR
-- ===========================================

ESX = exports['es_extended']:getSharedObject()

-- ===========================================
-- CALLBACKS
-- ===========================================

ESX.RegisterServerCallback('esx_medical:hasItem', function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        cb(false)
        return
    end

    local itemCount = xPlayer.getInventoryItem(item).count
    cb(itemCount > 0)
end)

ESX.RegisterServerCallback('esx_medical:getPlayerHealth', function(source, cb, targetId)
    local xTarget = ESX.GetPlayerFromId(targetId)

    if not xTarget then
        cb(0, 0)
        return
    end

    -- Récupérer la santé du joueur cible
    TriggerClientEvent('esx_medical:requestHealth', targetId)

    -- Attendre la réponse
    RegisterNetEvent('esx_medical:returnHealth')
    AddEventHandler('esx_medical:returnHealth', function(health, armor)
        cb(health, armor)
    end)
end)

-- Event client pour récupérer la santé
RegisterNetEvent('esx_medical:requestHealth')
AddEventHandler('esx_medical:requestHealth', function()
    local playerPed = PlayerPedId()
    local health = math.floor((GetEntityHealth(playerPed) - 100) / (GetEntityMaxHealth(playerPed) - 100) * 100)
    local armor = GetPedArmour(playerPed)

    TriggerServerEvent('esx_medical:returnHealth', health, armor)
end)

-- ===========================================
-- ACTIONS MÉDICALES
-- ===========================================

RegisterNetEvent('esx_medical:healPlayer')
AddEventHandler('esx_medical:healPlayer', function(targetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(targetId)

    if not xPlayer or not xTarget then return end

    -- Vérifier le job
    if xPlayer.job.name ~= Config.JobName then
        print(('[^3WARNING^7] Player ^5%s^7 attempted to heal without permission'):format(xPlayer.identifier))
        return
    end

    -- Vérifier et retirer l'item
    local item = xPlayer.getInventoryItem(Config.RequiredItems.heal)
    if item.count > 0 then
        xPlayer.removeInventoryItem(Config.RequiredItems.heal, 1)

        -- Appliquer le soin
        TriggerClientEvent('esx_medical:applyHeal', targetId)

        -- Payer le médecin
        if Config.EnableLegalActions then
            xPlayer.addAccountMoney('bank', Config.Prices.heal)
            xPlayer.showNotification('Vous avez reçu ~g~$' .. Config.Prices.heal .. '~s~ pour les soins')
        end

        -- Facturer le patient
        TriggerEvent('esx_billing:sendBill', targetId, 'society_ambulance', 'Soins médicaux', Config.Prices.heal)

        -- Log
        print(('[^2INFO^7] Player ^5%s^7 healed player ^5%s^7'):format(xPlayer.identifier, xTarget.identifier))
    else
        xPlayer.showNotification('~r~Vous n\'avez pas de ' .. Config.RequiredItems.heal)
    end
end)

RegisterNetEvent('esx_medical:revivePlayer')
AddEventHandler('esx_medical:revivePlayer', function(targetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(targetId)

    if not xPlayer or not xTarget then return end

    -- Vérifier le job
    if xPlayer.job.name ~= Config.JobName then
        print(('[^3WARNING^7] Player ^5%s^7 attempted to revive without permission'):format(xPlayer.identifier))
        return
    end

    -- Vérifier et retirer l'item
    local item = xPlayer.getInventoryItem(Config.RequiredItems.revive)
    if item.count > 0 then
        xPlayer.removeInventoryItem(Config.RequiredItems.revive, 1)

        -- Réanimer le joueur
        TriggerClientEvent('esx_ambulancejob:revive', targetId)

        -- Payer le médecin
        if Config.EnableLegalActions then
            xPlayer.addAccountMoney('bank', Config.Prices.revive)
            xPlayer.showNotification('Vous avez reçu ~g~$' .. Config.Prices.revive .. '~s~ pour la réanimation')
        end

        -- Facturer le patient
        TriggerEvent('esx_billing:sendBill', targetId, 'society_ambulance', 'Réanimation', Config.Prices.revive)

        -- Log
        print(('[^2INFO^7] Player ^5%s^7 revived player ^5%s^7'):format(xPlayer.identifier, xTarget.identifier))
    else
        xPlayer.showNotification('~r~Vous n\'avez pas de ' .. Config.RequiredItems.revive)
    end
end)

RegisterNetEvent('esx_medical:sedatePlayer')
AddEventHandler('esx_medical:sedatePlayer', function(targetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(targetId)

    if not xPlayer or not xTarget then return end

    -- Vérifier le job
    if xPlayer.job.name ~= Config.JobName then
        print(('[^3WARNING^7] Player ^5%s^7 attempted to sedate without permission'):format(xPlayer.identifier))
        return
    end

    -- Vérifier et retirer l'item
    local item = xPlayer.getInventoryItem(Config.RequiredItems.sedate)
    if item.count > 0 then
        xPlayer.removeInventoryItem(Config.RequiredItems.sedate, 1)

        -- Appliquer la sédation
        TriggerClientEvent('esx_medical:applySedate', targetId)

        -- Log
        print(('[^2INFO^7] Player ^5%s^7 sedated player ^5%s^7'):format(xPlayer.identifier, xTarget.identifier))
    else
        xPlayer.showNotification('~r~Vous n\'avez pas de ' .. Config.RequiredItems.sedate)
    end
end)

RegisterNetEvent('esx_medical:injurePlayer')
AddEventHandler('esx_medical:injurePlayer', function(targetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(targetId)

    if not xPlayer or not xTarget then return end

    -- Vérifier le job
    if xPlayer.job.name ~= Config.JobName then
        print(('[^3WARNING^7] Player ^5%s^7 attempted to injure without permission'):format(xPlayer.identifier))
        return
    end

    -- Appliquer les dégâts
    TriggerClientEvent('esx_medical:applyInjure', targetId)

    -- Log action illégale
    print(('[^1WARNING^7] Player ^5%s^7 injured player ^5%s^7 (ILLEGAL ACTION)'):format(xPlayer.identifier, xTarget.identifier))

    -- Notification police
    local coords = GetEntityCoords(GetPlayerPed(source))
    TriggerEvent('esx_service:notifyAllInService', {
        job = 'police',
        notification = 'Agression signalée - Position GPS envoyée',
        coords = coords
    })
end)

-- ===========================================
-- PRÉLÈVEMENTS SCIENTIFIQUES
-- ===========================================

RegisterNetEvent('esx_medical:takeSample')
AddEventHandler('esx_medical:takeSample', function(targetId, sampleType)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(targetId)

    if not xPlayer or not xTarget then return end

    -- Vérifier le job
    if xPlayer.job.name ~= Config.JobName then
        print(('[^3WARNING^7] Player ^5%s^7 attempted to take sample without permission'):format(xPlayer.identifier))
        return
    end

    local itemNeeded = Config.RequiredItems[sampleType .. 'Sample']
    local itemToGive = Config.SampleItems[sampleType]

    -- Vérifier et retirer l'item nécessaire
    local item = xPlayer.getInventoryItem(itemNeeded)
    if item and item.count > 0 then
        xPlayer.removeInventoryItem(itemNeeded, 1)

        -- Donner l'échantillon
        xPlayer.addInventoryItem(itemToGive, 1)
        xPlayer.showNotification('~g~Prélèvement effectué : ' .. itemToGive)

        -- Log action illégale pour os et peau
        if sampleType == 'bone' or sampleType == 'skin' then
            print(('[^1WARNING^7] Player ^5%s^7 took %s sample from ^5%s^7 (ILLEGAL)'):format(
                xPlayer.identifier,
                sampleType,
                xTarget.identifier
            ))

            -- Ajouter à la base de données pour tracking
            MySQL.insert('INSERT INTO medical_samples (medic_identifier, patient_identifier, sample_type, timestamp) VALUES (?, ?, ?, ?)', {
                xPlayer.identifier,
                xTarget.identifier,
                sampleType,
                os.time()
            })
        else
            print(('[^2INFO^7] Player ^5%s^7 took %s sample from ^5%s^7'):format(
                xPlayer.identifier,
                sampleType,
                xTarget.identifier
            ))
        end
    else
        xPlayer.showNotification('~r~Vous n\'avez pas l\'équipement nécessaire')
    end
end)

-- ===========================================
-- MARCHÉ NOIR
-- ===========================================

RegisterNetEvent('esx_medical:sellSample')
AddEventHandler('esx_medical:sellSample', function(sampleType)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then return end

    local itemName = Config.SampleItems[sampleType]
    local item = xPlayer.getInventoryItem(itemName)

    if item and item.count > 0 then
        local price = Config.Prices[sampleType .. 'Sample']

        -- Retirer l'item et donner l'argent
        xPlayer.removeInventoryItem(itemName, 1)
        xPlayer.addAccountMoney('black_money', price)

        xPlayer.showNotification('~g~Échantillon vendu pour $' .. price .. ' (argent sale)')

        -- Log
        print(('[^1WARNING^7] Player ^5%s^7 sold %s sample on black market for ^2$%d^7'):format(
            xPlayer.identifier,
            sampleType,
            price
        ))

        -- Ajouter à la base de données
        MySQL.insert('INSERT INTO medical_black_market (seller_identifier, sample_type, price, timestamp) VALUES (?, ?, ?, ?)', {
            xPlayer.identifier,
            sampleType,
            price,
            os.time()
        })
    else
        xPlayer.showNotification('~r~Vous n\'avez pas d\'échantillon de ce type')
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

    -- Vérifier l'argent
    if xPlayer.getMoney() >= totalPrice then
        xPlayer.removeMoney(totalPrice)
        xPlayer.addInventoryItem(itemName, quantity)
        xPlayer.showNotification('~g~Achat effectué : ' .. quantity .. 'x ' .. itemName)

        -- Log
        print(('[^2INFO^7] Player ^5%s^7 bought %dx %s for ^2$%d^7'):format(
            xPlayer.identifier,
            quantity,
            itemName,
            totalPrice
        ))
    else
        xPlayer.showNotification('~r~Vous n\'avez pas assez d\'argent')
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

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    print('^3[ESX Medical Job]^7 Arrêt du script...')
end)

print('^2═══════════════════════════════════════════════════════^7')
print('^2║     ESX Medical Job - Version 1.0.0                ║^7')
print('^2║     Script chargé avec succès !                    ║^7')
print('^2═══════════════════════════════════════════════════════^7')
