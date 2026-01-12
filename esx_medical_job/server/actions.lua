-- ===========================================
-- ACTIONS MÉDICALES SERVEUR - OX_INVENTORY
-- ===========================================

-- ===========================================
-- SOIGNER
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

    -- Retirer l'item avec ox_inventory
    local removed = exports.ox_inventory:RemoveItem(source, Config.RequiredItems.heal, 1)

    if removed then
        -- Appliquer le soin
        TriggerClientEvent('esx_medical:applyHeal', targetId)

        -- Payer le médecin
        xPlayer.addAccountMoney('bank', Config.Prices.heal)

        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Paiement',
            description = 'Vous avez reçu $' .. Config.Prices.heal,
            type = 'success'
        })

        -- Log
        print(('[^2Medical^7] %s healed %s'):format(xPlayer.identifier, xTarget.identifier))
    end
end)

-- ===========================================
-- RÉANIMER
-- ===========================================

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

    -- Retirer l'item
    local removed = exports.ox_inventory:RemoveItem(source, Config.RequiredItems.revive, 1)

    if removed then
        -- Réanimer
        TriggerClientEvent('esx_ambulancejob:revive', targetId)

        -- Payer
        xPlayer.addAccountMoney('bank', Config.Prices.revive)

        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Paiement',
            description = 'Vous avez reçu $' .. Config.Prices.revive,
            type = 'success'
        })

        -- Log
        print(('[^2Medical^7] %s revived %s'):format(xPlayer.identifier, xTarget.identifier))
    end
end)

-- ===========================================
-- EXAMINER
-- ===========================================

RegisterNetEvent('esx_medical:examinePlayer')
AddEventHandler('esx_medical:examinePlayer', function(targetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(targetId)

    if not xPlayer or not xTarget then return end

    -- Vérifier le job
    if xPlayer.job.name ~= Config.JobName then return end

    -- Pas de retrait d'item pour l'examen (stethoscope réutilisable)
    -- Récupérer la santé du joueur cible
    local targetPed = GetPlayerPed(targetId)
    local health = GetEntityHealth(targetPed)
    local armor = GetPedArmour(targetPed)

    -- Calculer en %
    local healthPercent = math.floor(((health - 100) / (GetEntityMaxHealth(targetPed) - 100)) * 100)
    local armorPercent = armor

    -- Envoyer au médecin
    TriggerClientEvent('esx_medical:showExamReport', source, healthPercent, armorPercent)

    -- Payer
    xPlayer.addAccountMoney('bank', Config.Prices.examine or 300)

    -- Log
    print(('[^2Medical^7] %s examined %s (HP: %d%%, Armor: %d%%)'):format(
        xPlayer.identifier,
        xTarget.identifier,
        healthPercent,
        armorPercent
    ))
end)

-- ===========================================
-- ENDORMIR (SÉDATION)
-- ===========================================

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

    -- Retirer l'item
    local removed = exports.ox_inventory:RemoveItem(source, Config.RequiredItems.sedate, 1)

    if removed then
        -- Appliquer la sédation
        TriggerClientEvent('esx_medical:applySedate', targetId)

        -- Payer
        xPlayer.addAccountMoney('bank', Config.Prices.sedate or 400)

        -- Log
        print(('[^3Medical^7] %s sedated %s'):format(xPlayer.identifier, xTarget.identifier))
    end
end)

-- ===========================================
-- BLESSER
-- ===========================================

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
    print(('[^1WARNING^7] %s injured %s (ILLEGAL ACTION)'):format(xPlayer.identifier, xTarget.identifier))

    -- Notifier la police si le script existe
    TriggerEvent('esx_service:notifyAllInService', {
        job = 'police',
        notification = 'Agression signalée',
    })
end)

-- ===========================================
-- PRÉLÈVEMENTS
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

    -- Retirer l'item nécessaire
    local removed = exports.ox_inventory:RemoveItem(source, itemNeeded, 1)

    if removed then
        -- Donner l'échantillon
        local added = exports.ox_inventory:AddItem(source, itemToGive, 1)

        if added then
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'Prélèvement',
                description = 'Échantillon obtenu : ' .. itemToGive,
                type = 'success'
            })

            -- Log
            local isLegal = (sampleType == 'blood')
            local logColor = isLegal and '^2' or '^1'

            print(('%s[Medical]^7 %s took %s sample from %s %s'):format(
                logColor,
                xPlayer.identifier,
                sampleType,
                xTarget.identifier,
                isLegal and '(LEGAL)' or '(ILLEGAL)'
            ))

            -- Enregistrer dans la DB si illégal
            if not isLegal then
                MySQL.insert('INSERT INTO medecin_samples (medic_identifier, medic_name, patient_identifier, patient_name, sample_type, is_legal, location, timestamp) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
                    xPlayer.identifier,
                    xPlayer.getName(),
                    xTarget.identifier,
                    xTarget.getName(),
                    sampleType,
                    0,
                    json.encode(GetEntityCoords(GetPlayerPed(source))),
                    os.time()
                })
            end
        else
            -- Inventaire plein, rendre l'item consommé
            exports.ox_inventory:AddItem(source, itemNeeded, 1)

            TriggerClientEvent('ox_lib:notify', source, {
                title = 'Erreur',
                description = 'Inventaire plein !',
                type = 'error'
            })
        end
    end
end)
