if not Config.EnableCreator then
    return
end

---@diagnostic disable: param-type-mismatch
local moveControls = {
    {
        key = 81, -- .
        offset = vector3(0.0, 0.0, 0.005)
    },
    {
        key = 82, -- ,
        offset = vector3(0.0, 0.0, -0.005)
    },
    {
        key = 172, -- arrow up
        offset = vector3(0.0, 0.005, 0.0)
    },
    {
        key = 173, -- arrow down
        offset = vector3(0.0, -0.005, 0.0)
    },
    {
        key = 174, -- arrow left
        offset = vector3(-0.005, 0.0, 0.0)
    },
    {
        key = 175, -- arrow right
        offset = vector3(0.005, 0.0, 0.0)
    },
    {
        key = 176, -- enter
        heading = 1.0
    },
    {
        key = 177, -- backspace
        heading = -1.0
    },
}

local placeObject
local objectLocation = { x = 0.0, y = 0.0, z = 0.0, heading = 0.0}

local function DrawObjectData(coords, heading, customText)
    if not coords then
        coords = objectLocation
    end

    if not heading then
        heading = objectLocation.heading
    end

    SetDrawOrigin(coords.x, coords.y, coords.z, 0)
    SetTextFont(0)
    SetTextProportional(true)
    SetTextScale(0.0, 0.3)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(("Heading: %s\nCoords: %s%s"):format(
        tostring(math.floor(heading + 0.5)),
        ("%.2f, %.2f, %.2f"):format(coords.x, coords.y, coords.z),
        customText or ""
    ))
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

local function HandleMoveObject()
    for i = 1, #moveControls do
        local control = moveControls[i]
        local shouldUpdate = false

        if IsControlJustPressed(0, control.key) then
            control.justPressed = GetGameTimer()
        end

        if IsControlPressed(0, control.key) and (control.justPressed or 0) + 100 < GetGameTimer() then
            shouldUpdate = true
        end

        if IsControlJustReleased(0, control.key) then
            control.justPressed = 0
            shouldUpdate = true
        end

        if shouldUpdate then
            if control.offset then
                local offset = GetOffsetFromEntityInWorldCoords(placeObject, control.offset.x, control.offset.y, control.offset.z)

                objectLocation.x = offset.x
                objectLocation.y = offset.y
                objectLocation.z = offset.z
            elseif control.heading then
                objectLocation.heading += control.heading
            end
        end
    end

    objectLocation.heading = math.floor(objectLocation.heading + 0.5)

    SetEntityCoords(placeObject, objectLocation.x, objectLocation.y, objectLocation.z, false, false, false, false)
    SetEntityRotation(placeObject, 0.0, 0.0, objectLocation.heading, 2, true)

    objectLocation.heading = GetEntityHeading(placeObject)
end

local function PlaceSafeDepositBox()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    objectLocation = { x = playerCoords.x, y = playerCoords.y, z = playerCoords.z, heading = 0.0 }
    placeObject = CreateObject(LoadModel(`hei_prop_heist_safedepdoor`), 0.0, 0.0, 0.0, false, false, false)
    SetEntityCollision(placeObject, false, false)

    while DoesEntityExist(placeObject) do
        playerCoords = GetEntityCoords(playerPed)

        if IsControlPressed(0, 51) then
            objectLocation.x = playerCoords.x
            objectLocation.y = playerCoords.y
            objectLocation.heading = GetEntityHeading(playerPed)

            local found, groundZ = GetGroundZFor_3dCoord(playerCoords.x, playerCoords.y, playerCoords.z, false)

            if found then
                local drillZ = groundZ + 1.2165969848633
                objectLocation.z = drillZ
            end
        end

        HandleMoveObject()

        DrawObjectData()

        Wait(0)
    end
end

local function PlaceTrolley()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    objectLocation = { x = playerCoords.x, y = playerCoords.y, z = playerCoords.z, heading = 0.0 }
    placeObject = CreateObject(LoadModel(`hei_prop_hei_cash_trolly_01`), 0.0, 0.0, 0.0, false, false, false)
    SetEntityCollision(placeObject, false, false)

    local dict = "anim@heists@ornate_bank@grab_cash"
    local anim = "intro"

    LoadDict(dict)

    while DoesEntityExist(placeObject) do
        playerCoords = GetEntityCoords(playerPed)

        local found, groundZ = GetGroundZFor_3dCoord(playerCoords.x, playerCoords.y, playerCoords.z, false)

        if found then
            objectLocation.z = groundZ + 0.47298431396848
        end

        if IsControlPressed(0, 51) then
            objectLocation.x = playerCoords.x
            objectLocation.y = playerCoords.y
            objectLocation.heading = GetEntityHeading(playerPed)
        end

        HandleMoveObject()

        DrawObjectData()

        local positionOffset = GetAnimInitialOffsetPosition(dict, anim, objectLocation.x, objectLocation.y, objectLocation.z, 0.0, 0.0, objectLocation.heading, 0, 2)
        DrawMarker(1, positionOffset.x, positionOffset.y, groundZ or 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 1.0, 255, 0, 255, 200, false, false, 0, false, nil, nil, false)

        Wait(0)
    end

    RemoveAnimDict(dict)
end

local function PlaceStack(isCash)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    objectLocation = { x = playerCoords.x, y = playerCoords.y, z = playerCoords.z, heading = 0.0 }
    placeObject = CreateObject(LoadModel(isCash and `h4_prop_h4_cash_stack_01a` or `h4_prop_h4_gold_stack_01a`), 0.0, 0.0, 0.0, false, false, false)
    SetEntityCollision(placeObject, false, false)

    local dict = "anim@scripted@player@mission@tun_table_grab@" .. (isCash and "cash@" or "gold@")
    local anim = "enter"

    LoadDict(dict)

    while DoesEntityExist(placeObject) do
        playerCoords = GetEntityCoords(playerPed)

        local found, groundZ = GetGroundZFor_3dCoord(playerCoords.x, playerCoords.y, playerCoords.z, false)

        if IsControlPressed(0, 51) then
            objectLocation.x = playerCoords.x
            objectLocation.y = playerCoords.y
            objectLocation.heading = GetEntityHeading(playerPed)

            if found then
                objectLocation.z = groundZ + 0.47298431396848
            end
        end

        HandleMoveObject()

        DrawObjectData()

        local positionOffset = GetAnimInitialOffsetPosition(dict, anim, objectLocation.x, objectLocation.y, objectLocation.z, 0.0, 0.0, objectLocation.heading, 0, 2)
        local camOffset = GetOffsetFromEntityInWorldCoords(placeObject, 0.0, 0.75, 0.25)

        DrawMarker(1, positionOffset.x, positionOffset.y, groundZ or 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 1.0, 255, 0, 255, 200, false, false, 0, false, nil, nil, false)
        DrawMarker(1, camOffset.x, camOffset.y, camOffset.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.25, 0.25, 255, 0, 255, 200, false, false, 0, false, nil, nil, false)
        Wait(0)
    end

    RemoveAnimDict(dict)
end

local function PlaceSecurityPanel()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    objectLocation = { x = playerCoords.x, y = playerCoords.y, z = playerCoords.z, heading = 0.0 }
    placeObject = CreateObject(LoadModel(`hei_prop_hei_securitypanel`), 0.0, 0.0, 0.0, false, false, false)
    SetEntityCollision(placeObject, false, false)

    while DoesEntityExist(placeObject) do
        playerCoords = GetEntityCoords(playerPed)

        if IsControlPressed(0, 51) then
            objectLocation.x = playerCoords.x
            objectLocation.y = playerCoords.y
            objectLocation.z = playerCoords.z
            objectLocation.heading = GetEntityHeading(playerPed)
        end

        HandleMoveObject()

        DrawObjectData()

        Wait(0)
    end
end

local models = {
    {
        model = `hei_v_ilev_bk_gate_pris`,
        name = "hei_v_ilev_bk_gate_pris"
    },
    {
        model = `hei_v_ilev_bk_gate2_pris`,
        name = "hei_v_ilev_bk_gate2_pris"
    },
    {
        model = `hei_v_ilev_bk_safegate_pris`,
        name = "hei_v_ilev_bk_safegate_pris"
    },
    {
        model = `v_ilev_bk_vaultdoor`,
        name = "v_ilev_bk_vaultdoor"
    },
    {
        model = `prop_ld_vault_door`,
        name = "prop_ld_vault_door"
    },
    {
        model = `v_ilev_gb_vauldr`,
        name = "v_ilev_gb_vauldr"
    },
    {
        model = `hei_prop_heist_sec_door`,
        name = "hei_prop_heist_sec_door"
    },
    {
        model = `v_ilev_gb_vaubar`,
        name = "v_ilev_gb_vaubar"
    },
    {
        model = `hei_prop_hei_securitypanel`,
        name = "hei_prop_hei_securitypanel"
    },
    {
        model = `v_corp_bk_secpanel`,
        name = "v_corp_bk_secpanel"
    },
    {
        model = `v_ilev_cbankvauldoor01`,
        name = "v_ilev_cbankvauldoor01"
    }
}

RegisterCommand("bankrobberyplace", function(source, args)
    local itemType = args[1]

    if placeObject and DoesEntityExist(placeObject) then
        DeleteObject(placeObject)
    end

    Wait(10)

    if itemType == "depositbox" then
        PlaceSafeDepositBox()
    elseif itemType == "trolley" then
        PlaceTrolley()
    elseif itemType == "cash" then
        PlaceStack(true)
    elseif itemType == "gold" then
        PlaceStack(false)
    elseif itemType == "security" then
        PlaceSecurityPanel()
    end
end, false)

local drawing = false
RegisterCommand("bankrobberydraw", function()
    drawing = not drawing

    local playerPed = PlayerPedId()

    while drawing do
        local playerCoords = GetEntityCoords(playerPed)

        for i = 1, #models do
            local modelData = models[i]
            local object = GetClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, 25.0, modelData.model, false, false, false)

            if not DoesEntityExist(object) then
                goto continue
            end

            local coords = GetEntityCoords(object)
            local heading = GetEntityHeading(object)
            local extraText = "\nModel: " .. modelData.name

            if modelData.animDict and modelData.anim then
                LoadDict(modelData.animDict)
                local positionOffset = GetAnimInitialOffsetPosition(modelData.animDict, modelData.anim, coords.x, coords.y, coords.z, 0.0, 0.0, heading, 0, 2)
                local rotationOffset = GetAnimInitialOffsetRotation(modelData.animDict, modelData.anim, coords.x, coords.y, coords.z, 0.0, 0.0, heading, 0, 2)

                DrawMarker(1, positionOffset.x, positionOffset.y, positionOffset.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, heading, 0.5, 0.5, 1.0, 255, 0, 255, 200, false, false, 0, false, nil, nil, false)
                extraText = "\nAnim: " .. ("%.2f, %.2f, %.2f Heading: %i"):format(positionOffset.x, positionOffset.y, positionOffset.z, math.floor(rotationOffset.z + 0.5))
            end

            DrawObjectData(coords, heading, extraText)

            ::continue::
        end

        Wait(0)
    end

    for i = 1, #models do
        local dict = models[i].animDict

        if dict then
            RemoveAnimDict(dict)
        end
    end
end, false)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() and placeObject then
        DeleteObject(placeObject)
    end
end)
