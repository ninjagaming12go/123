local lastFetchedPolice = 0
local policeOnline = 0

function GetPolice()
	if (GetGameTimer() - lastFetchedPolice) > 60000 then
		policeOnline = lib.callback.await("loaf_bankrobbery:getPolice", false)
		lastFetchedPolice = GetGameTimer()

        debugprint("Fetched police online:", policeOnline)
	end

	return policeOnline
end

-- Scenes
function LoadDict(dict)
    if HasAnimDictLoaded(dict) then
        return dict
    end

    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end

    return dict
end

function LoadModel(model)
    model = type(model) == "string" and GetHashKey(model) or model

    if HasModelLoaded(model) then
        return model
    end

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end

    return model
end

function LoadPtfx(ptfx)
    RequestNamedPtfxAsset(ptfx)
    while not HasNamedPtfxAssetLoaded(ptfx) do
        Wait(0)
    end

    UseParticleFxAsset(ptfx)
end

function WaitForSceneToStart(scene)
    local waitStartTimer = GetGameTimer() + 100

    while waitStartTimer > GetGameTimer() do
        Wait(0)

        if IsSynchronizedSceneRunning(NetworkConvertSynchronisedSceneToSynchronizedScene(scene)) then
            break
        end
    end
end

function WaitForScene(scene, endPhase)
    WaitForSceneToStart(scene)

    local playerPed = PlayerPedId()

    endPhase = endPhase or 0.99
    while true do
        Wait(0)
        local localScene = NetworkConvertSynchronisedSceneToSynchronizedScene(scene)

        if not IsSynchronizedSceneRunning(localScene) or IsPedDeadOrDying(playerPed, true) then
            return false
        end

        if GetSynchronizedScenePhase(localScene) > endPhase then
            return true
        end
    end
end

function TpToScene(sceneCoords, sceneRot, dict, anim)
    local playerPed = PlayerPedId()
    local positionOffset = GetAnimInitialOffsetPosition(dict, anim, sceneCoords.x, sceneCoords.y, sceneCoords.z, sceneRot.x, sceneRot.y, sceneRot.z, 0, 2)
    local rotationOffset = GetAnimInitialOffsetRotation(dict, anim, sceneCoords.x, sceneCoords.y, sceneCoords.z, sceneRot.x, sceneRot.y, sceneRot.z, 0, 2)

    SetEntityCoords(playerPed, positionOffset.x, positionOffset.y, positionOffset.z - 1.0, false, false, false, false)
    SetEntityHeading(playerPed, rotationOffset.z)
end

---@param netId number
---@return number entity
function WaitForControlAndNetId(netId)
    while not NetworkDoesNetworkIdExist(netId) or not NetworkGetEntityFromNetworkId(netId) do
        Wait(0)
    end

    local entity = NetworkGetEntityFromNetworkId(netId)

    while not NetworkHasControlOfEntity(entity) do
        NetworkRequestControlOfEntity(entity)
        Wait(0)
    end

    return entity
end

function CreateSceneObject(model, invisible)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local object

    model = LoadModel(model)

    if Config.ServerSideOnly then
        local netId = lib.callback.await("loaf_bankrobbery:createSceneObject", false, model, coords)

        object = WaitForControlAndNetId(netId)
    else
        object = CreateObject(model, coords.x, coords.y, coords.z, true, true, false)
    end

    SetEntityCollision(object, false, false)
    if invisible then
        SetEntityVisible(object, false, false)
    end

    local interior = GetInteriorFromEntity(playerPed)

    if interior and IsValidInterior(interior) and IsInteriorReady(interior) then
        local room = GetRoomKeyFromEntity(playerPed)

        ForceRoomForEntity(object, interior, room)
    end

    return object
end

---Function to toggle a door as locked. Note that this does get called quite often, not only upon lock/unlock
---@param bankId number
---@param doorId number
---@param entity number The door handle
---@param locked boolean
function ToggleLockDoor(bankId, doorId, entity, locked)
    local door = Config.Banks[bankId].doors[doorId]
    local desiredHeading, currentHeading = door.coords.w, GetEntityHeading(entity)

    FreezeEntityPosition(entity, locked)

    if not locked then
        return
    end

    if math.abs(desiredHeading - currentHeading) > 2.0 then
        SetEntityHeading(entity, desiredHeading)
    end
end

-- Clothing
function IsMale()
    local model = GetEntityModel(PlayerPedId())

    return model == `mp_m_freemode_01`
end

function IsWearingHeels()
    if IsMale() then
        return false
    end

    local playerPed = PlayerPedId()
    local shoes = GetPedDrawableVariation(playerPed, 6)
    local componentHash = GetHashNameForComponent(playerPed, 6, shoes, GetPedTextureVariation(playerPed, 6))

    if componentHash ~= 0 then
        return DoesShopPedApparelHaveRestrictionTag(componentHash, `HIGH_HEELS`, 0)
    else
        return (
            shoes == 0 or (shoes >= 6 and shoes <= 8) or shoes == 12 or shoes == 14
        )
    end
end

function IsWearingArmour()
    local kevlar = GetPedDrawableVariation(PlayerPedId(), 9)

    if IsMale() then
        return (
            (kevlar >= 1 and kevlar <= 12) or
            (kevlar >= 15 and kevlar <= 28) or
            kevlar == 57
        )
    else
        return (
            (kevlar >= 1 and kevlar <= 13) or
            (kevlar >= 17 and kevlar <= 32) or
            kevlar == 57
        )
    end
end

local noGloves = {
    male = { 0, 1, 2, 4, 5, 6, 8, 11, 12, 14, 15, 18, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 112, 113, 114, 118, 125, 132, 184, 188, 196, 198, 202 },
    female = { 0, 1, 2, 3, 4, 5, 6, 7, 9, 11, 12, 14, 15, 19, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 129, 130, 131, 135, 142, 149, 153, 157, 161, 165, 229, 233, 241 }
}

function IsExposingFingers()
    local exposed = false
    local exposedArray = noGloves[IsMale() and "male" or "female"]

    for i = 1, #exposedArray do
        if GetPedDrawableVariation(PlayerPedId(), 3) == exposedArray[i] then
            exposed = true
            break
        end
    end

    return exposed
end

local bags = { 40, 41, 44, 45, 81, 82, 85, 86 }

function HasBag()
    if not Config.RequireBag then
        return true
    end

    local equippedBag = GetPedDrawableVariation(PlayerPedId(), 5)

    for i = 1, #bags do
        if equippedBag == bags[i] then
            return true
        end
    end

    return false
end

local bagHidden, oldBag, oldBagTexture, oldBagPalette = false, 0, 0, 0

function ToggleBag(visible)
    if not visible and bagHidden then
        return
    end

    local playerPed = PlayerPedId()

    if not visible then
        oldBag = GetPedDrawableVariation(playerPed, 5)
        oldBagTexture = GetPedTextureVariation(playerPed, 5)
        oldBagPalette = GetPedPaletteVariation(playerPed, 5)

        Wait(0) -- wait for scene to start
        SetPedComponentVariation(playerPed, 5, 0, 0, 0)
    else
        if Config.KeepBag and not Config.RequireBag then
            local hadBag = false

            for i = 1, #bags do
                if oldBag == bags[i] then
                    hadBag = true
                    break
                end
            end

            if not hadBag then
                oldBag = 45
                oldBagTexture = 0
                oldBagPalette = 0
            end
        end

        SetPedComponentVariation(playerPed, 5, oldBag, oldBagTexture, oldBagPalette)
        Wait(0)
    end

    bagHidden = not visible
end

---@param coords vector3
function CreateEvidence(coords)
    if not coords or not IsExposingFingers() then
        return
    end

    if Config.Framework == "qb-core" then
        TriggerServerEvent("evidence:server:CreateFingerDrop", coords)
    end
end

-- Hacking
function ThermiteHack()
    if not Config.ThermiteMinigame.required then
        return true
    end

    local minigame = Config.ThermiteMinigame.minigame
    local params = Config.ThermiteMinigame.params

    if minigame == "memorygame" then
        local thermitePromise = promise.new()

        exports.memorygame:thermiteminigame(params.correctBlocks, params.incorrectBlocks, params.timeToShow, params.timeToLose, function()
            thermitePromise:resolve(true)
        end, function()
            thermitePromise:resolve(false)
        end)

        return Citizen.Await(thermitePromise)
    elseif minigame == "ps-ui" then
        local thermitePromise = promise.new()

        exports["ps-ui"]:Thermite(function(success)
            thermitePromise:resolve(success)
        end, params.timeToLose, params.gridSize, params.incorrectBlocks)

        return Citizen.Await(thermitePromise)
    elseif minigame == "ox_lib" and GetResourceState("ox_lib") == "started" then
        return exports.ox_lib:skillCheck("medium")
    else
        return true
    end
end

local keycardPromise

function KeycardHack()
    if not Config.KeycardHack then
        return true
    end

    if Config.KeycardHack == "howdy-hackminigame" then
        return exports["howdy-hackminigame"]:Begin(4, 5000)
    end

    keycardPromise = promise.new()

    if Config.KeycardHack == "ps-ui" then
        exports["ps-ui"]:Scrambler(function(success)
            keycardPromise:resolve(success)
        end, "numeric", 30, 0)
    elseif Config.KeycardHack == "ultra-voltlab" then
        TriggerEvent("ultra-voltlab", 30, function(outcome)
            keycardPromise:resolve(outcome == 1)
        end)
    elseif Config.KeycardHack == "ultra-keypadhack" then
        TriggerEvent("ultra-keypadhack", 2, 30, function(outcome)
            keycardPromise:resolve(outcome == 1)
        end)
    elseif Config.KeycardHack == "datacrack" then
        exports["datacrack"]:Start(3.5)
    elseif Config.KeycardHack == "utk_fingerprint" then
        TriggerEvent("utk_fingerprint:Start", 2, 3, 2, function(success)
            keycardPromise:resolve(success)
        end)
    elseif Config.KeycardHack == "electus_hacking" then
        exports.electus_hacking:RunHack("binaryPuzzle", 2, 5, true, function(success)
            keycardPromise:resolve(success)
        end)
    end

    return Citizen.Await(keycardPromise)
end

AddEventHandler("datacrack", function(success)
    if keycardPromise then
        keycardPromise:resolve(success)
    end
end)

-- Progressbar
function ShowProgressBar(text, time)
    if not Config.ShowProgress then
        return
    end

    if GetResourceState("progressbar") == "started" then
        pcall(function()
            exports.progressbar:Progress({
                name = "loaf_bankrobbery_" .. math.random(11111, 99999),
                duration = time * 1000,
                label = text,
                useWhileDead = false,
                canCancel = false,
                controlDisables = {}
            })
        end)
    elseif GetResourceState("progressBars") == "started" then
        pcall(function()
            exports.progressBars:startUI(time * 1000, text)
        end)
    elseif GetResourceState("ox_lib") == "started" then
        CreateThread(function()
            pcall(function()
                exports.ox_lib:progressBar({
                    duration = time * 1000,
                    label = text
                })
            end)
        end)
    else
        TriggerEvent("mythic_progbar:client:progress", {
            name = "loaf_bankrobbery_" .. math.random(11111, 99999),
            duration = time * 1000,
            useWhileDead = false,
            canCancel = false,
            controlDisables = {}
        })
    end
end

---@class MarkerData
---@field coords vector3
---@field scale? vector3
---@field alpha? number
---@field text? string | false
---@field key? number | false

---@param markerData MarkerData
---@param onEnter? function
---@param onExit? function
---@param onKey? function
function AddMarker(markerData, onEnter, onExit, onKey)
    local key = markerData.key
    local width = markerData.scale?.x or 1.0
    local color = Config.MarkerColor
    local marker = lib.marker.new({
        type = 1,
        coords = markerData.coords,
        color = { r = color.r, g = color.g, b = color.b, a = markerData.alpha or color.a },
        width = width,
        height = markerData.scale?.z or 0.5
    })

    local point = lib.points.new({
        coords = markerData.coords,
        distance = width
    })

    function point:nearby()
        if markerData.alpha ~= 0 then
            marker:draw()
        end

        if key and IsControlJustReleased(0, key) and onKey then
            Citizen.CreateThreadNow(function()
                onKey()
            end)
        end
    end

    function point:onEnter()
        if markerData.text then
            BeginTextCommandDisplayHelp("STRING")
            AddTextComponentSubstringPlayerName(markerData.text)
            EndTextCommandDisplayHelp(0, true, true, 0)
        end

        if onEnter then
            onEnter()
        end
    end

    if onExit then
        function point:onExit()
            if markerData.text then
                ClearAllHelpMessages()
            end

            onExit()
        end
    end

    return {
        marker = marker,
        point = point,
        remove = function()
            if point then
                ClearAllHelpMessages()
                point:remove()
            end

            marker = nil
            point = nil
        end
    }
end

-- Police alerts
local policeAlerts = {}

local function GetPoliceAlert(bankId)
    for i = 1, #policeAlerts do
        if policeAlerts[i].bank == bankId then
            return true, i
        end
    end

    return false
end

RegisterNetEvent("loaf_bankrobbery:alertPolice", function(bankId)
    if GetPoliceAlert(bankId) or not IsPolice() then
        return
    end

    local bank = Config.Banks[bankId]
    local blip = AddBlipForCoord(bank.coords.x, bank.coords.y, bank.coords.z)

    SetBlipSprite(blip, 161)
    SetBlipColour(blip, 1)
    SetBlipScale(blip, 1.5)
    SetBlipAsShortRange(blip, false)
    SetBlipDisplay(blip, 2)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(L("dispatch_label"))
    EndTextCommandSetBlipName(blip)

    policeAlerts[#policeAlerts+1] = {
        bank = bankId,
        blip = blip
    }

    Notify(L("dispatch_description", {
        bank = bank.name
    }), "info")
end)

RegisterNetEvent("loaf_bankrobbery:removePoliceAlert", function(bankId)
    local alerted, index = GetPoliceAlert(bankId)

    if not alerted then
        return
    end

    RemoveBlip(policeAlerts[index].blip)
    table.remove(policeAlerts, index)
end)
