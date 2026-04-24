if Config.Framework == 'qb' or Config.Framework == 'oldqb' then
    Citizen.CreateThread(function()
        while Core == nil do
            Wait(0)
        end
        RegisterCallback('m-multichar-server-GetCharacters', function(source, cb)
            SetPlayerRoutingBucket(source, tonumber(source))
            local license = Core.Functions.GetIdentifier(source, 'license')
            if not license then
                DropPlayer(source, "We can't find your license id!")
                return
            end
            local chars = {}
            local result = ExecuteSql('SELECT * FROM players WHERE license = "' .. license .. '"')
            for i = 1, (#result), 1 do
                result[i].charinfo = {
                    firstname = json.decode(result[i].charinfo).firstname,
                    lastname = json.decode(result[i].charinfo).lastname,
                    birthdate = json.decode(result[i].charinfo).birthdate,
                    nationality = json.decode(result[i].charinfo).nationality or 'UNKOWN',
                    phone = json.decode(result[i].charinfo).phone or 'UNKOWN',
                }
                result[i].money = {
                    cash = math.ceil(json.decode(result[i].money).cash) or 0,
                    bank = math.ceil(json.decode(result[i].money).bank) or 0
                }
                result[i].job = {
                    name = json.decode(result[i].job).label,
                    grade = json.decode(result[i].job).grade.name,
                    jobname = json.decode(result[i].job).name
                }
                result[i].job2 = {
                    name = json.decode(result[i].gang).label,
                    grade = json.decode(result[i].gang).grade.name,
                    jobname = json.decode(result[i].gang).name
                }
                playersData[result[i].citizenid] = tonumber(result[i].playtime)
                local totalPlayedTime = SecondsToClock(tonumber(result[i].playtime))
                result[i].playtime = totalPlayedTime
                table.insert(chars, result[i])
            end
            cb(chars)
        end)

        RegisterCallback("m-multichar:server:getSkin", function(source, cb, cid)
            local src = source
            if (Config.Clothes == "default") then
                local result = ExecuteSql('SELECT * FROM playerskins WHERE citizenid= "' .. cid .. '" AND active = 1')
                if result[1] ~= nil then
                    cb({
                        model = result[1].model,
                        skin = result[1].skin
                    })
                else
                    cb(nil)
                end
            elseif (Config.Clothes == "illenium-appearance") then
                local result = ExecuteSql('SELECT * FROM playerskins WHERE citizenid = "' .. cid .. '" AND active = 1')
                if result[1] ~= nil then
                    cb(result[1].skin)
                else
                    cb(nil)
                end
            else
                local result = ExecuteSql('SELECT * FROM playerskins WHERE citizenid = "' .. cid .. '" AND active = 1')
                if result[1] ~= nil then
                    cb(result[1].skin)
                else
                    cb(nil)
                end
            end
        end)
    end)
    RegisterCallback('m-multichar-server-DeleteCharacter', function(source, cb, citizenid)
        if Core.Player.DeleteCharacter(source, citizenid) then
            cb(true)
        else
            cb(false)
        end
    end)
    RegisterServerEvent("m-multichar-server-CreateChar", function(data)
        local src = source
        local newData = {}
        newData.cid = tonumber(data.cid) + 1
        newData.charinfo = data
        if Core.Player.Login(src, false, newData) then
            local Player = Core.Functions.GetPlayer(src)
            SetPlayerRoutingBucket(src, Config.DefaultBucket)
            print('^2[codem-multicharacter]^7 ' .. GetPlayerName(src) .. ' has successfully loaded!')
            TriggerClientEvent("m-multichar:client:closeNUIdefault", src)
            loadHouseData(src)
            PlayTimeLogin(Player.PlayerData.citizenid)
            SetSpawnTrigger(src, newData, true)
            GiveStarterItems(src)
        end
    end)
    RegisterServerEvent("m-multichar-server-LoadPlayer", function(data)
        src = source
        if Core.Player.Login(src, data.citizenid) then
            SetPlayerRoutingBucket(src, Config.DefaultBucket)
            print('^2[codem-multicharacter]^7 ' .. GetPlayerName(src) .. ' (Citizen ID: ' ..
                data.citizenid .. ') has succesfully loaded!')
            Core.Commands.Refresh(src)
            loadHouseData(src)
            PlayTimeLogin(data.citizenid)
            TriggerEvent("qb-log:server:CreateLog", "joinleave", "Loaded", "green",
                "**" .. GetPlayerName(src) .. "** (" .. data.citizenid .. " | " .. src .. ") loaded..")
            SetSpawnTrigger(src, data, false)
            TriggerClientEvent("m-multichar:client:closeNUIdefault", src)
        end
    end)


    function loadHouseData(src)
        local HouseGarages = {}
        local Houses = {}
        local result = MySQL.query.await('SELECT * FROM houselocations', {})
        if result[1] ~= nil then
            for _, v in pairs(result) do
                local owned = false
                if tonumber(v.owned) == 1 then
                    owned = true
                end
                local garage = v.garage ~= nil and json.decode(v.garage) or {}
                Houses[v.name] = {
                    coords = json.decode(v.coords),
                    owned = owned,
                    price = v.price,
                    locked = true,
                    adress = v.label,
                    tier = v.tier,
                    garage = garage,
                    decorations = {},
                }
                HouseGarages[v.name] = {
                    label = v.label,
                    takeVehicle = garage,
                }
            end
        end
        TriggerClientEvent("qb-garages:client:houseGarageConfig", src, HouseGarages)
        TriggerClientEvent("qb-houses:client:setHouseConfig", src, Houses)
    end

    SetSpawnTrigger = function(src, plyData, isNew) -- when player create a new char isNew variaton getting true
        if Config.UseQBApartments then
            if isNew then
                if Config.UseMSpawnSelector then
                    TriggerClientEvent('m-spawnselector:client:display', src, plyData, isNew)
                else
                    TriggerClientEvent('apartments:client:setupSpawnUI', src, plyData) -- plyData.cid // plyData.charinfo
                end
            else
                if Config.UseMSpawnSelector then
                    TriggerClientEvent('m-spawnselector:client:display', src, isNew)
                else
                    TriggerClientEvent('apartments:client:setupSpawnUI', src, plyData) -- plyData.cid // plyData.charinfo
                end
            end
        else
            if isNew then
                TriggerClientEvent('codem-multichar-creatingFirstChar', src) -- instead your spawn trigger for create first character
            else                                                         -- instead your spawn trigger for load player
                if Config.UseMSpawnSelector then
                    TriggerClientEvent('m-spawnselector:client:display', src, plyData, isNew)
                else
                    if Config.SpawnSelector then
                        TriggerClientEvent('qb-spawn:client:setupSpawns', src, plyData, false, nil)
                        TriggerClientEvent('qb-spawn:client:openUI', src, true)
                    else
                        local coords = json.decode(plyData.position)
                        TriggerClientEvent('codem-multicharacter-LoadPlayer', src, coords, plyData)
                    end                    

                end
            end
        end
    end

    GiveStarterItems = function(source)
        local src = source
        local Player = Core.Functions.GetPlayer(src)
        for k, v in pairs(Core.Shared.StarterItems) do
            local info = {}
            if v.item == "id_card" then
                info.citizenid = Player.PlayerData.citizenid
                info.firstname = Player.PlayerData.charinfo.firstname
                info.lastname = Player.PlayerData.charinfo.lastname
                info.birthdate = Player.PlayerData.charinfo.birthdate
                info.gender = Player.PlayerData.charinfo.gender
                info.nationality = Player.PlayerData.charinfo.nationality
            elseif v.item == "driver_license" then
                info.firstname = Player.PlayerData.charinfo.firstname
                info.lastname = Player.PlayerData.charinfo.lastname
                info.birthdate = Player.PlayerData.charinfo.birthdate
                info.type = "A1-A2-A | AM-B | C1-C-CE"
            end
            AddItem(src, v.item, 1, info)
        end
    end
    RegisterServerEvent("m-multichar:server:changecharacter")
    AddEventHandler("m-multichar:server:changecharacter", function(src)
        Core.Player.Logout(src)
        TriggerClientEvent('m-multichar-client-Load', src)
    end)

    Core.Commands.Add("logout", 'Change Character', {}, false, function(source)
        local src = source
        Core.Player.Logout(src)
        TriggerClientEvent('m-multichar-client-Load', src)
    end, Config.LoutOutPermission)
end
