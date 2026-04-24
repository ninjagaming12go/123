
-- Player Join
AddEventHandler('playerJoining', function(oldId)
    local src = source
    local playerName = GetPlayerName(src) or 'Unknown'
    local playersOnline = #GetPlayers()
    
    exports[GetCurrentResourceName()]:CreateLog({
        category = "join/leave",
        title = "Join/Leave Logs",
        action = "Player Joining",
        color = "green",
        players = {
            { id = src, role = "Player" },
        },
        info = {
            { name = "Player Name", value = playerName },
            { name = "Players Online", value = playersOnline },
            { name = "Join Time", value = os.date('%Y-%m-%d %H:%M:%S') },
        },
        takeScreenshot = false
    })
end)

-- Player Left
AddEventHandler('playerDropped', function(reason)
    local src = source
    local playerName = GetPlayerName(src) or 'Unknown'
    local playersOnline = #GetPlayers() - 1
    
    local license = GetPlayerIdentifierByType(src, 'license') or GetPlayerIdentifierByType(src, 'license2') or 'Unknown'
    local discord = GetPlayerIdentifierByType(src, 'discord') or 'Not Linked'
    local steam = GetPlayerIdentifierByType(src, 'steam') or 'Not Linked'
    
    local playtime = "Unknown"
    local playerJoinTime = GetPlayerJoinTime and GetPlayerJoinTime(src)
    if playerJoinTime then
        local sessionTime = os.time() - playerJoinTime
        local hours = math.floor(sessionTime / 3600)
        local minutes = math.floor((sessionTime % 3600) / 60)
        local seconds = sessionTime % 60
        playtime = string.format("%02d:%02d:%02d", hours, minutes, seconds)
    end
    
    exports[GetCurrentResourceName()]:CreateLog({
        category = "join/leave",
        title = "Join/Leave Logs",
        action = "Player Left",
        color = "red",
        players = {
            { id = src, role = "Player" },
        },
        info = {
            { name = "Player Name", value = playerName },
            { name = "Reason", value = reason },
            { name = "Players Remaining", value = playersOnline },
        },
        extra = {
            {
                title = "Session Information",
                data = {
                    { name = "Session Duration", value = playtime },
                    { name = "Leave Time", value = os.date('%Y-%m-%d %H:%M:%S') },
                }
            }
        },
        takeScreenshot = false
    })
end)

-- Resource Started
AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then return end
    
    local resourceAuthor = GetResourceMetadata(resourceName, 'author', 0) or 'Unknown'
    local resourceVersion = GetResourceMetadata(resourceName, 'version', 0) or 'Unknown'
    local resourceDescription = GetResourceMetadata(resourceName, 'description', 0) or 'No description'
    
    exports[GetCurrentResourceName()]:CreateLog({
        category = "resources",
        title = "Resource Logs",
        action = "Resource Started",
        color = "green",
        info = {
            { name = "Resource Name", value = resourceName },
            { name = "Started By", value = "Server" },
            { name = "Start Time", value = os.date('%Y-%m-%d %H:%M:%S') },
        },
        extra = {
            {
                title = "Resource Information",
                data = {
                    { name = "Author", value = resourceAuthor },
                    { name = "Version", value = resourceVersion },
                    { name = "Description", value = resourceDescription },
                }
            }
        },
    })
end)

-- Resource Stopped
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then return end
    
    local resourceAuthor = GetResourceMetadata(resourceName, 'author', 0) or 'Unknown'
    local resourceVersion = GetResourceMetadata(resourceName, 'version', 0) or 'Unknown'
    
    exports[GetCurrentResourceName()]:CreateLog({
        category = "resources",
        title = "Resource Logs",
        action = "Resource Stopped",
        color = "red",
        info = {
            { name = "Resource Name", value = resourceName },
            { name = "Stopped By", value = "Server" },
            { name = "Stop Time", value = os.date('%Y-%m-%d %H:%M:%S') },
        },
        extra = {
            {
                title = "Resource Information",
                data = {
                    { name = "Author", value = resourceAuthor },
                    { name = "Version", value = resourceVersion },
                }
            }
        },
    })
end)

-- Resource Restarted Detection
local resourceRestartTracker = {}

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then return end
    resourceRestartTracker[resourceName] = os.time()
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then return end
    
    if resourceRestartTracker[resourceName] and (os.time() - resourceRestartTracker[resourceName]) < 2 then
        local resourceAuthor = GetResourceMetadata(resourceName, 'author', 0) or 'Unknown'
        local resourceVersion = GetResourceMetadata(resourceName, 'version', 0) or 'Unknown'
        
        exports[GetCurrentResourceName()]:CreateLog({
            category = "resources",
            title = "Resource Logs",
            action = "Resource Restarted",
            color = "orange",
            info = {
                { name = "Resource Name", value = resourceName },
                { name = "Restart Time", value = os.date('%Y-%m-%d %H:%M:%S') },
            },
            extra = {
                {
                    title = "Resource Information",
                    data = {
                        { name = "Author", value = resourceAuthor },
                        { name = "Version", value = resourceVersion },
                    }
                }
            },
        })
        
        resourceRestartTracker[resourceName] = nil
    end
end)

-- Server Started
AddEventHandler('onServerResourceStart', function(resourceName)
    if resourceName == 'sessionmanager' or resourceName == 'mapmanager' then
        exports[GetCurrentResourceName()]:CreateLog({
            category = "resources",
            title = "Server Logs",
            action = "Server Started",
            color = "blue",
            info = {
                { name = "Status", value = "Server has been started successfully" },
                { name = "Start Time", value = os.date('%Y-%m-%d %H:%M:%S') },
            },
            extra = {
                {
                    title = "Server Information",
                    data = {
                        { name = "Server Name", value = GetConvar('sv_hostname', 'Unknown') },
                        { name = "Max Players", value = GetConvar('sv_maxclients', '32') },
                    }
                }
            },
        })
    end
end)
