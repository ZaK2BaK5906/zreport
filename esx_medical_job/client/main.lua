-- ===========================================
-- ESX MEDICAL JOB - CLIENT PRINCIPAL
-- ===========================================

ESX = exports['es_extended']:getSharedObject()
local PlayerData = {}
local isOnDuty = false
local currentVehicle = nil

-- ===========================================
-- ÉVÉNEMENTS ESX
-- ===========================================

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    InitializeJob()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
    InitializeJob()
end)

-- ===========================================
-- INITIALISATION
-- ===========================================

function InitializeJob()
    if PlayerData.job and PlayerData.job.name == Config.JobName then
        CreateJobBlips()
        CreateJobZones()
        CreateBlackMarket()
    end
end

CreateThread(function()
    while not ESX.IsPlayerLoaded() do
        Wait(100)
    end

    PlayerData = ESX.GetPlayerData()
    InitializeJob()
end)

-- ===========================================
-- BLIPS
-- ===========================================

function CreateJobBlips()
    for _, hospital in pairs(Config.Hospitals) do
        if hospital.blip then
            Utils.CreateBlip(
                hospital.blip.coords,
                hospital.blip.sprite,
                hospital.blip.color,
                hospital.blip.scale,
                hospital.name
            )
        end
    end
end

-- ===========================================
-- ZONES OX_TARGET
-- ===========================================

function CreateJobZones()
    for hospitalIndex, hospital in pairs(Config.Hospitals) do
        -- Vestiaire
        if hospital.cloakroom then
            exports.ox_target:addBoxZone({
                coords = hospital.cloakroom.coords,
                size = hospital.cloakroom.size,
                rotation = hospital.cloakroom.rotation,
                debug = false,
                options = {
                    {
                        name = 'medical_cloakroom_' .. hospitalIndex,
                        icon = 'fas fa-tshirt',
                        label = 'Vestiaire',
                        groups = Config.JobName,
                        onSelect = function()
                            OpenCloakroomMenu()
                        end
                    }
                }
            })
        end

        -- Pharmacie
        if hospital.pharmacy then
            exports.ox_target:addBoxZone({
                coords = hospital.pharmacy.coords,
                size = hospital.pharmacy.size,
                rotation = hospital.pharmacy.rotation,
                debug = false,
                options = {
                    {
                        name = 'medical_pharmacy_' .. hospitalIndex,
                        icon = 'fas fa-pills',
                        label = 'Pharmacie',
                        groups = Config.JobName,
                        onSelect = function()
                            OpenPharmacyMenu()
                        end
                    }
                }
            })
        end

        -- Laboratoire
        if hospital.laboratory then
            exports.ox_target:addBoxZone({
                coords = hospital.laboratory.coords,
                size = hospital.laboratory.size,
                rotation = hospital.laboratory.rotation,
                debug = false,
                options = {
                    {
                        name = 'medical_lab_' .. hospitalIndex,
                        icon = 'fas fa-flask',
                        label = 'Laboratoire',
                        groups = Config.JobName,
                        onSelect = function()
                            OpenLaboratoryMenu()
                        end
                    }
                }
            })
        end

        -- Garage
        if hospital.garage then
            exports.ox_target:addBoxZone({
                coords = hospital.garage.coords,
                size = hospital.garage.size,
                rotation = hospital.garage.rotation,
                debug = false,
                options = {
                    {
                        name = 'medical_garage_' .. hospitalIndex,
                        icon = 'fas fa-car',
                        label = 'Garage',
                        groups = Config.JobName,
                        onSelect = function()
                            OpenGarageMenu(hospital.garage)
                        end
                    }
                }
            })
        end
    end
end

-- ===========================================
-- MARCHÉ NOIR
-- ===========================================

function CreateBlackMarket()
    if not Config.BlackMarket or not Config.BlackMarket.enabled then return end

    -- Boucler sur toutes les locations du marché noir
    for locationIndex, location in pairs(Config.BlackMarket.locations) do
        if location.ped then
            -- Créer le PED
            local pedModel = GetHashKey(location.ped.model)
            RequestModel(pedModel)
            while not HasModelLoaded(pedModel) do
                Wait(10)
            end

            local ped = CreatePed(4, pedModel, location.ped.coords.x, location.ped.coords.y, location.ped.coords.z, location.ped.coords.w, false, true)
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)

            -- Scenario si défini
            if location.ped.scenario then
                TaskStartScenarioInPlace(ped, location.ped.scenario, 0, true)
            end

            -- Ajouter ox_target au PED
            exports.ox_target:addLocalEntity(ped, {
                {
                    name = 'blackmarket_medical_' .. locationIndex,
                    icon = 'fas fa-skull',
                    label = 'Marché Noir - Vendre échantillons',
                    onSelect = function()
                        OpenBlackMarketMenu()
                    end
                }
            })

            print('^2[Medical]^7 Marché noir #' .. locationIndex .. ' créé')
        end
    end
end

-- ===========================================
-- OX_TARGET SUR JOUEURS
-- ===========================================

CreateThread(function()
    exports.ox_target:addGlobalPlayer({
        {
            name = 'medical_heal',
            icon = 'fas fa-medkit',
            label = 'Soigner',
            groups = Config.JobName,
            canInteract = function(entity, distance, coords, name, bone)
                return PlayerData.job and PlayerData.job.name == Config.JobName and not IsPedDeadOrDying(entity, true)
            end,
            onSelect = function(data)
                local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
                HealPlayer(targetId, data.entity)
            end
        },
        {
            name = 'medical_revive',
            icon = 'fas fa-heartbeat',
            label = 'Réanimer',
            groups = Config.JobName,
            canInteract = function(entity, distance, coords, name, bone)
                return PlayerData.job and PlayerData.job.name == Config.JobName and (IsPedDeadOrDying(entity, true) or IsPedFatallyInjured(entity))
            end,
            onSelect = function(data)
                local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
                RevivePlayer(targetId, data.entity)
            end
        },
        {
            name = 'medical_examine',
            icon = 'fas fa-stethoscope',
            label = 'Examiner',
            groups = Config.JobName,
            onSelect = function(data)
                local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
                ExaminePlayer(targetId, data.entity)
            end
        },
        {
            name = 'medical_sedate',
            icon = 'fas fa-syringe',
            label = 'Endormir',
            groups = Config.JobName,
            canInteract = function(entity, distance, coords, name, bone)
                return PlayerData.job and PlayerData.job.name == Config.JobName and not IsPedDeadOrDying(entity, true)
            end,
            onSelect = function(data)
                local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
                SedatePlayer(targetId, data.entity)
            end
        },
        {
            name = 'medical_injure',
            icon = 'fas fa-skull-crossbones',
            label = 'Blesser (Illégal)',
            groups = Config.JobName,
            canInteract = function(entity, distance, coords, name, bone)
                return PlayerData.job and PlayerData.job.name == Config.JobName and not IsPedDeadOrDying(entity, true)
            end,
            onSelect = function(data)
                local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
                InjurePlayer(targetId, data.entity)
            end
        },
        {
            name = 'medical_bone_sample',
            icon = 'fas fa-bone',
            label = 'Prélever os (Illégal)',
            groups = Config.JobName,
            canInteract = function(entity, distance, coords, name, bone)
                return PlayerData.job and PlayerData.job.name == Config.JobName and (IsPedDeadOrDying(entity, true) or IsPedRagdoll(entity))
            end,
            onSelect = function(data)
                local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
                TakeBoneSample(targetId, data.entity)
            end
        },
        {
            name = 'medical_skin_sample',
            icon = 'fas fa-hand-paper',
            label = 'Prélever peau (Illégal)',
            groups = Config.JobName,
            canInteract = function(entity, distance, coords, name, bone)
                return PlayerData.job and PlayerData.job.name == Config.JobName
            end,
            onSelect = function(data)
                local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
                TakeSkinSample(targetId, data.entity)
            end
        },
        {
            name = 'medical_blood_sample',
            icon = 'fas fa-tint',
            label = 'Prélever sang',
            groups = Config.JobName,
            onSelect = function(data)
                local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
                TakeBloodSample(targetId, data.entity)
            end
        },
    })
end)

-- ===========================================
-- ACTIONS MÉDICALES
-- ===========================================
-- Les fonctions sont définies dans client/actions.lua

-- ===========================================
-- MENUS
-- ===========================================

function OpenCloakroomMenu()
    local gender = PlayerData.sex == 'm' and 'male' or 'female'
    local elements = {}

    for _, outfit in pairs(Config.Uniforms[gender]) do
        table.insert(elements, {
            title = outfit.label,
            icon = 'tshirt',
            onSelect = function()
                TriggerEvent('skinchanger:getSkin', function(skin)
                    TriggerEvent('skinchanger:loadClothes', skin, outfit.outfit)
                end)
            end
        })
    end

    table.insert(elements, {
        title = 'Tenue Civile',
        icon = 'user',
        onSelect = function()
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                TriggerEvent('skinchanger:loadSkin', skin)
            end)
        end
    })

    lib.registerContext({
        id = 'medical_cloakroom',
        title = '👔 Vestiaire',
        options = elements
    })

    lib.showContext('medical_cloakroom')
end

function OpenPharmacyMenu()
    local elements = {}

    for _, item in pairs(Config.PharmacyItems) do
        table.insert(elements, {
            title = item.label,
            description = 'Prix : $' .. item.price,
            icon = 'pills',
            onSelect = function()
                local input = lib.inputDialog('Achat - ' .. item.label, {
                    {type = 'number', label = 'Quantité', description = 'Combien voulez-vous acheter ?', required = true, min = 1, max = 50}
                })

                if input then
                    TriggerServerEvent('esx_medical:buyItem', item.item, input[1], item.price)
                end
            end
        })
    end

    lib.registerContext({
        id = 'medical_pharmacy',
        title = '💊 Pharmacie',
        options = elements
    })

    lib.showContext('medical_pharmacy')
end

function OpenLaboratoryMenu()
    lib.registerContext({
        id = 'medical_laboratory',
        title = '🔬 Laboratoire',
        options = {
            {
                title = 'Analyser échantillon de sang',
                icon = 'tint',
                onSelect = function()
                    -- Logique d'analyse
                    Utils.Notify('Fonction en développement', 'info')
                end
            },
            {
                title = 'Analyser échantillon de peau',
                icon = 'hand-paper',
                onSelect = function()
                    Utils.Notify('Fonction en développement', 'info')
                end
            },
            {
                title = 'Analyser échantillon d\'os',
                icon = 'bone',
                onSelect = function()
                    Utils.Notify('Fonction en développement', 'info')
                end
            }
        }
    })

    lib.showContext('medical_laboratory')
end

function OpenGarageMenu(garage)
    local elements = {}

    for _, vehicle in pairs(garage.vehicles) do
        table.insert(elements, {
            title = vehicle.label,
            icon = 'car',
            onSelect = function()
                SpawnVehicle(vehicle.name, garage.coords)
            end
        })
    end

    table.insert(elements, {
        title = 'Ranger le véhicule',
        icon = 'warehouse',
        onSelect = function()
            local playerPed = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(playerPed, false)

            if vehicle ~= 0 then
                ESX.Game.DeleteVehicle(vehicle)
                Utils.Notify('Véhicule rangé', 'success')
            else
                Utils.Notify('Vous devez être dans un véhicule', 'error')
            end
        end
    })

    lib.registerContext({
        id = 'medical_garage',
        title = '🚑 Garage',
        options = elements
    })

    lib.showContext('medical_garage')
end

function OpenBlackMarketMenu()
    lib.registerContext({
        id = 'blackmarket_medical',
        title = '💀 Marché Noir',
        options = {
            {
                title = 'Vendre échantillon d\'os',
                description = 'Prix : $' .. Config.Prices.boneSample,
                icon = 'bone',
                onSelect = function()
                    TriggerServerEvent('esx_medical:sellSample', 'bone')
                end
            },
            {
                title = 'Vendre échantillon de peau',
                description = 'Prix : $' .. Config.Prices.skinSample,
                icon = 'hand-paper',
                onSelect = function()
                    TriggerServerEvent('esx_medical:sellSample', 'skin')
                end
            },
            {
                title = 'Vendre échantillon de sang',
                description = 'Prix : $' .. Config.Prices.bloodSample,
                icon = 'tint',
                onSelect = function()
                    TriggerServerEvent('esx_medical:sellSample', 'blood')
                end
            }
        }
    })

    lib.showContext('blackmarket_medical')
end

function SpawnVehicle(model, coords)
    local playerPed = PlayerPedId()

    ESX.Game.SpawnVehicle(model, coords, coords.w or 0.0, function(vehicle)
        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
        SetVehicleNumberPlateText(vehicle, "EMS" .. math.random(1000, 9999))
        currentVehicle = vehicle
    end)
end

-- ===========================================
-- ÉVÉNEMENTS RÉSEAU
-- ===========================================
-- Les événements sont définis dans client/actions.lua
