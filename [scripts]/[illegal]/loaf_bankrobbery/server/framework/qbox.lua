if Config.Framework ~= "qbox" then
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
end

function RemoveItem(source, item, amount)
    local qPlayer = QB.Functions.GetPlayer(source)

    if not qPlayer then
        return false
    end

    if GetItemCount(source, item) >= amount then
        qPlayer.Functions.RemoveItem(item, amount)

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
        qPlayer.Functions.AddItem("black_money", amount)
    else
        qPlayer.Functions.AddMoney("cash", amount)
    end
end

function CreateUsableItem(item, cb)
    QB.Functions.CreateUseableItem(item, cb)
end
