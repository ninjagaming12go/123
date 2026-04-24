local QBCore = exports['qb-core']:GetCoreObject()

local ActiveFlights = {}

-- LEVEL + XP SYSTEM
local function GetLevelFromXP(xp)
    local level = 1
    for lvl, data in pairs(Config.Levels) do
        if xp >= data.xp and lvl > level then
            level = lvl
        end
    end
    return level
end

local function EnsurePilotMeta(Player)
    local meta = Player.PlayerData.metadata
    if not meta.pilotxp_legal then meta.pilotxp_legal = 0 end
    if not meta.pilotxp_illegal then meta.pilotxp_illegal = 0 end
    if not meta.pilotlevel_legal then meta.pilotlevel_legal = 1 end
    if not meta.pilotlevel_illegal then meta.pilotlevel_illegal = 1 end
    Player.Functions.SetMetaData("pilotxp_legal", meta.pilotxp_legal)
    Player.Functions.SetMetaData("pilotxp_illegal", meta.pilotxp_illegal)
    Player.Functions.SetMetaData("pilotlevel_legal", meta.pilotlevel_legal)
    Player.Functions.SetMetaData("pilotlevel_illegal", meta.pilotlevel_illegal)
end

local function AddPilotXP(src, kind, amount)
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    EnsurePilotMeta(Player)
    local meta = Player.PlayerData.metadata

    if kind == "legal" then
        meta.pilotxp_legal = meta.pilotxp_legal + amount
        meta.pilotlevel_legal = GetLevelFromXP(meta.pilotxp_legal)
        Player.Functions.SetMetaData("pilotxp_legal", meta.pilotxp_legal)
        Player.Functions.SetMetaData("pilotlevel_legal", meta.pilotlevel_legal)
    else
        meta.pilotxp_illegal = meta.pilotxp_illegal + amount
        meta.pilotlevel_illegal = GetLevelFromXP(meta.pilotxp_illegal)
        Player.Functions.SetMetaData("pilotxp_illegal", meta.pilotxp_illegal)
        Player.Functions.SetMetaData("pilotlevel_illegal", meta.pilotlevel_illegal)
    end
end

---------------------------------------------------------
-- JOB NPC → OPEN ROOT UI
---------------------------------------------------------
RegisterNetEvent("pilot:openRootUI", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    local levelLegal = Player.PlayerData.metadata.pilotlevel_legal or 1
    local levelIllegal = Player.PlayerData.metadata.pilotlevel_illegal or 1

    TriggerClientEvent("pilot:client:openRoot", src, levelLegal, levelIllegal)
end)

---------------------------------------------------------
-- ROOT MENU → LEGAL JOBS
---------------------------------------------------------
RegisterNetEvent("rootLegal", function()
    local src = source
    TriggerClientEvent("pilot:client:openContract", src, "legal", Config.LegalFlights)
end)
---------------------------------------------------------
-- ROOT MENU → ILLEGAL JOBS
---------------------------------------------------------
RegisterNetEvent("rootIllegal", function()
    local src = source
    TriggerClientEvent("pilot:client:openContract", src, "illegal", Config.IllegalFlights)
end)
---------------------------------------------------------
-- CONTRACT SELECTED
---------------------------------------------------------
RegisterNetEvent("selectJob", function(job)
    local src = source
    ActiveFlights[src] = {
        mission = job,
        kind = job.kind or "legal"
    }

    TriggerClientEvent("pilot:startLanding", src, job.to)
    TriggerClientEvent("QBCore:Notify", src, "Flight started", "success")
end)

---------------------------------------------------------
-- DEALERSHIP → OPEN UI
---------------------------------------------------------
RegisterNetEvent("pilot:openDealerUI", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    local level = Player.PlayerData.metadata.pilotlevel_legal or 1

    local owned = MySQL.query.await('SELECT vehicle FROM player_vehicles WHERE citizenid = ?', {
        Player.PlayerData.citizenid
    })

    local ownedList = {}
    for _, v in ipairs(owned) do
        ownedList[#ownedList+1] = v.vehicle
    end

    TriggerClientEvent("pilot:client:openDealer", src, Config.Planes, level, ownedList)
end)

---------------------------------------------------------
-- BUY PLANE
---------------------------------------------------------
RegisterNetEvent("pilot:buyPlane", function(model)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    local plane = nil
    for _, p in ipairs(Config.Planes) do
        if p.model == model then plane = p break end
    end
    if not plane then return end

    local level = Player.PlayerData.metadata.pilotlevel_legal or 1
    if level < plane.level then
        TriggerClientEvent("QBCore:Notify", src, "Not high enough level", "error")
        return
    end

    if not Player.Functions.RemoveMoney("bank", plane.price) then
        TriggerClientEvent("QBCore:Notify", src, "Not enough money", "error")
        return
    end

    local plate = QBCore.Shared.RandomInt(2) .. QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(3)

    MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state) VALUES (?, ?, ?, ?, ?, ?, ?)', {
        Player.PlayerData.license,
        Player.PlayerData.citizenid,
        model,
        GetHashKey(model),
        '{}',
        plate,
        0
    })

    TriggerClientEvent("pilot:spawnOwnedPlane", src, model, plate)
end)

---------------------------------------------------------
-- RENT PLANE
---------------------------------------------------------
RegisterNetEvent("pilot:rentPlaneDealer", function(model)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    local plane = nil
    for _, p in ipairs(Config.Planes) do
        if p.model == model then plane = p break end
    end
    if not plane then return end

    local level = Player.PlayerData.metadata.pilotlevel_legal or 1
    if level < plane.level then
        TriggerClientEvent("QBCore:Notify", src, "Not high enough level", "error")
        return
    end

    if not Player.Functions.RemoveMoney("bank", plane.rent) then
        TriggerClientEvent("QBCore:Notify", src, "Not enough money", "error")
        return
    end

    TriggerClientEvent("pilot:spawnRentedPlane", src, model)
end)

---------------------------------------------------------
-- SPAWN OWNED PLANE
---------------------------------------------------------
RegisterNetEvent("pilot:dealerSpawnOwned", function(model)
    local src = source
    TriggerClientEvent("pilot:spawnOwnedPlane", src, model, "OWN"..math.random(1000,9999))
end)

---------------------------------------------------------
-- MISSION COMPLETE
---------------------------------------------------------
RegisterNetEvent("pilot:completeMission", function(safeLanding)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local flight = ActiveFlights[src]
    if not flight then return end

    local pay = flight.mission.payout or 0
    Player.Functions.AddMoney("bank", pay)

    if flight.kind == "legal" then
        AddPilotXP(src, "legal", Config.XP.LegalMission + (safeLanding and Config.XP.SafeLandingBonus or 0))
    else
        AddPilotXP(src, "illegal", Config.XP.IllegalMission + (safeLanding and Config.XP.SafeLandingBonus or 0))
    end

    ActiveFlights[src] = nil
end)

AddEventHandler("playerDropped", function()
    ActiveFlights[source] = nil
end)
