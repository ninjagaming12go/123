local QBCore = exports['qb-core']:GetCoreObject()

local CurrentPlane = nil
local LandingActive = false
local LandingCoords = nil
local LandingBlip = nil

-- JOB NPC + BLIP
CreateThread(function()
    local model = `s_m_m_pilot_01`
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end

    local coords = vector4(-976.9468, -2940.4297, 13.9451, 220.2686)

    local ped = CreatePed(4, model, coords.x, coords.y, coords.z - 1.0, coords.w, false, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    exports['qb-target']:AddTargetEntity(ped, {
        options = {
            {
                type = "client",
                event = "pilot:openRootUI",
                icon = "fas fa-briefcase",
                label = "Pilot Job"
            }
        },
        distance = 2.0
    })

    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 307)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 3)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Pilot Job")
    EndTextCommandSetBlipName(blip)
end)

RegisterNetEvent("pilot:openRootUI", function()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openRoot"
    })
end)
--contract menu
RegisterNetEvent("pilot:client:openContract", function(kind, jobs)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openContract",
        kind = kind,
        legal = (kind == "legal") and jobs or nil,
        illegal = (kind == "illegal") and jobs or nil
    })
end)
-- ROOT MENU CALLBACKS
RegisterNUICallback("rootLegal", function(_, cb)
    TriggerServerEvent("rootLegal")
    cb("ok")
end)

RegisterNUICallback("rootIllegal", function(_, cb)
    TriggerServerEvent("rootIllegal")
    cb("ok")
end)

RegisterNUICallback("rootClose", function(_, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)

-- CONTRACT MENU CLOSE
RegisterNUICallback("closeContract", function(_, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterNUICallback("selectJob", function(data, cb)
    TriggerServerEvent("selectJob", data)
    SetNuiFocus(false, false)
    cb("ok")
end)

-- Dealer Ped

-- DEALERSHIP BLIP
CreateThread(function()
    local coords = vector3(-964.8337, -2965.2017, 13.9451)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)

    SetBlipSprite(blip, 431)     -- Dollar sign
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 3)       -- Blue
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Plane Dealership")
    EndTextCommandSetBlipName(blip)
end)

CreateThread(function()
    local pedData = Config.DealerPed
    local hash = GetHashKey(pedData.model)
    RequestModel(hash)
    while not HasModelLoaded(hash) do Wait(0) end

    local ped = CreatePed(4, hash, pedData.coords.x, pedData.coords.y, pedData.coords.z - 1.0, pedData.coords.w, false, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    exports['qb-target']:AddTargetEntity(ped, {
        options = {
            {
                type = "client",
                event = "pilot:openDealerUI",
                icon = "fas fa-plane",
                label = "Plane Dealership"
            }
        },
        distance = 2.0
    })
end)

-- Open Dealer UI
RegisterNetEvent("pilot:openDealerUI", function()
    TriggerServerEvent("pilot:openDealerUI")
end)

RegisterNetEvent("pilot:client:openDealer", function(planes, level, owned)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openDealer",
        planes = planes,
        playerLevel = level,
        ownedPlanes = owned
    })
end)

-- Spawn Plane
local function SpawnPlane(model, plate)
    local spawn = Config.DealerSpawn.coords
    local hash = GetHashKey(model)

    RequestModel(hash)
    while not HasModelLoaded(hash) do Wait(0) end

    local veh = CreateVehicle(hash, spawn.x, spawn.y, spawn.z, spawn.w, true, false)
    SetVehicleOnGroundProperly(veh)
    SetVehicleNumberPlateText(veh, plate or ("RENT"..math.random(100,999)))
    SetPedIntoVehicle(PlayerPedId(), veh, -1)

    TriggerEvent("vehiclekeys:client:SetOwner", plate)
    CurrentPlane = veh
end

RegisterNetEvent("pilot:spawnOwnedPlane", function(model, plate)
    SpawnPlane(model, plate)
end)

RegisterNetEvent("pilot:spawnRentedPlane", function(model)
    SpawnPlane(model, nil)
end)

-- NUI Callbacks
RegisterNUICallback("dealerBuy", function(data, cb)
    TriggerServerEvent("pilot:buyPlane", data.model)
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterNUICallback("dealerRent", function(data, cb)
    TriggerServerEvent("pilot:rentPlaneDealer", data.model)
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterNUICallback("dealerSpawnOwned", function(data, cb)
    TriggerServerEvent("pilot:dealerSpawnOwned", data.model)
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterNUICallback("dealerClose", function(_, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)

-- Landing Logic
RegisterNetEvent("pilot:startLanding", function(destination)
    local zone = Config.LandingZones[destination]
    if not zone then return end

    LandingCoords = zone.coords
    LandingActive = true

    SetNewWaypoint(zone.waypoint.x, zone.waypoint.y)

    if LandingBlip then RemoveBlip(LandingBlip) end
    LandingBlip = AddBlipForCoord(LandingCoords.x, LandingCoords.y, LandingCoords.z)
    SetBlipSprite(LandingBlip, 90)
    SetBlipColour(LandingBlip, 5)
    SetBlipScale(LandingBlip, 0.9)
end)

CreateThread(function()
    while true do
        Wait(0)

        if LandingActive and LandingCoords and CurrentPlane then
            DrawMarker(1, LandingCoords.x, LandingCoords.y, LandingCoords.z + 1.0, 0,0,0, 0,0,0, 8.0,8.0,1.0, 255,255,0,150, false,true,2,false,nil,nil,false)

            local pos = GetEntityCoords(CurrentPlane)
            local dist = #(pos - LandingCoords)

            if dist < 50.0 then
                local speed = GetEntitySpeed(CurrentPlane) * 3.6
                local safe = speed < 120.0

                TriggerServerEvent("pilot:completeMission", safe)

                LandingActive = false
                LandingCoords = nil

                if LandingBlip then
                    RemoveBlip(LandingBlip)
                    LandingBlip = nil
                end
            end
        end
    end
end)
