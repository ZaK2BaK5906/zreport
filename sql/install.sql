-- ============================================
-- ZREPORT - Base de données SQL
-- ============================================
-- Ce fichier est OPTIONNEL et n'est nécessaire que si vous
-- activez Config.SaveRespondedReports = true dans config.lua
-- ============================================

CREATE TABLE IF NOT EXISTS `zreport_stats` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `identifier` VARCHAR(50) NOT NULL,
    `admin_name` VARCHAR(100) NOT NULL,
    `reports_completed` INT(11) NOT NULL DEFAULT 0,
    `last_updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- INSTRUCTIONS
-- ============================================
-- 1. Importez ce fichier dans votre base de données MySQL
-- 2. Dans config.lua, mettez Config.SaveRespondedReports à true
-- 3. Configurez le bon type de database dans Config.Database
-- ============================================
