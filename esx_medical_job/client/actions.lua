-- ===========================================
-- ACTIONS MÉDICALES - OX_INVENTORY
-- ===========================================

local isActionInProgress = false

-- ===========================================
-- SOIGNER
-- ===========================================

function HealPlayer(targetId, targetPed)
    if isActionInProgress then
        lib.notify({
            title = 'Action en cours',
            description = 'Une action est déjà en cours',
            type = 'error'
        })
        return
    end

    -- Vérifier l'item avec ox_inventory
    local hasItem = exports.ox_inventory:Search('count', Config.RequiredItems.heal)

    if not hasItem or hasItem < 1 then
        lib.notify({
            title = 'Item manquant',
            description = 'Vous n\'avez pas de ' .. Config.RequiredItems.heal,
            type = 'error'
        })
        return
    end

    isActionInProgress = true
    local playerPed = PlayerPedId()
    local targetCoords = GetEntityCoords(targetPed)

    -- Animation
    lib.requestAnimDict('amb@medic@standing@knees@base')
    TaskPlayAnim(playerPed, 'amb@medic@standing@knees@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)

    -- Progress bar
    if lib.progressBar({
        duration = Config.ActionDurations.heal,
        label = 'Soin en cours...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
        anim = {
            dict = 'amb@medic@standing@knees@idle_a',
            clip = 'idle_a'
        },
    }) then
        -- Succès
        TriggerServerEvent('esx_medical:healPlayer', targetId)

        lib.notify({
            title = 'Soin effectué',
            description = 'Patient soigné avec succès',
            type = 'success'
        })
    else
        -- Annulé
        lib.notify({
            title = 'Annulé',
            description = 'Action annulée',
            type = 'error'
        })
    end

    ClearPedTasks(playerPed)
    isActionInProgress = false
end

-- ===========================================
-- RÉANIMER
-- ===========================================

function RevivePlayer(targetId, targetPed)
    if isActionInProgress then
        lib.notify({
            title = 'Action en cours',
            description = 'Une action est déjà en cours',
            type = 'error'
        })
        return
    end

    local hasItem = exports.ox_inventory:Search('count', Config.RequiredItems.revive)

    if not hasItem or hasItem < 1 then
        lib.notify({
            title = 'Item manquant',
            description = 'Vous n\'avez pas de ' .. Config.RequiredItems.revive,
            type = 'error'
        })
        return
    end

    isActionInProgress = true
    local playerPed = PlayerPedId()

    if lib.progressBar({
        duration = Config.ActionDurations.revive,
        label = 'Réanimation en cours...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
        anim = {
            dict = 'mini@cpr@char_a@cpr_str',
            clip = 'cpr_pumpchest'
        },
    }) then
        TriggerServerEvent('esx_medical:revivePlayer', targetId)

        lib.notify({
            title = 'Réanimation effectuée',
            description = 'Patient réanimé avec succès',
            type = 'success'
        })
    else
        lib.notify({
            title = 'Annulé',
            description = 'Action annulée',
            type = 'error'
        })
    end

    ClearPedTasks(playerPed)
    isActionInProgress = false
end

-- ===========================================
-- EXAMINER
-- ===========================================

function ExaminePlayer(targetId, targetPed)
    if isActionInProgress then
        lib.notify({
            title = 'Action en cours',
            description = 'Une action est déjà en cours',
            type = 'error'
        })
        return
    end

    local hasItem = exports.ox_inventory:Search('count', Config.RequiredItems.examine)

    if not hasItem or hasItem < 1 then
        lib.notify({
            title = 'Item manquant',
            description = 'Vous n\'avez pas de ' .. Config.RequiredItems.examine,
            type = 'error'
        })
        return
    end

    isActionInProgress = true
    local playerPed = PlayerPedId()

    if lib.progressBar({
        duration = Config.ActionDurations.examine,
        label = 'Examen en cours...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
        anim = {
            dict = 'amb@medic@standing@knees@base',
            clip = 'base'
        },
    }) then
        -- Demander les infos au serveur
        TriggerServerEvent('esx_medical:examinePlayer', targetId)

        lib.notify({
            title = 'Examen terminé',
            description = 'Rapport médical disponible',
            type = 'success'
        })
    else
        lib.notify({
            title = 'Annulé',
            description = 'Action annulée',
            type = 'error'
        })
    end

    ClearPedTasks(playerPed)
    isActionInProgress = false
end

-- ===========================================
-- ENDORMIR (SÉDATION)
-- ===========================================

function SedatePlayer(targetId, targetPed)
    if isActionInProgress then
        lib.notify({
            title = 'Action en cours',
            description = 'Une action est déjà en cours',
            type = 'error'
        })
        return
    end

    local hasItem = exports.ox_inventory:Search('count', Config.RequiredItems.sedate)

    if not hasItem or hasItem < 1 then
        lib.notify({
            title = 'Item manquant',
            description = 'Vous n\'avez pas de ' .. Config.RequiredItems.sedate,
            type = 'error'
        })
        return
    end

    isActionInProgress = true
    local playerPed = PlayerPedId()

    if lib.progressBar({
        duration = Config.ActionDurations.sedate,
        label = 'Injection sédatif...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
        anim = {
            dict = 'amb@medic@standing@knees@base',
            clip = 'base'
        },
    }) then
        TriggerServerEvent('esx_medical:sedatePlayer', targetId)

        lib.notify({
            title = 'Sédation effectuée',
            description = 'Patient endormi',
            type = 'success'
        })
    else
        lib.notify({
            title = 'Annulé',
            description = 'Action annulée',
            type = 'error'
        })
    end

    ClearPedTasks(playerPed)
    isActionInProgress = false
end

-- ===========================================
-- BLESSER
-- ===========================================

function InjurePlayer(targetId, targetPed)
    if isActionInProgress then
        lib.notify({
            title = 'Action en cours',
            description = 'Une action est déjà en cours',
            type = 'error'
        })
        return
    end

    -- Confirmation
    local alert = lib.alertDialog({
        header = '⚠️ Action Illégale',
        content = 'Voulez-vous vraiment blesser cette personne ?\n\nCette action est ILLÉGALE !',
        centered = true,
        cancel = true
    })

    if alert ~= 'confirm' then return end

    isActionInProgress = true
    local playerPed = PlayerPedId()

    if lib.progressBar({
        duration = Config.ActionDurations.injure,
        label = 'Action en cours...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
        anim = {
            dict = 'melee@unarmed@streamed_core',
            clip = 'heavy_punch_a'
        },
    }) then
        TriggerServerEvent('esx_medical:injurePlayer', targetId)

        lib.notify({
            title = 'Action effectuée',
            description = 'Dégâts infligés',
            type = 'warning'
        })
    else
        lib.notify({
            title = 'Annulé',
            description = 'Action annulée',
            type = 'error'
        })
    end

    ClearPedTasks(playerPed)
    isActionInProgress = false
end

-- ===========================================
-- PRÉLÈVEMENT OS
-- ===========================================

function TakeBoneSample(targetId, targetPed)
    if isActionInProgress then
        lib.notify({
            title = 'Action en cours',
            description = 'Une action est déjà en cours',
            type = 'error'
        })
        return
    end

    local hasItem = exports.ox_inventory:Search('count', Config.RequiredItems.boneSample)

    if not hasItem or hasItem < 1 then
        lib.notify({
            title = 'Item manquant',
            description = 'Vous n\'avez pas de ' .. Config.RequiredItems.boneSample,
            type = 'error'
        })
        return
    end

    -- Confirmation
    local alert = lib.alertDialog({
        header = '⚠️ Prélèvement Illégal',
        content = 'Prélever des os est ILLÉGAL.\n\nContinuer ?',
        centered = true,
        cancel = true
    })

    if alert ~= 'confirm' then return end

    isActionInProgress = true
    local playerPed = PlayerPedId()

    if lib.progressBar({
        duration = Config.ActionDurations.boneSample,
        label = 'Prélèvement osseux...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
        anim = {
            dict = 'amb@medic@standing@knees@base',
            clip = 'base'
        },
    }) then
        TriggerServerEvent('esx_medical:takeSample', targetId, 'bone')

        lib.notify({
            title = 'Prélèvement effectué',
            description = 'Échantillon d\'os obtenu',
            type = 'success'
        })
    else
        lib.notify({
            title = 'Annulé',
            description = 'Action annulée',
            type = 'error'
        })
    end

    ClearPedTasks(playerPed)
    isActionInProgress = false
end

-- ===========================================
-- PRÉLÈVEMENT PEAU
-- ===========================================

function TakeSkinSample(targetId, targetPed)
    if isActionInProgress then
        lib.notify({
            title = 'Action en cours',
            description = 'Une action est déjà en cours',
            type = 'error'
        })
        return
    end

    local hasItem = exports.ox_inventory:Search('count', Config.RequiredItems.skinSample)

    if not hasItem or hasItem < 1 then
        lib.notify({
            title = 'Item manquant',
            description = 'Vous n\'avez pas de ' .. Config.RequiredItems.skinSample,
            type = 'error'
        })
        return
    end

    local alert = lib.alertDialog({
        header = '⚠️ Prélèvement Illégal',
        content = 'Prélever de la peau est ILLÉGAL.\n\nContinuer ?',
        centered = true,
        cancel = true
    })

    if alert ~= 'confirm' then return end

    isActionInProgress = true
    local playerPed = PlayerPedId()

    if lib.progressBar({
        duration = Config.ActionDurations.skinSample,
        label = 'Prélèvement cutané...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
        anim = {
            dict = 'amb@medic@standing@knees@base',
            clip = 'base'
        },
    }) then
        TriggerServerEvent('esx_medical:takeSample', targetId, 'skin')

        lib.notify({
            title = 'Prélèvement effectué',
            description = 'Échantillon de peau obtenu',
            type = 'success'
        })
    else
        lib.notify({
            title = 'Annulé',
            description = 'Action annulée',
            type = 'error'
        })
    end

    ClearPedTasks(playerPed)
    isActionInProgress = false
end

-- ===========================================
-- PRÉLÈVEMENT SANG
-- ===========================================

function TakeBloodSample(targetId, targetPed)
    if isActionInProgress then
        lib.notify({
            title = 'Action en cours',
            description = 'Une action est déjà en cours',
            type = 'error'
        })
        return
    end

    local hasItem = exports.ox_inventory:Search('count', Config.RequiredItems.bloodSample)

    if not hasItem or hasItem < 1 then
        lib.notify({
            title = 'Item manquant',
            description = 'Vous n\'avez pas de ' .. Config.RequiredItems.bloodSample,
            type = 'error'
        })
        return
    end

    isActionInProgress = true
    local playerPed = PlayerPedId()

    if lib.progressBar({
        duration = Config.ActionDurations.bloodSample,
        label = 'Prélèvement sanguin...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
        anim = {
            dict = 'amb@medic@standing@knees@base',
            clip = 'base'
        },
    }) then
        TriggerServerEvent('esx_medical:takeSample', targetId, 'blood')

        lib.notify({
            title = 'Prélèvement effectué',
            description = 'Échantillon de sang obtenu',
            type = 'success'
        })
    else
        lib.notify({
            title = 'Annulé',
            description = 'Action annulée',
            type = 'error'
        })
    end

    ClearPedTasks(playerPed)
    isActionInProgress = false
end

-- ===========================================
-- EVENT POUR RECEVOIR LES EFFETS
-- ===========================================

RegisterNetEvent('esx_medical:applyHeal')
AddEventHandler('esx_medical:applyHeal', function()
    local playerPed = PlayerPedId()
    SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))

    lib.notify({
        title = 'Soigné',
        description = 'Vous avez été soigné !',
        type = 'success'
    })
end)

RegisterNetEvent('esx_medical:applySedate')
AddEventHandler('esx_medical:applySedate', function()
    local playerPed = PlayerPedId()

    SetPedToRagdoll(playerPed, 10000, 10000, 0, 0, 0, 0)
    StartScreenEffect('DrugsMichaelAliensFight', 10000, false)

    lib.notify({
        title = 'Sédation',
        description = 'Vous avez été endormi...',
        type = 'warning'
    })

    SetTimeout(10000, function()
        StopScreenEffect('DrugsMichaelAliensFight')
    end)
end)

RegisterNetEvent('esx_medical:applyInjure')
AddEventHandler('esx_medical:applyInjure', function()
    local playerPed = PlayerPedId()
    local currentHealth = GetEntityHealth(playerPed)

    SetEntityHealth(playerPed, math.max(100, currentHealth - 50))
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.4)
    StartScreenEffect('MP_race_crash', 2000, false)

    lib.notify({
        title = 'Blessé',
        description = 'Vous avez été blessé !',
        type = 'error'
    })

    SetTimeout(2000, function()
        StopGameplayCamShaking(true)
        StopScreenEffect('MP_race_crash')
    end)
end)

RegisterNetEvent('esx_medical:showExamReport')
AddEventHandler('esx_medical:showExamReport', function(health, armor)
    local diagnosis = string.format(
        "État de santé : %d%%\nProtection : %d%%\nÉtat : %s",
        health,
        armor,
        health > 75 and "Bon" or health > 50 and "Moyen" or health > 25 and "Critique" or "Mourant"
    )

    lib.alertDialog({
        header = '🩺 Rapport Médical',
        content = diagnosis,
        centered = true,
        cancel = false
    })
end)
