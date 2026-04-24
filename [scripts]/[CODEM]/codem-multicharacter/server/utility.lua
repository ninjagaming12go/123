function ExecuteSql(query, parameters)
    local IsBusy = true
    local result = nil
    if Config.SQL == "oxmysql" then
        if parameters then
            exports.oxmysql:execute(query, parameters, function(data)
                result = data
                IsBusy = false
            end)
        else
            exports.oxmysql:execute(query, function(data)
                result = data
                IsBusy = false
            end)
        end
    elseif Config.SQL == "ghmattimysql" then
        if parameters then
            exports.ghmattimysql:execute(query, parameters, function(data)
                result = data
                IsBusy = false
            end)
        else
            exports.ghmattimysql:execute(query, {}, function(data)
                result = data
                IsBusy = false
            end)
        end
    elseif Config.SQL == "mysql-async" then
        if parameters then
            MySQL.Async.fetchAll(query, parameters, function(data)
                result = data
                IsBusy = false
            end)
        else
            MySQL.Async.fetchAll(query, {}, function(data)
                result = data
                IsBusy = false
            end)
        end
    end
    while IsBusy do
        Citizen.Wait(0)
    end
    return result
end

function RegisterCallback(name, cbFunc)
    while not Core do
        Wait(0)
    end
    if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
        Core.RegisterServerCallback(name, function(source, cb, data)
            cbFunc(source, cb, data)
        end)
    else
        Core.Functions.CreateCallback(name, function(source, cb, data)
            cbFunc(source, cb, data)
        end)
    end
end

function WaitCore()
    while Core == nil do
        Wait(0)
    end
end

function GetPlayer(source)
    local Player = false
    while Core == nil do
        Citizen.Wait(0)
    end
    if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
        Player = Core.GetPlayerFromId(source)
    else
        Player = Core.Functions.GetPlayer(source)
    end
    return Player
end

function GetIdentifier(source)
    local Player = GetPlayer(source)
    if Player then
        if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
            return Player.getIdentifier()
        else
            return Player.PlayerData.citizenid
        end
    end
end

function GetName(source)
    if Config.Framework == "oldesx" or Config.Framework == "esx" then
        local xPlayer = Core.GetPlayerFromId(tonumber(source))
        if xPlayer then
            return xPlayer.getName()
        else
            return "0"
        end
    elseif Config.Framework == 'qb' or Config.Framework == 'oldqb' then
        local Player = Core.Functions.GetPlayer(tonumber(source))
        if Player then
            return Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
        else
            return "0"
        end
    end
end

function GetPlayerMoney(source, value)
    local Player = GetPlayer(source)
    if Player then
        if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
            if value == 'bank' then
                return Player.getAccount('bank').money
            end
            if value == 'cash' then
                return Player.getMoney()
            end
        elseif Config.Framework == 'qb' or Config.Framework == 'oldqb' then
            if value == 'bank' then
                return Player.PlayerData.money['bank']
            end
            if value == 'cash' then
                return Player.PlayerData.money['cash']
            end
        end
    end
end

function GetJob(source)
    local Player = GetPlayer(source)
    if Player then
        if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
            return Player.getJob().name
        else
            return Player.PlayerData.job.name
        end
    end
    return false
end

function AddItem(src, item, amount, info)
    local Player = GetPlayer(src)
    if Player then
        if Config.Inventory == "qb_inventory" then
            Player.Functions.AddItem(item, amount, false, info)
        elseif Config.Inventory == "esx_inventory" then
            Player.addInventoryItem(item, amount)
        elseif Config.Inventory == "ox_inventory" then
            exports.ox_inventory:AddItem(src, item, amount)
        elseif Config.Inventory == "codem-inventory" then
            if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
                Player.addInventoryItem(item, amount)
            else
                Player.Functions.AddItem(item, amount, false, info)
            end
        elseif Config.Inventory == "qs_inventory" then
            if GetResourceState('qs_inventory') == 'started' then
                if info then 
                    exports['qs-inventory']:AddItem(src, item, amount, nil, info)
                else
                    exports['qs-inventory']:AddItem(src, item, amount, nil)
                end
            end
        end
    end
end

Citizen.CreateThread(function()
    if Config.VersionChecker then
        local resource_name = 'codem-multicharacter-remake'
        local current_version = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)
        PerformHttpRequest('https://raw.githubusercontent.com/Aiakos232/versionchecker/main/version.json',
            function(error, result, headers)
                if not result then
                    print('^1Version check disabled because github is down.^0')
                    return
                end
                local result = json.decode(result)
                if tonumber(result[resource_name]) ~= nil then
                    if tonumber(result[resource_name]) > tonumber(current_version) then
                        print('\n')
                        print('^1======================================================================^0')
                        print('^1' .. resource_name ..
                            ' is outdated, new version is available: ' .. result[resource_name] .. '^0')
                        print('^1======================================================================^0')
                        print('\n')
                    elseif tonumber(result[resource_name]) == tonumber(current_version) then
                        print('^2' .. resource_name .. ' is up to date! -  ^4 Thanks for choose CodeM ^4 ^0')
                    elseif tonumber(result[resource_name]) < tonumber(current_version) then
                        print('^3' .. resource_name .. ' is a higher version than the official version!^0')
                    end
                else
                    print('^1' .. resource_name .. ' is not in the version database^0')
                end
            end, 'GET')
    end
end)