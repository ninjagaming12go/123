local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('qb-cityhall:server:getIdentityData', function(source, cb, hallIndex)
    local hall = Config.Cityhalls[hallIndex]
    if not hall or not hall.licenses then
        cb({})
        return
    end
    cb(hall.licenses)
end)

QBCore.Functions.CreateCallback('qb-cityhall:server:receiveJobs', function(source, cb)
    cb(Config.AvailableJobs)
end)

RegisterNetEvent('qb-cityhall:server:requestId', function(licenseType, hallIndex, cost)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local hall = Config.Cityhalls[hallIndex]
    if not hall or not hall.licenses or not hall.licenses[licenseType] then return end

    local license = hall.licenses[licenseType]
    if cost ~= license.cost then return end

    if Player.Functions.RemoveMoney('cash', license.cost, 'cityhall-license') then
        local info = {}
        if license.metadata == 'id_card' then
            info.citizenid = Player.PlayerData.citizenid
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.gender = Player.PlayerData.charinfo.gender
            info.nationality = Player.PlayerData.charinfo.nationality
        elseif license.metadata == 'driver' then
            info.type = 'driver'
        elseif license.metadata == 'weapon' then
            info.type = 'weapon'
        end
        Player.Functions.AddItem(licenseType, 1, false, info)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[licenseType], 'add')
    end
end)

RegisterNetEvent('qb-cityhall:server:ApplyJob', function(job, coords)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local jobData = Config.AvailableJobs[job]
    if not jobData then return end

    Player.Functions.SetJob(job, 0)
    Player.Functions.SetJobDuty(Config.DefaultDuty)
    TriggerClientEvent('QBCore:Notify', src, 'You are now a '..jobData.label, 'success')
end)

RegisterNetEvent('qb-cityhall:server:sendDriverTest', function(instructors)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local charinfo = Player.PlayerData.charinfo
    for _, cid in ipairs(instructors) do
        local result = MySQL.single.await('SELECT citizenid, charinfo FROM players WHERE citizenid = ?', { cid })
        if result then
            local tChar = json.decode(result.charinfo)
            local target = QBCore.Functions.GetPlayerByCitizenId(result.citizenid)
            if target then
                TriggerClientEvent('qb-cityhall:client:sendDriverEmail', target.PlayerData.source, charinfo)
            end
        end
    end
end)
