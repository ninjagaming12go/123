
-- Chat Message Log
AddEventHandler('chatMessage', function(src, author, message)
    if not message or message == '' then return end
    
    if string.sub(message, 1, 1) == '/' then return end
    
    local playerName = GetPlayerName(src) or 'Unknown'
    local license = GetPlayerIdentifierByType(src, 'license') or GetPlayerIdentifierByType(src, 'license2') or 'Unknown'
    local discord = GetPlayerIdentifierByType(src, 'discord') or 'Not Linked'
    local steam = GetPlayerIdentifierByType(src, 'steam') or 'Not Linked'
    
    local messageLength = string.len(message)
    
    exports[GetCurrentResourceName()]:CreateLog({
        category = 'chat',
        title = 'Chat Logs',
        action = 'Message Sent',
        color = 'grey',
        players = {
            { id = src, role = 'Sender' }
        },
        info = {
            { name = 'Player Name', value = playerName },
            { name = 'Message', value = message },
            { name = 'Message Length', value = messageLength .. ' characters' },
        },
        takeScreenshot = false
    })
end)

-- Chat Command Log
AddEventHandler('chatMessage', function(src, author, message)
    if not message or message == '' then return end
    
    if string.sub(message, 1, 1) ~= '/' then return end
    
    local playerName = GetPlayerName(src) or 'Unknown'
    local command = string.match(message, "^/(%S+)")
    local args = string.match(message, "^/%S+%s(.+)") or "No arguments"
    
    exports[GetCurrentResourceName()]:CreateLog({
        category = 'chat',
        title = 'Chat Logs',
        action = 'Command Executed',
        color = 'blue',
        players = {
            { id = src, role = 'Executor' }
        },
        info = {
            { name = 'Player Name', value = playerName },
            { name = 'Command', value = '/' .. (command or 'unknown') },
        },
        extra = {
            {
                title = "Command Details",
                data = {
                    { name = 'Full Message', value = message },
                    { name = 'Arguments', value = args },
                    { name = 'Timestamp', value = os.date('%Y-%m-%d %H:%M:%S') },
                }
            }
        },
        takeScreenshot = false
    })
end)

-- Spam Detection
local chatSpamTracker = {}
local SPAM_THRESHOLD = 5
local SPAM_TIME_WINDOW = 10 

AddEventHandler('chatMessage', function(src, author, message)
    if not message or message == '' then return end
    if string.sub(message, 1, 1) == '/' then return end
    
    local currentTime = os.time()
    
    if not chatSpamTracker[src] then
        chatSpamTracker[src] = {
            messages = {},
            lastWarning = 0
        }
    end
    
    table.insert(chatSpamTracker[src].messages, {
        message = message,
        time = currentTime
    })
    
    for i = #chatSpamTracker[src].messages, 1, -1 do
        if currentTime - chatSpamTracker[src].messages[i].time > SPAM_TIME_WINDOW then
            table.remove(chatSpamTracker[src].messages, i)
        end
    end
    
    if #chatSpamTracker[src].messages >= SPAM_THRESHOLD then
        if currentTime - chatSpamTracker[src].lastWarning > 30 then
            local playerName = GetPlayerName(src) or 'Unknown'
            
            exports[GetCurrentResourceName()]:CreateLog({
                category = 'chat',
                title = 'Chat Logs',
                action = 'Spam Detected',
                color = 'red',
                players = {
                    { id = src, role = 'Spammer' }
                },
                info = {
                    { name = 'Player Name', value = playerName },
                    { name = 'Messages Sent', value = #chatSpamTracker[src].messages .. ' messages in ' .. SPAM_TIME_WINDOW .. ' seconds' },
                },
                extra = {
                    {
                        title = "Recent Messages",
                        data = {
                            { name = 'Last Message', value = message },
                            { name = 'Detection Time', value = os.date('%Y-%m-%d %H:%M:%S') },
                        }
                    }
                },
                takeScreenshot = true
            })
            
            chatSpamTracker[src].lastWarning = currentTime
        end
    end
end)

-- F8 Command Logs
local criticalCommands = {
    ['restart'] = true,
    ['stop'] = true,
    ['refresh'] = true,
    ['ensure'] = true,
    ['start'] = true,
    ['exec'] = true,
    ['quit'] = true,
    ['sv_password'] = true,
    ['remove_principal'] = true,
    ['add_principal'] = true,
    ['add_ace'] = true,
    ['remove_ace'] = true,
}

local dangerousCommands = {
    ['quit'] = true,
    ['sv_password'] = true,
    ['remove_principal'] = true,
}

AddEventHandler('rconCommand', function(commandName, args)
    local commandLower = string.lower(commandName)
    local argsString = table.concat(args, ' ')
    
    local isCritical = criticalCommands[commandLower] or false
    local isDangerous = dangerousCommands[commandLower] or false
    
    local logColor = "blue"
    local dangerLevel = "🟢 NORMAL"
    
    if isDangerous then
        logColor = "darkred"
        dangerLevel = "🔴 DANGEROUS"
    elseif isCritical then
        logColor = "orange"
        dangerLevel = "🟠 CRITICAL"
    end
    
    local serverName = GetConvar('sv_hostname', 'Unknown')
    local maxPlayers = GetConvar('sv_maxclients', '32')
    local playersOnline = #GetPlayers()
    
    exports[GetCurrentResourceName()]:CreateLog({
        category = "chat",
        title = "RCON Logs",
        action = "RCON Command Executed",
        color = logColor,
        info = {
            { name = "Command", value = commandName },
            { name = "Danger Level", value = dangerLevel },
            { name = "Timestamp", value = os.date('%Y-%m-%d %H:%M:%S') },
        },
        extra = {
            {
                title = "Command Details",
                data = {
                    { name = "Full Command", value = commandName .. (argsString ~= "" and " " .. argsString or "") },
                    { name = "Arguments", value = argsString ~= "" and argsString or "No arguments" },
                    { name = "Arguments Count", value = #args },
                }
            },
            {
                title = "Server Information",
                data = {
                    { name = "Server Name", value = serverName },
                    { name = "Players Online", value = playersOnline .. " / " .. maxPlayers },
                    { name = "Execution Time", value = os.date('%H:%M:%S') },
                }
            },
            isDangerous and {
                title = "⚠️ Security Alert",
                data = {
                    { name = "Warning", value = "🚨 DANGEROUS COMMAND EXECUTED" },
                    { name = "Risk Level", value = "HIGH - Potential Server Impact" },
                    { name = "Recommendation", value = "Review this action immediately" },
                }
            } or nil
        },
        takeScreenshot = isDangerous or isCritical
    })
end)


AddEventHandler('playerDropped', function(reason)
    local src = source
    if chatSpamTracker[src] then
        chatSpamTracker[src] = nil
    end
end)

