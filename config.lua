Config = {}

-- ============================================
-- CONFIGURATION GÉNÉRALE
-- ============================================

Config.Debug = false

Config.Framework = 'ESX' -- ESX / QB / STANDALONE

Config.UseNewStaffCheckMethod = true -- QBCORE et ESX UNIQUEMENT - true = vérifiera si un joueur est staff d'une autre manière (RECOMMANDÉ pour ESX)

Config.UseAcePermissions = false -- ESX UNIQUEMENT - true = utilisera aussi les ACE permissions en plus de xPlayer.getGroup()

Config.QBPermissionsUpdate = false -- QBCORE UNIQUEMENT - mettez à true si vous avez la dernière mise à jour des permissions

-- ============================================
-- COMMANDES
-- ============================================

Config.ReportCommand = 'report' -- Commande pour les joueurs pour créer un report

Config.AdminReportCommand = 'reports' -- Commande pour les admins pour vérifier les reports

Config.NotificationToggleCommand = 'rn' -- Commande pour activer/désactiver les notifications

-- ============================================
-- OPTIONS
-- ============================================

Config.UseSteamNames = false -- Utilise les noms Steam au lieu des noms de jeu

Config.SaveRespondedReports = false -- Sauvegarde le nombre de reports complétés par les admins dans la base de données

Config.Database = 'mysql-async' -- mysql-async / oxmysql / ghmattimysql (Utilisé si Config.SaveRespondedReports est à true)

Config.NoAdminAssistingText = 'Aucun' -- Texte affiché quand aucun admin n'assiste

Config.TeleportBackAfterConcluding = true -- Téléporte l'admin à sa position d'origine après avoir conclu un report

Config.NewReportNotifyType = 'STANDALONE' -- QB ou STANDALONE

Config.LatestSendNotifyToAdmin = true -- Envoie une notification au dernier admin qui a répondu

Config.GetAllPlayersForNotify = false -- Envoie les notifications à tous les admins en ligne

-- ============================================
-- CATÉGORIES DE REPORTS (Traduction)
-- ============================================

Config.ReportCategoriesTranslation = {
	player = "SIGNALER UN JOUEUR",
	bug = "SIGNALER UN BUG",
	question = "POSER UNE QUESTION"
}

-- ============================================
-- GROUPES D'ADMINISTRATEURS
-- ============================================

Config.AdminGroups = { -- Utilisé pour ESX et QB
	'god',
	'superadmin',
	'admin',
	'mod'
}

-- Utilisé pour définir les admins lors de l'utilisation de la version STANDALONE
-- Types d'identifiants: steam: | license: | xbl: | live: | discord: | fivem: | ip:
Config.StandaloneStaffIdentifiers = {
	'license:9asg8d9812g3989as8dy8912398123y89123y221', -- Exemple, changez ceci
	'license:09asyhhdh8912h389asgdhh912g389asgd98y123' -- Exemple, changez ceci
}

-- ============================================
-- NOTIFICATIONS
-- ============================================

Config.Notifications = {
	['success_rep'] = {
		title = 'REPORT',
		text = 'Vous avez créé un report avec succès',
		time = 5000,
		type = 'success'
	},
	['adm_answered'] = {
		title = 'REPORT',
		text = 'Un administrateur vous a répondu',
		time = 5000,
		type = 'info'
	},
	['player_answered'] = {
		title = 'REPORT',
		text = '#${id} - ${name} vous a répondu',
		time = 5000,
		type = 'info'
	},
	['adm_assist'] = {
		title = 'REPORT',
		text = 'Un administrateur vous assiste',
		time = 5000,
		type = 'info'
	},
	['rep_concluded'] = {
		title = 'REPORT',
		text = 'Votre report a été conclu',
		time = 5000,
		type = 'success'
	},
	['rep_canceled'] = {
		title = 'REPORT',
		text = 'Vous avez annulé votre report',
		time = 5000,
		type = 'error'
	},
	['adm_rep_concluded'] = {
		title = 'REPORT',
		text = 'Le report #${id} a été conclu',
		time = 5000,
		type = 'success'
	},
	['new_rep'] = {
		title = 'REPORT',
		text = 'Il y a un nouveau report',
		time = 5000,
		type = 'info'
	},
	['rep_not_on'] = {
		title = 'REPORT',
		text = 'Vous avez activé les notifications de reports !',
		time = 5000,
		type = 'success'
	},
	['rep_not_off'] = {
		title = 'REPORT',
		text = 'Vous avez désactivé les notifications de reports !',
		time = 5000,
		type = 'error'
	},
	['rep_not_exist'] = {
		title = 'REPORT',
		text = 'Ce report n\'existe pas !',
		time = 5000,
		type = 'error'
	},
	['already_have_report'] = {
		title = 'REPORT',
		text = 'Vous avez déjà un report ouvert !',
		time = 5000,
		type = 'error'
	},
	['cannot_cancel'] = {
		title = 'REPORT',
		text = 'Vous ne pouvez plus annuler ce report car un admin a déjà interagi !',
		time = 5000,
		type = 'error'
	},
}

-- ============================================
-- SUGGESTIONS DE COMMANDES
-- ============================================

Config.CommandSuggestions = {
	['report'] = {
		text = 'Commande pour créer ou vérifier votre report'
	},
	['adm_report'] = {
		text = 'Commande pour vérifier les reports ouverts'
	},
	['adm_notifications'] = {
		text = 'Commande pour activer/désactiver les notifications de nouveaux reports'
	},
}

-- ============================================
-- LOGS DISCORD
-- ============================================

-- Pour définir votre URL de Webhook Discord, allez dans webhook.lua, ligne 1

Config.BotName = 'ZReport' -- Nom du bot Discord

Config.ServerName = 'Mon Serveur RP' -- Nom de votre serveur

Config.IconURL = '' -- Lien de l\'image désirée

Config.DateFormat = '%d/%m/%Y [%X]' -- Pour changer le format de date, consultez https://www.lua.org/pil/22.1.html

Config.ReportTitle = 'SYSTÈME DE REPORT'

-- Pour changer la couleur d'un webhook, vous devez définir la valeur décimale d'une couleur
-- Vous pouvez utiliser ce site pour le faire - https://www.mathsisfun.com/hexadecimal-decimal-colors.html

Config.playerReportWebhookColor = '65280' -- Vert

Config.bugReportWebhookColor = '16711680' -- Rouge

Config.questionReportWebhookColor = '49151' -- Bleu

Config.playerWebhookColor = '255' -- Bleu foncé

Config.adminWebhookColor = '16746240' -- Orange

Config.WebhookMessages = {
	-- Joueur
	['player_report'] = {
		action = 'A ouvert un report',
		description = 'Signalement d\'un joueur'
	},
	['bug_report'] = {
		action = 'A ouvert un report',
		description = 'Signalement d\'un bug'
	},
	['question_report'] = {
		action = 'A ouvert un report',
		description = 'Question au staff'
	},
	['p_cancel_report'] = {
		action = 'A annulé un report',
		type = 'Report #${id}'
	},
	['p_answer_report'] = {
		action = 'Le joueur a répondu au report',
		type = 'Report #${id}'
	},

	-- Admin
	['a_answer_report'] = {
		action = 'L\'admin a répondu au report',
		type = 'Report #${id}'
	},
	['a_bring_report'] = {
		action = 'L\'admin a téléporté le joueur à lui',
		type = 'Report #${id}'
	},
	['a_goto_report'] = {
		action = 'L\'admin s\'est téléporté au joueur',
		type = 'Report #${id}'
	},
	['a_closed_report'] = {
		action = 'L\'admin a clos un report',
		type = 'Report #${id}'
	},
}

-- ============================================
-- TEXTES DE L'INTERFACE
-- ============================================

Config.Locale = {
	-- Interface principale
	['ui_title'] = 'Système de Report',
	['ui_create_report'] = 'Créer un Report',
	['ui_my_report'] = 'Mon Report',
	['ui_admin_panel'] = 'Panel Admin',

	-- Catégories
	['category_player'] = 'Signaler un Joueur',
	['category_bug'] = 'Signaler un Bug',
	['category_question'] = 'Poser une Question',

	-- Formulaire
	['form_category'] = 'Catégorie',
	['form_description'] = 'Description',
	['form_description_placeholder'] = 'Décrivez votre problème en détail...',
	['form_submit'] = 'Envoyer le Report',
	['form_cancel'] = 'Annuler',

	-- Chat
	['chat_title'] = 'Discussion',
	['chat_placeholder'] = 'Tapez votre message...',
	['chat_send'] = 'Envoyer',
	['chat_no_messages'] = 'Aucun message pour le moment',

	-- Admin
	['admin_reports_list'] = 'Liste des Reports',
	['admin_no_reports'] = 'Aucun report ouvert',
	['admin_report_id'] = 'Report #',
	['admin_player'] = 'Joueur',
	['admin_category'] = 'Catégorie',
	['admin_status'] = 'Statut',
	['admin_actions'] = 'Actions',
	['admin_answer'] = 'Répondre',
	['admin_bring'] = 'Téléporter ici',
	['admin_goto'] = 'Aller vers',
	['admin_close'] = 'Conclure',

	-- Statuts
	['status_waiting'] = 'En attente',
	['status_in_progress'] = 'En cours',
	['status_concluded'] = 'Conclu',
}
