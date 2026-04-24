local QBCore = exports['qb-core']:GetCoreObject()

local plateReaderActive = false
local showANPR = false

local lastPlateData = {
    plate = "NONE",
    mot = "UNKNOWN",
    insurance = "UNKNOWN",
    extra = ""
}

local scannedVehicles = {}

-- BLIPS
local cameraBlips = {}
local showCamBlips = Config.ShowCameraBlips

local function CreateCameraBlips()
    for _, blip in pairs(cameraBlips) do
        RemoveBlip(blip)
    end

    cameraBlips = {}

    if not showCamBlips then return end

    local PlayerData = QBCore.Functions.GetPlayerData()
    if PlayerData.job.name ~= Config.Job then return end

    for _, coords in pairs(Config.Cameras) do
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)

        SetBlipSprite(blip, Config.BlipSprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, Config.BlipScale)
        SetBlipColour(blip, Config.BlipColor)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.BlipName)
        EndTextCommandSetBlipName(blip)

        table.insert(cameraBlips, blip)
    end
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    Wait(2000)
    CreateCameraBlips()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function()
    Wait(1000)
    CreateCameraBlips()
end)

RegisterCommand("anprcams", function()
    local PlayerData = QBCore.Functions.GetPlayerData()
    if PlayerData.job.name ~= Config.Job then return end

    showCamBlips = not showCamBlips
    CreateCameraBlips()

    QBCore.Functions.Notify("ANPR Cameras " .. (showCamBlips and "ON" or "OFF"))
end)

-- Plate Reader Toggle
RegisterCommand("togglepr", function()
    local PlayerData = QBCore.Functions.GetPlayerData()
    if PlayerData.job.name ~= Config.Job then return end

    plateReaderActive = not plateReaderActive
    QBCore.Functions.Notify("Plate Reader " .. (plateReaderActive and "ON" or "OFF"))
end)

RegisterKeyMapping("togglepr", "Toggle Plate Reader", "keyboard", "L")

-- ANPR Display Toggle
RegisterCommand("anpr", function()
    local PlayerData = QBCore.Functions.GetPlayerData()
    if PlayerData.job.name ~= Config.Job then return end

    showANPR = not showANPR
    QBCore.Functions.Notify("ANPR Display " .. (showANPR and "ON" or "OFF"))
end)

-- DRAW UI
CreateThread(function()
    while true do
        Wait(0)
        if showANPR then
            -- Background
            DrawRect(0.85, 0.2, 0.25, 0.18, 0, 0, 0, 180)

            -- TITLE
            SetTextFont(4)
            SetTextScale(0.38, 0.38)
            SetTextColour(0, 255, 0, 255)

            SetTextEntry("STRING")
            AddTextComponentString("ANPR SYSTEM")
            DrawText(0.75, 0.12)

            -- =====================
            -- PLATE
            -- =====================
            -- Label (small)
            SetTextFont(4)
            SetTextScale(0.22, 0.22)
            SetTextColour(150, 150, 150, 255)

            SetTextEntry("STRING")
            AddTextComponentString("PLATE:")
            DrawText(0.75, 0.155)

            -- Value (bigger)
            SetTextScale(0.30, 0.30)
            SetTextColour(0, 255, 255, 255)

            SetTextEntry("STRING")
            AddTextComponentString(lastPlateData.plate)
            DrawText(0.82, 0.155)

            -- =====================
            -- MOT
            -- =====================
            -- Label (small)
            SetTextScale(0.22, 0.22)
            SetTextColour(150, 150, 150, 255)

            SetTextEntry("STRING")
            AddTextComponentString("MOT:")
            DrawText(0.75, 0.18)

            -- Value (bigger + colored)
            SetTextScale(0.30, 0.30)
            if lastPlateData.mot == "VALID" then
                SetTextColour(0, 255, 0, 255)
            else
                SetTextColour(255, 0, 0, 255)
            end

            SetTextEntry("STRING")
            AddTextComponentString(lastPlateData.mot)
            DrawText(0.82, 0.18)

            -- =====================
            -- INSURANCE
            -- =====================
            -- Label (small)
            SetTextScale(0.22, 0.22)
            SetTextColour(150, 150, 150, 255)

            SetTextEntry("STRING")
            AddTextComponentString("INSURANCE:")
            DrawText(0.75, 0.205)

            -- Value (bigger + colored)
            SetTextScale(0.30, 0.30)
            if lastPlateData.insurance == "VALID" then
                SetTextColour(0, 255, 0, 255)
            else
                SetTextColour(255, 0, 0, 255)
            end

            SetTextEntry("STRING")
            AddTextComponentString(lastPlateData.insurance)
            DrawText(0.87, 0.205)

            -- =====================
            -- EXTRA / BOLO
            -- =====================
            SetTextScale(0.26, 0.26)
            SetTextColour(255, 200, 0, 255)

            SetTextEntry("STRING")
            AddTextComponentString(lastPlateData.extra)
            DrawText(0.75, 0.235)
        end
    end
end)

-- Manual Plate Reader
CreateThread(function()
    while true do
        Wait(1000)
        if plateReaderActive then
            local ped = PlayerPedId()
            if IsPedInAnyVehicle(ped, false) then
                local veh = GetVehiclePedIsIn(ped, false)

                local coords = GetEntityCoords(veh)
                local forward = GetEntityForwardVector(veh)
                local target = coords + forward * 10.0

                local ray = StartShapeTestRay(coords.x, coords.y, coords.z, target.x, target.y, target.z, 10, veh, 0)
                local _, hit, _, _, entity = GetShapeTestResult(ray)

                if hit == 1 and IsEntityAVehicle(entity) then
                    local plate = string.gsub(GetVehicleNumberPlateText(entity), "%s+", "")
                    TriggerServerEvent("qb-plate-reader:checkPlate", plate)
                end
            end
        end
    end
end)

-- Roadside Cameras
CreateThread(function()
    while true do
        Wait(1000)

        local vehicles = GetGamePool('CVehicle')

        for _, veh in ipairs(vehicles) do
            local vehCoords = GetEntityCoords(veh)

            for _, camPos in pairs(Config.Cameras) do
                if #(vehCoords - camPos) <= Config.CameraRadius then
                    local plate = string.gsub(GetVehicleNumberPlateText(veh), "%s+", "")

                    if not scannedVehicles[plate] then
                        scannedVehicles[plate] = true

                        TriggerServerEvent("qb-anpr:scanVehicle", plate, vehCoords)

                        CreateThread(function()
                            Wait(Config.ScanCooldown)
                            scannedVehicles[plate] = nil
                        end)
                    end
                end
            end
        end
    end
end)

-- RESULTS
RegisterNetEvent("qb-plate-reader:motResult", function(plate, mot, insurance)
    local motText = mot and "VALID" or "EXPIRED"
    local insText = insurance and "VALID" or "NONE"

    lastPlateData.plate = plate
    lastPlateData.mot = motText
    lastPlateData.insurance = insText
    lastPlateData.extra = ""

    QBCore.Functions.Notify("Plate: "..plate.." | MOT: "..motText.." | INS: "..insText)
end)

RegisterNetEvent("qb-plate-reader:alert", function(plate, reason)
    lastPlateData.extra = reason
    QBCore.Functions.Notify("🚨 "..plate.." | "..reason, "error", 7000)
end)