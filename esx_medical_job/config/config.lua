Config = {}

-- Configuration générale
Config.Locale = 'fr'
Config.JobName = 'ambulance'

-- Permissions
Config.EnableLegalActions = true  -- Soins légaux
Config.EnableIllegalActions = true -- Prélèvements illégaux

-- Prix et gains
Config.Prices = {
    heal = 500,           -- Prix pour soigner
    revive = 1000,        -- Prix pour réanimer
    examine = 200,        -- Prix pour examiner
    sedate = 300,         -- Prix pour endormir
    boneSample = 2500,    -- Gain pour prélèvement d'os (marché noir)
    skinSample = 1500,    -- Gain pour prélèvement de peau (marché noir)
    bloodSample = 800,    -- Gain pour prélèvement de sang
}

-- Items nécessaires
Config.RequiredItems = {
    heal = 'medikit',
    revive = 'defib',
    examine = 'stethoscope',
    sedate = 'sedative',
    boneSample = 'surgical_kit',
    skinSample = 'surgical_kit',
    bloodSample = 'syringe',
}

-- Durées des actions (en millisecondes)
Config.ActionDurations = {
    heal = 8000,
    revive = 15000,
    examine = 6000,
    sedate = 5000,
    boneSample = 12000,
    skinSample = 10000,
    bloodSample = 7000,
    injure = 4000,
}

-- Items donnés après prélèvement
Config.SampleItems = {
    bone = 'bone_sample',
    skin = 'skin_sample',
    blood = 'blood_sample',
}

-- Hôpitaux et points d'interaction
Config.Hospitals = {
    {
        name = "Hôpital Central",
        blip = {coords = vector3(307.7, -1433.4, 29.9), sprite = 61, color = 2, scale = 0.8},

        -- Vestiaire
        cloakroom = {
            coords = vector3(298.6, -1428.5, 29.9),
            size = vector3(2.0, 2.0, 2.0),
            rotation = 45.0,
        },

        -- Pharmacie
        pharmacy = {
            coords = vector3(306.4, -1433.2, 29.9),
            size = vector3(2.0, 2.0, 2.0),
            rotation = 45.0,
        },

        -- Laboratoire (pour activités scientifiques)
        laboratory = {
            coords = vector3(310.2, -1440.8, 29.9),
            size = vector3(3.0, 3.0, 2.0),
            rotation = 45.0,
        },

        -- Garage véhicules
        garage = {
            coords = vector3(294.3, -1448.1, 29.9),
            size = vector3(3.0, 3.0, 2.0),
            rotation = 45.0,
            vehicles = {
                {name = 'ambulance', label = 'Ambulance', price = 0},
                {name = 'lguard', label = 'Maître Nageur', price = 0},
            }
        },
    },

    -- Sandy Shores
    {
        name = "Clinique Sandy Shores",
        blip = {coords = vector3(1839.6, 3672.9, 34.2), sprite = 61, color = 2, scale = 0.7},

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

        garage = {
            coords = vector3(1830.2, 3680.5, 34.2),
            size = vector3(3.0, 3.0, 2.0),
            rotation = 120.0,
            vehicles = {
                {name = 'ambulance', label = 'Ambulance', price = 0},
            }
        },
    },

    -- Paleto Bay
    {
        name = "Clinique Paleto Bay",
        blip = {coords = vector3(-247.8, 6331.5, 32.4), sprite = 61, color = 2, scale = 0.7},

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

        garage = {
            coords = vector3(-262.4, 6315.5, 32.4),
            size = vector3(3.0, 3.0, 2.0),
            rotation = 45.0,
            vehicles = {
                {name = 'ambulance', label = 'Ambulance', price = 0},
            }
        },
    },
}

-- Marché noir (pour vendre les prélèvements)
Config.BlackMarket = {
    coords = vector3(2434.8, 4969.2, 42.3),
    size = vector3(2.0, 2.0, 2.0),
    rotation = 45.0,
    ped = {
        model = 's_m_m_scientist_01',
        coords = vector4(2434.8, 4969.2, 41.3, 312.4),
    }
}

-- Tenues
Config.Uniforms = {
    male = {
        {label = 'Tenue de Médecin', outfit = {
            ['tshirt_1'] = 15, ['tshirt_2'] = 0,
            ['torso_1'] = 249, ['torso_2'] = 0,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 85,
            ['pants_1'] = 96, ['pants_2'] = 0,
            ['shoes_1'] = 24, ['shoes_2'] = 0,
            ['chain_1'] = 126, ['chain_2'] = 0,
        }},
        {label = 'Tenue de Chirurgien', outfit = {
            ['tshirt_1'] = 15, ['tshirt_2'] = 0,
            ['torso_1'] = 250, ['torso_2'] = 0,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 86,
            ['pants_1'] = 97, ['pants_2'] = 0,
            ['shoes_1'] = 24, ['shoes_2'] = 0,
        }},
    },
    female = {
        {label = 'Tenue de Médecin', outfit = {
            ['tshirt_1'] = 14, ['tshirt_2'] = 0,
            ['torso_1'] = 258, ['torso_2'] = 0,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 101,
            ['pants_1'] = 99, ['pants_2'] = 0,
            ['shoes_1'] = 24, ['shoes_2'] = 0,
            ['chain_1'] = 96, ['chain_2'] = 0,
        }},
        {label = 'Tenue de Chirurgien', outfit = {
            ['tshirt_1'] = 14, ['tshirt_2'] = 0,
            ['torso_1'] = 259, ['torso_2'] = 0,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 102,
            ['pants_1'] = 100, ['pants_2'] = 0,
            ['shoes_1'] = 24, ['shoes_2'] = 0,
        }},
    },
}

-- Items de la pharmacie
Config.PharmacyItems = {
    {item = 'medikit', label = 'Kit médical', price = 150},
    {item = 'bandage', label = 'Bandage', price = 50},
    {item = 'defib', label = 'Défibrillateur', price = 500},
    {item = 'stethoscope', label = 'Stéthoscope', price = 100},
    {item = 'sedative', label = 'Sédatif', price = 200},
    {item = 'surgical_kit', label = 'Kit chirurgical', price = 800},
    {item = 'syringe', label = 'Seringue', price = 80},
}

-- Messages
Config.Messages = {
    no_permission = "Vous n'êtes pas médecin !",
    no_players_nearby = "Aucun joueur à proximité",
    no_item = "Vous n'avez pas l'item nécessaire",
    player_not_unconscious = "Le patient n'est pas inconscient",
    player_healed = "Vous avez soigné le patient",
    player_revived = "Vous avez réanimé le patient",
    player_examined = "Examen médical effectué",
    player_sedated = "Patient endormi",
    player_injured = "Vous avez blessé la personne",
    sample_taken = "Prélèvement effectué avec succès",
    illegal_action = "Action illégale détectée - Soyez discret !",
}
