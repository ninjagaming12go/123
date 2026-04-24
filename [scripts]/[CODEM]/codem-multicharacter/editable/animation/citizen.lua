local coords = vector3(-1830.56, -1254.41, 13.02)
local heading = 122.31
table.insert(JobCameras, {
    unemployed = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', coords.x - 2, coords.y - 0.45, coords.z + 0.5,
        0.0, 0.0,
        -80.0,
        GetGameplayCamFov(), false, 2)
})
function CitizenJobAnimation(citizenid)
    DeleteNotSelectedPedorVehicle()
    local ped = PlayerPedId()

    SetClothes(citizenid, coords, heading, 'PROP_HUMAN_BUM_SHOPPING_CART')
end
