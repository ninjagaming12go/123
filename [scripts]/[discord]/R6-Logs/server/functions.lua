function DebugPrint(text)
    print("[^5Discord Logs^0] (^1ERROR^0) " .. text .. "^0")
end

function DumpTable(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            s = s .. '['..k..'] = ' .. DumpTable(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

function GetWeaponLabel(weaponHash)
    for k,v in pairs(Config.WeaponLabels) do
        if GetHashKey(k) == weaponHash then
            return v
        end
    end
    return weaponHash
end

function GetPlayerData(src)
    local characterName, citizenId = nil, nil

    if GetResourceState('qbx_core') == 'started' then
        local ok, Player = pcall(function()
            return exports.qbx_core:GetPlayer(src)
        end)
        if ok and Player and Player.PlayerData then
            if Player.PlayerData.charinfo then
                characterName = (Player.PlayerData.charinfo.firstname or "") .. " " .. (Player.PlayerData.charinfo.lastname or "")
            end
            citizenId = Player.PlayerData.citizenid
        end

    elseif GetResourceState('qb-core') == 'started' then
        local ok, QBCore = pcall(function()
            return exports['qb-core']:GetCoreObject()
        end)
        if ok and QBCore then
            local Player = QBCore.Functions.GetPlayer(src)
            if Player and Player.PlayerData then
                if Player.PlayerData.charinfo then
                    characterName = (Player.PlayerData.charinfo.firstname or "") .. " " .. (Player.PlayerData.charinfo.lastname or "")
                end
                citizenId = Player.PlayerData.citizenid
            end
        end

    elseif GetResourceState('es_extended') == 'started' then
        local ok, ESX = pcall(function()
            return exports['es_extended']:getSharedObject()
        end)
        if ok and ESX then
            local xPlayer = ESX.GetPlayerFromId(src)
            if xPlayer then
                characterName = xPlayer.getName()
                citizenId = xPlayer.identifier
            end
        end

    elseif GetResourceState('esx_core') == 'started' or GetResourceState('esx_legacy') == 'started' then
        local ok = pcall(function()
            ESX = exports['esx_core']:getSharedObject() or exports['esx_legacy']:getSharedObject()
        end)
        if ok and ESX then
            local xPlayer = ESX.GetPlayerFromId(src)
            if xPlayer then
                characterName = xPlayer.getName()
                citizenId = xPlayer.identifier
            end
        end
    end

    return characterName, citizenId
end