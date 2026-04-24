local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
    SendNUIMessage({ action = "hideAll" })
    SetNuiFocus(false, false)
end)

local function OpenDealership()
    QBCore.Functions.TriggerCallback("rx-trucking:getDealershipData", function(data)
        SetNuiFocus(true, true)
SendNUIMessage({
    action = "openDealership",
    trucks = data.trucks,
    level = data.level,
    owned = data.owned
})
    end)
end

RegisterNUICallback("dealershipClose", function(_, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterNUICallback("dealershipBuy", function(data, cb)
    TriggerServerEvent("rx-trucking:buyTruck", data.model)
    cb("ok")
end)

RegisterNUICallback("dealershipRent", function(data, cb)
    TriggerServerEvent("rx-trucking:rentTruck", data.model)
    cb("ok")
end)

RegisterNUICallback("dealershipSpawn", function(data, cb)
    TriggerServerEvent("rx-trucking:spawnOwnedTruck", data.model)
    cb("ok")
end)

RegisterNetEvent("rx-trucking:spawnTruck", function(model)
    local ped = PlayerPedId()
    local hash = GetHashKey(model)
    RequestModel(hash)
    while not HasModelLoaded(hash) do Wait(0) end

    local veh = CreateVehicle(hash, 906.7621, -3118.0623, 5.9008, 29.0133, true, false)
    SetPedIntoVehicle(ped, veh, -1)
    SetVehicleOnGroundProperly(veh)
end)

CreateThread(function()
    local pedHash = TruckingConfig.DealershipPed.model
    RequestModel(pedHash)
    while not HasModelLoaded(pedHash) do Wait(0) end

    local c = TruckingConfig.DealershipPed.coords
    local ped = CreatePed(4, pedHash, c.x, c.y, c.z, c.w, false, true)

    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    exports['qb-target']:AddTargetEntity(ped, {
        options = {
            {
                label = "Open Truck Dealership",
                icon = "fas fa-truck",
                action = function()
                    OpenDealership()
                end
            }
        },
        distance = 2.0
    })
end)

CreateThread(function()
    local c = TruckingConfig.DealershipPed.coords

    local dealerBlip = AddBlipForCoord(c.x, c.y, c.z)
    SetBlipSprite(dealerBlip, 431)
    SetBlipDisplay(dealerBlip, 4)
    SetBlipScale(dealerBlip, 0.9)
    SetBlipColour(dealerBlip, 2)
    SetBlipAsShortRange(dealerBlip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Truck Dealership")
    EndTextCommandSetBlipName(dealerBlip)
end)
