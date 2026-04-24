if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
    Citizen.CreateThread(function()
        while Core == nil do
            Wait(0)
        end
        ESXStarterItem = {
            [1] = {item = 'water', amount = 2},
            [2] = {item = 'phone', amount = 1},
        }
        RegisterCallback('m-multichar-server-GetCharacters', function(source, cb)
            TriggerEvent('esx:playerLogout', tonumber(source))
            SetPlayerRoutingBucket(source, tonumber(source))
            identifier = Config.Prefix .. '%:' .. Core.GetIdentifier(source)
            if not identifier then
                DropPlayer(source, "We can't find your license id!")
                return
            end
            local chars = {}
            local result = ExecuteSql('SELECT * FROM users WHERE identifier LIKE  "%' .. identifier .. '%"')
            for i = 1, (#result), 1 do
                result[i].charinfo = {}
                result[i].charinfo = {
                    firstname = result[i].firstname,
                    lastname = result[i].lastname,
                    birthdate = result[i].dateofbirth,
                    nationality = result[i].nationality or 'UNKOWN',
                    phone = result[i].phone_number or "000-000",
                }
                result[i].money = {}
                result[i].money = {
                    cash = json.decode(result[i].accounts).money or 0,
                    bank = json.decode(result[i].accounts).bank or 0
                }
                result[i].esxjobName = result[i].job
                result[i].job = {
                    name = result[i].esxjobName or 'unemployed',
                    grade = result[i].job_grade,
                    jobname = result[i].esxjobName or 'unemployed'
                }
                result[i].esxjobName2 = result[i].job2
                result[i].job2 = {
                    name = result[i].esxjobName2 or 'None',
                    grade = result[i].job_grade or 0,
                    jobname = result[i].esxjobName2 or 'unemployed'
                }
                playersData[result[i].identifier] = tonumber(result[i].playtime)
                local totalPlayedTime = SecondsToClock(tonumber(result[i].playtime))
                result[i].playtime = totalPlayedTime
                table.insert(chars, result[i])
            end
            cb(chars)
        end)
        RegisterCallback("m-multichar:server:getSkin", function(source, cb, cid)
            local src = source
            local result = ExecuteSql('SELECT skin FROM users WHERE identifier = "' .. cid .. '"')
            if result[1] ~= nil then
                cb(result[1].skin)
            else
                cb(nil)
            end
        end)

        RegisterCallback('m-multichar-server-DeleteCharacter', function(source, cb, citizenid)
            local query = 'DELETE FROM %s WHERE %s = ?'
            local queries = {}
            local count = 0

            for table, column in pairs(Config.DeleteTable) do
                count += 1
                queries[count] = { query = query:format(table, column), values = { citizenid } }
            end

            MySQL.transaction(queries, function(result)
                if result then
                    print(('[^2INFO^7] Player ^5%s %s^7 has deleted a character ^5(%s)^7'):format(GetPlayerName(source),
                        source, citizenid))
                    Wait(50)
                    cb(true)
                else
                    error('\n^1Transaction failed while trying to delete ' .. citizenid .. '^0')
                    cb(false)
                end
            end)
        end)
        Core.RegisterCommand('logout', Config.LoutOutPermission, function(xPlayer, args, showError)
            if not xPlayer then return end
                local source = xPlayer.source
                TriggerEvent("m-multichar-server-Relog", source)
            end, true,
            {
                help = 'LOGOUT Commnad',
                validate = true,
            })
    end)
    LoadPlayer = function(source)
        local src = source
        local ts = 0
        while not Core.GetPlayerFromId(src) and ts < 1000 do
            ts += 1
            Wait(0)
        end
        local ply = Player(src).state
        if not ply then return end
        local identifier = Core.GetPlayerFromId(src).identifier
        if identifier then
            ply:set('identifier', Core.GetPlayerFromId(src).identifier, true)
        end
        return true
    end

    RegisterServerEvent("m-multichar-server-CreateChar", function(data)
        local src = source
        data.cid = tonumber(data.cid) + 1
        if data.gender == 0 then
            data.sex = "m"
        else
            data.sex = "f"
        end
        data.dateofbirth = data.birthdate
        TriggerEvent('esx:onPlayerJoined', src, Config.Prefix .. data.cid, data)
        LoadPlayer(tonumber(src))
        local ply = Core.GetPlayerFromId(src)
        identifier = ply.identifier or 'unknown'
        if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
            ExecuteSql('UPDATE users SET nationality = "' .. data.nationality .. '" WHERE identifier = "' .. identifier .. '"')
        end
        PlayTimeLogin(identifier)
        SetPlayerRoutingBucket(src, Config.DefaultBucket)
        TriggerClientEvent("m-multichar:client:closeNUIdefault", src)
    end)
    RegisterServerEvent("m-multichar-server-LoadPlayer", function(data)
        src = source
        Wait(200)
        local _, _, number = string.find(data.identifier, Config.Prefix .. "(%d+)")
        TriggerClientEvent("m-multichar:client:closeNUIdefault", src)
        SetPlayerRoutingBucket(src, Config.DefaultBucket)
        TriggerEvent('esx:onPlayerJoined', src, Config.Prefix .. number, nil)
        LoadPlayer(src)
        PlayTimeLogin(data.identifier)
        print('^2[codem-multichacter]^7 ' .. GetPlayerName(src) .. ' (Identifier: ' ..
            data.identifier .. ') has succesfully loaded!')
    end)
    RegisterNetEvent("m-multichar-server-Relog", function(source, srcc)
        source = source or srcc
        TriggerEvent('esx:playerLogout', source)
        TriggerClientEvent('m-multichar-client-Load', source)
        local actuallTime = os.time()
        if source == nil then return end
        local player = Core.GetPlayerFromId(source)
        if player == nil then return end
        identifier = player.identifier
        if identifier == nil then return end
        if (playersData[identifier] ~= nil and playersDataActuall[identifier] ~= nil) then
            local time = tonumber(actuallTime - playersDataActuall[identifier])
            local timeFormatted = SecondsToClock(time)
            local timeAll = time + playersData[identifier]
            local timeAllFormatted = SecondsToClock(timeAll)
            if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
                ExecuteSql('UPDATE users SET playtime = "' .. timeAll .. '" WHERE identifier = "' .. identifier .. '"')
            elseif Config.Framework == 'qb' or Config.Framework == 'oldqb' then
                ExecuteSql('UPDATE players SET playtime = "' .. timeAll .. '" WHERE citizenid = "' .. identifier .. '"')
            end
            playersData[identifier] = timeAll
        end
    end)

    RegisterServerEvent("m-multichar-server-StarterItems")
    AddEventHandler("m-multichar-server-StarterItems",function()
        src = source
        local xPlayer = Core.GetPlayerFromId(src)
        for _, v in pairs(ESXStarterItem) do
            AddItem(src, v.item, v.amount, false)
        end
    end)
end
