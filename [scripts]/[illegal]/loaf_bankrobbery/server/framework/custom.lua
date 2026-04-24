if Config.Framework ~= "custom" then
    return
end

function GetPolice()
    return 0
end

function IsPolice(source)
    return false
end

function GetItemCount(source, item)
    if GetResourceState("ox_inventory") == "started" then
        return exports.ox_inventory:GetItemCount(source, item)
    end

    return 0
end

function AddItem(source, item, amount)
    if GetResourceState("ox_inventory") == "started" then
        exports.ox_inventory:AddItem(source, item, amount)
        return true
    end

    return false
end

function RemoveItem(source, item, amount)
    if GetResourceState("ox_inventory") == "started" then
        return exports.ox_inventory:RemoveItem(source, item, amount)
    end

    return false
end

function GiveMoney(source, amount)
    return false
end
