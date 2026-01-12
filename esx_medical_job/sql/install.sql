-- ===========================================
-- ESX MEDICAL JOB - BASE DE DONNÉES
-- ===========================================

-- Table pour suivre les prélèvements effectués
CREATE TABLE IF NOT EXISTS `medical_samples` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `medic_identifier` VARCHAR(60) NOT NULL,
    `patient_identifier` VARCHAR(60) NOT NULL,
    `sample_type` ENUM('bone', 'skin', 'blood') NOT NULL,
    `timestamp` INT(11) NOT NULL,
    PRIMARY KEY (`id`),
    INDEX `medic_identifier` (`medic_identifier`),
    INDEX `patient_identifier` (`patient_identifier`),
    INDEX `sample_type` (`sample_type`),
    INDEX `timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table pour le marché noir
CREATE TABLE IF NOT EXISTS `medical_black_market` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `seller_identifier` VARCHAR(60) NOT NULL,
    `sample_type` ENUM('bone', 'skin', 'blood') NOT NULL,
    `price` INT(11) NOT NULL,
    `timestamp` INT(11) NOT NULL,
    PRIMARY KEY (`id`),
    INDEX `seller_identifier` (`seller_identifier`),
    INDEX `sample_type` (`sample_type`),
    INDEX `timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table pour les statistiques des médecins
CREATE TABLE IF NOT EXISTS `medical_stats` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `medic_identifier` VARCHAR(60) NOT NULL,
    `action_type` VARCHAR(50) NOT NULL,
    `timestamp` INT(11) NOT NULL,
    PRIMARY KEY (`id`),
    INDEX `medic_identifier` (`medic_identifier`),
    INDEX `action_type` (`action_type`),
    INDEX `timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ===========================================
-- ITEMS POUR LE JOB MÉDICAL
-- ===========================================

-- Insertion des items dans la table items (si elle existe)
INSERT IGNORE INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
    ('medikit', 'Kit médical', 1, 0, 1),
    ('bandage', 'Bandage', 1, 0, 1),
    ('defib', 'Défibrillateur', 3, 0, 1),
    ('stethoscope', 'Stéthoscope', 1, 0, 1),
    ('sedative', 'Sédatif', 1, 0, 1),
    ('surgical_kit', 'Kit chirurgical', 2, 0, 1),
    ('syringe', 'Seringue', 1, 0, 1),
    ('bone_sample', 'Échantillon d\'os', 1, 1, 1),
    ('skin_sample', 'Échantillon de peau', 1, 1, 1),
    ('blood_sample', 'Échantillon de sang', 1, 0, 1)
ON DUPLICATE KEY UPDATE
    `label` = VALUES(`label`),
    `weight` = VALUES(`weight`);

-- ===========================================
-- DONNÉES DE TEST (OPTIONNEL - À SUPPRIMER EN PRODUCTION)
-- ===========================================

-- Uncomment pour ajouter des données de test
/*
-- Exemple de prélèvement
INSERT INTO `medical_samples` (`medic_identifier`, `patient_identifier`, `sample_type`, `timestamp`) VALUES
    ('char1:example123', 'char2:example456', 'blood', UNIX_TIMESTAMP());

-- Exemple de vente au marché noir
INSERT INTO `medical_black_market` (`seller_identifier`, `sample_type`, `price`, `timestamp`) VALUES
    ('char1:example123', 'bone', 2500, UNIX_TIMESTAMP());

-- Exemple de statistiques
INSERT INTO `medical_stats` (`medic_identifier`, `action_type`, `timestamp`) VALUES
    ('char1:example123', 'heal', UNIX_TIMESTAMP()),
    ('char1:example123', 'revive', UNIX_TIMESTAMP());
*/

-- ===========================================
-- VUES POUR STATISTIQUES
-- ===========================================

-- Vue pour les statistiques des médecins
CREATE OR REPLACE VIEW `medical_stats_view` AS
SELECT
    ms.medic_identifier,
    ms.action_type,
    COUNT(*) as total_actions,
    MAX(ms.timestamp) as last_action
FROM medical_stats ms
GROUP BY ms.medic_identifier, ms.action_type;

-- Vue pour les prélèvements illégaux
CREATE OR REPLACE VIEW `medical_illegal_samples_view` AS
SELECT
    ms.medic_identifier,
    ms.patient_identifier,
    ms.sample_type,
    FROM_UNIXTIME(ms.timestamp) as sample_date
FROM medical_samples ms
WHERE ms.sample_type IN ('bone', 'skin')
ORDER BY ms.timestamp DESC;

-- Vue pour le marché noir
CREATE OR REPLACE VIEW `medical_black_market_view` AS
SELECT
    mbm.seller_identifier,
    mbm.sample_type,
    mbm.price,
    FROM_UNIXTIME(mbm.timestamp) as sale_date,
    COUNT(*) OVER (PARTITION BY mbm.seller_identifier) as total_sales,
    SUM(mbm.price) OVER (PARTITION BY mbm.seller_identifier) as total_earnings
FROM medical_black_market mbm
ORDER BY mbm.timestamp DESC;

-- ===========================================
-- PERMISSIONS ET INDEX
-- ===========================================

-- Optimisation des index pour les requêtes fréquentes
ALTER TABLE `medical_samples`
    ADD INDEX `idx_medic_sample` (`medic_identifier`, `sample_type`),
    ADD INDEX `idx_timestamp_desc` (`timestamp` DESC);

ALTER TABLE `medical_black_market`
    ADD INDEX `idx_seller_timestamp` (`seller_identifier`, `timestamp` DESC);

ALTER TABLE `medical_stats`
    ADD INDEX `idx_medic_action` (`medic_identifier`, `action_type`),
    ADD INDEX `idx_timestamp_desc` (`timestamp` DESC);

-- ===========================================
-- PROCÉDURES STOCKÉES (OPTIONNEL)
-- ===========================================

DELIMITER $$

-- Procédure pour obtenir les stats d'un médecin
CREATE PROCEDURE IF NOT EXISTS `GetMedicStats`(IN medic_id VARCHAR(60))
BEGIN
    SELECT
        action_type,
        COUNT(*) as count,
        MAX(FROM_UNIXTIME(timestamp)) as last_action
    FROM medical_stats
    WHERE medic_identifier = medic_id
    GROUP BY action_type;
END$$

-- Procédure pour obtenir les prélèvements d'un médecin
CREATE PROCEDURE IF NOT EXISTS `GetMedicSamples`(IN medic_id VARCHAR(60))
BEGIN
    SELECT
        patient_identifier,
        sample_type,
        FROM_UNIXTIME(timestamp) as sample_date
    FROM medical_samples
    WHERE medic_identifier = medic_id
    ORDER BY timestamp DESC
    LIMIT 100;
END$$

-- Procédure pour nettoyer les anciennes données (>30 jours)
CREATE PROCEDURE IF NOT EXISTS `CleanOldMedicalData`()
BEGIN
    DECLARE days_to_keep INT DEFAULT 30;
    DECLARE cutoff_timestamp INT;

    SET cutoff_timestamp = UNIX_TIMESTAMP() - (days_to_keep * 24 * 60 * 60);

    -- Nettoyer les anciennes stats
    DELETE FROM medical_stats WHERE timestamp < cutoff_timestamp;

    -- Nettoyer les anciens prélèvements
    DELETE FROM medical_samples WHERE timestamp < cutoff_timestamp;

    -- Nettoyer les anciennes ventes
    DELETE FROM medical_black_market WHERE timestamp < cutoff_timestamp;

    SELECT CONCAT('Nettoyage effectué - Données de plus de ', days_to_keep, ' jours supprimées') AS result;
END$$

DELIMITER ;

-- ===========================================
-- ÉVÉNEMENTS AUTOMATIQUES (OPTIONNEL)
-- ===========================================

-- Nettoyer automatiquement les vieilles données tous les 7 jours
-- Décommenter pour activer
/*
CREATE EVENT IF NOT EXISTS `auto_clean_medical_data`
ON SCHEDULE EVERY 7 DAY
STARTS CURRENT_TIMESTAMP
DO CALL CleanOldMedicalData();
*/

-- ===========================================
-- FIN DU SCRIPT
-- ===========================================

-- Message de confirmation
SELECT '✅ Base de données ESX Medical Job installée avec succès !' AS status;
