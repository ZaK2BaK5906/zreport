-- ===========================================
-- MÉDECIN SCIENTIFIQUE - SQL COMPLET ESX + OX
-- ===========================================

-- ===========================================
-- 1. CRÉATION DU JOB
-- ===========================================

INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
    ('medecin_scientifique', 'Médecin Scientifique', 1)
ON DUPLICATE KEY UPDATE
    `label` = 'Médecin Scientifique',
    `whitelisted` = 1;

-- ===========================================
-- 2. GRADES DU JOB
-- ===========================================

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
    ('medecin_scientifique', 0, 'stagiaire', 'Stagiaire Médical', 250, '{}', '{}'),
    ('medecin_scientifique', 1, 'infirmier', 'Infirmier', 500, '{}', '{}'),
    ('medecin_scientifique', 2, 'medecin', 'Médecin', 800, '{}', '{}'),
    ('medecin_scientifique', 3, 'chirurgien', 'Chirurgien', 1200, '{}', '{}'),
    ('medecin_scientifique', 4, 'scientifique', 'Scientifique', 1500, '{}', '{}'),
    ('medecin_scientifique', 5, 'chef_scientifique', 'Chef Scientifique', 2000, '{}', '{}'),
    ('medecin_scientifique', 6, 'directeur', 'Directeur Médical', 2500, '{}', '{}')
ON DUPLICATE KEY UPDATE
    `label` = VALUES(`label`),
    `salary` = VALUES(`salary`);

-- ===========================================
-- 3. ADDON ACCOUNTS (Comptes bancaires société)
-- ===========================================

INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
    ('society_medecin_scientifique', 'Médecin Scientifique', 1)
ON DUPLICATE KEY UPDATE
    `label` = 'Médecin Scientifique',
    `shared` = 1;

INSERT INTO `addon_account_data` (`account_name`, `money`) VALUES
    ('society_medecin_scientifique', 50000)
ON DUPLICATE KEY UPDATE
    `money` = 50000;

-- ===========================================
-- 4. ADDON INVENTORY (Inventaire société)
-- ===========================================

INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
    ('society_medecin_scientifique', 'Médecin Scientifique', 1)
ON DUPLICATE KEY UPDATE
    `label` = 'Médecin Scientifique',
    `shared` = 1;

-- ===========================================
-- 5. ITEMS OX_INVENTORY
-- ===========================================

-- Items médicaux de base
INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
    -- Équipement médical
    ('medikit_advanced', 'Kit Médical Avancé', 500, 0, 1),
    ('defib_pro', 'Défibrillateur Professionnel', 1000, 0, 1),
    ('stethoscope_digital', 'Stéthoscope Numérique', 200, 0, 1),
    ('medical_scanner', 'Scanner Médical', 800, 0, 1),

    -- Médicaments et sédatifs
    ('sedative_light', 'Sédatif Léger', 100, 0, 1),
    ('sedative_heavy', 'Sédatif Puissant', 150, 1, 1),
    ('anesthetic', 'Anesthésiant', 200, 0, 1),
    ('morphine', 'Morphine', 150, 1, 1),
    ('adrenaline', 'Adrénaline', 100, 0, 1),

    -- Équipement chirurgical
    ('surgical_kit_basic', 'Kit Chirurgical Basique', 1500, 0, 1),
    ('surgical_kit_advanced', 'Kit Chirurgical Avancé', 2000, 1, 1),
    ('scalpel', 'Scalpel Chirurgical', 200, 0, 1),
    ('surgical_saw', 'Scie Chirurgicale', 800, 1, 1),

    -- Matériel de prélèvement
    ('syringe_sterile', 'Seringue Stérile', 50, 0, 1),
    ('blood_bag', 'Poche de Sang', 150, 0, 1),
    ('sample_container', 'Conteneur à Échantillon', 100, 0, 1),
    ('biopsy_needle', 'Aiguille de Biopsie', 150, 1, 1),

    -- Échantillons biologiques
    ('bone_sample', 'Échantillon d\'Os', 200, 1, 1),
    ('skin_sample', 'Échantillon de Peau', 150, 1, 1),
    ('blood_sample', 'Échantillon de Sang', 100, 0, 1),
    ('tissue_sample', 'Échantillon de Tissu', 150, 1, 1),
    ('organ_sample', 'Échantillon d\'Organe', 300, 1, 1),

    -- Soins
    ('bandage_sterile', 'Bandage Stérile', 100, 0, 1),
    ('medical_tape', 'Bande Médicale', 50, 0, 1),
    ('gauze', 'Compresse de Gaze', 50, 0, 1),
    ('antibiotic', 'Antibiotique', 100, 0, 1),
    ('painkiller', 'Antidouleur', 80, 0, 1),

    -- Équipement de protection
    ('surgical_mask', 'Masque Chirurgical', 50, 0, 1),
    ('latex_gloves', 'Gants Latex', 30, 0, 1),
    ('lab_coat', 'Blouse de Laboratoire', 500, 0, 1)
ON DUPLICATE KEY UPDATE
    `label` = VALUES(`label`),
    `weight` = VALUES(`weight`);

-- ===========================================
-- 6. TABLES CUSTOM MÉDECIN SCIENTIFIQUE
-- ===========================================

-- Table des prélèvements effectués
CREATE TABLE IF NOT EXISTS `medecin_samples` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `medic_identifier` VARCHAR(60) NOT NULL,
    `medic_name` VARCHAR(100) NOT NULL,
    `patient_identifier` VARCHAR(60) NOT NULL,
    `patient_name` VARCHAR(100) NOT NULL,
    `sample_type` ENUM('bone', 'skin', 'blood', 'tissue', 'organ') NOT NULL,
    `is_legal` TINYINT(1) NOT NULL DEFAULT 1,
    `location` VARCHAR(255) DEFAULT NULL,
    `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    INDEX `medic_identifier` (`medic_identifier`),
    INDEX `patient_identifier` (`patient_identifier`),
    INDEX `sample_type` (`sample_type`),
    INDEX `is_legal` (`is_legal`),
    INDEX `timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table du marché noir
CREATE TABLE IF NOT EXISTS `medecin_black_market` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `seller_identifier` VARCHAR(60) NOT NULL,
    `seller_name` VARCHAR(100) NOT NULL,
    `sample_type` ENUM('bone', 'skin', 'blood', 'tissue', 'organ') NOT NULL,
    `quantity` INT(11) NOT NULL DEFAULT 1,
    `price_per_unit` INT(11) NOT NULL,
    `total_price` INT(11) NOT NULL,
    `buyer_npc` VARCHAR(100) DEFAULT 'Scientifique Clandestin',
    `location` VARCHAR(255) DEFAULT NULL,
    `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    INDEX `seller_identifier` (`seller_identifier`),
    INDEX `sample_type` (`sample_type`),
    INDEX `timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table des statistiques des médecins
CREATE TABLE IF NOT EXISTS `medecin_stats` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `medic_identifier` VARCHAR(60) NOT NULL,
    `medic_name` VARCHAR(100) NOT NULL,
    `action_type` VARCHAR(50) NOT NULL,
    `patient_identifier` VARCHAR(60) DEFAULT NULL,
    `patient_name` VARCHAR(100) DEFAULT NULL,
    `success` TINYINT(1) NOT NULL DEFAULT 1,
    `payment` INT(11) DEFAULT 0,
    `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    INDEX `medic_identifier` (`medic_identifier`),
    INDEX `action_type` (`action_type`),
    INDEX `timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table des analyses en laboratoire
CREATE TABLE IF NOT EXISTS `medecin_lab_analysis` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `sample_id` INT(11) NOT NULL,
    `analyst_identifier` VARCHAR(60) NOT NULL,
    `analyst_name` VARCHAR(100) NOT NULL,
    `analysis_type` VARCHAR(100) NOT NULL,
    `results` TEXT DEFAULT NULL,
    `status` ENUM('pending', 'in_progress', 'completed') DEFAULT 'pending',
    `started_at` TIMESTAMP NULL DEFAULT NULL,
    `completed_at` TIMESTAMP NULL DEFAULT NULL,
    PRIMARY KEY (`id`),
    INDEX `sample_id` (`sample_id`),
    INDEX `analyst_identifier` (`analyst_identifier`),
    INDEX `status` (`status`),
    FOREIGN KEY (`sample_id`) REFERENCES `medecin_samples`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table des interventions médicales
CREATE TABLE IF NOT EXISTS `medecin_interventions` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `medic_identifier` VARCHAR(60) NOT NULL,
    `medic_name` VARCHAR(100) NOT NULL,
    `medic_grade` INT(11) NOT NULL,
    `patient_identifier` VARCHAR(60) NOT NULL,
    `patient_name` VARCHAR(100) NOT NULL,
    `intervention_type` VARCHAR(100) NOT NULL,
    `diagnosis` TEXT DEFAULT NULL,
    `treatment` TEXT DEFAULT NULL,
    `cost` INT(11) DEFAULT 0,
    `duration` INT(11) DEFAULT 0,
    `location` VARCHAR(255) DEFAULT NULL,
    `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    INDEX `medic_identifier` (`medic_identifier`),
    INDEX `patient_identifier` (`patient_identifier`),
    INDEX `intervention_type` (`intervention_type`),
    INDEX `timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ===========================================
-- 7. VUES POUR STATISTIQUES
-- ===========================================

-- Vue des meilleures ventes au marché noir
CREATE OR REPLACE VIEW `medecin_black_market_stats` AS
SELECT
    seller_identifier,
    seller_name,
    sample_type,
    COUNT(*) as total_sales,
    SUM(quantity) as total_quantity,
    SUM(total_price) as total_earnings,
    AVG(price_per_unit) as avg_price,
    MAX(timestamp) as last_sale
FROM medecin_black_market
GROUP BY seller_identifier, seller_name, sample_type;

-- Vue des statistiques des médecins
CREATE OR REPLACE VIEW `medecin_performance_stats` AS
SELECT
    ms.medic_identifier,
    ms.medic_name,
    ms.action_type,
    COUNT(*) as total_actions,
    SUM(ms.success) as successful_actions,
    ROUND((SUM(ms.success) / COUNT(*)) * 100, 2) as success_rate,
    SUM(ms.payment) as total_earnings,
    MAX(ms.timestamp) as last_action
FROM medecin_stats ms
GROUP BY ms.medic_identifier, ms.medic_name, ms.action_type;

-- Vue des prélèvements illégaux
CREATE OR REPLACE VIEW `medecin_illegal_activity` AS
SELECT
    ms.medic_identifier,
    ms.medic_name,
    ms.patient_identifier,
    ms.patient_name,
    ms.sample_type,
    ms.location,
    ms.timestamp
FROM medecin_samples ms
WHERE ms.is_legal = 0
ORDER BY ms.timestamp DESC;

-- ===========================================
-- 8. PROCÉDURES STOCKÉES
-- ===========================================

DELIMITER $$

-- Procédure pour enregistrer un prélèvement
CREATE PROCEDURE IF NOT EXISTS `RegisterSample`(
    IN p_medic_id VARCHAR(60),
    IN p_medic_name VARCHAR(100),
    IN p_patient_id VARCHAR(60),
    IN p_patient_name VARCHAR(100),
    IN p_sample_type VARCHAR(20),
    IN p_is_legal TINYINT,
    IN p_location VARCHAR(255)
)
BEGIN
    INSERT INTO medecin_samples (
        medic_identifier,
        medic_name,
        patient_identifier,
        patient_name,
        sample_type,
        is_legal,
        location
    ) VALUES (
        p_medic_id,
        p_medic_name,
        p_patient_id,
        p_patient_name,
        p_sample_type,
        p_is_legal,
        p_location
    );

    SELECT LAST_INSERT_ID() as sample_id;
END$$

-- Procédure pour enregistrer une vente au marché noir
CREATE PROCEDURE IF NOT EXISTS `RegisterBlackMarketSale`(
    IN p_seller_id VARCHAR(60),
    IN p_seller_name VARCHAR(100),
    IN p_sample_type VARCHAR(20),
    IN p_quantity INT,
    IN p_price_per_unit INT,
    IN p_location VARCHAR(255)
)
BEGIN
    DECLARE total INT;
    SET total = p_quantity * p_price_per_unit;

    INSERT INTO medecin_black_market (
        seller_identifier,
        seller_name,
        sample_type,
        quantity,
        price_per_unit,
        total_price,
        location
    ) VALUES (
        p_seller_id,
        p_seller_name,
        p_sample_type,
        p_quantity,
        p_price_per_unit,
        total,
        p_location
    );

    SELECT total as earned_amount;
END$$

-- Procédure pour nettoyer les anciennes données
CREATE PROCEDURE IF NOT EXISTS `CleanOldMedicalData`(IN days_to_keep INT)
BEGIN
    DECLARE cutoff_date TIMESTAMP;
    SET cutoff_date = DATE_SUB(NOW(), INTERVAL days_to_keep DAY);

    -- Supprimer les vieilles stats
    DELETE FROM medecin_stats WHERE timestamp < cutoff_date;

    -- Supprimer les vieux prélèvements
    DELETE FROM medecin_samples WHERE timestamp < cutoff_date;

    -- Supprimer les vieilles ventes
    DELETE FROM medecin_black_market WHERE timestamp < cutoff_date;

    -- Supprimer les vieilles interventions
    DELETE FROM medecin_interventions WHERE timestamp < cutoff_date;

    SELECT CONCAT('Données de plus de ', days_to_keep, ' jours supprimées') AS result;
END$$

-- Procédure pour obtenir le top des médecins
CREATE PROCEDURE IF NOT EXISTS `GetTopMedics`(IN limit_count INT)
BEGIN
    SELECT
        medic_identifier,
        medic_name,
        COUNT(*) as total_interventions,
        SUM(cost) as total_revenue,
        AVG(duration) as avg_duration
    FROM medecin_interventions
    GROUP BY medic_identifier, medic_name
    ORDER BY total_interventions DESC
    LIMIT limit_count;
END$$

DELIMITER ;

-- ===========================================
-- 9. TRIGGERS
-- ===========================================

DELIMITER $$

-- Trigger pour enregistrer automatiquement les stats après intervention
CREATE TRIGGER IF NOT EXISTS `after_intervention_insert`
AFTER INSERT ON `medecin_interventions`
FOR EACH ROW
BEGIN
    INSERT INTO medecin_stats (
        medic_identifier,
        medic_name,
        action_type,
        patient_identifier,
        patient_name,
        success,
        payment
    ) VALUES (
        NEW.medic_identifier,
        NEW.medic_name,
        NEW.intervention_type,
        NEW.patient_identifier,
        NEW.patient_name,
        1,
        NEW.cost
    );
END$$

DELIMITER ;

-- ===========================================
-- 10. ÉVÉNEMENTS AUTOMATIQUES
-- ===========================================

-- Nettoyer automatiquement les vieilles données tous les 7 jours
-- Décommenter pour activer
/*
SET GLOBAL event_scheduler = ON;

CREATE EVENT IF NOT EXISTS `auto_clean_medical_data`
ON SCHEDULE EVERY 7 DAY
STARTS CURRENT_TIMESTAMP
DO CALL CleanOldMedicalData(30);
*/

-- ===========================================
-- 11. DONNÉES DE TEST (OPTIONNEL)
-- ===========================================

-- Décommenter pour ajouter des données de test
/*
-- Test intervention
CALL RegisterSample(
    'char1:test123',
    'Dr. John Doe',
    'char2:test456',
    'Jane Patient',
    'blood',
    1,
    'Hospital Central'
);

-- Test vente marché noir
CALL RegisterBlackMarketSale(
    'char1:test123',
    'Dr. Evil',
    'bone',
    3,
    2500,
    'Secret Location'
);
*/

-- ===========================================
-- FIN DU SCRIPT
-- ===========================================

SELECT '✅ Base de données Médecin Scientifique installée avec succès !' AS status,
       'Job: medecin_scientifique | 7 grades | Items OX | Tables complètes' AS info;
