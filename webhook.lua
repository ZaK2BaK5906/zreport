local DISCORD_WEBHOOK = '' -- METTEZ VOTRE URL DE WEBHOOK DISCORD ICI

function SendToDiscord(name, message, color)
    if DISCORD_WEBHOOK == '' then
        return
    end

    local embed = {
        {
            ['color'] = color,
            ['title'] = '**' .. Config.ReportTitle .. '**',
            ['description'] = message,
            ['footer'] = {
                ['text'] = Config.ServerName .. ' • ' .. os.date(Config.DateFormat),
                ['icon_url'] = Config.IconURL,
            },
        }
    }

    PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({
        username = Config.BotName,
        embeds = embed,
        avatar_url = Config.IconURL
    }), {
        ['Content-Type'] = 'application/json'
    })
end

function FormatDiscordMessage(action, playerName, playerId, reportId, category, description)
    local message = ''

    if action then
        message = message .. '**Action:** ' .. action .. '\n'
    end

    if playerName and playerId then
        message = message .. '**Joueur:** ' .. playerName .. ' [' .. playerId .. ']\n'
    end

    if reportId then
        message = message .. '**Report ID:** #' .. reportId .. '\n'
    end

    if category then
        message = message .. '**Catégorie:** ' .. category .. '\n'
    end

    if description then
        message = message .. '**Description:** ' .. description .. '\n'
    end

    return message
end
