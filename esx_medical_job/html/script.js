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
// PROGRESS BAR 3D
// ===========================================

let progressBarId = 0;
let activeProgressBars = {};

function showProgressBar3D(label, duration, icon = 'fa-heartbeat') {
    const id = progressBarId++;

    const progressBar = $(`
        <div class="progress-bar-3d animate__animated animate__zoomIn" data-id="${id}">
            <div class="progress-label">${label}</div>
            <div class="progress-bar-wrapper">
                <div class="progress-bar-fill" style="width: 0%">
                    <div class="progress-percentage">0%</div>
                </div>
            </div>
            <div class="progress-icon">
                <i class="fas ${icon}"></i>
            </div>
        </div>
    `);

    $('#progress-container').append(progressBar);

    // Animation de la progression
    let progress = 0;
    const increment = 100 / (duration / 50); // Mise à jour toutes les 50ms

    activeProgressBars[id] = setInterval(() => {
        progress = Math.min(progress + increment, 100);

        progressBar.find('.progress-bar-fill').css('width', progress + '%');
        progressBar.find('.progress-percentage').text(Math.floor(progress) + '%');

        if (progress >= 100) {
            clearInterval(activeProgressBars[id]);
            delete activeProgressBars[id];

            setTimeout(() => {
                removeProgressBar3D(id);
            }, 500);
        }
    }, 50);

    return id;
}

function removeProgressBar3D(id) {
    const progressBar = $(`.progress-bar-3d[data-id="${id}"]`);

    if (activeProgressBars[id]) {
        clearInterval(activeProgressBars[id]);
        delete activeProgressBars[id];
    }

    progressBar.addClass('animate__zoomOut');

    setTimeout(() => {
        progressBar.remove();
    }, 400);
}

function cancelProgressBar3D(id) {
    removeProgressBar3D(id);
}

// ===========================================
// INTERACTION 3D
// ===========================================

let interactionId = 0;

function showInteraction3D(title, text, duration = 3000) {
    const id = interactionId++;

    const interaction = $(`
        <div class="interaction-3d animate__animated animate__bounceIn" data-id="${id}">
            <div class="interaction-title">${title}</div>
            <div class="interaction-text">${text}</div>
        </div>
    `);

    $('#interaction-container').append(interaction);

    setTimeout(() => {
        removeInteraction3D(id);
    }, duration);

    return id;
}

function removeInteraction3D(id) {
    const interaction = $(`.interaction-3d[data-id="${id}"]`);

    interaction.removeClass('animate__bounceIn').addClass('animate__bounceOut');

    setTimeout(() => {
        interaction.remove();
    }, 400);
}

// ===========================================
// GESTION DES ÉVÉNEMENTS NUI
// ===========================================

window.addEventListener('message', function(event) {
    const data = event.data;

    switch (data.action) {
        case 'showNotification':
            showNotification(data.message, data.type || 'info', data.duration || 5000);
            break;

        case 'showProgressBar':
            showProgressBar3D(data.label, data.duration, data.icon);
            break;

        case 'cancelProgressBar':
            if (data.id !== undefined) {
                cancelProgressBar3D(data.id);
            }
            break;

        case 'showInteraction':
            showInteraction3D(data.title, data.text, data.duration);
            break;

        case 'hideAll':
            // Supprimer toutes les notifications
            $('.notification').each(function() {
                const id = $(this).data('id');
                removeNotification(id);
            });

            // Supprimer toutes les barres de progression
            $('.progress-bar-3d').each(function() {
                const id = $(this).data('id');
                removeProgressBar3D(id);
            });

            // Supprimer toutes les interactions
            $('.interaction-3d').each(function() {
                const id = $(this).data('id');
                removeInteraction3D(id);
            });
            break;
    }
});

// ===========================================
// EXPOSITION GLOBALE
// ===========================================

window.MedicalNotifications = {
    show: showNotification,
    remove: removeNotification,
};

window.MedicalProgressBar = {
    show: showProgressBar3D,
    remove: removeProgressBar3D,
    cancel: cancelProgressBar3D,
};

window.MedicalInteraction = {
    show: showInteraction3D,
    remove: removeInteraction3D,
};

console.log('🔬 Médecin Scientifique - NUI chargée avec succès !');
console.log('✅ Notifications 3D activées');
console.log('✅ Progress Bars 3D activées');
console.log('✅ Interactions 3D activées');
