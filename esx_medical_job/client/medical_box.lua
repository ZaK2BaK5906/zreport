-- ===========================================
-- SYSTÈME DE PROPS MÉDICAL
-- ===========================================

local medicalBoxes = {}
local nextBoxId = 1

-- ===========================================
-- UTILISATION DU MEDIKIT ADVANCED (POSER LA BOÎTE)
-- ===========================================

exports('useMedikitAdvanced', function(data, slot)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local playerHeading = GetEntityHeading(playerPed)

    -- Position devant le joueur
    local forward = GetEntityForwardVector(playerPed)
    local boxCoords = vector3(
        playerCoords.x + forward.x * 1.0,
        playerCoords.y + forward.y * 1.0,
        playerCoords.z - 0.95
    )

    -- Animation de pose
    lib.progressBar({
        duration = 3000,
        label = 'Pose de la boîte médicale',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
        anim = {
            dict = 'anim@narcotics@trash',
            clip = 'drop_front'
        },
    })

    -- Créer le props
    CreateMedicalBox(boxCoords, playerHeading)

    -- Retirer l'item (ox_inventory)
    TriggerServerEvent('esx_medical:removeMedicalBox')
end)

-- ===========================================
-- CRÉER LA BOÎTE MÉDICALE
-- ===========================================

function CreateMedicalBox(coords, heading)
    local boxId = nextBoxId
    nextBoxId = nextBoxId + 1

    -- Model du props (boîte médicale)
    local modelHash = GetHashKey('prop_ld_health_pack')

    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(10)
    end

    -- Créer l'objet
    local box = CreateObject(modelHash, coords.x, coords.y, coords.z, true, true, false)
    PlaceObjectOnGroundProperly(box)
    SetEntityHeading(box, heading)
    FreezeEntityPosition(box, true)

    -- Sauvegarder
    medicalBoxes[boxId] = {
        object = box,
        coords = coords,
        netId = NetworkGetNetworkIdFromEntity(box)
    }

    -- Ajouter ox_target
    exports.ox_target:addLocalEntity(box, {
        {
            name = 'medical_box_use_' .. boxId,
            icon = 'fas fa-briefcase-medical',
            label = 'Ouvrir la boîte médicale',
            groups = Config.JobName,
            onSelect = function()
                OpenMedicalBoxMenu(boxId)
            end
        },
        {
            name = 'medical_box_pickup_' .. boxId,
            icon = 'fas fa-hand-holding',
            label = 'Ramasser la boîte',
            groups = Config.JobName,
            onSelect = function()
                PickupMedicalBox(boxId)
            end
        }
    })

    -- Notification
    lib.notify({
        title = 'Boîte Médicale',
        description = 'Boîte médicale posée avec succès',
        type = 'success',
        icon = 'briefcase-medical'
    })

    print('^2[Medical Box]^7 Boîte #' .. boxId .. ' créée')
end

-- ===========================================
-- MENU DE LA BOÎTE MÉDICALE
-- ===========================================

function OpenMedicalBoxMenu(boxId)
    local box = medicalBoxes[boxId]
    if not box then return end

    -- Menu ox_lib
    lib.registerContext({
        id = 'medical_box_menu',
        title = '🩺 Boîte Médicale',
        options = {
            {
                title = 'Kit Médical Avancé',
                description = 'Pour soigner les patients',
                icon = 'medkit',
                iconColor = '#06d6a0',
                onSelect = function()
                    TriggerServerEvent('esx_medical:takeFromBox', 'medikit_advanced', 1)
                end
            },
            {
                title = 'Défibrillateur Pro',
                description = 'Pour réanimer',
                icon = 'heartbeat',
                iconColor = '#ef476f',
                onSelect = function()
                    TriggerServerEvent('esx_medical:takeFromBox', 'defib_pro', 1)
                end
            },
            {
                title = 'Stéthoscope Numérique',
                description = 'Pour examiner',
                icon = 'stethoscope',
                iconColor = '#00b4d8',
                onSelect = function()
                    TriggerServerEvent('esx_medical:takeFromBox', 'stethoscope_digital', 1)
                end
            },
            {
                title = 'Scanner Médical',
                description = 'Diagnostic avancé',
                icon = 'laptop-medical',
                iconColor = '#0096c7',
                onSelect = function()
                    TriggerServerEvent('esx_medical:takeFromBox', 'medical_scanner', 1)
                end
            },
            -- SEPARATOR
            {
                title = '━━━ Médicaments ━━━',
                icon = 'pills',
                disabled = true
            },
            {
                title = 'Sédatif Léger',
                description = 'Calmer les patients',
                icon = 'syringe',
                iconColor = '#ffc107',
                onSelect = function()
                    TriggerServerEvent('esx_medical:takeFromBox', 'sedative_light', 1)
                end
            },
            {
                title = 'Sédatif Puissant',
                description = 'Endormir rapidement',
                icon = 'syringe',
                iconColor = '#ff9800',
                onSelect = function()
                    TriggerServerEvent('esx_medical:takeFromBox', 'sedative_heavy', 1)
                end
            },
            {
                title = 'Morphine',
                description = 'Antidouleur puissant',
                icon = 'prescription-bottle',
                iconColor = '#e91e63',
                onSelect = function()
                    TriggerServerEvent('esx_medical:takeFromBox', 'morphine', 1)
                end
            },
            {
                title = 'Adrénaline',
                description = 'Urgences vitales',
                icon = 'fire',
                iconColor = '#f44336',
                onSelect = function()
                    TriggerServerEvent('esx_medical:takeFromBox', 'adrenaline', 1)
                end
            },
            -- SEPARATOR
            {
                title = '━━━ Chirurgie ━━━',
                icon = 'scalpel',
                disabled = true
            },
            {
                title = 'Kit Chirurgical Basique',
                description = 'Interventions mineures',
                icon = 'briefcase',
                iconColor = '#9c27b0',
                onSelect = function()
                    TriggerServerEvent('esx_medical:takeFromBox', 'surgical_kit_basic', 1)
                end
            },
            {
                title = 'Kit Chirurgical Avancé',
                description = 'Chirurgies complexes',
                icon = 'briefcase',
                iconColor = '#673ab7',
                onSelect = function()
                    TriggerServerEvent('esx_medical:takeFromBox', 'surgical_kit_advanced', 1)
                end
            },
            {
                title = 'Scalpel',
                description = 'Scalpel stérile',
                icon = 'cut',
                iconColor = '#607d8b',
                onSelect = function()
                    TriggerServerEvent('esx_medical:takeFromBox', 'scalpel', 1)
                end
            },
            -- SEPARATOR
            {
                title = '━━━ Prélèvements ━━━',
                icon = 'vial',
                disabled = true
            },
            {
                title = 'Seringue Stérile',
                description = 'Pour prélèvements',
                icon = 'syringe',
                iconColor = '#00bcd4',
                onSelect = function()
                    TriggerServerEvent('esx_medical:takeFromBox', 'syringe_sterile', 1)
                end
            },
            {
                title = 'Poche de Sang',
                description = 'Collecte de sang',
                icon = 'droplet',
                iconColor = '#d32f2f',
                onSelect = function()
                    TriggerServerEvent('esx_medical:takeFromBox', 'blood_bag', 1)
                end
            },
            {
                title = 'Conteneur à Échantillon',
                description = 'Échantillons biologiques',
                icon = 'flask',
                iconColor = '#388e3c',
                onSelect = function()
                    TriggerServerEvent('esx_medical:takeFromBox', 'sample_container', 1)
                end
            },
            {
                title = 'Aiguille de Biopsie',
                description = 'Prélèvements tissus',
                icon = 'syringe',
                iconColor = '#7b1fa2',
                onSelect = function()
                    TriggerServerEvent('esx_medical:takeFromBox', 'biopsy_needle', 1)
                end
            },
            -- SEPARATOR
            {
                title = '━━━ Soins ━━━',
                icon = 'bandage',
                disabled = true
            },
            {
                title = 'Bandage Stérile',
                description = 'Pour plaies',
                icon = 'bandage',
                iconColor = '#ffffff',
                onSelect = function()
                    TriggerServerEvent('esx_medical:takeFromBox', 'bandage_sterile', 1)
                end
            },
            {
                title = 'Antibiotique',
                description = 'Large spectre',
                icon = 'capsules',
                iconColor = '#4caf50',
                onSelect = function()
                    TriggerServerEvent('esx_medical:takeFromBox', 'antibiotic', 1)
                end
            },
            {
                title = 'Antidouleur',
                description = 'Standard',
                icon = 'pills',
                iconColor = '#2196f3',
                onSelect = function()
                    TriggerServerEvent('esx_medical:takeFromBox', 'painkiller', 1)
                end
            },
            -- SEPARATOR
            {
                title = '━━━ Protection ━━━',
                icon = 'shield',
                disabled = true
            },
            {
                title = 'Masque Chirurgical',
                description = 'Protection',
                icon = 'head-side-mask',
                iconColor = '#9e9e9e',
                onSelect = function()
                    TriggerServerEvent('esx_medical:takeFromBox', 'surgical_mask', 1)
                end
            },
            {
                title = 'Gants Latex',
                description = 'Stériles',
                icon = 'mitten',
                iconColor = '#03a9f4',
                onSelect = function()
                    TriggerServerEvent('esx_medical:takeFromBox', 'latex_gloves', 1)
                end
            },
        }
    })

    lib.showContext('medical_box_menu')
end

-- ===========================================
-- RAMASSER LA BOÎTE
-- ===========================================

function PickupMedicalBox(boxId)
    local box = medicalBoxes[boxId]
    if not box then return end

    -- Animation
    lib.progressBar({
        duration = 2000,
        label = 'Ramassage de la boîte',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
        anim = {
            dict = 'pickup_object',
            clip = 'pickup_low'
        },
    })

    -- Supprimer le props
    if DoesEntityExist(box.object) then
        DeleteEntity(box.object)
    end

    -- Retirer ox_target
    exports.ox_target:removeLocalEntity(box.object, 'medical_box_use_' .. boxId)
    exports.ox_target:removeLocalEntity(box.object, 'medical_box_pickup_' .. boxId)

    -- Supprimer de la table
    medicalBoxes[boxId] = nil

    -- Rendre l'item
    TriggerServerEvent('esx_medical:returnMedicalBox')

    lib.notify({
        title = 'Boîte Médicale',
        description = 'Boîte médicale ramassée',
        type = 'success',
        icon = 'briefcase-medical'
    })

    print('^3[Medical Box]^7 Boîte #' .. boxId .. ' ramassée')
end

-- ===========================================
-- NETTOYAGE
-- ===========================================

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    -- Supprimer toutes les boîtes
    for boxId, box in pairs(medicalBoxes) do
        if DoesEntityExist(box.object) then
            DeleteEntity(box.object)
        end
    end

    print('^3[Medical Box]^7 Toutes les boîtes ont été supprimées')
end)
