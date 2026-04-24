function GetBankFromVault(entity)
    local coords = GetEntityCoords(entity)

    for i = 1, #Config.Banks do
        local bank = Config.Banks[i]

        if bank.vault?.model == GetEntityModel(entity) and #(coords - bank.vault.coords.xyz) <= 2.0 then
            return i
        end
    end
end

-- Target
function AddTargets()
    for model, offsets in pairs(Config.ThermiteOffsets) do
        exports.qtarget:AddTargetModel({ model }, {
            distance = 3.0,
            options = {
                {
                    event = "loaf_bankrobbery:useThermite",
                    icon = "fa-solid fa-burst",
                    label = L("use_thermite"),
                    canInteract = function(entity)
                        local bankId, doorId = GetBankFromDoor(entity, model)

                        if not bankId then
                            return false
                        end

                        local bank = Config.Banks[bankId]
                        local door = bank.doors[doorId]

                        return (bank.robbable and door.locked) and (Config.AllowPoliceRob or not IsPolice())
                    end,
                    parameters = {
                        offset = offsets.anim,
                        model = model
                    }
                }
            },
        })
    end

    if Config.AllowPoliceLockVault then
        local uniqueVaults, vaultModels = {}, {}

        for i = 1, #Config.Banks do
            local vaultModel = Config.Banks[i].vault?.model

            if vaultModel and not uniqueVaults[vaultModel] then
                uniqueVaults[vaultModel] = true
                vaultModels[#vaultModels+1] = vaultModel
            end
        end

        exports.qtarget:AddTargetModel(vaultModels, {
            distance = 3.0,
            options = {
                {
                    event = "loaf_bankrobbery:lockVault",
                    icon = "fa-solid fa-lock",
                    label = L("lock_vault"),
                    canInteract = function(entity)
                        if not IsPolice() then
                            return false
                        end

                        local bankId = GetBankFromVault(entity)

                        if not bankId then
                            return false
                        end

                        local bank = Config.Banks[bankId]

                        return bank.robbable and not bank.vault.locked
                    end,
                    parameters = {}
                }
            },
        })
    end

    for bankId = 1, #Config.Banks do
        local bank = Config.Banks[bankId]

        if bank.loot then
            for lootId = 1, #bank.loot do
                local loot = bank.loot[lootId]
                local width, length, height = 1.0, 1.0, 0.5

                if loot.type == "cash" or loot.type == "gold" then
                    width = 0.8
                    length = 0.8
                    height = 0.5
                elseif loot.type == "cash_trolley" then
                    width = 1.0
                    length = 1.0
                    height = 1.0
                end

                exports.qtarget:AddBoxZone("loaf_bankrobbery:loot-" .. bankId .. "-" .. lootId, loot.coords.xyz - vector3(0.0, 0.0, 0.1), width, length, {
                    name = "loaf_bankrobbery:loot-" .. bankId .. "-" .. lootId,
                    heading = loot.coords.w,
                    debugPoly = false,
                    minZ = loot.coords.z - (height / 2),
                    maxZ = loot.coords.z + (height / 2)
                }, {
                    options = {
                        {
                            event = "loaf_bankrobbery:grabLoot",
                            icon = "fa-solid fa-money-bill",
                            label = L(loot.type == "gold" and "grab_gold" or "grab_cash"),
                            canInteract = function()
                                local _bank = Config.Banks[bankId]
                                local _loot = _bank.loot[lootId]

                                return (_bank.lootable and not _loot.empty) and (Config.AllowPoliceRob or not IsPolice())
                            end,
                            parameters = {
                                bankId = bankId,
                                lootId = lootId
                            }
                        }
                    },
                    distance = 2.0
                })
            end

            if bank.drill then
                for drillId = 1, #bank.drill do
                    local drill =  bank.drill[drillId]

                    exports.qtarget:AddBoxZone("loaf_bankrobbery:drill-" .. bankId .. "-" .. drillId, drill.coords.xyz, 0.2, 0.2, {
                        name = "loaf_bankrobbery:drill-" .. bankId .. "-" .. drillId,
                        heading = drill.coords.w,
                        debugPoly = false,
                        minZ = drill.coords.z - 0.1,
                        maxZ = drill.coords.z + 0.1
                    }, {
                        options = {
                            {
                                event = "loaf_bankrobbery:drill",
                                icon = "fas fa-screwdriver",
                                label = L("drill_safe_deposit"),
                                canInteract = function()
                                    local _bank = Config.Banks[bankId]
                                    local _drill = _bank.drill[drillId]

                                    return (_bank.lootable and not _drill.empty) and (Config.AllowPoliceRob or not IsPolice())
                                end,
                                parameters = {
                                    bankId = bankId,
                                    drillId = drillId
                                }
                            }
                        },
                        distance = 2.0
                    })
                end
            end
        end

        local keycard = bank.keycard

        if keycard then
            exports.qtarget:AddBoxZone("loaf_bankrobbery:keycard-" .. bankId, keycard.coords, 0.5, 0.5, {
                name = "loaf_bankrobbery:keycard-" .. bankId,
                heading = keycard.coords.w,
                debugPoly = false,
                minZ = keycard.coords.z - 0.3,
                maxZ = keycard.coords.z + 0.3
            }, {
                options = {
                    {
                        event = "loaf_bankrobbery:useKeycard",
                        icon = "fa-solid fa-laptop-code",
                        label = L("hack_keycard"),
                        canInteract = function()
                            bank = Config.Banks[bankId]
                            keycard = bank.keycard
                            return (bank.robbable and not keycard.hacked) and (Config.AllowPoliceRob or not IsPolice())
                        end,
                        parameters = {
                            bankId = bankId
                        }
                    }
                },
                distance = 2.0
            })
        end
    end
end

-- Markers
local markers = {}

local function RefreshLootMarkers(bankId, isPolice)
    local bank = Config.Banks[bankId]

    for i = 1, #bank.loot do
        local loot = bank.loot[i]
        local markerName = ("bank-%i loot-%i"):format(bankId, i)

        if (not bank.lootable or loot.empty or loot.looting) or (not Config.AllowPoliceRob and isPolice) then
            if markers[markerName] then
                markers[markerName].remove()
                markers[markerName] = nil

                if HideItemPrompt then
                    HideItemPrompt(Config.RequiredItems.loot)
                end
            end

            goto continue
        end

        if markers[markerName] then
            goto continue
        end

        markers[markerName] = AddMarker({
            coords = loot.coords.xyz,
            scale = vector3(1.5, 1.5, 0.5),
            alpha = 0,
            text = Config.InteractSystem == "native" and "~INPUT_CONTEXT~ " .. L(loot.type == "gold" and "grab_gold" or "grab_cash"),
            key = Config.InteractSystem == "native" and 51,
            callbackData = {}
        }, function()
            if ShowItemPrompt then
                ShowItemPrompt(Config.RequiredItems.loot)
            end
        end, function()
            if HideItemPrompt then
                HideItemPrompt(Config.RequiredItems.loot)
            end
        end, function()
            TriggerEvent("loaf_bankrobbery:grabLoot", {
                parameters = {
                    bankId = bankId,
                    lootId = i
                }
            })
        end)

        ::continue::
    end
end

local function RefreshDrillMarkers(bankId, isPolice)
    local bank = Config.Banks[bankId]

    for i = 1, #bank.drill do
        local drill = bank.drill[i]
        local markerName = ("bank-%i drill-%i"):format(bankId, i)

        if (not bank.lootable or drill.empty or drill.drilling) or (not Config.AllowPoliceRob and isPolice) then
            if markers[markerName] then
                markers[markerName].remove()
                markers[markerName] = nil

                if HideItemPrompt then
                    HideItemPrompt(Config.RequiredItems.drill)
                end
            end
            goto continue
        end

        if markers[markerName] then
            goto continue
        end

        markers[markerName] = AddMarker({
            coords = drill.coords.xyz,
            alpha = 0,
            text = Config.InteractSystem == "native" and "~INPUT_CONTEXT~ " .. L("drill_safe_deposit"),
            key = Config.InteractSystem == "native" and 51,
            callbackData = {}
        }, function()
            if ShowItemPrompt then
                ShowItemPrompt(Config.RequiredItems.drill)
            end
        end, function()
            if HideItemPrompt then
                HideItemPrompt(Config.RequiredItems.drill)
            end
        end, function()
            TriggerEvent("loaf_bankrobbery:drill", {
                parameters = {
                    bankId = bankId,
                    drillId = i
                }
            })
        end)

        ::continue::
    end
end

local function RefreshDoorMarkers(bankId, isPolice)
    local bank = Config.Banks[bankId]

    for i = 1, #bank.doors do
        local door = bank.doors[i]
        local markerName = ("bank-%i door-%i"):format(bankId, i)

        if (not bank.robbable or not door.locked or door.thermite) or (not Config.AllowPoliceRob and isPolice) then
            if markers[markerName] then
                markers[markerName].remove()
                markers[markerName] = nil

                if HideItemPrompt then
                    HideItemPrompt(Config.RequiredItems.thermite)
                end
            end
            goto continue
        end

        if markers[markerName] then
            goto continue
        end

        local offsets = Config.ThermiteOffsets[door.model]

        markers[markerName] = AddMarker({
            coords = GetObjectOffsetFromCoords(door.coords.x, door.coords.y, door.coords.z, door.coords.w, offsets.marker.x, offsets.marker.y, offsets.marker.z),
            alpha = 0,
            scale = vector3(1.5, 1.5, 0.5),
            text = Config.InteractSystem == "native" and "~INPUT_CONTEXT~ " .. L("use_thermite"),
            key = Config.InteractSystem == "native" and 51,
            callbackData = {}
        }, function()
            if ShowItemPrompt then
                ShowItemPrompt(Config.RequiredItems.thermite)
            end
        end, function()
            if HideItemPrompt then
                HideItemPrompt(Config.RequiredItems.thermite)
            end
        end, function()
            TriggerEvent("loaf_bankrobbery:useThermite", {
                parameters = {
                    bankId = bankId,
                    doorId = i,
                    offset = offsets.anim,
                    model = door.model
                }
            })
        end)

        ::continue::
    end
end

local function RefreshKeycardMarker(bankId, isPolice)
    local bank = Config.Banks[bankId]
    local keycard = bank.keycard
    local markerName = ("bank-%i-keycard"):format(bankId, isPolice)

    if (not bank.robbable or keycard.hacked or keycard.hacking) or (not Config.AllowPoliceRob and isPolice) then
        if markers[markerName] then
            markers[markerName].remove()
            markers[markerName] = nil

            if HideItemPrompt then
                HideItemPrompt(Config.RequiredItems.keycard)
            end
        end

        return
    end

    if markers[markerName] then
        return
    end

    markers[markerName] = AddMarker({
        coords = keycard.coords.xyz,
        alpha = 0,
        text = Config.InteractSystem == "native" and "~INPUT_CONTEXT~ " .. L("hack_keycard"),
        key = Config.InteractSystem == "native" and 51,
        callbackData = {}
    }, function()
        if ShowItemPrompt then
            ShowItemPrompt(Config.RequiredItems.keycard)
        end
    end, function()
        if HideItemPrompt then
            HideItemPrompt(Config.RequiredItems.keycard)
        end
    end, function()
        TriggerEvent("loaf_bankrobbery:useKeycard", {
            parameters = {
                bankId = bankId
            }
        })
    end)
end

local function RefreshLockVaultMarker(bankId, isPolice)
    local markerName = markers["bank-" .. bankId .. "-vault"]
    local bank = Config.Banks[bankId]
    local vault = bank.vault

    if vault.locked or not isPolice then
        if markers[markerName] then
            markers[markerName].remove()
            markers[markerName] = nil
        end

        return
    end

    if markers[markerName] then
        return
    end

    markers[markerName] = AddMarker({
        coords = vault.coords.xyz,
        alpha = 0,
        text = "~INPUT_DETONATE~ " .. L("lock_vault"),
        key = 47,
        scale = vector3(2.0, 2.0, 1.5),
        callbackData = {}
    }, nil, nil, function()
        TriggerServerEvent("loaf_bankrobbery:lockVault", bankId)
    end)
end

function RefreshAllMarkers()
    local isPolice = IsPolice()

    for i = 1, #Config.Banks do
        local bank = Config.Banks[i]

        if not bank then
            goto continue
        end

        if bank.loot then
            RefreshLootMarkers(i, isPolice)
        end

        if bank.drill then
            RefreshDrillMarkers(i, isPolice)
        end

        if bank.doors then
            RefreshDoorMarkers(i, isPolice)
        end

        if bank.keycard then
            RefreshKeycardMarker(i, isPolice)
        end

        if bank.vault and Config.InteractSystem == "native" and Config.AllowPoliceLockVault then
            RefreshLockVaultMarker(i, isPolice)
        end

        ::continue::
    end
end

-- Items
local function FindClosestActivity(locations)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local closest, distance

    for i = 1, #locations do
        local coords = locations[i].coords.xyz

        if not distance or #(playerCoords - coords) < distance then
            closest = i
            distance = #(playerCoords - coords)
        end
    end

    return closest, distance
end

local function FindClosestBankByActivity(activity)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local closestBank, closestDistance, closestIndex

    for i = 1, #Config.Banks do
        local bank = Config.Banks[i]

        local closest, distance
        if bank[activity].coords then
            distance = #(playerCoords - bank[activity].coords.xyz)
        elseif type(bank[activity]) == "table" then
            closest, distance = FindClosestActivity(bank[activity])
        end

        if not closestDistance or distance < closestDistance then
            closestBank = i
            closestIndex = closest
            closestDistance = distance
        end
    end

    return closestBank, closestDistance, closestIndex
end

RegisterNetEvent("loaf_bankrobbery:usedItem", function(itemType)
    if itemType == "thermite" then
        local bank, distance, door = FindClosestBankByActivity("doors")

        if distance and distance <= 1.5 then
            local doorModel = Config.Banks[bank].doors[door].model
            TriggerEvent("loaf_bankrobbery:useThermite", {
                parameters = {
                    bankId = bank,
                    doorId = door,
                    offset = Config.ThermiteOffsets[doorModel].anim,
                    model = doorModel
                }
            })
        end
    elseif itemType == "keycard" then
        local bank, distance = FindClosestBankByActivity("keycard")

        if distance and distance <= 1.5 then
            TriggerEvent("loaf_bankrobbery:useKeycard", {
                parameters = {
                    bankId = bank
                }
            })
        end
    elseif itemType == "drill" then
        local bank, distance, drill = FindClosestBankByActivity("drill")

        if distance and distance <= 1.5 then
            TriggerEvent("loaf_bankrobbery:drill", {
                parameters = {
                    bankId = bank,
                    drillId = drill
                }
            })
        end
    elseif itemType == "loot" then
        local bank, distance, loot = FindClosestBankByActivity("loot")

        if distance and distance <= 2.0 then
            TriggerEvent("loaf_bankrobbery:grabLoot", {
                parameters = {
                    bankId = bank,
                    lootId = loot
                }
            })
        end
    end
end)
