
-- nomral/local spawn vehicle
local currentlivery = 1
local veh_extras = {['vehicleExtras'] = {}}
local repaired = {}
local spawned = false
local attempts = 0
local garagetype = nil
playerCacheCoords = nil
cratedVehicle = nil
garageOpened = false
cachePlate = nil

RegisterNUICallback('spawnlocalvehicle',function(data,cb)
    local model  = data.model['model']
    local plate  = data.model['plate']
    local garage = data.garage
    local props  = data.model
    
    if Config.Framework == 'esx' then

        CreateThread(function()
            if not spawned and not addfavorite then
                local NearbyVehicles = frameworkObject.Game.GetVehiclesInArea(Config.Garages[garage]["car"].showcar, 5.0)
                if next(NearbyVehicles) then
                    DeleteVehicle(car)
                    DeleteEntity(car)
                    Config.ClientNotification(Config.NotificationText["OCCUPIED"].text, Config.NotificationText["OCCUPIED"].type, Config.NotificationText["OCCUPIED"].timeout)
                else
                    spawned = true
                    car = CreateVehicle(model, Config.Garages[garage]["car"].showcar,false, false)
                    frameworkObject.Game.SetVehicleProperties(car,props)
                    SetVehicleNumberPlateText(car, plate)
                    SetVehicleOnGroundProperly(car)
                    SetEntityInvincible(car, true)
                    SetVehicleDoorsLocked(car, 2)
                    SetVehicleDoorsLockedForAllPlayers(car, true)
                    SetVehicleDoorsLockedForPlayer(car, PlayerId(), true)
                    SetEntityAsMissionEntity(car, true, true)
                    SetModelAsNoLongerNeeded(model)
                    SetVehicleEngineOn(car, true, true)
                    spawned = false
                end
            end
        end)
        
        DeleteVehicle(car)

        local carLoaded = LoadModel(model)

        if carLoaded then
            Wait(100)
            cb(plate)
        end
    else

        CreateThread(function()
            if not spawned and not addfavorite then
                if IsSpawnPointClear(Config.Garages[garage]["car"].showcar, 5.0) then
                    spawned = true
                    car = CreateVehicle(model, Config.Garages[garage]["car"].showcar, false, false)
                    frameworkObject.Functions.SetVehicleProperties(car,props)
                    SetVehicleNumberPlateText(car, plate)
                    SetVehicleNumberPlateText(car, plate)
                    SetVehicleOnGroundProperly(car)
                    SetEntityInvincible(car, true)
                    SetVehicleDoorsLocked(car, 2)
                    SetVehicleDoorsLockedForAllPlayers(car, true)
                    SetVehicleDoorsLockedForPlayer(car, PlayerId(), true)
                    SetEntityAsMissionEntity(car, true, true)
                    SetModelAsNoLongerNeeded(model)
                    SetVehicleEngineOn(car, true, true)
                    spawned = false
                else
                    DeleteVehicle(car)
                    Config.ClientNotification(Config.NotificationText["OCCUPIED"].text, Config.NotificationText["OCCUPIED"].type, Config.NotificationText["OCCUPIED"].timeout)
                end
            end
        end)

        DeleteVehicle(car)

        local carLoaded = LoadModel(model)
        if carLoaded then
            Wait(100)
            cb(plate)
        end
    end
end)

RegisterNUICallback('spawnvehicle',function(data,cb)
    local model  = data.model['model']
    local plate  = data.model['plate']
    local garage = data.garage
    print(garage)
    local props  = data.model

    if data.vale == true then
        local money = Callback('codem-garage:checkmoney')
        cb(money)
    elseif data.impound == true then
        local money = Callback('codem-garage:checkmoneyImpound')
        cb(money)
    else
        if Config.Framework == 'esx' then
            local NearbyVehicles = frameworkObject.Game.GetVehiclesInArea(Config.Garages[garage]["car"].spawncar, 3.0)
            if next(NearbyVehicles) then
                Config.ClientNotification(Config.NotificationText["OCCUPIED"].text, Config.NotificationText["OCCUPIED"].type, Config.NotificationText["OCCUPIED"].timeout)
            else
                spawnCoords = Config.Garages[garage]["car"].spawncar
                
                if playerCacheCoords then
                    cratedVehicle = CreateVehicle(model, playerCacheCoords, true, true)
                    SetVehicleNumberPlateText(cratedVehicle, plate)
                    frameworkObject.Game.SetVehicleProperties(cratedVehicle,props)
                    SetVehicleEngineOn(cratedVehicle, true, true)
                    SetVehicleHasBeenOwnedByPlayer(cratedVehicle, true)
                    SetVehRadioStation(cratedVehicle, "OFF")
                    SetEntityAsMissionEntity(cratedVehicle, true, true)
                    Config.SetVehicleFuel(cratedVehicle,props.fuelLevel)
                    GiveVehicleKeys(plate,model,cratedVehicle)
                    if repaired[car] then
                        SetVehicleDirtLevel(cratedVehicle,0,0)
                        SetVehicleUndriveable(cratedVehicle, false)
                        WashDecalsFromVehicle(cratedVehicle, 1.0)
                        SetVehicleFixed(cratedVehicle)
                        SetVehicleDeformationFixed(cratedVehicle)
                    end
                    SetModelAsNoLongerNeeded(model)
                else
                    vehicle = CreateVehicle(model, spawnCoords, true, true)
                    frameworkObject.Game.SetVehicleProperties(vehicle,props)
                    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                    SetVehicleNumberPlateText(vehicle, plate)
                    SetVehicleEngineOn(vehicle, true, true)
                    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
                    SetVehRadioStation(vehicle, "OFF")
                    SetEntityAsMissionEntity(vehicle, true, true)
                    Config.SetVehicleFuel(vehicle,props.fuelLevel)
                    GiveVehicleKeys(plate,model,vehicle)
                    SetModelAsNoLongerNeeded(model)
                    if repaired[car] then
                        SetVehicleDirtLevel(vehicle,0,0)
                        SetVehicleUndriveable(vehicle, false)
                        WashDecalsFromVehicle(vehicle, 1.0)
                        SetVehicleFixed(vehicle)
                        SetVehicleDeformationFixed(vehicle)
                    end

                    if Config.Garages[garage].garage == "jobgarage" then
                        SetVehicleLivery(vehicle,currentlivery)
                        Config.SetVehicleFuel(vehicle,100)
                        for extraID = 0, 20 do
                            if veh_extras.vehicleExtras[extraID] == true then
                                check = true
                            else
                                check = false
                            end
                            SetVehicleExtra(vehicle, extraID, check)
                        end
                        if Config.JobVehicleMax then
                            PerformanceUpgradeVehicle(vehicle)
                        end
                    end

                end

                TriggerServerEvent('codem-garage:stored',plate,0,garage)

                if data.vale == 2 then
                    TriggerServerEvent('codem-garage:pay','vale')
                elseif data.vale == 3 then
                    TriggerServerEvent('codem-garage:pay','impound')
                end

            end

        else
            local NearbyVehicles = IsSpawnPointClear(Config.Garages[garage]["car"].spawncar, 3.0)

            if NearbyVehicles then
                spawnCoords = Config.Garages[garage]["car"].spawncar

                if playerCacheCoords then
                    cratedVehicle = CreateVehicle(model, playerCacheCoords, true, true)
                    SetVehicleNumberPlateText(cratedVehicle, plate)
                    frameworkObject.Functions.SetVehicleProperties(cratedVehicle,props)
                    SetVehicleEngineOn(cratedVehicle, true, true)
                    SetEntityAsMissionEntity(cratedVehicle, true, true)
                    SetVehicleHasBeenOwnedByPlayer(cratedVehicle, true)
                    SetVehRadioStation(cratedVehicle, "OFF")
                    Config.SetVehicleFuel(cratedVehicle,props.fuelLevel)
                    GiveVehicleKeys(plate,model,cratedVehicle)
                    if repaired[car] then
                        SetVehicleDirtLevel(cratedVehicle,0,0)
                        SetVehicleUndriveable(cratedVehicle, false)
                        WashDecalsFromVehicle(cratedVehicle, 1.0)
                        SetVehicleFixed(cratedVehicle)
                        SetVehicleDeformationFixed(cratedVehicle)
                    end
                else
                    vehicle = CreateVehicle(model, spawnCoords, true, true)
                    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                    SetVehicleNumberPlateText(vehicle, plate)
                    frameworkObject.Functions.SetVehicleProperties(vehicle,props)
                    GiveVehicleKeys(frameworkObject.Functions.GetPlate(vehicle),model,vehicle)
                    SetVehicleEngineOn(vehicle, true, true)
                    SetEntityAsMissionEntity(vehicle, true, true)
                    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
                    SetVehRadioStation(vehicle, "OFF")
                    Config.SetVehicleFuel(vehicle,props.fuelLevel)

                    if repaired[car] then
                        SetVehicleDirtLevel(vehicle,0,0)
                        SetVehicleUndriveable(vehicle, false)
                        WashDecalsFromVehicle(vehicle, 1.0)
                        SetVehicleFixed(vehicle)
                        SetVehicleDeformationFixed(vehicle)
                    end

                    if Config.Garages[garage].garage == "jobgarage" then
                        Config.SetVehicleFuel(vehicle,100)
                        SetVehicleLivery(vehicle,currentlivery)
                        for extraID = 0, 20 do
                            if veh_extras.vehicleExtras[extraID] == true then
                                check = true
                            else
                                check = false
                            end
                            SetVehicleExtra(vehicle, extraID, check)
                        end
                        if Config.JobVehicleMax then
                            PerformanceUpgradeVehicle(vehicle)
                        end
                    end
                end

                TriggerServerEvent('codem-garage:stored',plate,0,garage)

                if data.vale == 2 then
                    TriggerServerEvent('codem-garage:pay','vale')
                elseif data.vale == 3 then
                    TriggerServerEvent('codem-garage:pay','impound')
                end

            else

                Config.ClientNotification(Config.NotificationText["OCCUPIED"].text, Config.NotificationText["OCCUPIED"].type, Config.NotificationText["OCCUPIED"].timeout)
            end
        end
    end
end)

local performanceModIndices = { 11, 12, 13, 15, 16 }
function PerformanceUpgradeVehicle(vehicle, customWheels)
    customWheels = customWheels or false
    local max
    if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
        SetVehicleModKit(vehicle, 0)
        for _, modType in ipairs(performanceModIndices) do
            max = GetNumVehicleMods(vehicle, tonumber(modType)) - 1
            SetVehicleMod(vehicle, modType, max, customWheels)
        end
        ToggleVehicleMod(vehicle, 18, true) -- Turbo
	SetVehicleFixed(vehicle)
    SetVehicleDirtLevel(vehicle, 0)
    SetVehiclePetrolTankHealth(vehicle, 1000.0)
    SetVehicleEngineHealth(vehicle, 1000.0)
    end
end
RegisterNUICallback('extra',function (data, cb)
    local count = tonumber(data.count)
    if DoesEntityExist(car) then
        if IsVehicleExtraTurnedOn(car,count) then
            SetVehicleExtra(car,count,true)
            veh_extras.vehicleExtras[count] = true
        else
            SetVehicleExtra(car,count,false)
            veh_extras.vehicleExtras[count] = false
        end

    end
    cb("ok")
end)

RegisterNUICallback('apply',function (data, cb)
    local count = data.count
    currentlivery = GetVehicleLivery(car)
    for extraID = 0, 20 do
        if veh_extras.vehicleExtras[extraID] == IsVehicleExtraTurnedOn(car, extraID) == 1 then
            check = true
        else
            check = false
        end
    end
    cb("ok")

end)

RegisterNUICallback('livery',function (data, cb)
    local count = data.count
    if DoesEntityExist(car) then
        SetVehicleLivery(car,count)
        currentlivery = count
    end
    cb("ok")

end)

RegisterNUICallback('repair',function(data, cb)
    if data.plate then
        local money = Callback('codem-garage:checkmoney2')
        if money then
            if not repaired[car] and car then
                repaired[car] = true
                TriggerServerEvent('codem-garage:repair',data.plate)
            else
                Config.ClientNotification(Config.NotificationText["ALREADYREPAIRED"].text, Config.NotificationText["ALREADYREPAIRED"].type, Config.NotificationText["ALREADYREPAIRED"].timeout)
            end
        else
            Config.ClientNotification(Config.NotificationText["NO_MONEY"].text, Config.NotificationText["NO_MONEY"].type, Config.NotificationText["NO_MONEY"].timeout)
        end
    end
    if cb then
        cb("ok")
    end
end)

RegisterNetEvent('codem-garage:openGarage')
AddEventHandler('codem-garage:openGarage', function(garageName)
    openGarage(garageName)
end)

RegisterNetEvent('codem-garage:storeVehicle')
AddEventHandler('codem-garage:storeVehicle', function(house)
    local ped = PlayerPedId()
    local playerCar = GetVehiclePedIsIn(ped)
    local plate = GetVehicleNumberPlateText(playerCar)

    ownedVehicle = Callback('codem-garage:checkowned' , plate)

    if ownedVehicle then
        TriggerServerEvent('codem-garage:stored', plate,1,house)

        if Config.Framework == "esx" then
            TriggerServerEvent('codem-garage:saveProps', plate, frameworkObject.Game.GetVehicleProperties(playerCar))
        else
            TriggerServerEvent('codem-garage:saveProps', plate, frameworkObject.Functions.GetVehicleProperties(playerCar))
        end

        Citizen.Wait(250)
        TaskLeaveVehicle(ped, playerCar, 0)
        Citizen.Wait(1500)
        DeleteEntity(playerCar)
    end
end)

RegisterNetEvent('codem-garage:openHouseGarage')
AddEventHandler('codem-garage:openHouseGarage', function()
    openGarage('House Garage', true)
end)

-- blip and ped

Citizen.CreateThread(function()
    for _,v in pairs(Config.Garages) do
        if v.npc["show"] == nil then
            v.npc["show"] = true
        end
        if v.npc["show"] then
            RequestModel(v.npc["npcModel"])
            while not HasModelLoaded(v.npc["npcModel"]) do
            Wait(1)
            end
            ped =  CreatePed(4,v.npc["npcModel"], v.npc["npc"].x,v.npc["npc"].y,v.npc["npc"].z -1, 3374176, false, true)
            SetEntityHeading(ped,v.npc["npc"].w)
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
        end
        if Config.Blip then
            if v.blip["show"] then
                local blip = AddBlipForCoord(v.npc["npc"])
                SetBlipSprite(blip, v.blip["blipType"])
                SetBlipScale(blip, 0.6)
                SetBlipColour(blip, v.blip["blipColour"])
                SetBlipDisplay(blip, 4)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                if Config.GarageName == true then
                    AddTextComponentString(k)
                else
                    AddTextComponentString(v.blip["blipName"])
                end
                EndTextCommandSetBlipName(blip)
            end
        end
    end
end)

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    garageOpened = false
    ClearFocus()
    DestroyCam(cam)
    RenderScriptCams(0, 1, 750, 1, 0)
    veh_extras = {['vehicleExtras'] = {}}
    Config.MenuClose()

    if DoesEntityExist(car) then
        DeleteVehicle(car)
    end

    if playerCacheCoords then
        local playerPed = PlayerPedId()
        SetEntityCoords(playerPed, playerCacheCoords)

        local syncAttempts = 0
        while syncAttempts < 20 do
            Wait(100)
            syncAttempts = syncAttempts + 1
            local currentPos = GetEntityCoords(playerPed)
            local distToTarget = #(currentPos - playerCacheCoords)
            if distToTarget < 1.0 then
                break
            end
        end

        if cratedVehicle and DoesEntityExist(cratedVehicle) then
            local carPos = GetEntityCoords(cratedVehicle)
            local playerPos = GetEntityCoords(playerPed)
            local dist = #(carPos - playerCacheCoords)
            local dist2 = #(carPos - playerPos)

            if dist < 10.0 or dist2 < 10.0 then
                TaskWarpPedIntoVehicle(playerPed, cratedVehicle, -1)
            end
        end

        playerCacheCoords = nil
        cratedVehicle = nil
    end

    local closedAttempts = 0
    while closedAttempts < 200 do
        Wait(10)
        closedAttempts = closedAttempts + 1
        if not garageOpened and DoesEntityExist(car) then
            DeleteVehicle(car)
        end
        if garageOpened then
            break
        end
    end

    if cb then
        cb("ok")
    end
end)

function LoadModel(model)
    local attempts = 0
    if type(model) == "string" then
        model = GetHashKey(model)
    end

    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(10)
        attempts = attempts + 1

        if attempts > 100 then
            spawned = false
            break
        end

        if not garageOpened and DoesEntityExist(car) then
            DeleteVehicle(car)
        end
    end

    return model
end

function WaitPlayer()
    if Config.Framework == "esx" then
        while frameworkObject == nil do
            Citizen.Wait(0)
        end
        while frameworkObject.GetPlayerData()  == nil do
            Citizen.Wait(0)
        end
        while frameworkObject.GetPlayerData().job == nil do
            Citizen.Wait(0)
        end
    else
        while frameworkObject == nil do
            Citizen.Wait(0)
        end
        while frameworkObject.Functions.GetPlayerData() == nil do
            Citizen.Wait(0)
        end
        while frameworkObject.Functions.GetPlayerData().metadata == nil do
            Citizen.Wait(0)
        end
    end
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    Citizen.Wait(2500)
    while Core == nil do
        Citizen.Wait(0)
    end
    local discordimage = Callback('codem-garage:getimage')
    local playername = Callback('codem-garage:getname')
    SendNUIMessage({
        action = "SET_PROFILE",
        avatar = discordimage,
        name = playername,
    })
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    Citizen.Wait(2500)
    while Core == nil do
        Citizen.Wait(0)
    end
    local discordimage = Callback('codem-garage:getimage')
    local playername = Callback('codem-garage:getname')
    SendNUIMessage({
        action = "SET_PROFILE",
        avatar = discordimage,
        name = playername,
    })
end)