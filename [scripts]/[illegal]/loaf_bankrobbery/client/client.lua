local busy = false

local function BasicCanRobCheck(bankId)
    if not HasBag() then
        Notify(L("no_bag"), "error")
        return false
    end

    if not Config.AllowPoliceRob and IsPolice() then
        Notify(L("police_cannot_rob"), "error")
        return false
    end

    local bank = Config.Banks[bankId]

    if GetPolice() < (bank.requiredPolice or Config.RequiredPolice) then
        Notify(L("not_enough_police"), "error")
        return false
    end

    return true
end

function GetBankFromDoor(entity, model)
    for bankId = 1, #Config.Banks do
        local bank = Config.Banks[bankId]

        for doorId = 1, #bank.doors do
            local door = bank.doors[doorId]

            if model == door.model and #(door.coords.xyz - GetEntityCoords(entity)) <= 1.0 then
                return bankId, doorId
            end
        end
    end

    return false
end

RegisterNetEvent("loaf_bankrobbery:syncThermite", function(bankId, doorId)
    local bank = Config.Banks[bankId]
    local door = bank.doors[doorId]
    local doorEntity = GetClosestObjectOfType(door.coords.x, door.coords.y, door.coords.z, 1.0, door.model, false, false, false)

    if not DoesEntityExist(doorEntity) then
        return
    end

    local offsets = Config.ThermiteOffsets[door.model]
    local smokeOffset, dripOffset = offsets.smoke, offsets.drip
    local timeToUnlock = (door.thermiteTime or Config.DefaultThermiteTime or 10) * 1000

    LoadPtfx("scr_ornate_heist")

    local smoke = StartParticleFxLoopedOnEntity("scr_heist_ornate_thermal_burn", doorEntity, smokeOffset.x, smokeOffset.y, smokeOffset.z, 0.0, 0.0, 0.0, 0.75, false, false, false)

    Wait(math.max(1000, timeToUnlock - 2000))
    LoadPtfx("scr_ornate_heist")

    local drip = StartParticleFxLoopedOnEntity("scr_heist_ornate_metal_drip", doorEntity, dripOffset.x, dripOffset.y, dripOffset.z, 0.0, 0.0, 0.0, 1.0, false, false, false)

    Wait(3000)
    StopParticleFxLooped(smoke, false)
    Wait(1000)
    SetParticleFxLoopedEvolution(drip, "DIE_OFF", 1.0, false)
    Wait(1000)
    StopParticleFxLooped(drip, false)

    RemoveNamedPtfxAsset("scr_ornate_heist")
end)

RegisterNetEvent("loaf_bankrobbery:useThermite", function(data)
    if busy then
        return
    end

    local model, offset = data.parameters.model, data.parameters.offset
    local bankId, doorId = data.parameters.bankId, data.parameters.doorId

    if not bankId or not doorId then
        bankId, doorId = GetBankFromDoor(data.entity, model)

        if not bankId then
            return
        end
    end

    local bank = Config.Banks[bankId]
    local door = bank.doors[doorId]

    if not bank.robbable or not door.locked then
        return
    end

    local doorObject = GetClosestObjectOfType(door.coords.x, door.coords.y, door.coords.z, 1.0, door.model, false, false, false)

    if not DoesEntityExist(doorObject) then
        return
    end

    if not BasicCanRobCheck(bankId) then
        return
    end

    local placeOffset = GetOffsetFromEntityInWorldCoords(doorObject, offset.x, offset.y, offset.z)
    local allowed, reason, params = lib.callback.await("loaf_bankrobbery:placeThermite", false, bankId, doorId)

    if not allowed then
        if reason == "missing_required_items" then
            local itemsArray, requiredItems = {}, Config.RequiredItems.thermite

            for i = 1, #requiredItems do
                itemsArray[#itemsArray+1] = GetItemLabel(requiredItems[i].item)
            end

            Notify(L(reason, {
                required_items = table.concat(itemsArray, ", ")
            }), "error")
        else
            Notify(L(reason, params), "error")
        end

        return
    end

    busy = true

    if ThermiteHack() then
        CreateEvidence(placeOffset)
        PlaceThermite(bankId, doorId, vector4(placeOffset.x, placeOffset.y, placeOffset.z, door.thermiteHeading))
    else
        TriggerServerEvent("loaf_bankrobbery:failThermite", bankId, doorId)
    end

    busy = false
end)

RegisterNetEvent("loaf_bankrobbery:useKeycard", function(data)
    if busy then
        return
    end

    local bankId = data.parameters.bankId
    local bank = Config.Banks[bankId]

    if not bank.robbable or bank.keycard.hacked then
        return
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
        Notify(L("required_doors_locked"), "error")
        return
    end

    if not BasicCanRobCheck(bankId) then
        return
    end

    local allowed, reason, params = lib.callback.await("loaf_bankrobbery:initiateHack", false, bankId)

    if not allowed then
        if reason == "missing_required_items" then
            local itemsArray, requiredItems = {}, Config.RequiredItems.keycard
            for i = 1, #requiredItems do
                itemsArray[#itemsArray+1] = GetItemLabel(requiredItems[i].item)
            end

            Notify(L(reason, {
                required_items = table.concat(itemsArray, ", ")
            }), "error")
        else
            Notify(L(reason, params), "error")
        end

        return
    end

    CreateEvidence(bank.keycard.coords.xyz)

    busy = true
    HackKeycard(bankId)
    busy = false
end)

RegisterNetEvent("loaf_bankrobbery:grabLoot", function(data)
    if busy then
        return
    end

    local bankId, lootId = data.parameters.bankId, data.parameters.lootId
    local bank = Config.Banks[bankId]
    local loot = bank.loot[lootId]

    if not loot.netId then
        return
    end

    if not BasicCanRobCheck(bankId) then
        return
    end

    local allowed, reason, params = lib.callback.await("loaf_bankrobbery:grabLoot", false, bankId, lootId)

    if not allowed then
        if reason == "missing_required_items" then
            local itemsArray, requiredItems = {}, Config.RequiredItems.loot

            for i = 1, #requiredItems do
                itemsArray[#itemsArray+1] = GetItemLabel(requiredItems[i].item)
            end

            Notify(L(reason, {
                required_items = table.concat(itemsArray, ", ")
            }), "error")
        else
            Notify(L(reason, params), "error")
        end
        return
    end

    local model = Config.LootModels[loot.type]

    if not model then
        return print(("Invalid loot? Bank: %i, loot: %i type: %s"):format(bankId, lootId, loot.type))
    end

    LoadModel(model)

    local entity

    if Config.ServerSideOnly then
        entity = WaitForControlAndNetId(loot.netId)
    else
        entity = CreateObjectNoOffset(model, loot.coords.x, loot.coords.y, loot.coords.z, true, false, false)
        SetEntityHeading(entity, loot.coords.w)
    end

    CreateEvidence(loot.coords.xyz)

    busy = true

    if loot.type == "cash_trolley" then
        GrabCashTrolley(entity, bankId, lootId)
    elseif loot.type == "cash" then
        GrabItems(entity, bankId, lootId)
    elseif loot.type == "gold" then
        GrabItems(entity, bankId, lootId)
    end

    busy = false

    SetModelAsNoLongerNeeded(model)
end)

RegisterNetEvent("loaf_bankrobbery:drill", function(data)
    if busy then
        return
    end

    local bankId, drillId = data.parameters.bankId, data.parameters.drillId

    local bank = Config.Banks[bankId]
    local drill = bank.drill[drillId]

    if drill.drilling then
        Notify(L("somebody_drilling"), "error")
        return
    end

    if drill.empty then
        Notify(L("drill_empty"), "error")
        return
    end

    if not BasicCanRobCheck(bankId) then
        return
    end

    local allowed, reason, params = lib.callback.await("loaf_bankrobbery:startDrilling", false, bankId, drillId)

    if not allowed then
        if reason == "missing_required_items" then
            local itemsArray, requiredItems = {}, Config.RequiredItems.drill

            for i = 1, #requiredItems do
                itemsArray[#itemsArray+1] = GetItemLabel(requiredItems[i].item)
            end

            Notify(L(reason, {
                required_items = table.concat(itemsArray, ", ")
            }), "error")
        else
            Notify(L(reason, params), "error")
        end

        return
    end

    CreateEvidence(drill.coords.xyz)

    busy = true
    local success = DrillScene(drill.coords.xyz, drill.coords.w)
    TriggerServerEvent("loaf_bankrobbery:stopDrilling", bankId, drillId, success)
    busy = false
end)

RegisterNetEvent("loaf_bankrobbery:lockVault", function(data)
    local bankId = GetBankFromVault(data.entity)

    if not bankId then
        return
    end

    local bank = Config.Banks[bankId]

    if bank?.vault?.locked then
        return
    end

    TriggerServerEvent("loaf_bankrobbery:lockVault", bankId)
end)

-- handle bank states (doors, robbable etc)
local function HandleDoors(bank, bankId)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    for i = 1, #bank.doors do
        local door = bank.doors[i]

        if #(coords - door.coords.xyz) > 100.0 then
            goto continue
        end

        if door.locked then
            CreateModelSwap(door.coords.x, door.coords.y, door.coords.z, 1.0, door.moltenModel, door.model, false)
        else
            CreateModelSwap(door.coords.x, door.coords.y, door.coords.z, 1.0, door.model, door.moltenModel, false)
        end

        local model = door.locked and door.model or door.moltenModel
        local doorObject = GetClosestObjectOfType(door.coords.x, door.coords.y, door.coords.z, 1.0, model, false, false, false)

        if not DoesEntityExist(doorObject) then
            goto continue
        end

        ToggleLockDoor(bankId, i, doorObject, door.locked)

        ::continue::
    end
end

local function AnimateHeading(entity, desiredHeading, inverseRotation)
    while math.abs(GetEntityHeading(entity) - desiredHeading) >= 2.0 do
        SetEntityCollision(entity, false, false)

        if GetEntityHeading(entity) > desiredHeading and not inverseRotation then
            SetEntityHeading(entity, GetEntityHeading(entity) - 0.5)
        else
            SetEntityHeading(entity, GetEntityHeading(entity) + 0.5)
        end

        Wait(10)
    end

    SetEntityCollision(entity, true, true)
end

local function HandleVault(vault)
    local vaultEntity = GetClosestObjectOfType(vault.coords.x, vault.coords.y, vault.coords.z, 1.0, vault.model, false, false, false)

    if not DoesEntityExist(vaultEntity) then
        return
    end

    local currentHeading, desiredHeading = GetEntityHeading(vaultEntity), vault.locked and vault.coords.w or vault.unlockedHeading

    if math.abs(currentHeading - desiredHeading) > 2.0 then
        AnimateHeading(vaultEntity, desiredHeading, vault.inverseRotation)
    end

    FreezeEntityPosition(vaultEntity, true)
end

RegisterNetEvent("loaf_bankrobbery:setBankData", function(keys, value)
    local bank = Config.Banks

    for i = 1, #keys do
        local key = keys[i]

        if i == #keys then
            bank[key] = value
        else
            bank = bank[key]
        end
    end

    RefreshAllMarkers()
end)

while not Loaded do
    Wait(500)
end

Config.Banks = lib.callback.await("loaf_bankrobbery:getBanks", false)

if Config.InteractSystem == "target" then
    AddTargets()
end

RefreshAllMarkers()

AddTextEntry("DRILL_HELPTEXT", L("drill_helptext", {
    control_key = "~INPUT_SCRIPT_RT~",
    push_key = "~INPUT_LOOK_UD~",
    cancel_key = "~INPUT_FRONTEND_RRIGHT~"
}))

AddTextEntry("DRILL_OVERHEATED", L("drill_overheated", {
    control_key = "~INPUT_SCRIPT_RT~",
}))

-- Sync headings since they sometimes get out of sync
local function HandleHeadings(bank)
    for i = 1, #bank.loot do
        local loot = bank.loot[i]
        local netId = loot.netId

        if not netId or not NetworkDoesNetworkIdExist(netId) then
            goto continue
        end

        local entity = NetworkGetEntityFromNetworkId(netId)

        if not DoesEntityExist(entity) then
            goto continue
        end

        local diff = math.abs(GetEntityHeading(entity) - loot.coords.w)

        if diff > 0.5 then
            SetEntityHeading(entity, loot.coords.w)
        end

        ::continue::
    end
end

CreateThread(function()
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())

        for i = 1, #Config.Banks do
            local bank = Config.Banks[i]

            HandleDoors(bank, i)

            if bank.vault then
                HandleVault(bank.vault)
            end

            if bank.loot and #(bank.coords - playerCoords) <= 100.0 then
                HandleHeadings(bank)
            end
        end

        Wait(500)
    end
end)

-- Alarms

local soundIds = {}
local bankAlarms = lib.callback.await("loaf_bankrobbery:getAlarms", false)

RegisterNetEvent("loaf_bankrobbery:alarm", function(bankId, sound)
    bankAlarms[tostring(bankId)] = sound
end)

local function StartAlarm(bankId, bank)
    local bankInterior = GetInteriorAtCoords(bank.coords.x, bank.coords.y, bank.coords.z)
    local playerInterior = GetInteriorFromEntity(PlayerPedId())
    local shouldPlayClose = bankInterior == 0 or bankInterior ~= playerInterior
    local sound = soundIds[bankId]

    if sound then
        if HasSoundFinished(sound.id) or sound.close ~= shouldPlayClose then
            StopSound(sound.id)
            ReleaseSoundId(sound.id)
            debugprint("Sound finished or close changed, restarting alarm", bankId)
        elseif sound.close == shouldPlayClose then
            return
        end
    end

    debugprint("Requesting audio bank")

    while not RequestScriptAudioBank("ALARM_KLAXON_03", false) do
        Wait(0)
    end

    local soundId = GetSoundId()

    ---@diagnostic disable-next-line: param-type-mismatch
    PlaySoundFromCoord(soundId, "ALARMS_KLAXON_03_" .. (shouldPlayClose and "CLOSE" or "FAR"), bank.coords.x, bank.coords.y, bank.coords.z, 0, false, 30, false)
    debugprint("Playing alarm", bankId, "close:", shouldPlayClose)

    soundIds[bankId] = {
        id = soundId,
        close = shouldPlayClose
    }
end

CreateThread(function()
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())

        local alarmPlaying = false
        for bankId, sound in pairs(bankAlarms) do
            local bank = Config.Banks[tonumber(bankId)]

            if not sound or not bank or #(playerCoords - bank.coords) > 150.0 then
                if soundIds[bankId] then
                    local soundId = soundIds[bankId].id

                    StopSound(soundId)
                    ReleaseSoundId(soundId)
                    debugprint("Stopping alarm", bankId)

                    soundIds[bankId] = nil
                end

                goto continue
            end

            if sound then
                StartAlarm(bankId, bank)
                alarmPlaying = true
            end

            ::continue::
        end

        if not alarmPlaying then
            ReleaseNamedScriptAudioBank("ALARM_KLAXON_03")
        end

        Wait(1000)
    end
end)

-- fix molten model showing when stopping the script
AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    for bankId = 1, #Config.Banks do
        local bank = Config.Banks[bankId]

        for doorId = 1, #bank.doors do
            local door = bank.doors[doorId]

            CreateModelSwap(door.coords.x, door.coords.y, door.coords.z, 1.0, door.model, door.moltenModel, false)
        end
    end
end)
