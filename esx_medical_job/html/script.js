// ===========================================
// ESX MEDICAL JOB - NUI SCRIPT
// ===========================================

const notificationIcons = {
    info: '<i class="fas fa-info-circle"></i>',
    success: '<i class="fas fa-check-circle"></i>',
    warning: '<i class="fas fa-exclamation-triangle"></i>',
    error: '<i class="fas fa-times-circle"></i>',
};

const notificationTitles = {
    info: 'Information',
    success: 'Succès',
    warning: 'Attention',
    error: 'Erreur',
};

let notificationId = 0;

// ===========================================
// ÉCOUTEUR D'ÉVÉNEMENTS
// ===========================================

window.addEventListener('message', function(event) {
    const data = event.data;

    if (data.action === 'showNotification') {
        showNotification(data.message, data.type || 'info', data.duration || 5000);
    }
});

// ===========================================
// FONCTION DE NOTIFICATION
// ===========================================

function showNotification(message, type = 'info', duration = 5000) {
    const id = notificationId++;
    const icon = notificationIcons[type] || notificationIcons.info;
    const title = notificationTitles[type] || notificationTitles.info;

    const notification = $(`
        <div class="notification ${type}" data-id="${id}">
            <div class="notification-header">
                <div class="notification-icon">${icon}</div>
                <div class="notification-title">${title}</div>
            </div>
            <div class="notification-message">${message}</div>
            <div class="notification-progress" style="animation-duration: ${duration}ms;"></div>
        </div>
    `);

    $('#notification-container').append(notification);

    // Animation d'entrée
    setTimeout(() => {
        notification.addClass('show');
    }, 10);

    // Suppression automatique
    setTimeout(() => {
        removeNotification(id);
    }, duration);
}

function removeNotification(id) {
    const notification = $(`.notification[data-id="${id}"]`);

    notification.addClass('removing');

    setTimeout(() => {
        notification.remove();
    }, 300);
}

// ===========================================
// FONCTIONS UTILITAIRES
// ===========================================

function playNotificationSound(type) {
    // Les sons sont gérés côté client dans FiveM
    // Cette fonction est un placeholder pour future utilisation
}

// ===========================================
// TESTS (Désactivé en production)
// ===========================================

if (window.location.protocol !== 'https:') {
    // Mode développement - Tester les notifications
    /*
    setTimeout(() => {
        showNotification('Ceci est une notification d\'information', 'info', 5000);
    }, 1000);

    setTimeout(() => {
        showNotification('Opération effectuée avec succès !', 'success', 5000);
    }, 2000);

    setTimeout(() => {
        showNotification('Attention, action dangereuse !', 'warning', 5000);
    }, 3000);

    setTimeout(() => {
        showNotification('Une erreur s\'est produite', 'error', 5000);
    }, 4000);
    */
}

// ===========================================
// EXPOSITION GLOBALE
// ===========================================

window.MedicalNotifications = {
    show: showNotification,
    remove: removeNotification,
};

console.log('ESX Medical Job - NUI chargée avec succès !');
