local QBCore = exports['qb-core']:GetCoreObject()

---------------------------------------------------------------------
--  LEVEL + XP SYSTEM
---------------------------------------------------------------------
local QBCore = exports['qb-core']:GetCoreObject()

local function GetXPRequired(level)
    return math.floor(TruckingConfig.XPRequiredBase * (TruckingConfig.XPRequiredGrowth ^ (level - 1)))
end

local function GetPlayerLevelData(Player)
    local xp = Player.PlayerData.metadata["truckingxp"] or 0
    local level = Player.PlayerData.metadata["truckinglevel"] or 1
    return xp, level
end

local function SetPlayerLevelData(Player, xp, level)
    Player.Functions.SetMetaData("truckingxp", xp)
    Player.Functions.SetMetaData("truckinglevel", level)
end

local function GiveXP(src, baseXP)
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local xp = Player.PlayerData.metadata["truckingxp"] or 0
    local level = Player.PlayerData.metadata["truckinglevel"] or 1

    local gain = baseXP or TruckingConfig.XPPerJob
    local newXP = xp + gain
    local needed = GetXPRequired(level)
    local leveledUp = false

    while newXP >= needed do
        newXP = newXP - needed
        level = level + 1
        needed = GetXPRequired(level)
        leveledUp = true
    end

    SetPlayerLevelData(Player, newXP, level)

    TriggerClientEvent("trucking:xpBar", src, level, level + 1, newXP, needed, gain)

    if leveledUp then
        TriggerClientEvent("rx-trucking:playLevelUpSound", src)
    end
end

---------------------------------------------------------------------
--  OWNED TRUCKS
---------------------------------------------------------------------

local function GetOwned(Player)
    return Player.PlayerData.metadata[TruckingConfig.TruckingOwnedMeta] or {}
end

local function SetOwned(Player, owned)
    Player.Functions.SetMetaData(TruckingConfig.TruckingOwnedMeta, owned)
end

---------------------------------------------------------------------
--  DEALERSHIP CALLBACK
---------------------------------------------------------------------

QBCore.Functions.CreateCallback("rx-trucking:getDealershipData", function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then 
        return cb({ trucks = {}, level = 1, owned = {} }) 
    end

    local level = Player.PlayerData.metadata[TruckingConfig.TruckingLevelMeta] or 1
    local owned = GetOwned(Player)

    cb({
        trucks = TruckingConfig.DealershipTrucks,
        level = level,
        owned = owned
    })
end)

---------------------------------------------------------------------
--  BUY TRUCK
---------------------------------------------------------------------

RegisterNetEvent("rx-trucking:buyTruck", function(model)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local truckData
    for _, v in ipairs(TruckingConfig.DealershipTrucks) do
        if v.model == model then
            truckData = v
            break
        end
    end
    if not truckData then return end

    if Player.PlayerData.money.bank < truckData.price then
        TriggerClientEvent("QBCore:Notify", src, "Not enough money", "error")
        return
    end

    Player.Functions.RemoveMoney("bank", truckData.price, "bought-truck")

    local plate = QBCore.Shared.RandomInt(2) .. QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(1)

    MySQL.insert.await(
        'INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state, garage) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
        {
            Player.PlayerData.license,
            Player.PlayerData.citizenid,
            model,
            GetHashKey(model),
            json.encode({}),
            plate,
            0,
            TruckingConfig.GarageName
        }
    )

    local owned = GetOwned(Player)
    table.insert(owned, model)
    SetOwned(Player, owned)

    exports['qb-vehiclekeys']:AddKey(src, plate)
    TriggerClientEvent("rx-trucking:spawnOwnedTruckAtDealership", src, model, plate)

    TriggerClientEvent("QBCore:Notify", src, "Truck purchased and stored in the trucking garage", "success")
end)

---------------------------------------------------------------------
--  RENT TRUCK
---------------------------------------------------------------------

RegisterNetEvent("rx-trucking:rentTruck", function(model)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local level = Player.PlayerData.metadata[TruckingConfig.TruckingLevelMeta] or 1
    local truck

    for _, v in ipairs(TruckingConfig.DealershipTrucks) do
        if v.model == model then
            truck = v
            break
        end
    end

    if not truck then return end
    if level < truck.level then
        TriggerClientEvent("QBCore:Notify", src, "Requires level " .. truck.level, "error")
        return
    end

    if Player.Functions.GetMoney("bank") < truck.rent then
        TriggerClientEvent("QBCore:Notify", src, "Not enough money", "error")
        return
    end

    Player.Functions.RemoveMoney("bank", truck.rent)
    TriggerClientEvent("rx-trucking:spawnTruck", src, model)
end)

---------------------------------------------------------------------
--  SPAWN OWNED TRUCK
---------------------------------------------------------------------

RegisterNetEvent("rx-trucking:spawnOwnedTruck", function(model)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local owned = GetOwned(Player)
    for _, m in ipairs(owned) do
        if m == model then
            TriggerClientEvent("rx-trucking:spawnTruck", src, model)
            return
        end
    end

    TriggerClientEvent("QBCore:Notify", src, "You do not own this truck", "error")
end)

-- LEGAL JOB START
RegisterNetEvent("rx-trucking:startJobFromUI", function()
    local src = source
    print("SERVER: LEGAL START FIRED", src)
    TriggerClientEvent("rx-trucking:validateTruck", src)
end)

-- ILLEGAL JOB START
RegisterNetEvent("rx-trucking:startIllegalJob", function()
    local src = source
    print("SERVER: ILLEGAL START FIRED", src)
    TriggerClientEvent("rx-trucking:startIllegalRoute", src)
end)
---------------------------------------------------------------------
--  PAYOUT CALCULATION (FINAL + CORRECT)
---------------------------------------------------------------------

local function CalculatePayout(jobData, engine, body, tEngine, tBody, trailerCount)
    local base = jobData.pay or 0
    trailerCount = trailerCount or 1

    local avgTruck = (engine + body) / 2
    local avgTrailer = (tEngine + tBody) / 2
    local avgHealth = (avgTruck + avgTrailer) / 2

    local dmgFactor = 1.0

    if avgHealth < 800.0 then
        local dmg = math.max(0.0, 800.0 - avgHealth)
        local penalty = (dmg / 800.0) * (TruckingConfig.MaxDamagePenalty or 0.5)
        if penalty > 0.9 then penalty = 0.9 end
        dmgFactor = 1.0 - penalty
    end

    local trailerBonus = 1.0 + ((trailerCount - 1) * (TruckingConfig.TrailerBonusPerExtra or 0.1))

    local total = math.floor(base * dmgFactor * trailerBonus)
    if total < 0 then total = 0 end

    return total
end

---------------------------------------------------------------------
--  FINISH JOB (LEGAL + ILLEGAL)
---------------------------------------------------------------------

RegisterNetEvent("rx-trucking:finishJob", function(jobType, jobData, engine, body, tEngine, tBody, trailerCount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player or not jobData then return end

    trailerCount = trailerCount or 1

    local payout = CalculatePayout(jobData, engine, body, tEngine, tBody, trailerCount)

    if payout <= 0 then
        TriggerClientEvent("QBCore:Notify", src, "No payout (job config or damage)", "error")
        return
    end

    if jobType == "legal" then
        Player.Functions.AddMoney("bank", payout, "trucking-legal")
        TriggerClientEvent("QBCore:Notify", src, ("You earned £%s"):format(payout), "success")
        GiveXP(src, TruckingConfig.XPPerJob)

    elseif jobType == "illegal" then
        local success = true

        for i = 1, payout do
            local info = { worth = 1 }
            local ok = Player.Functions.AddItem("markedbills", 1, nil, info)
            if not ok then
                success = false
                break
            end
        end

        if success then
            TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items["markedbills"], "add")
            TriggerClientEvent("QBCore:Notify", src, ("You earned £%s in dirty cash"):format(payout), "success")
            GiveXP(src, TruckingConfig.XPPerJob)
        else
            TriggerClientEvent("QBCore:Notify", src, "FAILED TO ADD MARKED BILLS", "error")
        end
    end
end)

-------------------------------------------------------------------
--  LEVEL CALLBACK
---------------------------------------------------------------------

QBCore.Functions.CreateCallback("rx-trucking:getPlayerLevel", function(src, cb)
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then cb(1, 0, GetXPRequired(1)) return end

    local xp, level = GetPlayerLevelData(Player)
    cb(level, xp, GetXPRequired(level))
end)
