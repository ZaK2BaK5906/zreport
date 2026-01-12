Config = {}

-- ===========================================
-- CONFIGURATION GÉNÉRALE
-- ===========================================

Config.Locale = 'fr'
Config.JobName = 'medecin_scientifique'  -- Nom du job
Config.UseOxInventory = true  -- Utiliser ox_inventory
Config.UseOxTarget = true  -- Utiliser ox_target
Config.UseOxLib = true  -- Utiliser ox_lib

-- Debug mode
Config.Debug = false

-- ===========================================
-- PERMISSIONS PAR GRADE
-- ===========================================

Config.MinGradeFor = {
    heal = 0,              -- Stagiaire peut soigner
    revive = 1,            -- Infirmier peut réanimer
    examine = 0,           -- Stagiaire peut examiner
    sedate = 2,            -- Médecin peut endormir
    bloodSample = 1,       -- Infirmier peut prélever du sang
    skinSample = 3,        -- Chirurgien peut prélever de la peau
    boneSample = 4,        -- Scientifique peut prélever des os
    organSample = 5,       -- Chef Scientifique peut prélever des organes
    injure = 2,            -- Médecin peut blesser (illégal)
    blackMarket = 3,       -- Chirurgien peut vendre au marché noir
}

-- ===========================================
-- PRIX ET GAINS (ox_inventory compatible)
-- ===========================================

Config.Prices = {
    -- Actions légales (paiements)
    heal = 800,
    revive = 1500,
    examine = 300,
    bloodSample = 500,

    -- Actions illégales (marché noir)
    boneSample = 3500,
    skinSample = 2500,
    organSample = 5000,
    tissueSample = 1500,

    -- Sédation
    sedate = 400,

    -- Autres
    injure = 0,  -- Pas de paiement pour blesser
}

-- ===========================================
-- ITEMS OX_INVENTORY
-- ===========================================

Config.RequiredItems = {
    heal = 'medikit_advanced',
    revive = 'defib_pro',
    examine = 'stethoscope_digital',
    sedate = 'sedative_heavy',
    boneSample = 'surgical_kit_advanced',
    skinSample = 'surgical_kit_basic',
    bloodSample = 'syringe_sterile',
    organSample = 'surgical_kit_advanced',
    tissueSample = 'biopsy_needle',
}

Config.SampleItems = {
    bone = 'bone_sample',
    skin = 'skin_sample',
    blood = 'blood_sample',
    organ = 'organ_sample',
    tissue = 'tissue_sample',
}

-- Items consommés lors des actions
Config.ConsumeItems = true

-- Quantité consommée
Config.ItemsConsumed = {
    heal = 1,
    revive = 1,
    examine = 0,  -- N'est pas consommé
    sedate = 1,
    boneSample = 1,
    skinSample = 1,
    bloodSample = 1,
    organSample = 1,
    tissueSample = 1,
}

-- ===========================================
-- DURÉES DES ACTIONS (millisecondes)
-- ===========================================

Config.ActionDurations = {
    heal = 10000,          -- 10 secondes
    revive = 18000,        -- 18 secondes
    examine = 8000,        -- 8 secondes
    sedate = 6000,         -- 6 secondes
    boneSample = 15000,    -- 15 secondes
    skinSample = 12000,    -- 12 secondes
    bloodSample = 8000,    -- 8 secondes
    organSample = 20000,   -- 20 secondes
    tissueSample = 10000,  -- 10 secondes
    injure = 5000,         -- 5 secondes
}

-- ===========================================
-- EFFETS 3D CUSTOM
-- ===========================================

Config.Effects3D = {
    -- Texte 3D
    text = {
        enabled = true,
        scale = 0.4,
        font = 4,
        color = {r = 255, g = 255, b = 255, a = 255},
        outline = true,
        shadow = true,
    },

    -- Barre de progression 3D
    progressBar = {
        enabled = true,
        width = 0.2,
        height = 0.02,
        offset = 0.8,  -- Hauteur au-dessus du joueur
        bgColor = {r = 0, g = 0, b = 0, a = 180},
        showPercentage = true,
        smoothAnimation = true,
    },

    -- Particules
    particles = {
        enabled = true,
        heal = {dict = 'core', name = 'ent_dst_elec_crackle', scale = 0.5},
        revive = {dict = 'core', name = 'ent_dst_elec_fire_sp', scale = 1.0},
        sample = {dict = 'core', name = 'blood_stab', scale = 0.8},
        sedate = {dict = 'core', name = 'ent_sht_steam', scale = 0.6},
    },

    -- Effets d'écran
    screenEffects = {
        enabled = true,
        heal = 'MP_OrbitalCannon',
        revive = 'DeathFailMPDark',
        sedate = 'DrugsMichaelAliensFight',
        injure = 'MP_race_crash',
    },

    -- Secousses caméra
    cameraShake = {
        enabled = true,
        revive = {intensity = 0.3, duration = 3000},
        sedate = {intensity = 0.5, duration = 5000},
        injure = {intensity = 0.4, duration = 2000},
    },
}

-- ===========================================
-- NUI CUSTOM NOTIFICATIONS
-- ===========================================

Config.NUI = {
    enabled = true,
    position = 'top-right',  -- top-right, top-left, bottom-right, bottom-left
    maxNotifications = 5,
    defaultDuration = 5000,
    animations = {
        enter = 'slideInRight',
        exit = 'slideOutRight',
    },
    sounds = true,
}

-- ===========================================
-- HÔPITAUX ET POINTS D'INTERACTION
-- ===========================================

Config.Hospitals = {
    -- Hôpital Central de Los Santos
    {
        name = "Centre Médical Scientifique LS",
        blip = {
            coords = vector3(307.7, -1433.4, 29.9),
            sprite = 61,
            color = 3,
            scale = 1.0,
            display = 4,
        },

        -- Vestiaire
        cloakroom = {
            coords = vector3(298.6, -1428.5, 29.9),
            size = vector3(2.5, 2.5, 2.5),
            rotation = 45.0,
            debug = false,
        },

        -- Pharmacie
        pharmacy = {
            coords = vector3(306.4, -1433.2, 29.9),
            size = vector3(2.5, 2.5, 2.5),
            rotation = 45.0,
            debug = false,
        },

        -- Laboratoire scientifique
        laboratory = {
            coords = vector3(310.2, -1440.8, 29.9),
            size = vector3(4.0, 4.0, 2.5),
            rotation = 45.0,
            debug = false,
        },

        -- Salle d'opération
        operatingRoom = {
            coords = vector3(314.5, -1425.2, 29.9),
            size = vector3(3.0, 3.0, 2.5),
            rotation = 45.0,
            debug = false,
        },

        -- Garage véhicules
        garage = {
            coords = vector3(294.3, -1448.1, 29.9),
            size = vector3(4.0, 4.0, 2.5),
            rotation = 45.0,
            debug = false,
            spawnPoint = vector4(287.3, -1456.8, 29.9, 230.0),
            vehicles = {
                {model = 'ambulance', label = 'Ambulance Standard', grade = 0},
                {model = 'lguard', label = 'Ambulance Plage', grade = 1},
                {model = 'firetruk', label = 'Véhicule d\'Intervention', grade = 3},
            }
        },

        -- Boss menu
        boss = {
            coords = vector3(335.5, -1432.2, 29.9),
            size = vector3(2.0, 2.0, 2.0),
            rotation = 45.0,
            minGrade = 5,  -- Chef Scientifique
            debug = false,
        },
    },

    -- Clinique Sandy Shores
    {
        name = "Clinique Scientifique Sandy",
        blip = {
            coords = vector3(1839.6, 3672.9, 34.2),
            sprite = 61,
            color = 3,
            scale = 0.8,
            display = 4,
        },

        cloakroom = {
            coords = vector3(1822.3, 3672.1, 34.2),
            size = vector3(2.0, 2.0, 2.0),
            rotation = 45.0,
        },

        pharmacy = {
            coords = vector3(1839.6, 3672.9, 34.2),
            size = vector3(2.0, 2.0, 2.0),
            rotation = 45.0,
        },

        laboratory = {
            coords = vector3(1845.2, 3675.5, 34.2),
            size = vector3(3.0, 3.0, 2.0),
            rotation = 120.0,
        },

        garage = {
            coords = vector3(1830.2, 3680.5, 34.2),
            size = vector3(3.0, 3.0, 2.0),
            rotation = 120.0,
            spawnPoint = vector4(1828.5, 3686.2, 33.9, 210.0),
            vehicles = {
                {model = 'ambulance', label = 'Ambulance', grade = 0},
            }
        },
    },

    -- Clinique Paleto Bay
    {
        name = "Clinique Scientifique Paleto",
        blip = {
            coords = vector3(-247.8, 6331.5, 32.4),
            sprite = 61,
            color = 3,
            scale = 0.8,
            display = 4,
        },

        cloakroom = {
            coords = vector3(-254.8, 6324.5, 32.6),
            size = vector3(2.0, 2.0, 2.0),
            rotation = 45.0,
        },

        pharmacy = {
            coords = vector3(-247.8, 6331.5, 32.4),
            size = vector3(2.0, 2.0, 2.0),
            rotation = 45.0,
        },

        laboratory = {
            coords = vector3(-241.2, 6328.8, 32.4),
            size = vector3(3.0, 3.0, 2.0),
            rotation = 45.0,
        },

        garage = {
            coords = vector3(-262.4, 6315.5, 32.4),
            size = vector3(3.0, 3.0, 2.0),
            rotation = 45.0,
            spawnPoint = vector4(-268.5, 6319.2, 32.1, 135.0),
            vehicles = {
                {model = 'ambulance', label = 'Ambulance', grade = 0},
            }
        },
    },
}

-- ===========================================
-- MARCHÉ NOIR
-- ===========================================

Config.BlackMarket = {
    enabled = true,
    locations = {
        {
            coords = vector3(2434.8, 4969.2, 42.3),
            size = vector3(3.0, 3.0, 2.5),
            rotation = 45.0,
            debug = false,
            ped = {
                model = 's_m_m_scientist_01',
                coords = vector4(2434.8, 4969.2, 41.3, 312.4),
                scenario = 'WORLD_HUMAN_CLIPBOARD',
            },
            blip = {
                enabled = false,  -- Caché
                sprite = 378,
                color = 1,
                scale = 0.7,
            }
        },
        -- Autre localisation secrète
        {
            coords = vector3(-1307.5, -2689.8, 13.9),
            size = vector3(3.0, 3.0, 2.5),
            rotation = 45.0,
            ped = {
                model = 's_m_y_scientist_01',
                coords = vector4(-1307.5, -2689.8, 12.9, 140.5),
                scenario = 'WORLD_HUMAN_SMOKING',
            },
        },
    }
}

-- ===========================================
-- TENUES (skinchanger compatible)
-- ===========================================

Config.Uniforms = {
    male = {
        {
            label = '👔 Tenue Médecin Standard',
            outfit = {
                ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                ['torso_1'] = 249, ['torso_2'] = 0,
                ['decals_1'] = 0, ['decals_2'] = 0,
                ['arms'] = 85,
                ['pants_1'] = 96, ['pants_2'] = 0,
                ['shoes_1'] = 24, ['shoes_2'] = 0,
                ['chain_1'] = 126, ['chain_2'] = 0,
            }
        },
        {
            label = '🩺 Tenue Chirurgien',
            outfit = {
                ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                ['torso_1'] = 250, ['torso_2'] = 0,
                ['decals_1'] = 0, ['decals_2'] = 0,
                ['arms'] = 86,
                ['pants_1'] = 97, ['pants_2'] = 0,
                ['shoes_1'] = 24, ['shoes_2'] = 0,
            }
        },
        {
            label = '🔬 Tenue Scientifique',
            outfit = {
                ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                ['torso_1'] = 71, ['torso_2'] = 0,
                ['decals_1'] = 0, ['decals_2'] = 0,
                ['arms'] = 14,
                ['pants_1'] = 88, ['pants_2'] = 0,
                ['shoes_1'] = 24, ['shoes_2'] = 0,
                ['mask_1'] = 28, ['mask_2'] = 0,
            }
        },
    },
    female = {
        {
            label = '👔 Tenue Médecin Standard',
            outfit = {
                ['tshirt_1'] = 14, ['tshirt_2'] = 0,
                ['torso_1'] = 258, ['torso_2'] = 0,
                ['decals_1'] = 0, ['decals_2'] = 0,
                ['arms'] = 101,
                ['pants_1'] = 99, ['pants_2'] = 0,
                ['shoes_1'] = 24, ['shoes_2'] = 0,
                ['chain_1'] = 96, ['chain_2'] = 0,
            }
        },
        {
            label = '🩺 Tenue Chirurgien',
            outfit = {
                ['tshirt_1'] = 14, ['tshirt_2'] = 0,
                ['torso_1'] = 259, ['torso_2'] = 0,
                ['decals_1'] = 0, ['decals_2'] = 0,
                ['arms'] = 102,
                ['pants_1'] = 100, ['pants_2'] = 0,
                ['shoes_1'] = 24, ['shoes_2'] = 0,
            }
        },
        {
            label = '🔬 Tenue Scientifique',
            outfit = {
                ['tshirt_1'] = 14, ['tshirt_2'] = 0,
                ['torso_1'] = 73, ['torso_2'] = 0,
                ['decals_1'] = 0, ['decals_2'] = 0,
                ['arms'] = 14,
                ['pants_1'] = 90, ['pants_2'] = 0,
                ['shoes_1'] = 24, ['shoes_2'] = 0,
                ['mask_1'] = 28, ['mask_2'] = 0,
            }
        },
    },
}

-- ===========================================
-- ITEMS DE LA PHARMACIE (ox_inventory)
-- ===========================================

Config.PharmacyItems = {
    -- Équipement médical
    {item = 'medikit_advanced', label = 'Kit Médical Avancé', price = 300, minGrade = 0},
    {item = 'defib_pro', label = 'Défibrillateur Pro', price = 800, minGrade = 1},
    {item = 'stethoscope_digital', label = 'Stéthoscope Numérique', price = 200, minGrade = 0},
    {item = 'medical_scanner', label = 'Scanner Médical', price = 500, minGrade = 2},

    -- Médicaments
    {item = 'sedative_light', label = 'Sédatif Léger', price = 150, minGrade = 1},
    {item = 'sedative_heavy', label = 'Sédatif Puissant', price = 300, minGrade = 2},
    {item = 'anesthetic', label = 'Anesthésiant', price = 250, minGrade = 2},
    {item = 'morphine', label = 'Morphine', price = 200, minGrade = 2},
    {item = 'adrenaline', label = 'Adrénaline', price = 180, minGrade = 1},

    -- Équipement chirurgical
    {item = 'surgical_kit_basic', label = 'Kit Chirurgical Basique', price = 1000, minGrade = 2},
    {item = 'surgical_kit_advanced', label = 'Kit Chirurgical Avancé', price = 2500, minGrade = 4},
    {item = 'scalpel', label = 'Scalpel', price = 150, minGrade = 2},
    {item = 'surgical_saw', label = 'Scie Chirurgicale', price = 600, minGrade = 4},

    -- Matériel de prélèvement
    {item = 'syringe_sterile', label = 'Seringue Stérile', price = 80, minGrade = 0},
    {item = 'blood_bag', label = 'Poche de Sang', price = 120, minGrade = 1},
    {item = 'sample_container', label = 'Conteneur à Échantillon', price = 100, minGrade = 2},
    {item = 'biopsy_needle', label = 'Aiguille de Biopsie', price = 200, minGrade = 3},

    -- Soins
    {item = 'bandage_sterile', label = 'Bandage Stérile', price = 50, minGrade = 0},
    {item = 'medical_tape', label = 'Bande Médicale', price = 30, minGrade = 0},
    {item = 'gauze', label = 'Gaze', price = 25, minGrade = 0},
    {item = 'antibiotic', label = 'Antibiotique', price = 90, minGrade = 1},
    {item = 'painkiller', label = 'Antidouleur', price = 60, minGrade = 0},

    -- Protection
    {item = 'surgical_mask', label = 'Masque Chirurgical', price = 40, minGrade = 0},
    {item = 'latex_gloves', label = 'Gants Latex', price = 20, minGrade = 0},
    {item = 'lab_coat', label = 'Blouse de Labo', price = 350, minGrade = 3},
}

-- ===========================================
-- MESSAGES
-- ===========================================

Config.Messages = {
    -- Erreurs
    no_permission = "❌ Vous n'êtes pas médecin scientifique !",
    no_grade = "❌ Votre grade est insuffisant pour cette action",
    no_players_nearby = "❌ Aucun joueur à proximité",
    no_item = "❌ Vous n'avez pas l'équipement nécessaire",
    player_not_unconscious = "❌ Le patient n'est pas inconscient",
    already_in_progress = "⚠️ Une action est déjà en cours",

    -- Succès
    player_healed = "✅ Patient soigné avec succès",
    player_revived = "✅ Patient réanimé avec succès",
    player_examined = "✅ Examen médical terminé",
    player_sedated = "✅ Patient endormi",
    player_injured = "⚠️ Dégâts infligés",
    sample_taken = "✅ Prélèvement effectué",
    item_purchased = "✅ Achat effectué",

    -- Illégal
    illegal_action = "⚠️ ATTENTION - Action illégale détectée",
    police_notified = "🚨 La police a été alertée",
    black_market_sale = "💰 Vente au marché noir réussie",

    -- Autres
    on_duty = "✅ Vous êtes en service",
    off_duty = "❌ Vous n'êtes plus en service",
    vehicle_spawned = "🚗 Véhicule sorti",
    vehicle_stored = "🏁 Véhicule rangé",
}

-- ===========================================
-- ANIMATIONS
-- ===========================================

Config.Animations = {
    heal = {dict = 'amb@medic@standing@knees@base', anim = 'base', flag = 1},
    revive = {dict = 'mini@cpr@char_a@cpr_str', anim = 'cpr_pumpchest', flag = 1},
    examine = {dict = 'amb@medic@standing@knees@idle_a', anim = 'idle_a', flag = 1},
    sedate = {dict = 'amb@medic@standing@knees@base', anim = 'base', flag = 1},
    sample = {dict = 'amb@medic@standing@knees@base', anim = 'base', flag = 1},
    injure = {dict = 'melee@unarmed@streamed_core', anim = 'heavy_punch_a', flag = 0},
}

return Config
