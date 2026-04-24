PoliceJobAnimationCam = nil
local function LoadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end
end

local function PlayAnimation(ped, dict, anim)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(1)
    end
    TaskPlayAnim(ped, dict, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
end
local vehicle1, vehicle2, policePed1, policePed2 = nil, nil, nil, nil

local camcoords = vector3(1161.37, -336.03, 68.54)
table.insert(JobCameras, {
    police = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', camcoords.x + 0.2, camcoords.y - 2, camcoords.z + .5,
        0.0, 0.0,
        5.0,
        GetGameplayCamFov(), false, 2)

})


function PoliceJobAnimation(citizenid)
    DeleteVehicle(vehicle1)
    DeleteVehicle(vehicle2)
    DeletePed(policePed1)
    DeletePed(policePed2)
    DeleteNotSelectedPedorVehicle()

    LoadModel(GetHashKey("police2"))
    LoadModel(GetHashKey("s_m_y_cop_01"))
    LoadModel(GetHashKey("s_f_y_cop_01"))
    
    local coords = vector3(1161.37, -336.03, 68.54)
    local heading = 192.32
    SetClothes(citizenid, coords, heading, 'WORLD_HUMAN_COP_IDLES')

    vehicle1 = CreateVehicle(GetHashKey("police2"), 1157.03, -332.84, 68.36, 154.39, true, false)
    vehicle2 = CreateVehicle(GetHashKey("police2"), 1164.41, -332.79, 68.45, 41.17, true, false)
    table.insert(totalVehicle, vehicle1)
    table.insert(totalVehicle, vehicle2)
    SetVehicleSiren(vehicle1, true)
    SetVehicleSiren(vehicle2, true)

    policePed1 = CreatePed(4, GetHashKey("s_m_y_cop_01"), 1155.43, -332.84, 68.75, 200.39, false, true)
    policePed2 = CreatePed(4, GetHashKey("s_f_y_cop_01"), 1163.14, -333.25, 68.82 - 0.98, 162.88, false, true)
    table.insert(totalPed, policePed1)
    table.insert(totalPed, policePed2)
    PlayAnimation(policePed1, "random@arrests", "generic_radio_chatter")
    PlayAnimation(policePed2, "random@arrests", "generic_radio_chatter")
end

