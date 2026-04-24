--- Player coords = 277.87, -608.31 43.01 96.1

local function RequestAndLoadModel(modelHash)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(1)
    end
end


local function PlayAnimation(ped, dict, anim, settings)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(1)
        end
    end
    TaskPlayAnim(ped, dict, anim, settings.blendInSpeed, settings.blendOutSpeed, settings.duration, settings.flag,
        settings.playbackRate, settings.lockX, settings.lockY, settings.lockZ)
end
local camcoords = vector3(277.87, -608.31, 43.01)
table.insert(JobCameras, {
    ambulance = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', camcoords.x - 3, camcoords.y - 0.5, camcoords.z - 0.3,
        0.0, 0.0,
        -80.0,
        GetGameplayCamFov(), false, 2)
})


function AmbulanceJobAnimation(citizenid)
    DeleteVehicle(vehicle)
    DeletePed(policePed)
    DeleteNotSelectedPedorVehicle()

    RequestAndLoadModel(GetHashKey("s_m_y_cop_01"))
    RequestAndLoadModel(GetHashKey('ambulance'))

    local vehicle = CreateVehicle(GetHashKey('ambulance'), 278.89, -604.95, 42.82, 46.6, true, false)
    table.insert(totalVehicle, vehicle)
    SetVehicleOnGroundProperly(vehicle)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleSiren(vehicle, true)

    local policePed = CreatePed(4, GetHashKey("s_m_y_cop_01"), 277.33, -607.98, 43.0 - 0.98, 11.49, false, true)
    table.insert(totalPed, policePed)
    PlayAnimation(policePed, "dead", "dead_a",
        { blendInSpeed = 1.0, blendOutSpeed = 1.0, duration = -1, flag = 1, playbackRate = 0 })

    SetClothes(citizenid, vector3(277.87, -608.31, 43.01 - 0.98), 96.1, nil,
        { "amb@medic@standing@kneel@base", "base", "mini@cpr@char_a@cpr_str", "cpr_pumpchest" })
end
