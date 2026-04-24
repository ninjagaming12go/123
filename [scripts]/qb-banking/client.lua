local QBCore = exports['qb-core']:GetCoreObject()
local bankOpen = false

RegisterNetEvent('qb-banking:openMenu', function()
    if bankOpen then return end
    bankOpen = true

    QBCore.Functions.TriggerCallback('qb-banking:getPersonalBalance', function(personal)
        QBCore.Functions.TriggerCallback('qb-banking:getJointAccounts', function(joint)
            QBCore.Functions.TriggerCallback('qb-banking:getSocietyAccount', function(society)

                SendNUIMessage({
                    action = 'openBank',
                    personal = personal,
                    joint = joint,
                    society = society
                })

                Wait(50)
                SetNuiFocus(true, true)
            end)
        end)
    end)
end)

RegisterNUICallback('jointDeposit', function(data, cb)
    TriggerServerEvent('qb-banking:jointDeposit', data.accountId, tonumber(data.amount))
    cb('ok')
end)

RegisterNUICallback('jointWithdraw', function(data, cb)
    TriggerServerEvent('qb-banking:jointWithdraw', data.accountId, tonumber(data.amount))
    cb('ok')
end)

RegisterNUICallback('societyDeposit', function(data, cb)
    TriggerServerEvent('qb-banking:societyDeposit', tonumber(data.amount))
    cb('ok')
end)

RegisterNUICallback('societyWithdraw', function(data, cb)
    TriggerServerEvent('qb-banking:societyWithdraw', tonumber(data.amount))
    cb('ok')
end)

RegisterNUICallback('close', function(_, cb)
    bankOpen = false
    SetNuiFocus(false, false)
    cb('ok')
end)

CreateThread(function()
    Wait(500)

    for i, loc in ipairs(Config.BankLocations) do

        exports['qb-target']:AddBoxZone('bank_'..i, loc, 1.5, 1.5, {
            name = 'bank_'..i,
            heading = 0,
            debugPoly = false
        }, {
            options = {
                {
                    event = 'qb-banking:openMenu',
                    icon = 'fas fa-university',
                    label = 'Open Bank'
                }
            },
            distance = 2.0
        })

        local blip = AddBlipForCoord(loc.x, loc.y, loc.z)
        SetBlipSprite(blip, Config.BankBlipSprite)
        SetBlipScale(blip, Config.BankBlipScale)
        SetBlipColour(blip, Config.BankBlipColour)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Bank")
        EndTextCommandSetBlipName(blip)
    end
end)

AddEventHandler('onResourceStart', function(res)
    if res == GetCurrentResourceName() then
        SetNuiFocus(false, false)
        SendNUIMessage({ action = 'closeBank' })
    end
end)
