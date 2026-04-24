function TriggerCallback(name, data)
    local incomingData = false
    local status = 'UNKOWN'
    local counter = 0
    while Core == nil and not nuiLoaded do
        Wait(0)
    end
    if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
        Core.TriggerServerCallback(name, function(payload)
            status = 'SUCCESS'
            incomingData = payload
        end, data)
    else
        Core.Functions.TriggerCallback(name, function(payload)
            status = 'SUCCESS'
            incomingData = payload
        end, data)
    end
    CreateThread(function()
        while incomingData == 'UNKOWN' do
            Wait(1000)
            if counter == 4 then
                status = 'FAILED'
                incomingData = false
                break
            end
            counter = counter + 1
        end
    end)

    while status == 'UNKOWN' do
        Wait(0)
    end
    return incomingData
end

function WaitForModel(model)
    if not IsModelValid(model) then
        return
    end
    if not HasModelLoaded(model) then
        RequestModel(model)
    end
    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end
end

function WaitCore()
    while Core == nil do
        Wait(0)
    end
end

function SetPlayerJob()
    while Core == nil do
        Wait(0)
    end
    Wait(500)
    while not nuiLoaded do
        Wait(50)
    end
    WaitPlayer()

    if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
        local PlayerData = Core.GetPlayerData()
        if next(PlayerData) == nil then
            return 'unemployed'
        else
            return PlayerData.job.name
        end
    else
        local PlayerData = Core.Functions.GetPlayerData()
        if next(PlayerData) == nil then
            return 'unemployed'
        else
            return PlayerData["job"].name
        end
    end
end

  AddEventHandler('onClientResourceStop', function (resourceName)
    DeleteNotSelectedPedorVehicle()
  end)