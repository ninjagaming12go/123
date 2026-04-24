lib.callback.register("loaf_bankrobbery:getBanks", function(source)
    return Config.Banks
end)

-- Thermite
lib.callback.register("loaf_bankrobbery:placeThermite", function(source, bankId, doorId)
    if not bankId or not doorId then
        return false, "invalid_bank"
    end

    local bank = Config.Banks[bankId]
    local door = bank.doors[doorId]

    if not bank or not door then
        return false, "invalid_bank"
    end

    if not bank.robbable then
        return false, "bank_not_robbable"
    end

    if not door.locked then
        return false, "door_not_locked"
    end

    if door.thermite then
        return false, "thermite_already_placed"
    end

    if not HasRequiredItems(source, "thermite") then
        return false, "missing_required_items"
    end

    local allowed, reason, params = CanRob(source, bankId)

    if not allowed then
        return false, reason, params
    end

    door.thermite = source
    TriggerClientEvent("loaf_bankrobbery:setBankData", -1, { bankId, "doors", doorId, "thermite" }, source)

    UpdateTimersAndAlertPolice(bankId)
    RemoveRequiredItems(source, "thermite")

    return true
end)

RegisterNetEvent("loaf_bankrobbery:failThermite", function(bankId, doorId)
    local src = source

    if not bankId or not doorId then
        return
    end

    local door = Config.Banks[bankId]?.doors[doorId]

    if door?.thermite == src then
        door.thermite = nil
        TriggerClientEvent("loaf_bankrobbery:setBankData", -1, { bankId, "doors", doorId, "thermite" }, nil)
    end
end)

RegisterNetEvent("loaf_bankrobbery:syncThermite", function(bankId, doorId)
    local src = source

    if not bankId or not doorId then
        return
    end

    local bank = Config.Banks[bankId]
    local door = bank.doors[doorId]

    if not bank or not door or door.thermite ~= src then
        return
    end

    TriggerClientEvent("loaf_bankrobbery:syncThermite", -1, bankId, doorId)

    local timeToUnlock = (door.thermiteTime or Config.DefaultThermiteTime or 10) * 1000

    Wait(timeToUnlock)

    door.locked = false
    door.thermite = nil

    TriggerClientEvent("loaf_bankrobbery:setBankData", -1, { bankId, "doors", doorId }, door)
end)

-- Hacking
lib.callback.register("loaf_bankrobbery:initiateHack", function(source, bankId)
    if not bankId then
        return false, "invalid_bank"
    end

    local bank = Config.Banks[bankId]

    if not bank?.robbable then
        return false, "bank_not_robbable"
    end

    if bank.keycard and (bank.keycard.hacked or bank.keycard.hacking) then
        return false, "keycard_already_hacked"
    end

    local requiredUnlocked = true

    for i = 1, #bank.doors do
        local door = bank.doors[i]

        if door.locked and door.required then
            requiredUnlocked = false
            break
        end
    end

    if not requiredUnlocked then
        return false, "required_doors_locked"
    end

    if not HasRequiredItems(source, "keycard") then
        return false, "missing_required_items"
    end

    local allowed, reason, params = CanRob(source, bankId)

    if not allowed then
        return false, reason, params
    end

    bank.keycard.hacking = source
    TriggerClientEvent("loaf_bankrobbery:setBankData", -1, { bankId, "keycard", "hacking" }, source)

    UpdateTimersAndAlertPolice(bankId)
    RemoveRequiredItems(source, "keycard")

    return true
end)

RegisterNetEvent("loaf_bankrobbery:setHackSuccess", function(success, bankId)
    local src = source

    if not bankId then
        return
    end

    local bank = Config.Banks[bankId]

    if not bank?.keycard or bank.keycard.hacking ~= src then
        return
    end

    bank.keycard.hacking = nil
    bank.keycard.hacked = success == true

    if success == true then
        local timeToUnlock = (bank.keycard.vaultTime or Config.DefaultVaultTime or 0) * 1000

        Wait(timeToUnlock)

        if bank.vault then
            bank.vault.locked = false
        end

        bank.lootable = true
    end

    TriggerClientEvent("loaf_bankrobbery:setBankData", -1, { bankId }, bank)
    SpawnLoot(bankId)
end)

RegisterNetEvent("loaf_bankrobbery:lockVault", function(bankId)
    local src = source

    if not Config.AllowPoliceLockVault or not IsPolice(src) then
        return
    end

    local bank = Config.Banks[bankId]

    if not bank?.vault or bank.vault.locked then
        return
    end

    bank.vault.locked = true

    TriggerClientEvent("loaf_bankrobbery:setBankData", -1, { bankId, "vault", "locked" }, true)
end)

-- Looting
lib.callback.register("loaf_bankrobbery:grabLoot", function(source, bankId, lootId)
    if not bankId then
        return false, "invalid_bank"
    end

    local bank = Config.Banks[bankId]

    if not bank?.lootable then
        return false, "not_lootable"
    end

    local loot = bank.loot[lootId]

    if not loot then
        return false, "invalid_bank"
    end

    if loot.looting or loot.empty then
        return false, "loot_already_grabbed"
    end

    if loot.entity and DoesEntityExist(loot.entity) then
        if Config.ServerSideOnly then
            SetEntityIgnoreRequestControlFilter(loot.entity, true)
        else
            DeleteEntity(loot.entity)
        end
    end

    if not HasRequiredItems(source, "loot") then
        return false, "missing_required_items"
    end

    local allowed, reason, params = CanRob(source, bankId)

    if not allowed then
        return false, reason, params
    end

    loot.looting = source
    TriggerClientEvent("loaf_bankrobbery:setBankData", -1, { bankId, "loot", lootId, "looting" }, source)

    UpdateTimersAndAlertPolice(bankId)
    RemoveRequiredItems(source, "loot")

    return true
end)

-- Drilling
lib.callback.register("loaf_bankrobbery:startDrilling", function(source, bankId, drillId)
    if not bankId then
        return false, "invalid_bank"
    end

    local bank = Config.Banks[bankId]

    if not bank?.lootable then
        return false, "not_lootable"
    end

    local drill = bank.drill[drillId]

    if not drill then
        return false, "invalid_bank"
    end

    if drill.empty then
        return false, "drill_empty"
    end

    if drill.drilling then
        return false, "somebody_drilling"
    end

    if not HasRequiredItems(source, "drill") then
        return false, "missing_required_items"
    end

    local allowed, reason, params = CanRob(source, bankId)

    if not allowed then
        return false, reason, params
    end

    drill.drilling = source
    TriggerClientEvent("loaf_bankrobbery:setBankData", -1, { bankId, "drill", drillId, "drilling" }, source)

    UpdateTimersAndAlertPolice(bankId)
    RemoveRequiredItems(source, "drill")

    return true
end)

RegisterNetEvent("loaf_bankrobbery:stopDrilling", function(bankId, drillId, success)
    local src = source

    if not bankId then
        return
    end

    local bank = Config.Banks[bankId]

    if not bank?.lootable then
        return
    end

    local drill = bank.drill[drillId]

    if not drill or drill.empty or drill.drilling ~= src then
        return
    end

    drill.empty = success == true
    drill.drilling = nil

    if success then
        GiveRewards(src, bankId, "drill")
    end

    TriggerClientEvent("loaf_bankrobbery:setBankData", -1, { bankId, "drill", drillId }, drill)
end)

local function CreateUsableItems(items, itemType)
    for i = 1, #items do
        local item = items[i]

        if not item.usable then
            goto continue
        end

        CreateUsableItem(item.item, function(src)
            TriggerClientEvent("loaf_bankrobbery:usedItem", src, itemType)
        end)

        ::continue::
    end
end

if Config.UsableItems and CreateUsableItem then
    for itemType, itemData in pairs(Config.RequiredItems) do
        CreateUsableItems(itemData, itemType)
    end
end

-- Cancel events if the player leaves
AddEventHandler("playerDropped", function()
    local src = source

    for i = 1, #Config.Banks do
        local bank = Config.Banks[i]

        if bank.keycard?.hacking == src then
            bank.keycard.hacking = nil
            TriggerClientEvent("loaf_bankrobbery:setBankData", -1, { i, "keycard", "hacking" }, nil)
        end

        if not bank.doors then
            goto skipdoors
        end

        for j = 1, #bank.doors do
            local door = bank.doors[j]

            if door.thermite == src then
                door.thermite = nil
                TriggerClientEvent("loaf_bankrobbery:setBankData", -1, { i, "doors", j, "thermite" }, nil)
            end
        end

        ::skipdoors::

        if not bank.loot then
            goto skiploot
        end

        for j = 1, #bank.loot do
            local loot = bank.loot[j]

            if loot.looting == src then
                loot.looting = nil
                TriggerClientEvent("loaf_bankrobbery:setBankData", -1, { i, "loot", j, "looting" }, nil)
            end
        end

        ::skiploot::

        if not bank.drill then
            goto skipdrill
        end

        for j = 1, #bank.drill do
            local drill = bank.drill[j]

            if drill.drilling == src then
                drill.drilling = nil
                TriggerClientEvent("loaf_bankrobbery:setBankData", -1, { i, "drill", j, "drilling" }, nil)
            end
        end

        ::skipdrill::
    end
end)

-- version check
CreateThread(function()
    PerformHttpRequest("https://loaf-scripts.com/versions/", function(_, text, _)
        print(text or "^3[INFO]^0 Error checking script version, the website did not respond. (You don't have to do anything. The script will continue to work.)")
    end, "POST", json.encode({
        resource = "bankrobbery",
        version = GetResourceMetadata(GetCurrentResourceName(), "version", 0) or "1.0.0"
    }), {["Content-Type"] = "application/json"})
end)
