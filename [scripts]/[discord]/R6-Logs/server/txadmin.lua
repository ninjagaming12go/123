
-- Player Ban
AddEventHandler('txAdmin:events:playerBanned', function(data)
    if data.targetNetId then
        exports[GetCurrentResourceName()]:CreateLog({
            category = "ban",
            title = "txAdmin Logs",
            action = "Player Banned",
            color = "red",
            players = {
                { id = data.targetNetId, role = "Target" }
            },
            info = {
                { name = "Action ID", value = data.actionId },
                { name = "Administrator Name", value = data.author },
                { name = "Target Name", value = data.targetName },
                { name = "Reason", value = data.reason },
            },
            extra = {
                {
                    title = "Ban Duration & Expiration",
                    data = {
                        { name = "Duration", value = data.durationInput or "Permanent" },
                        { name = "Expiration", value = data.expiration and os.date("%Y-%m-%d %H:%M:%S", data.expiration) or "Permanent" },
                        { name = "Duration Translated", value = data.durationTranslated or "N/A" },
                    }
                },
                {
                    title = "Target Identifiers",
                    data = {
                        { name = "Target IDs", value = table.concat(data.targetIds or {}, ", ") },
                        { name = "\nTarget HWIDs", value = table.concat(data.targetHwids or {}, ", ") or "None" },
                    }
                }
            },
            takeScreenshot = true,
        })
    else
        exports[GetCurrentResourceName()]:CreateLog({
            category = "ban",
            title = "txAdmin Logs",
            action = "Identifiers Banned",
            color = "red",
            info = {
                { name = "Action ID", value = data.actionId },
                { name = "Administrator Name", value = data.author },
                { name = "Reason", value = data.reason },
            },
            extra = {
                {
                    title = "Ban Details",
                    data = {
                        { name = "Kick Message", value = data.kickMessage or "N/A" },
                        { name = "Duration", value = data.durationInput or "Permanent" },
                        { name = "Expiration", value = data.expiration and os.date("%Y-%m-%d %H:%M:%S", data.expiration) or "Permanent" },
                    }
                },
                {
                    title = "Banned Identifiers",
                    data = {
                        { name = "Target IDs", value = table.concat(data.targetIds or {}, ", ") },
                        { name = "\nTarget HWIDs", value = table.concat(data.targetHwids or {}, ", ") or "None" },
                    }
                }
            },
        })
    end
end)

-- Player Kick
AddEventHandler('txAdmin:events:playerKicked', function(data)
    if data.target == -1 then
        exports[GetCurrentResourceName()]:CreateLog({
            category = "kick",
            title = "txAdmin Logs",
            action = "Mass Kick - All Players",
            color = "orange",
            info = {
                { name = "Administrator Name", value = data.author },
                { name = "Reason", value = data.reason },
            },
            extra = {
                {
                    title = "Kick Details",
                    data = {
                        { name = "Drop Message", value = data.dropMessage or "N/A" },
                        { name = "Target", value = "All Players" },
                    }
                }
            },
        })
    else
        exports[GetCurrentResourceName()]:CreateLog({
            category = "kick",
            title = "txAdmin Logs",
            action = "Player Kicked",
            color = "orange",
            players = {
                { id = data.target, role = "Target" },
            },
            info = {
                { name = "Administrator Name", value = data.author },
                { name = "Reason", value = data.reason },
            },
            extra = {
                {
                    title = "Kick Details",
                    data = {
                        { name = "Drop Message", value = data.dropMessage or "N/A" },
                    }
                }
            },
            takeScreenshot = true,
        })
    end
end)

-- Player Warn
AddEventHandler('txAdmin:events:playerWarned', function(data)
    local targetId = data.targetNetId

    if targetId then
        -- Online player warn
        exports[GetCurrentResourceName()]:CreateLog({
            category = "warn",
            title = "txAdmin Logs",
            action = "Player Warned (Online)",
            color = "yellow",
            players = {
                { id = targetId, role = "Target" },
            },
            info = {
                { name = "Action ID", value = data.actionId },
                { name = "Administrator Name", value = data.author },
                { name = "Target Name", value = data.targetName },
                { name = "Reason", value = data.reason },
            },
            extra = {
                {
                    title = "Target Identifiers",
                    data = {
                        { name = "Target IDs", value = table.concat(data.targetIds or {}, ", ") },
                    }
                }
            },
            takeScreenshot = true,
        })
    else
        -- Offline player warn
        exports[GetCurrentResourceName()]:CreateLog({
            category = "warn",
            title = "txAdmin Logs",
            action = "Player Warned (Offline)",
            color = "yellow",
            info = {
                { name = "Action ID", value = data.actionId },
                { name = "Administrator Name", value = data.author },
                { name = "Target Name", value = data.targetName },
                { name = "Reason", value = data.reason },
            },
            extra = {
                {
                    title = "Target Identifiers",
                    data = {
                        { name = "Target IDs", value = table.concat(data.targetIds or {}, ", ") },
                    }
                }
            },
        })
    end
end)

-- Server Announcement
AddEventHandler('txAdmin:events:announcement', function(data)
    exports[GetCurrentResourceName()]:CreateLog({
        category = "txadmin",
        title = "txAdmin Logs",
        action = "Announcement",
        color = "blue",
        info = {
            { name = "Administrator Name", value = data.author },
            { name = "Message", value = data.message },
        },
    })
end)

-- Server Shutdown
AddEventHandler('txAdmin:events:serverShuttingDown', function(data)
    exports[GetCurrentResourceName()]:CreateLog({
        category = "txadmin",
        title = "txAdmin Logs",
        action = "Server Shutting Down",
        color = "red",
        info = {
            { name = "Triggered By", value = data.author },
            { name = "Type", value = data.author == "txAdmin" and "Automatic" or "Manual" },
        },
        extra = {
            {
                title = "Shutdown Details",
                data = {
                    { name = "Message", value = data.message },
                    { name = "Delay", value = data.delay .. " ms" },
                }
            }
        },
    })
end)

-- Scheduled Restart
AddEventHandler('txAdmin:events:scheduledRestart', function(data)
    local minutes = math.floor(data.secondsRemaining / 60)

    exports[GetCurrentResourceName()]:CreateLog({
        category = "txadmin",
        title = "txAdmin Logs",
        action = "Scheduled Restart Warning",
        color = "orange",
        info = {
            { name = "Time Remaining", value = minutes .. " minute(s)" },
            { name = "Seconds Remaining", value = data.secondsRemaining .. " seconds" },
        },
        extra = {
            {
                title = "Restart Message",
                data = {
                    { name = "Message", value = data.translatedMessage },
                }
            }
        },
    })
end)

-- Scheduled Restart Skipped
AddEventHandler('txAdmin:events:scheduledRestartSkipped', function(data)
    exports[GetCurrentResourceName()]:CreateLog({
        category = "txadmin",
        title = "txAdmin Logs",
        action = "Scheduled Restart Skipped",
        color = "green",
        info = {
            { name = "Administrator Name", value = data.author },
            { name = "Was Scheduled For", value = math.floor(data.secondsRemaining / 60) .. " minute(s)" },
        },
        extra = {
            {
                title = "Skip Details",
                data = {
                    { name = "Type", value = data.temporary and "Temporary" or "Configured" },
                    { name = "Seconds Remaining", value = data.secondsRemaining .. " seconds" },
                }
            }
        },
    })
end)

-- Player Whitelisted
AddEventHandler('txAdmin:events:whitelistPlayer', function(data)
    local actionColor = data.action == "added" and "green" or "red"
    local actionTitle = data.action == "added" and "Player Whitelisted" or "Player Whitelist Removed"

    exports[GetCurrentResourceName()]:CreateLog({
        category = "txadmin",
        title = "txAdmin Logs",
        action = actionTitle,
        color = actionColor,
        info = {
            { name = "Action", value = string.upper(data.action) },
            { name = "Administrator Name", value = data.adminName },
            { name = "Player Name", value = data.playerName },
        },
        extra = {
            {
                title = "Player Identifiers",
                data = {
                    { name = "License", value = data.license },
                }
            }
        },
    })
end)

-- Whitelist Pre-Approval
AddEventHandler('txAdmin:events:whitelistPreApproval', function(data)
    local actionColor = data.action == "added" and "green" or "red"
    local actionTitle = data.action == "added" and "Pre-Approval Added" or "Pre-Approval Removed"

    exports[GetCurrentResourceName()]:CreateLog({
        category = "txadmin",
        title = "txAdmin Logs",
        action = actionTitle,
        color = actionColor,
        info = {
            { name = "Action", value = string.upper(data.action) },
            { name = "Administrator Name", value = data.adminName },
        },
        extra = {
            {
                title = "Pre-Approval Details",
                data = {
                    { name = "Identifier", value = data.identifier },
                    { name = "Player Name", value = data.playerName or "N/A" },
                }
            }
        },
    })
end)

-- Whitelist Request
AddEventHandler('txAdmin:events:whitelistRequest', function(data)
    local actionColors = {
        requested = "blue",
        approved = "green",
        denied = "red",
        deniedAll = "darkred"
    }

    local actionTitles = {
        requested = "Whitelist Requested",
        approved = "Whitelist Request Approved",
        denied = "Whitelist Request Denied",
        deniedAll = "All Whitelist Requests Denied"
    }

    if data.action == "deniedAll" then
        exports[GetCurrentResourceName()]:CreateLog({
            category = "txadmin",
            title = "txAdmin Logs",
            action = actionTitles[data.action],
            color = actionColors[data.action],
            info = {
                { name = "Action", value = "DENIED ALL REQUESTS" },
                { name = "Administrator Name", value = data.adminName or "System" },
            },
        })
    else
        exports[GetCurrentResourceName()]:CreateLog({
            category = "txadmin",
            title = "txAdmin Logs",
            action = actionTitles[data.action],
            color = actionColors[data.action],
            info = {
                { name = "Action", value = string.upper(data.action) },
                { name = "Request ID", value = data.requestId or "N/A" },
                { name = "Player Name", value = data.playerName or "Unknown" },
            },
            extra = {
                {
                    title = "Request Details",
                    data = {
                        { name = "License", value = data.license or "N/A" },
                        { name = "Administrator Name", value = data.adminName or "N/A" },
                    }
                }
            },
        })
    end
end)

-- Player Healed
AddEventHandler('txAdmin:events:playerHealed', function(data)
    if data.target == -1 then
        -- Heal all players
        exports[GetCurrentResourceName()]:CreateLog({
            category = "txadmin",
            title = "txAdmin Logs",
            action = "All Players Healed",
            color = "green",
            info = {
                { name = "Administrator Name", value = data.author },
                { name = "Target", value = "All Players" },
            },
        })
    else
        -- Heal specific player
        exports[GetCurrentResourceName()]:CreateLog({
            category = "txadmin",
            title = "txAdmin Logs",
            action = "Player Healed",
            color = "green",
            players = {
                { id = data.target, role = "Target" },
            },
            info = {
                { name = "Administrator Name", value = data.author },
            },
        })
    end
end)

-- Player Direct Message
AddEventHandler('txAdmin:events:playerDirectMessage', function(data)
    exports[GetCurrentResourceName()]:CreateLog({
        category = "txadmin",
        title = "txAdmin Logs",
        action = "Direct Message Sent",
        color = "blue",
        players = {
            { id = data.target, role = "Recipient" },
        },
        info = {
            { name = "Administrator Name", value = data.author },
        },
        extra = {
            {
                title = "Message Content",
                data = {
                    { name = "Message", value = data.message },
                }
            }
        },
    })
end)

-- Action Revoked
AddEventHandler('txAdmin:events:actionRevoked', function(data)
    exports[GetCurrentResourceName()]:CreateLog({
        category = "txadmin",
        title = "txAdmin Logs",
        action = "Action Revoked",
        color = "purple",
        info = {
            { name = "Action ID", value = data.actionId },
            { name = "Action Type", value = string.upper(data.actionType) },
            { name = "Revoked By", value = data.revokedBy },
        },
        extra = {
            {
                title = "Original Action Details",
                data = {
                    { name = "Original Reason", value = data.actionReason },
                    { name = "Original Author", value = data.actionAuthor },
                    { name = "Player Name", value = data.playerName or "N/A" },
                }
            },
            {
                title = "Player Identifiers",
                data = {
                    { name = "Player IDs", value = table.concat(data.playerIds or {}, ", ") },
                    { name = "Player HWIDs", value = table.concat(data.playerHwids or {}, ", ") or "None" },
                }
            }
        },
    })
end)

-- Admin Auth
AddEventHandler('txAdmin:events:adminAuth', function(data)
    if data.netid == -1 then
        -- Force reauth all admins
        exports[GetCurrentResourceName()]:CreateLog({
            category = "txadmin",
            title = "txAdmin Logs",
            action = "Force Admin Re-Authentication",
            color = "orange",
            info = {
                { name = "Action", value = "All admins forced to re-authenticate" },
            },
        })
    else
        local actionTitle = data.isAdmin and "Admin Authenticated" or "Admin Permission Revoked"
        local actionColor = data.isAdmin and "green" or "red"

        exports[GetCurrentResourceName()]:CreateLog({
            category = "txadmin",
            title = "txAdmin Logs",
            action = actionTitle,
            color = actionColor,
            players = {
                { id = data.netid, role = "Admin" },
            },
            info = {
                { name = "Status", value = data.isAdmin and "Authenticated" or "Revoked" },
            },
            extra = {
                {
                    title = "Admin Details",
                    data = {
                        { name = "Username", value = data.username or "N/A" },
                    }
                }
            },
        })
    end
end)

-- Admins Updated
AddEventHandler('txAdmin:events:adminsUpdated', function(data)
    local onlineAdmins = {}
    if data and type(data) == "table" then
        for i, netid in ipairs(data) do
            if GetPlayerName(netid) then
                table.insert(onlineAdmins, GetPlayerName(netid) .. " [" .. netid .. "]")
            end
        end
    end

    exports[GetCurrentResourceName()]:CreateLog({
        category = "txadmin",
        title = "txAdmin Logs",
        action = "Admins List Updated",
        color = "blue",
        info = {
            { name = "Online Admins Count", value = #onlineAdmins },
        },
        extra = {
            {
                title = "Online Admins List",
                data = {
                    { name = "Admins", value = table.concat(onlineAdmins, ", ") or "None" },
                }
            }
        },
    })
end)

-- Config Changed
AddEventHandler('txAdmin:events:configChanged', function(data)
    exports[GetCurrentResourceName()]:CreateLog({
        category = "txadmin",
        title = "txAdmin Logs",
        action = "Configuration Changed",
        color = "blue",
        info = {
            { name = "Status", value = "txAdmin configuration has been updated" },
        },
        extra = {
            {
                title = "Change Details",
                data = {
                    { name = "Note", value = "In-game settings may have changed (e.g., language)" },
                }
            }
        },
    })
end)

-- Console Command
AddEventHandler('txAdmin:events:consoleCommand', function(data)
    exports[GetCurrentResourceName()]:CreateLog({
        category = "txadmin",
        title = "txAdmin Logs",
        action = "Console Command Executed",
        color = "grey",
        info = {
            { name = "Administrator Name", value = data.author },
            { name = "Channel", value = string.upper(data.channel) },
        },
        extra = {
            {
                title = "Command Details",
                data = {
                    { name = "Command", value = data.command },
                }
            }
        },
    })
end)