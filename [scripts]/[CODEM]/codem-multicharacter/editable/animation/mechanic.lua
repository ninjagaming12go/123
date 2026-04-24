MechanicJobAnimationCam = nil
local function LoadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end
end

local function RequestAndLoadModel(modelHash)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
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
local vehicle = nil

local camcoords = vector3(-365.26, -132.97, 38.68)
table.insert(JobCameras, {
    mechanic = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', camcoords.x - 1.2, camcoords.y + 2.6,
        camcoords.z + .4,
        0.0, 0.0,
        -70.0,
        GetGameplayCamFov(), false, 2)
})

function MechanicJobAnimation(citizenid)
    DeleteVehicle(vehicle)
    DeleteNotSelectedPedorVehicle()
    RequestAndLoadModel(GetHashKey('sultanrs'))

    vehicle = CreateVehicle(GetHashKey('sultanrs'), -361.32, -128.52, 38.09, 105.63, true, true)

    table.insert(totalVehicle, vehicle)
    netID = NetworkGetNetworkIdFromEntity(vehicle)
    TriggerServerEvent('codem-multicharacter:server:ChangeBucket', netID)
    SetVehicleOnGroundProperly(vehicle)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleDoorOpen(vehicle, 4, false, false)
    SetClothes(citizenid, vector3(-363.71, -129.36, 38.7 - 0.98), 281.48, nil, { "mini@repair", "fixing_a_ped" })
end
