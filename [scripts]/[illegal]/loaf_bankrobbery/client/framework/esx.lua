if Config.Framework ~= "esx" then
    return
end

local _, ESX = pcall(function()
    return exports.es_extended:getSharedObject()
end)

while not ESX do
    TriggerEvent("esx:getSharedObject", function(obj)
        ESX = obj
    end)

    Wait(500)
end

RegisterNetEvent("esx:playerLoaded", function(playerData)
    ESX.PlayerData = playerData
    ESX.PlayerLoaded = true
end)

RegisterNetEvent("esx:setJob", function(job)
    if not ESX.PlayerData then
        return
    end

    local wasPolice = IsPolice()

    ESX.PlayerData.job = job

    if not wasPolice and IsPolice() then
        TriggerServerEvent("loaf_bankrobbery:getPoliceAlerts")
    end

    RefreshAllMarkers()
end)

function IsPolice()
    local job = ESX.PlayerData.job?.name

    for i = 1, #Config.PoliceJobs do
        if Config.PoliceJobs[i] == job then
            return true
        end
    end

    return false
end

function Notify(text, errType)
    ESX.ShowNotification(text, errType)
end

function GetItemLabel(item)
    return item
end

while not ESX.PlayerLoaded do
    Wait(500)
end

Loaded = true
