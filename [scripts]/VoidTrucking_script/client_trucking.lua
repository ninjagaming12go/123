local QBCore = exports['qb-core']:GetCoreObject()

local currentJob = nil
local jobPhase = nil
local CurrentDestBlip = nil
local activeTrailers = {}
local trailerCount = 1

local function DrawRedRadius(coords)
    if not coords then return end
    local x, y, z = coords.x, coords.y, coords.z
    local found, groundZ = GetGroundZFor_3dCoord(x, y, z, false)
    if not found then groundZ = z end
    DrawMarker(1, x, y, groundZ - 1.0, 0,0,0, 0,0,0, 6.0,6.0,1.0, 255,0,0,120, false,false,2,false)
end

local function IsGroundValid(coords)
    local found, z = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z, false)
    return found and z > 0.0
end

local function IsOnRoad(coords)
    return IsPointOnRoad(coords.x, coords.y, coords.z, PlayerPedId())
end

local function IsAreaClear(coords)
    return not IsPositionOccupied(coords.x, coords.y, coords.z, 6.0, false, true, true, false, false, 0, false)
end

local function IsSafeForTrailer(coords)
    return IsGroundValid(coords) and IsOnRoad(coords) and IsAreaClear(coords)
end

local function GetSafePickup()
    for i = 1, 80 do
        local loc = TruckingConfig.TrailerPickupLocations[math.random(#TruckingConfig.TrailerPickupLocations)]
        loc = vector3(loc.x, loc.y, loc.z)
        if IsSafeForTrailer(loc) then return loc end
    end
    return TruckingConfig.TrailerPickupLocations[1]
end

local function GetSafeDropoffFarFromPickup(pickup)
    for i = 1, 80 do
        local raw = TruckingConfig.TrailerDropoffLocations[math.random(#TruckingConfig.TrailerDropoffLocations)]
        local loc = vector3(raw.pos.x, raw.pos.y, raw.pos.z)
        if IsSafeForTrailer(loc) then
            if #(loc - pickup) >= 2000.0 then
                return raw
            end
        end
    end
    return TruckingConfig.TrailerDropoffLocations[#TruckingConfig.TrailerDropoffLocations]
end

CreateThread(function()
    SendNUIMessage({ action = "hideAll" })
    SetNuiFocus(false, false)
end)

RegisterNUICallback("startJob", function(_, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "closeJobMenu" })
    TriggerServerEvent("rx-trucking:startJobFromUI")
    cb("ok")
end)

RegisterNUICallback("illegalJob", function(_, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "closeJobMenu" })
    TriggerServerEvent("rx-trucking:startIllegalJob")
    cb("ok")
end)

RegisterNUICallback("closeJob", function(_, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "closeJobMenu" })
    cb("ok")
end)

RegisterNetEvent("rx-trucking:openJobMenuNPC", function()
    SetNuiFocus(true, true)
    SendNUIMessage({ action = "openJobMenu" })
end)

RegisterNetEvent("rx-trucking:openIllegalJobMenuNPC", function()
    SetNuiFocus(true, true)
    SendNUIMessage({ action = "openIllegalJobMenu" })
end)

CreateThread(function()
    local model = `s_m_m_trucker_01`
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end
    local coords = TruckingConfig.JobNPC.coords
    local ped = CreatePed(4, model, coords.x, coords.y, coords.z - 1.0, coords.w, false, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    exports['qb-target']:AddTargetEntity(ped, {
        options = {
            {
                label = "Start Trucking Job",
                icon = "fas fa-truck",
                action = function()
                    TriggerEvent("rx-trucking:openJobMenuNPC")
                end
            },
        },
        distance = 2.0
    })
end)
---------------------------------------------------------------------
-- TRUCKING DEPOT BLIP
---------------------------------------------------------------------

CreateThread(function()
    local c = TruckingConfig.JobNPC.coords

    local depotBlip = AddBlipForCoord(c.x, c.y, c.z)
    SetBlipSprite(depotBlip, 477)
    SetBlipScale(depotBlip, 0.8)
    SetBlipColour(depotBlip, 2)
    SetBlipAsShortRange(depotBlip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Trucking Depot")
    EndTextCommandSetBlipName(depotBlip)
end)

RegisterNetEvent("rx-trucking:spawnOwnedTruckAtDealership", function(model, plate)
    local spawn = TruckingConfig.DealershipSpawn.coords
    local hash = GetHashKey(model)
    RequestModel(hash)
    while not HasModelLoaded(hash) do Wait(0) end
    local veh = CreateVehicle(hash, spawn.x, spawn.y, spawn.z, spawn.w, true, false)
    SetVehicleNumberPlateText(veh, plate)
    SetVehicleOnGroundProperly(veh)
    SetEntityAsMissionEntity(veh, true, true)
    TriggerServerEvent("qb-vehiclekeys:server:AddKey", plate)
    QBCore.Functions.Notify("Your truck is waiting outside the dealership!", "success")
end)

local function CreateDestinationBlip(coords)
    if DoesBlipExist(CurrentDestBlip) then RemoveBlip(CurrentDestBlip) end
    CurrentDestBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(CurrentDestBlip, 1)
    SetBlipColour(CurrentDestBlip, 5)
    SetBlipScale(CurrentDestBlip, 1.2)
    SetBlipRoute(CurrentDestBlip, true)
    SetBlipRouteColour(CurrentDestBlip, 5)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Destination")
    EndTextCommandSetBlipName(CurrentDestBlip)
end

RegisterNetEvent("rx-trucking:validateTruck", function()
    TriggerEvent("rx-trucking:startNextMission")
end)

RegisterNetEvent("rx-trucking:startIllegalRoute", function()
    StartIllegalTruckingJob()
end)

RegisterNetEvent("rx-trucking:startNextMission", function()
    local pickup = GetSafePickup()
    local dropRaw = GetSafeDropoffFarFromPickup(pickup)
    trailerCount = 1
    currentJob = {
        start = pickup,
        dropoff = dropRaw.pos,
        pay = dropRaw.pay,
        type = "legal"
    }
    jobPhase = "pickup"
    CreateDestinationBlip(pickup)
    QBCore.Functions.Notify("Drive to the trailer pickup location")
end)

function StartIllegalTruckingJob()
    local pickup = GetSafePickup()
    local dropRaw = GetSafeDropoffFarFromPickup(pickup)
    trailerCount = 1
    currentJob = {
        start = pickup,
        dropoff = dropRaw.pos,
        pay = dropRaw.pay * 1.3,
        type = "illegal"
    }
    jobPhase = "pickup"
    CreateDestinationBlip(pickup)
    QBCore.Functions.Notify("Drive to the illegal trailer pickup location")
end

CreateThread(function()
    while true do
        Wait(0)
        if jobPhase == "pickup" and currentJob then
            DrawRedRadius(currentJob.start)
        elseif jobPhase == "delivery" and currentJob then
            DrawRedRadius(currentJob.dropoff)
        end
    end
end)

RegisterNetEvent("rx-trucking:spawnPickupTrailer", function(dropoff)
    local ped = PlayerPedId()
    local truck = GetVehiclePedIsIn(ped, false)
    activeTrailers = {}
    local model = TruckingConfig.TrailerModels[math.random(#TruckingConfig.TrailerModels)]
    local hash = GetHashKey(model)
    RequestModel(hash)
    while not HasModelLoaded(hash) do Wait(0) end
    local base = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local trailer = CreateVehicle(hash, base.x, base.y - 12.0, base.z, heading, true, false)
    table.insert(activeTrailers, trailer)
    if truck ~= 0 then AttachVehicleToTrailer(truck, trailer, 1.0) end
    jobPhase = "delivery"
    CreateDestinationBlip(dropoff)
    QBCore.Functions.Notify("Deliver the trailer to the marked location")
end)

CreateThread(function()
    while true do
        Wait(200)
        local ped = PlayerPedId()
        local truck = GetVehiclePedIsIn(ped, false)
        if truck ~= 0 then
            local hasTrailer, trailer = GetVehicleTrailerVehicle(truck)
            if hasTrailer and trailer ~= 0 then
                if GetEntityHealth(trailer) < 100 then SetEntityHealth(trailer, 100) end
                if GetVehicleBodyHealth(trailer) < 100.0 then SetVehicleBodyHealth(trailer, 100.0) end
                if GetVehicleEngineHealth(trailer) < 100.0 then SetVehicleEngineHealth(trailer, 100.0) end
            end
        end
    end
end)

CreateThread(function()
    while true do
        Wait(500)
        if currentJob and jobPhase then
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            if jobPhase == "pickup" then
                if #(coords - currentJob.start) < 6.0 then
                    TriggerEvent("rx-trucking:spawnPickupTrailer", currentJob.dropoff)
                end
            elseif jobPhase == "delivery" then
                if #(coords - currentJob.dropoff) < 6.0 then
                    local truck = GetVehiclePedIsIn(ped, false)
                    local engine = truck ~= 0 and GetVehicleEngineHealth(truck) or 1000
                    local body = truck ~= 0 and GetVehicleBodyHealth(truck) or 1000
                    local tEngine = 1000
                    local tBody = 1000
                    local hasTrailer, trailer = GetVehicleTrailerVehicle(truck)
                    if hasTrailer and trailer ~= 0 then
                        tEngine = GetVehicleEngineHealth(trailer)
                        tBody = GetVehicleBodyHealth(trailer)
                    end
                    for _, t in ipairs(activeTrailers) do
                        if DoesEntityExist(t) then DeleteEntity(t) end
                    end
                    if DoesBlipExist(CurrentDestBlip) then RemoveBlip(CurrentDestBlip) end
                    TriggerServerEvent("rx-trucking:finishJob", currentJob.type, currentJob, engine, body, tEngine, tBody, trailerCount)
                    CreateThread(function()
                        Wait(500)
                        TriggerEvent("rx-trucking:startNextMission")
                    end)
                end
            end
        end
    end
end)

local function CombinedHealth(engine, body)
    local avg = (engine + body) / 2
    local percent = (avg / 1000) * 100
    return math.floor(percent)
end

CreateThread(function()
    while true do
        Wait(500)

        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)

        if veh == 0 then
            SendNUIMessage({ action = "updateMergedHealth", merged = -1 })
            goto continue
        end

        if GetVehicleClass(veh) ~= 20 then
            SendNUIMessage({ action = "updateMergedHealth", merged = -1 })
            goto continue
        end

        local engine = GetVehicleEngineHealth(veh)
        local body = GetVehicleBodyHealth(veh)
        local truckHealth = (engine + body) / 2

        local hasTrailer, trailer = GetVehicleTrailerVehicle(veh)
        local trailerHealth = 1000

        if hasTrailer and trailer ~= 0 then
            local tEngine = GetVehicleEngineHealth(trailer)
            local tBody = GetVehicleBodyHealth(trailer)
            trailerHealth = (tEngine + tBody) / 2
        end

        local merged = math.floor(((truckHealth + trailerHealth) / 2) / 1000 * 100)

        SendNUIMessage({
            action = "updateMergedHealth",
            merged = merged
        })

        ::continue::
    end
end)


