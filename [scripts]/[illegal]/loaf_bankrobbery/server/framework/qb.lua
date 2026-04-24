if Config.Framework ~= "qb-core" then
    return
end

local QB = exports["qb-core"]:GetCoreObject()

function GetPolice()
    local police = 0

    local qPlayers = QB.Functions.GetQBPlayers()
    for _, v in pairs(qPlayers) do
        if v and v.PlayerData.job.name == "police" and v.PlayerData.job.onduty then
            police += 1
        end
    end

    return police
end

function IsPolice(source)
    local qPlayer = QB.Functions.GetPlayer(source)
    if not qPlayer then
        return false
    end

    local job = qPlayer.PlayerData.job.name
    for i = 1, #Config.PoliceJobs do
        if job == Config.PoliceJobs[i] then
            return true
        end
    end

    return false
end

function GetItemCount(source, item)
    local qPlayer = QB.Functions.GetPlayer(source)
    if not qPlayer then
        return 0
    end

    return qPlayer.Functions.GetItemByName(item)?.amount or 0
end

function AddItem(source, item, amount)
    local qPlayer = QB.Functions.GetPlayer(source)
    if not qPlayer then
        return false
    end

    qPlayer.Functions.AddItem(item, amount)
    TriggerClientEvent("inventory:client:ItemBox", source, QB.Shared.Items[item], "add")
end

function RemoveItem(source, item, amount)
    local qPlayer = QB.Functions.GetPlayer(source)
    if not qPlayer then
        return false
    end

    if GetItemCount(source, item) >= amount then
        qPlayer.Functions.RemoveItem(item, amount)
        TriggerClientEvent("inventory:client:ItemBox", source, QB.Shared.Items[item], "remove")
        return true
    end

    return false
end

function GiveMoney(source, amount)
    local qPlayer = QB.Functions.GetPlayer(source)
    if not qPlayer then
        return false
    end

    if Config.GiveBlackMoney then
        qPlayer.Functions.AddItem("markedbills", 1, false, { worth = amount })
        TriggerClientEvent("inventory:client:ItemBox", source, QB.Shared.Items["markedbills"], "add")
    else
        qPlayer.Functions.AddMoney("cash", amount)
    end
end

function CreateUsableItem(item, cb)
    QB.Functions.CreateUseableItem(item, cb)
end
