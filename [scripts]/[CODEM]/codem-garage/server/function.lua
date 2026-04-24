Config.BotToken = "" -- https://www.youtube.com/watch?v=-m-Z7Wav-fM&ab_channel=GAKventure

function ExecuteSql(query)
	local IsBusy = true
	local result = nil
	if Config.SQL == "oxmysql" then
	    if MySQL == nil then
	        exports.oxmysql:execute(query, function(data)
		  result = data
		  IsBusy = false
	        end)
	    else
	        MySQL.query(query, {}, function(data)
		  result = data
		  IsBusy = false
	        end)
	    end
      
	elseif Config.SQL == "ghmattimysql" then
	    exports.ghmattimysql:execute(query, {}, function(data)
	        result = data
	        IsBusy = false
	    end)
	elseif Config.SQL == "mysql-async" then   
	    MySQL.Async.fetchAll(query, {}, function(data)
	        result = data
	        IsBusy = false
	    end)
	end
	while IsBusy do
	    Citizen.Wait(0)
	end
	return result
end


if Config.Sell and Config.Framework == "esx" then
    vehiclepricetables = {}

    Citizen.CreateThread(function()
        Citizen.Wait(0)
        if Config.Framework == "esx" then
            local cars = ExecuteSql("SELECT * FROM vehicles ")
            if cars then 			
                for k,v in pairs(cars) do
                    v.hash = GetHashKey(v.model)		
                end
                vehiclepricetables = cars
            end 
        end
    end)
    
    Citizen.CreateThread(function()
        if Config.Framework == "esx" then
            frameworkObject = GetFrameworkObject()
            frameworkObject.RegisterServerCallback('codem-garage:vehicleprice', function(source, cb)	
                cb(vehiclepricetables)
            end)
        end
    end)
end

RegisterServerEvent('codem-garage:pay')
AddEventHandler('codem-garage:pay', function(ctype,price)
    if Config.Framework == 'esx' then
		local xPlayer = frameworkObject.GetPlayerFromId(source)
        if ctype == 'vale' then
            xPlayer.removeAccountMoney(Config.MoneyType, Config.ValePrice)
        else
            xPlayer.removeAccountMoney(Config.MoneyType, Config.ImpoundPrice)
        end
	else
        local Player = frameworkObject.Functions.GetPlayer(source)
        if ctype == 'vale' then
            Player.Functions.RemoveMoney(Config.MoneyType, Config.ValePrice)
        else
            Player.Functions.RemoveMoney(Config.MoneyType, Config.ImpoundPrice)
        end
	end
end)

Citizen.CreateThread(function()
	frameworkObject = GetFrameworkObject()
    if Config.Framework == "esx" then

        frameworkObject.RegisterServerCallback('codem-garage:changedCars', function(source, cb, plate)
	        local vehicles = GetAllVehicles()
	        plate = frameworkObject.Math.Trim(plate)
	        local found = false

	        for i = 1, #vehicles do                    
		       if frameworkObject.Math.Trim(GetVehicleNumberPlateText(vehicles[i])) == plate:upper() then    
                found = true
                break
		       end
	        end
            
	        cb(found)
      
	    end)

        frameworkObject.RegisterServerCallback('codem-garage:checkmoneyImpound', function(source, cb)
            local src = source
            local xPlayer = frameworkObject.GetPlayerFromId(src)
            if xPlayer ~= nil then
                local moneyType = Config.MoneyType
                if moneyType == 'money' then
                    if xPlayer.getMoney() >= Config.ImpoundPrice then
                        cb(true)
                    else
                        cb(false)
                    end
                else
                    if xPlayer.getAccount(moneyType).money >= Config.ImpoundPrice then
                        cb(true)
                    else
                        Config.ServerNotification(src, Config.NotificationText["FAILVALE"].text, Config.NotificationText["FAILVALE"].type, Config.NotificationText["FAILVALE"].timeout)
                        cb(false)
                    end
                end
            else
                cb(false)
            end
        end)

        frameworkObject.RegisterServerCallback("codem-garage:checkowned", function(source, cb, plate)
            local src = source
            local xPlayer = frameworkObject.GetPlayerFromId(src)
            local plate = PlakeTrim(plate)
            local result = ExecuteSql("SELECT * FROM owned_vehicles WHERE plate = '" .. plate .. "' AND owner = '" .. xPlayer.identifier .. "'")
            if result[1] ~= nil then
                cb(true)
            else
                cb(false)
            end
        end)

	else 
		frameworkObject.Functions.CreateCallback('codem-garage:changedCars', function(source, cb, plate)
            local vehicles = GetAllVehicles()
		    
			plate = string.gsub(plate, "%s+", ""):lower();
			
			local found = false

			for i = 1, #vehicles do  

			    if string.gsub(GetVehicleNumberPlateText(vehicles[i]), "%s+", ""):lower() == plate then    
			         
			        found = true
			        break
			    end
			end
			cb(found)
	        
		end)

        frameworkObject.Functions.CreateCallback('codem-garage:checkmoneyImpound', function(source, cb)
            local src = source
            local Player = frameworkObject.Functions.GetPlayer(src)
            if Player ~= nil then
                local moneyType = Config.MoneyType
                if Player.PlayerData.money[Config.MoneyType] >= Config.ImpoundPrice then
                    cb(true)
                else
                    Config.ServerNotification(src, Config.NotificationText["FAILVALE"].text, Config.NotificationText["FAILVALE"].type, Config.NotificationText["FAILVALE"].timeout)
                    cb(false)
                end
            else
                cb(false)
            end
        end)
        
        frameworkObject.Functions.CreateCallback("codem-garage:checkowned", function(source, cb, plate)
            local xPlayer = frameworkObject.Functions.GetPlayer(source)
            local plate = PlakeTrim(plate)
            local result = ExecuteSql("SELECT * FROM player_vehicles WHERE plate = '" .. plate .. "' AND citizenid = '" .. xPlayer.PlayerData.citizenid .. "'")
            if result[1] ~= nil then
                cb(true)
            else
                cb(false)
            end
        end)
	end

end)

Citizen.CreateThread(function()
    if Config.Framework ~= "esx" then
        frameworkObject.Functions.CreateCallback('codem-garage:server:GetPlayerVehicles', function(source, cb)
            local Player = frameworkObject.Functions.GetPlayer(source)
            local Vehicles = {}
        
            MySQL.query('SELECT * FROM player_vehicles WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
                if result[1] then
                    for _, v in pairs(result) do
                        local VehicleData = frameworkObject.Shared.Vehicles[v.vehicle]
        
                        local VehicleGarage = "No Garage"
                        if v.parking ~= nil then
                            if Config.Garages[v.parking] ~= nil then
                                VehicleGarage = v.parking
                            end
                        end
        
                        if v.stored == 0 then
                            v.stored = "Out"
                        elseif v.stored == 1 then
                            v.stored = "In Garage"
                        end
        
                        local fullname
                        if VehicleData["brand"] ~= nil then
                            fullname = VehicleData["brand"] .. " " .. VehicleData["name"]
                        else
                            fullname = VehicleData["name"]
                        end
                        Vehicles[#Vehicles+1] = {
                            fullname = fullname,
                            brand = VehicleData["brand"],
                            model = VehicleData["name"],
                            plate = v.plate,
                            garage = VehicleGarage,
                            state = v.stored,
                            fuel = v.fuel,
                            engine = v.engine,
                            body = v.body
                        }
                    end
                    cb(Vehicles)
                else
                    cb(nil)
                end
            end)
            
        end)
    end
end)


-- transfer vehicle to another player

RegisterServerEvent('codem-garage:transfer')
AddEventHandler('codem-garage:transfer',function(plate,id)
    if Config.Framework == "esx" then
        if plate ~= nil then
            local src = source
            id = tonumber(id)
            local xPlayer = frameworkObject.GetPlayerFromId(src)
            local xTarget = frameworkObject.GetPlayerFromId(id)
            if xTarget ~= nil then
                if id ~= src then
                    local givecar = ExecuteSql("SELECT `vehicle` FROM `owned_vehicles` WHERE `plate` = '"..plate.."' AND `owner` = '"..xPlayer.identifier.."'")
                    if givecar then
                        ExecuteSql("UPDATE  `owned_vehicles` SET `owner` = '" .. xTarget.identifier .. "' WHERE `plate` ='"..plate.."'")
                        Config.ServerNotification(src, Config.NotificationText["SUCCESTRANSFER"].text, Config.NotificationText["SUCCESTRANSFER"].type, Config.NotificationText["SUCCESTRANSFER"].timeout)
                        Config.ServerNotification(id, Config.NotificationText["SUCCESTRANSFER"].text, Config.NotificationText["SUCCESTRANSFER"].type, Config.NotificationText["SUCCESTRANSFER"].timeout)
                    else
                        Config.ServerNotification(src, Config.NotificationText["ERR_TRANSFER"].text, Config.NotificationText["ERR_TRANSFER"].type, Config.NotificationText["ERR_TRANSFER"].timeout)
                    end
                else
                    Config.ServerNotification(src, Config.NotificationText["ERR_YOURSELF"].text, Config.NotificationText["ERR_YOURSELF"].type, Config.NotificationText["ERR_YOURSELF"].timeout)
                end
            else
                Config.ServerNotification(src, Config.NotificationText["NO_PLAYER"].text, Config.NotificationText["NO_PLAYER"].type, Config.NotificationText["NO_PLAYER"].timeout)
            end
        end
    else
        if plate ~= nil then
            local src = source
            id = tonumber(id)
            local xPlayer = frameworkObject.Functions.GetPlayer(source)
            local xTarget = frameworkObject.Functions.GetPlayer(id)
            if xTarget ~= nil then
                if id ~= src then
                    local givecar = ExecuteSql("SELECT `mods` FROM `player_vehicles` WHERE `plate` = '"..plate.."' AND `citizenid` = '"..xPlayer.PlayerData.citizenid.."'")
                    if givecar then
                        ExecuteSql("UPDATE  `player_vehicles` SET `citizenid` = '" .. xTarget.PlayerData.citizenid .. "' WHERE `plate` ='"..plate.."'")
                        Config.ServerNotification(src, Config.NotificationText["SUCCESTRANSFER"].text, Config.NotificationText["SUCCESTRANSFER"].type, Config.NotificationText["SUCCESTRANSFER"].timeout)
                        Config.ServerNotification(id, Config.NotificationText["SUCCESTRANSFER"].text, Config.NotificationText["SUCCESTRANSFER"].type, Config.NotificationText["SUCCESTRANSFER"].timeout)
                    else
                        Config.ServerNotification(src, Config.NotificationText["ERR_TRANSFER"].text, Config.NotificationText["ERR_TRANSFER"].type, Config.NotificationText["ERR_TRANSFER"].timeout)
                    end
                else
                    Config.ServerNotification(src, Config.NotificationText["ERR_YOURSELF"].text, Config.NotificationText["ERR_YOURSELF"].type, Config.NotificationText["ERR_YOURSELF"].timeout)
                end
            else
                Config.ServerNotification(src, Config.NotificationText["NO_PLAYER"].text, Config.NotificationText["NO_PLAYER"].type, Config.NotificationText["NO_PLAYER"].timeout)
            end
        end
    end
end)

-- sell

RegisterServerEvent('codem-garage:sell')
AddEventHandler('codem-garage:sell', function(plate,price)
    if Config.Framework == "esx" then
        local src = source
        local xPlayer = frameworkObject.GetPlayerFromId(src)
        price = tonumber(price)
        if plate ~= nil and price then
            local deleted = ExecuteSql("DELETE FROM `owned_vehicles` WHERE `plate` = '"..plate.."' AND `owner` = '"..xPlayer.identifier.."'")
            if deleted then
                xPlayer.addMoney(price)
                Config.ServerNotification(src, Config.NotificationText["SUCCESFULL_SELL"].text, Config.NotificationText["SUCCESFULL_SELL"].type, Config.NotificationText["SUCCESFULL_SELL"].timeout)
            else
                Config.ServerNotification(src, Config.NotificationText["NO_PLAYER"].text, Config.NotificationText["NO_PLAYER"].type, Config.NotificationText["NO_PLAYER"].timeout)
            end
        end
    else
        local src = source
        local xPlayer  = frameworkObject.Functions.GetPlayer(source)
        price = tonumber(price)
        if plate ~= nil and price then
            local deleted = ExecuteSql("DELETE FROM `player_vehicles` WHERE `plate` = '"..plate.."' AND `citizenid` = '"..xPlayer.PlayerData.citizenid.."'")
            if deleted then
                xPlayer.Functions.AddMoney('cash', price)
                Config.ServerNotification(src, Config.NotificationText["SUCCESFULL_SELL"].text, Config.NotificationText["SUCCESFULL_SELL"].type, Config.NotificationText["SUCCESFULL_SELL"].timeout)
            else
                Config.ServerNotification(src, Config.NotificationText["NO_PLAYER"].text, Config.NotificationText["NO_PLAYER"].type, Config.NotificationText["NO_PLAYER"].timeout)
            end
        end
    end
end)

if Config.AutoReset then
    local storedsql = 1

    AddEventHandler('onResourceStart', function(resource)
        if resource == GetCurrentResourceName() then
            Wait(100)
            if Config.Framework == "esx" then	 
                if Config.SQL == 'oxmysql' then
                    ExecuteSql("UPDATE  `owned_vehicles` SET `stored` = '" ..storedsql.. "'") 
                elseif Config.SQL == 'mysql-async' then
                    ExecuteSql("UPDATE  `owned_vehicles` SET `stored` = '" ..storedsql.. "'")    
                end
            else
                if Config.SQL == 'oxmysql' then
                    ExecuteSql("UPDATE  `player_vehicles` SET `stored` = '" ..storedsql.. "'")   
                elseif Config.SQL == 'mysql-async' then
                    ExecuteSql("UPDATE  `player_vehicles` SET `stored` = '" ..storedsql.. "'")   
                end
            end
        end
    end)
end

function PlakeTrim(plate)
    if not plate then return nil end
    plate = (string.gsub(plate, '^%s*(.-)%s*$', '%1'))
    return plate
end

RegisterNetEvent('codem-garage:saveProps')
AddEventHandler('codem-garage:saveProps', function(plate, props)
    local xProps = json.encode(props)
    if Config.Framework == "esx" then
        local plate = PlakeTrim(plate)
        ExecuteSql("UPDATE `owned_vehicles` SET `vehicle` = '" .. xProps .. "' WHERE `plate` ='".. plate .."'")
    else
        local plate = PlakeTrim(plate)
        ExecuteSql("UPDATE `player_vehicles` SET `mods` = '" .. xProps .. "' WHERE `plate` ='".. plate .."'")
    end
end)



Citizen.CreateThread(function()
    local resource_name = 'codem_garage'
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
end)