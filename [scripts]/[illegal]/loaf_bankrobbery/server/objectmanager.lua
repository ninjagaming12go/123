function DeleteLoot(bankId)
    if not bankId or not Config.Banks[bankId] then
        return false
    end

    local bank = Config.Banks[bankId]

    for i = 1, #bank.loot do
        local loot = bank.loot[i]

        if not loot.entity and loot.netId then
            loot.entity = NetworkGetEntityFromNetworkId(loot.netId)
        end

        if loot.entity and DoesEntityExist(loot.entity) then
            DeleteEntity(loot.entity)
        end

        loot.entity = nil
        loot.netId = nil
    end

    return true
end

function SpawnLoot(bankId)
    if not bankId then
        return false
    end

    local bank = Config.Banks[bankId]

    if not bank then
        return false
    end

    for i = 1, #bank.loot do
        local loot = bank.loot[i]

        if not loot.entity and loot.netId then
            loot.entity = NetworkGetEntityFromNetworkId(loot.netId)
        end

        if loot.entity and DoesEntityExist(loot.entity) then
            goto continue
        end

        local model = Config.LootModels[loot.type]

        if not model then
            print(("Invalid loot? Bank: %i, loot: %i type: %s"):format(bankId, i, loot.type))
            goto continue
        end

        if loot.empty and Config.LootModels[loot.type .. "_empty"] then
            model = Config.LootModels[loot.type .. "_empty"]
        end

        local entity = CreateObjectNoOffset(model, loot.coords.x, loot.coords.y, loot.coords.z, true, false, false)

        FreezeEntityPosition(entity, true)
        SetEntityHeading(entity, loot.coords.w)

        loot.entity = entity
        loot.netId = NetworkGetNetworkIdFromEntity(entity)

        ::continue::
    end

    TriggerClientEvent("loaf_bankrobbery:setBankData", -1, { bankId }, bank)

    return true
end

RegisterNetEvent("loaf_bankrobbery:finishLooting", function(bankId, lootId, netId)
    local src = source
    if not bankId or not lootId then
        return
    end

    local loot = Config.Banks[bankId]?.loot[lootId]

    if not loot then
        return
    end

    if loot.looting ~= src then
        PossibleCheater(src, "finish_looting_not_looting", bankId, lootId)
        return
    end

    if loot.entity and DoesEntityExist(loot.entity) then
        DeleteEntity(loot.entity)
    end

    local model = Config.LootModels[loot.type .. "_empty"]

    if model then
        if netId then
            DeleteEntity(NetworkGetEntityFromNetworkId(netId))
        end

        local entity = CreateObjectNoOffset(model, loot.coords.x, loot.coords.y, loot.coords.z, true, false, false)

        FreezeEntityPosition(entity, true)
        SetEntityHeading(entity, loot.coords.w)

        loot.entity = entity
        loot.netId = NetworkGetNetworkIdFromEntity(entity)
    else
        loot.entity = nil
        loot.netId = nil
    end

    GiveRewards(src, bankId, loot.type)

    loot.empty = true
    loot.looting = nil

    TriggerClientEvent("loaf_bankrobbery:setBankData", -1, { bankId, "loot", lootId }, loot)
end)

RegisterNetEvent("loaf_bankrobbery:cancelledLooting", function(bankId, lootId)
    local src = source

    if not bankId or not lootId then
        return
    end

    local loot = Config.Banks[bankId]?.loot[lootId]

    if not loot or loot.looting ~= src then
        return
    end

    if loot.entity and DoesEntityExist(loot.entity) then
        DeleteEntity(loot.entity)
    end

    local model = Config.LootModels[loot.type]

    if model then
        local entity = CreateObjectNoOffset(model, loot.coords.x, loot.coords.y, loot.coords.z, true, false, false)
        FreezeEntityPosition(entity, true)
        SetEntityHeading(entity, loot.coords.w)

        loot.entity = entity
        loot.netId = NetworkGetNetworkIdFromEntity(entity)
    else
        loot.entity = nil
        loot.netId = nil
    end

    loot.looting = nil

    TriggerClientEvent("loaf_bankrobbery:setBankData", -1, { bankId, "loot", lootId }, loot)
end)

local playerEntities = {}

local function AllowedCreateObject(source)
    for bankId = 1, #Config.Banks do
        local bank = Config.Banks[bankId]

        if not bank.keycard then
            goto skipKeycard
        end

        if bank.keycard.hacking == source then
            return true
        end

        ::skipKeycard::

        if not bank.doors then
            goto skipDoors
        end

        for doorId = 1, #bank.doors do
            local door = bank.doors[doorId]

            if door.thermite == source then
                return true
            end
        end

        ::skipDoors::

        if not bank.loot then
            goto skipLoot
        end

        for lootId = 1, #bank.loot do
            local loot = bank.loot[lootId]

            if loot.looting == source then
                return true
            end
        end

        ::skipLoot::

        if not bank.drill then
            goto skipDrills
        end

        for drillId = 1, #bank.drill do
            local drill = bank.drill[drillId]

            if drill.drilling == source then
                return true
            end
        end

        ::skipDrills::
    end

    return false
end

lib.callback.register("loaf_bankrobbery:createSceneObject", function(source, model, coords)
    if not Config.ServerSideOnly then
        PossibleCheater(source, "create_object_not_enabled", model, coords)
        return
    end

    if not AllowedCreateObject(source) then
        PossibleCheater(source, "create_object_not_allowed", model, coords)
        return
    end

    local sSrc = tostring(source)

    if not playerEntities[sSrc] then
        playerEntities[sSrc] = {}
    end

    local entity = CreateObjectNoOffset(model, coords.x, coords.y, coords.z, true, false, false)
    local entities = playerEntities[sSrc]

    SetEntityIgnoreRequestControlFilter(entity, true)

    entities[#entities+1] = entity

    return NetworkGetNetworkIdFromEntity(entity)
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    for bankId = 1, #Config.Banks do
        local bank = Config.Banks[bankId]

        for i = 1, #bank.loot do
            local loot = bank.loot[i]

            if loot.entity and DoesEntityExist(loot.entity) then
                DeleteEntity(loot.entity)
            end
        end
    end

    for _, entities in pairs(playerEntities) do
        for i = 1, #entities do
            if DoesEntityExist(entities[i]) then
                DeleteEntity(entities[i])
            end
        end
    end
end)

AddEventHandler("playerDropped", function()
    local src = source
    local sSrc = tostring(src)
    local entitites = playerEntities[sSrc]

    if not entitites then
        return
    end

    for i = 1, #entitites do
        if DoesEntityExist(entitites[i]) then
            DeleteEntity(entitites[i])
        end
    end

    playerEntities[sSrc] = nil
end)
