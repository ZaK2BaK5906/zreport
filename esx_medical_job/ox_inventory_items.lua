-- ===========================================
-- ITEMS OX_INVENTORY - MÉDECIN SCIENTIFIQUE
-- ===========================================
--
-- INSTALLATION:
-- 1. Ouvrir ox_inventory/data/items.lua
-- 2. Copier tout le contenu ci-dessous
-- 3. Coller à la fin du fichier items.lua (avant le return)
-- 4. Redémarrer ox_inventory
--
-- ===========================================

return {
    -- ===========================================
    -- ÉQUIPEMENT MÉDICAL
    -- ===========================================

    ['medikit_advanced'] = {
        label = 'Kit Médical Avancé',
        weight = 500,
        stack = true,
        close = true,
        description = 'Kit médical professionnel pour soigner les patients',
        client = {
            image = 'medikit.png',
        }
    },

    ['defib_pro'] = {
        label = 'Défibrillateur Professionnel',
        weight = 1000,
        stack = false,
        close = true,
        description = 'Défibrillateur pour réanimer les patients en arrêt cardiaque',
        client = {
            image = 'defib.png',
        }
    },

    ['stethoscope_digital'] = {
        label = 'Stéthoscope Numérique',
        weight = 200,
        stack = true,
        close = true,
        description = 'Stéthoscope électronique pour examiner les patients',
        client = {
            image = 'stethoscope.png',
        }
    },

    ['medical_scanner'] = {
        label = 'Scanner Médical',
        weight = 800,
        stack = false,
        close = true,
        description = 'Scanner portable pour diagnostics avancés',
        client = {
            image = 'scanner.png',
        }
    },

    -- ===========================================
    -- MÉDICAMENTS ET SÉDATIFS
    -- ===========================================

    ['sedative_light'] = {
        label = 'Sédatif Léger',
        weight = 100,
        stack = true,
        close = true,
        description = 'Sédatif léger pour calmer les patients',
        client = {
            image = 'sedative.png',
        }
    },

    ['sedative_heavy'] = {
        label = 'Sédatif Puissant',
        weight = 150,
        stack = true,
        close = true,
        description = 'Sédatif puissant pour endormir rapidement',
        client = {
            image = 'sedative_heavy.png',
        }
    },

    ['anesthetic'] = {
        label = 'Anesthésiant',
        weight = 200,
        stack = true,
        close = true,
        description = 'Anesthésiant pour interventions chirurgicales',
        client = {
            image = 'anesthetic.png',
        }
    },

    ['morphine'] = {
        label = 'Morphine',
        weight = 150,
        stack = true,
        close = true,
        description = 'Antidouleur puissant pour soins intensifs',
        client = {
            image = 'morphine.png',
        }
    },

    ['adrenaline'] = {
        label = 'Adrénaline',
        weight = 100,
        stack = true,
        close = true,
        description = 'Injection d\'adrénaline pour urgences vitales',
        client = {
            image = 'adrenaline.png',
        }
    },

    -- ===========================================
    -- ÉQUIPEMENT CHIRURGICAL
    -- ===========================================

    ['surgical_kit_basic'] = {
        label = 'Kit Chirurgical Basique',
        weight = 1500,
        stack = false,
        close = true,
        description = 'Kit chirurgical pour interventions mineures',
        client = {
            image = 'surgical_kit.png',
        }
    },

    ['surgical_kit_advanced'] = {
        label = 'Kit Chirurgical Avancé',
        weight = 2000,
        stack = false,
        close = true,
        description = 'Kit chirurgical professionnel pour chirurgies complexes',
        client = {
            image = 'surgical_kit_advanced.png',
        }
    },

    ['scalpel'] = {
        label = 'Scalpel Chirurgical',
        weight = 200,
        stack = true,
        close = true,
        description = 'Scalpel stérile à usage unique',
        client = {
            image = 'scalpel.png',
        }
    },

    ['surgical_saw'] = {
        label = 'Scie Chirurgicale',
        weight = 800,
        stack = false,
        close = true,
        description = 'Scie électrique pour chirurgie osseuse',
        client = {
            image = 'surgical_saw.png',
        }
    },

    -- ===========================================
    -- MATÉRIEL DE PRÉLÈVEMENT
    -- ===========================================

    ['syringe_sterile'] = {
        label = 'Seringue Stérile',
        weight = 50,
        stack = true,
        close = true,
        description = 'Seringue stérile pour prélèvements',
        client = {
            image = 'syringe.png',
        }
    },

    ['blood_bag'] = {
        label = 'Poche de Sang',
        weight = 150,
        stack = true,
        close = true,
        description = 'Poche pour collecte et conservation du sang',
        client = {
            image = 'blood_bag.png',
        }
    },

    ['sample_container'] = {
        label = 'Conteneur à Échantillon',
        weight = 100,
        stack = true,
        close = true,
        description = 'Conteneur stérile pour échantillons biologiques',
        client = {
            image = 'sample_container.png',
        }
    },

    ['biopsy_needle'] = {
        label = 'Aiguille de Biopsie',
        weight = 150,
        stack = true,
        close = true,
        description = 'Aiguille pour prélèvements de tissus',
        client = {
            image = 'biopsy_needle.png',
        }
    },

    -- ===========================================
    -- ÉCHANTILLONS BIOLOGIQUES (MARCHÉ NOIR)
    -- ===========================================

    ['bone_sample'] = {
        label = 'Échantillon d\'Os',
        weight = 200,
        stack = true,
        close = true,
        description = 'Échantillon osseux prélevé - ILLÉGAL',
        client = {
            image = 'bone_sample.png',
        }
    },

    ['skin_sample'] = {
        label = 'Échantillon de Peau',
        weight = 150,
        stack = true,
        close = true,
        description = 'Échantillon cutané prélevé - ILLÉGAL',
        client = {
            image = 'skin_sample.png',
        }
    },

    ['blood_sample'] = {
        label = 'Échantillon de Sang',
        weight = 100,
        stack = true,
        close = true,
        description = 'Échantillon sanguin pour analyses',
        client = {
            image = 'blood_sample.png',
        }
    },

    ['tissue_sample'] = {
        label = 'Échantillon de Tissu',
        weight = 150,
        stack = true,
        close = true,
        description = 'Échantillon de tissu cellulaire - ILLÉGAL',
        client = {
            image = 'tissue_sample.png',
        }
    },

    ['organ_sample'] = {
        label = 'Échantillon d\'Organe',
        weight = 300,
        stack = true,
        close = true,
        description = 'Fragment d\'organe prélevé - TRÈS ILLÉGAL',
        client = {
            image = 'organ_sample.png',
        }
    },

    -- ===========================================
    -- SOINS
    -- ===========================================

    ['bandage_sterile'] = {
        label = 'Bandage Stérile',
        weight = 100,
        stack = true,
        close = true,
        description = 'Bandage stérile pour plaies',
        client = {
            image = 'bandage.png',
        }
    },

    ['medical_tape'] = {
        label = 'Bande Médicale',
        weight = 50,
        stack = true,
        close = true,
        description = 'Bande adhésive médicale',
        client = {
            image = 'medical_tape.png',
        }
    },

    ['gauze'] = {
        label = 'Compresse de Gaze',
        weight = 50,
        stack = true,
        close = true,
        description = 'Compresse stérile pour soins',
        client = {
            image = 'gauze.png',
        }
    },

    ['antibiotic'] = {
        label = 'Antibiotique',
        weight = 100,
        stack = true,
        close = true,
        description = 'Antibiotique large spectre',
        client = {
            image = 'antibiotic.png',
        }
    },

    ['painkiller'] = {
        label = 'Antidouleur',
        weight = 80,
        stack = true,
        close = true,
        description = 'Antidouleur standard',
        client = {
            image = 'painkiller.png',
        }
    },

    -- ===========================================
    -- ÉQUIPEMENT DE PROTECTION
    -- ===========================================

    ['surgical_mask'] = {
        label = 'Masque Chirurgical',
        weight = 50,
        stack = true,
        close = true,
        description = 'Masque de protection chirurgical',
        client = {
            image = 'surgical_mask.png',
        }
    },

    ['latex_gloves'] = {
        label = 'Gants Latex',
        weight = 30,
        stack = true,
        close = true,
        description = 'Gants en latex stériles',
        client = {
            image = 'latex_gloves.png',
        }
    },

    ['lab_coat'] = {
        label = 'Blouse de Laboratoire',
        weight = 500,
        stack = false,
        close = true,
        description = 'Blouse blanche de laboratoire',
        client = {
            image = 'lab_coat.png',
        }
    },
}
