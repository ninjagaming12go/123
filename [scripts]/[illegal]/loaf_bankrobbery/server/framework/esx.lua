if Config.Framework ~= "esx" then
    return
end

local _, ESX = pcall(function()
    return exports.es_extended:getSharedObject()
end)

if not ESX then
    TriggerEvent("esx:getSharedObject", function(obj)
        ESX = obj
    end)
end

function GetPolice()
	local police = 0

    if ESX.GetNumPlayers then
		for i = 1, #Config.PoliceJobs do
			police += ESX.GetNumPlayers("job", Config.PoliceJobs[i])
		end

		return police
	end

	if ESX.JobsPlayerCount then
        for i = 1, #Config.PoliceJobs do
            local jobKey = ("%s:count"):format(Config.PoliceJobs[i])

            police += GlobalState[jobKey] or 0
        end

        return police
    end

	print("^3[WARNING]^7: You are running an outdated version of ESX. The script will still work, but you should consider updating.")

	if ESX.GetExtendedPlayers then
		for i = 1, #Config.PoliceJobs do
			police += #ESX.GetExtendedPlayers("job", Config.PoliceJobs[i])
		end

		return police
	end

	print("^3[WARNING]^7: You are running an extremely old version of ESX. The script will still work, but you should consider updating.")

	local xPlayers = ESX.GetPlayers()

    for playerId = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[playerId])

        for i = 1, #Config.PoliceJobs do
            if xPlayer.job.name == Config.PoliceJobs[i] then
                police += 1
            end
        end
    end

	return police
end

function IsPolice(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        return false
    end

    local job = xPlayer.job.name

    for i = 1, #Config.PoliceJobs do
        if job == Config.PoliceJobs[i] then
            return true
        end
    end

    return false
end

function GetItemCount(source, item)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        return 0
    end

    return xPlayer.getInventoryItem(item)?.count or 0
end

function AddItem(source, item, amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        return false
    end

    if xPlayer.canCarryItem and not xPlayer.canCarryItem(item, amount) then
        return false
    elseif not xPlayer.canCarryItem then
        local itemData = xPlayer.getInventoryItem(item)

        if itemData.limit ~= -1 and itemData.count + amount > itemData.limit then
            return false
        end
    end

    xPlayer.addInventoryItem(item, amount)
    return true
end

function RemoveItem(source, item, amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        return false
    end

    if GetItemCount(source, item) >= amount then
        xPlayer.removeInventoryItem(item, amount)
        return true
    end

    return false
end

function GiveMoney(source, amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        return false
    end

    if Config.GiveBlackMoney then
        xPlayer.addAccountMoney("black_money", amount)
    else
        xPlayer.addMoney(amount)
    end

    return true
end

function CreateUsableItem(item, cb)
    ESX.RegisterUsableItem(item, cb)
end
