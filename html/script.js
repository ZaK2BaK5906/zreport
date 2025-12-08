// ============================================
// VARIABLES GLOBALES
// ============================================

let currentMode = 'player';
let isAdmin = false;
let allReports = {};
let currentReportId = null;
let selectedCategory = null;
let configLocale = {};

// ============================================
// GESTION DES MESSAGES NUI
// ============================================

window.addEventListener('message', (event) => {
    const data = event.data;

    switch (data.action) {
        case 'openUI':
            openUI(data);
            break;
        case 'closeUI':
            closeUI();
            break;
        case 'updateReports':
            updateReports(data.reports);
            break;
        case 'showNotification':
            showNotification(data.data);
            break;
    }
});

// ============================================
// GESTION DE L'UI
// ============================================

function openUI(data) {
    currentMode = data.mode;
    isAdmin = data.isAdmin;
    allReports = data.reports || {};
    currentReportId = data.reportId;
    configLocale = data.config || {};

    const container = document.getElementById('app');
    container.classList.add('active');

    if (currentMode === 'player') {
        showPlayerView();
    } else if (currentMode === 'admin') {
        showAdminView();
    }
}

function closeUI() {
    const container = document.getElementById('app');
    container.classList.remove('active');

    // Réinitialiser
    selectedCategory = null;
    currentReportId = null;

    // Cacher toutes les vues
    document.querySelectorAll('.view').forEach(view => {
        view.style.display = 'none';
    });

    // Réinitialiser le formulaire
    document.getElementById('reportForm').style.display = 'none';
    document.getElementById('reportDescription').value = '';
    document.querySelectorAll('.category-card').forEach(card => {
        card.classList.remove('selected');
    });
}

function showPlayerView() {
    hideAllViews();

    // Vérifier si le joueur a un report ouvert
    let playerReport = null;
    for (let id in allReports) {
        const report = allReports[id];
        if (report.status !== 'concluded') {
            playerReport = report;
            currentReportId = id;
            break;
        }
    }

    if (playerReport) {
        // Afficher le report du joueur
        showMyReport(playerReport);
        document.getElementById('myReportView').style.display = 'block';
    } else {
        // Afficher le formulaire de création
        document.getElementById('createReportView').style.display = 'block';
    }
}

function showAdminView() {
    hideAllViews();
    document.getElementById('adminView').style.display = 'block';
    renderAdminReportsList();
}

function hideAllViews() {
    document.querySelectorAll('.view').forEach(view => {
        view.style.display = 'none';
    });
}

// ============================================
// VUE JOUEUR - CRÉER UN REPORT
// ============================================

// Sélectionner une catégorie
document.querySelectorAll('.category-card').forEach(card => {
    card.addEventListener('click', function() {
        const category = this.dataset.category;
        selectCategory(category);
    });
});

function selectCategory(category) {
    selectedCategory = category;

    // Mettre à jour l'UI
    document.querySelectorAll('.category-card').forEach(card => {
        if (card.dataset.category === category) {
            card.classList.add('selected');
        } else {
            card.classList.remove('selected');
        }
    });

    // Afficher le formulaire
    document.getElementById('reportForm').style.display = 'block';

    // Mettre à jour le badge de catégorie
    const categoryNames = {
        'player': 'Signaler un Joueur',
        'bug': 'Signaler un Bug',
        'question': 'Poser une Question'
    };
    document.getElementById('selectedCategoryBadge').textContent = categoryNames[category];

    // Scroll vers le formulaire
    document.getElementById('reportForm').scrollIntoView({ behavior: 'smooth' });
}

function cancelReportCreation() {
    selectedCategory = null;
    document.getElementById('reportForm').style.display = 'none';
    document.getElementById('reportDescription').value = '';
    document.querySelectorAll('.category-card').forEach(card => {
        card.classList.remove('selected');
    });
}

// Compteur de caractères
document.getElementById('reportDescription').addEventListener('input', function() {
    const count = this.value.length;
    document.getElementById('charCount').textContent = count;
});

// Soumettre le report
function submitReport() {
    if (!selectedCategory) {
        showNotification({
            title: 'ERREUR',
            text: 'Veuillez sélectionner une catégorie',
            type: 'error',
            time: 5000
        });
        return;
    }

    const description = document.getElementById('reportDescription').value.trim();

    if (description.length < 20) {
        showNotification({
            title: 'ERREUR',
            text: 'La description doit contenir au moins 20 caractères',
            type: 'error',
            time: 5000
        });
        return;
    }

    // Envoyer au serveur
    fetch(`https://${GetParentResourceName()}/createReport`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            category: selectedCategory,
            description: description
        })
    });
}

// ============================================
// VUE JOUEUR - MON REPORT
// ============================================

function showMyReport(report) {
    // Mettre à jour les informations
    document.getElementById('myReportId').textContent = '#' + report.id;
    document.getElementById('myReportDescription').textContent = report.description;

    // Catégorie
    const categoryNames = {
        'player': 'Signaler un Joueur',
        'bug': 'Signaler un Bug',
        'question': 'Poser une Question'
    };
    document.getElementById('myReportCategory').textContent = categoryNames[report.category];

    // Statut
    const statusElement = document.getElementById('myReportStatus');
    const statusNames = {
        'waiting': 'En attente',
        'in_progress': 'En cours',
        'concluded': 'Conclu'
    };
    statusElement.textContent = statusNames[report.status] || report.status;
    statusElement.className = 'status-badge ' + report.status;

    // Bouton annuler
    const cancelBtn = document.getElementById('cancelReportBtn');
    if (report.adminInteracted) {
        cancelBtn.style.display = 'none';
    } else {
        cancelBtn.style.display = 'inline-flex';
    }

    // Afficher les messages
    renderChatMessages('chatMessages', report.messages);
}

function cancelMyReport() {
    if (!currentReportId) return;

    fetch(`https://${GetParentResourceName()}/cancelReport`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            reportId: parseInt(currentReportId)
        })
    });
}

function sendChatMessage() {
    const input = document.getElementById('chatInput');
    const message = input.value.trim();

    if (message.length === 0) return;

    fetch(`https://${GetParentResourceName()}/sendMessage`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            reportId: parseInt(currentReportId),
            message: message
        })
    });

    input.value = '';
}

// Envoyer avec Enter
document.getElementById('chatInput').addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        sendChatMessage();
    }
});

// ============================================
// VUE ADMIN - LISTE DES REPORTS
// ============================================

function renderAdminReportsList() {
    const container = document.getElementById('reportsList');
    container.innerHTML = '';

    const reportIds = Object.keys(allReports);

    if (reportIds.length === 0) {
        container.innerHTML = `
            <div class="no-reports">
                <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>
                </svg>
                <h3>Aucun report ouvert</h3>
                <p>Tous les reports ont été traités</p>
            </div>
        `;
        return;
    }

    reportIds.forEach(id => {
        const report = allReports[id];
        const statusNames = {
            'waiting': 'En attente',
            'in_progress': 'En cours',
            'concluded': 'Conclu'
        };
        const categoryNames = {
            'player': 'Signaler un Joueur',
            'bug': 'Signaler un Bug',
            'question': 'Poser une Question'
        };

        const reportItem = document.createElement('div');
        reportItem.className = 'report-item';
        reportItem.onclick = () => viewAdminReport(id);
        reportItem.innerHTML = `
            <div class="report-item-header">
                <div class="report-item-title">Report <span class="report-id">#${report.id}</span></div>
            </div>
            <div class="report-item-meta">
                <span class="player-name">${report.playerName}</span>
                <span class="status-badge ${report.status}">${statusNames[report.status]}</span>
                <span class="report-category">${categoryNames[report.category]}</span>
            </div>
            <div class="report-item-description">${report.description}</div>
        `;

        container.appendChild(reportItem);
    });
}

function viewAdminReport(reportId) {
    currentReportId = reportId;
    const report = allReports[reportId];

    if (!report) return;

    hideAllViews();
    document.getElementById('adminReportDetailView').style.display = 'block';

    // Mettre à jour les informations
    document.getElementById('adminReportId').textContent = '#' + report.id;
    document.getElementById('adminReportPlayer').textContent = report.playerName;
    document.getElementById('adminReportDescription').textContent = report.description;

    // Catégorie
    const categoryNames = {
        'player': 'Signaler un Joueur',
        'bug': 'Signaler un Bug',
        'question': 'Poser une Question'
    };
    document.getElementById('adminReportCategory').textContent = categoryNames[report.category];

    // Statut
    const statusElement = document.getElementById('adminReportStatus');
    const statusNames = {
        'waiting': 'En attente',
        'in_progress': 'En cours',
        'concluded': 'Conclu'
    };
    statusElement.textContent = statusNames[report.status] || report.status;
    statusElement.className = 'status-badge ' + report.status;

    // Afficher les messages
    renderChatMessages('adminChatMessages', report.messages);
}

function backToReportsList() {
    hideAllViews();
    document.getElementById('adminView').style.display = 'block';
    renderAdminReportsList();
}

// ============================================
// VUE ADMIN - ACTIONS
// ============================================

function adminBringPlayer() {
    if (!currentReportId) return;

    fetch(`https://${GetParentResourceName()}/bringPlayer`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            reportId: parseInt(currentReportId)
        })
    });
}

function adminGotoPlayer() {
    if (!currentReportId) return;

    fetch(`https://${GetParentResourceName()}/gotoPlayer`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            reportId: parseInt(currentReportId)
        })
    });
}

function adminConcludeReport() {
    if (!currentReportId) return;

    fetch(`https://${GetParentResourceName()}/concludeReport`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            reportId: parseInt(currentReportId)
        })
    });

    backToReportsList();
}

function sendAdminChatMessage() {
    const input = document.getElementById('adminChatInput');
    const message = input.value.trim();

    if (message.length === 0) return;

    fetch(`https://${GetParentResourceName()}/sendMessage`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            reportId: parseInt(currentReportId),
            message: message
        })
    });

    input.value = '';
}

// Envoyer avec Enter
document.getElementById('adminChatInput').addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        sendAdminChatMessage();
    }
});

// ============================================
// CHAT MESSAGES
// ============================================

function renderChatMessages(containerId, messages) {
    const container = document.getElementById(containerId);
    container.innerHTML = '';

    if (!messages || messages.length === 0) {
        container.innerHTML = `
            <div class="no-messages">
                <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>
                </svg>
                <p>Aucun message pour le moment</p>
            </div>
        `;
        return;
    }

    messages.forEach(msg => {
        const messageDiv = document.createElement('div');
        messageDiv.className = 'chat-message' + (msg.isAdmin ? ' admin' : '');

        const time = new Date(msg.timestamp * 1000).toLocaleTimeString('fr-FR', {
            hour: '2-digit',
            minute: '2-digit'
        });

        messageDiv.innerHTML = `
            <div class="message-sender ${msg.isAdmin ? 'admin' : ''}">
                ${msg.sender}
                ${msg.isAdmin ? '<span class="admin-badge">Admin</span>' : ''}
            </div>
            <div class="message-bubble">
                <div class="message-text">${escapeHtml(msg.message)}</div>
                <div class="message-time">${time}</div>
            </div>
        `;

        container.appendChild(messageDiv);
    });

    // Scroll vers le bas
    container.scrollTop = container.scrollHeight;
}

// ============================================
// MISE À JOUR DES REPORTS
// ============================================

function updateReports(reports) {
    allReports = reports;

    if (currentMode === 'player') {
        // Mettre à jour la vue joueur
        let playerReport = null;
        for (let id in allReports) {
            const report = allReports[id];
            if (report.status !== 'concluded') {
                playerReport = report;
                currentReportId = id;
                break;
            }
        }

        if (playerReport && document.getElementById('myReportView').style.display !== 'none') {
            showMyReport(playerReport);
        }
    } else if (currentMode === 'admin') {
        if (document.getElementById('adminView').style.display !== 'none') {
            renderAdminReportsList();
        } else if (document.getElementById('adminReportDetailView').style.display !== 'none' && currentReportId) {
            const report = allReports[currentReportId];
            if (report) {
                viewAdminReport(currentReportId);
            } else {
                backToReportsList();
            }
        }
    }
}

// ============================================
// NOTIFICATIONS
// ============================================

function showNotification(data) {
    const container = document.getElementById('notifications');

    const notification = document.createElement('div');
    notification.className = 'notification ' + (data.type || 'info');
    notification.innerHTML = `
        <div class="notification-title">${data.title}</div>
        <div class="notification-text">${data.text}</div>
    `;

    container.appendChild(notification);

    // Retirer après le délai
    setTimeout(() => {
        notification.style.animation = 'notificationSlideIn 0.3s reverse';
        setTimeout(() => {
            notification.remove();
        }, 300);
    }, data.time || 5000);
}

// ============================================
// UTILITAIRES
// ============================================

function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

function GetParentResourceName() {
    return 'zreport';
}

// ============================================
// FERMER AVEC ECHAP
// ============================================

document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        closeUI();
        fetch(`https://${GetParentResourceName()}/closeUI`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({})
        });
    }
});
