
if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
    RegisterNetEvent("m-multichar-client-finished", function ()
        finished = true
    end)

    RegisterNUICallback('DeleteCharacter', function(data, cb)
        if data.identifier == nil then
            cb(false)
            return
        end
        local delete = TriggerCallback("m-multichar-server-DeleteCharacter", data.identifier)
        if delete == nil then
            cb(false)
            return
        end
        local playerData = TriggerCallback("m-multichar-server-GetCharacters")
        if playerData == nil then
            cb(false)
            return
        end
        cb(playerData)
    end)

    RegisterNUICallback('SelectCharacter', function(data, cb)
        local playerjob = data.job.name or 'unemployed'
        local animationfunctionname = Config.PlayerAnimation[playerjob] and Config.PlayerAnimation[playerjob].animationfunctionname or 'CitizenJobAnimation'
        
        if animationfunctionname == "CitizenJobAnimation" then
            playerjob = "unemployed"
        end
        if _G[animationfunctionname] then
            data.position = data.position or Config.DefaultSpawn
            local positionname = findLastLocation(data.position) or 'unknown'
            NuiMessage('UPDATE_LAST_LOCATION', positionname)
            _G[animationfunctionname](data.identifier)
            ChangeCamera(playerjob)
            cb(true)
        else
            print("Animation function not found for job: " .. playerjob)
            cb(false)
        end
    end)

    RegisterNUICallback('createChar', function(data, cb)
        if data.gender == "male" then
            data.gender = 0
        elseif data.gender == "female" then
            data.gender = 1
        end
        TriggerServerEvent('m-multichar-server-CreateChar', data)
        Wait(500)
        cb("ok")
        DeleteNotSelectedPedorVehicle()
    end)

    RegisterNUICallback('continuePlayer', function(data, cb)
        if spamControl then
            cb(false)
            return
        end

        spamControl = true

        DoScreenFadeOut(500)
        local cData = data
        SetNuiFocus(false, false)
        TriggerServerEvent('m-multichar-server-LoadPlayer', cData)
        cb("ok")
        DestroyMulticharCamera()
        DeleteNotSelectedPedorVehicle()
        Wait(500)
        DoScreenFadeIn(250)
    end)
    
    function GetModel(str)
        model = nil
        str = str == "m" and 0 or 1
        if tonumber(str) == 0 then
            model = `mp_m_freemode_01`
        else
            model = `mp_f_freemode_01`
        end
        return model
    end

    SetSpawnTrigger = function(spawn, isNew, skin)
        if Config.UseMSpawnSelector then
            TriggerEvent("m-spawnselector:client:display", spawn, isNew, skin) 
        else
            TriggerEvent("m-spawnselector:client:display", spawn, isNew, skin) 
        end

    end

    local function PlayerLoaded(playerData, isNew, skin)
        SetNuiFocus(false, false)
        local spawn = playerData.coords or Config.DefaultSpawn
        if isNew or not skin or #skin == 1 then
            local playerPed = PlayerPedId()
            FreezeEntityPosition(playerPed, true)
            SetEntityCoordsNoOffset(playerPed, spawn.x, spawn.y, spawn.z, false, false, false)
            NetworkResurrectLocalPlayer(spawn.x, spawn.y, spawn.z, spawn.heading or 0.0, true, false)
            SetEntityHeading(playerPed, spawn.heading)
            FreezeEntityPosition(playerPed, false)
            finished = false
    
            local model = GetModel(playerData.sex or 'm')
            RequestModel(model)
            while not HasModelLoaded(model) do Wait(0) end
            SetPlayerModel(PlayerId(), model)
            SetModelAsNoLongerNeeded(model)

            skin = Appearance[Config.Clothes][playerData.sex or 'm']
            skin.sex = playerData.sex == 'm' and 0 or 1
            
            TriggerEvent('skinchanger:loadSkin', skin, function()
                local playerPed = PlayerPedId()
                SetPedAoBlobRendering(playerPed, true)
                ResetEntityAlpha(playerPed)
                SetEntityVisible(playerPed,true)
                TriggerEvent('esx_skin:openSaveableMenu', function()
                    TriggerEvent("m-multichar-client-finished")
                end, function()
                    TriggerEvent("m-multichar-client-finished")
                end)
            end)
            TriggerServerEvent("m-multichar-server-StarterItems")
            repeat Wait(200) until finished
        end
        if Config.SpawnSelector and not isNew then
            SetSpawnTrigger(spawn , isNew, skin)
        elseif not Config.SpawnSelector and not isNew then
            local playerPed = PlayerPedId()
            FreezeEntityPosition(playerPed, true)
            SetEntityCoordsNoOffset(playerPed, spawn.x, spawn.y, spawn.z, false, false, false)
            NetworkResurrectLocalPlayer(spawn.x, spawn.y, spawn.z, spawn.heading or 0.0, true, false)
            SetEntityHeading(playerPed, spawn.heading)
            FreezeEntityPosition(playerPed, false)
        end
        
        if not isNew then 
            TriggerEvent('skinchanger:loadSkin', skin) 
        end
        
        if isNew then
            TriggerEvent('esx:restoreLoadout')
        end

        DestroyMulticharCamera()
        DeleteNotSelectedPedorVehicle()
        Wait(1000)
        TriggerServerEvent('esx:onPlayerSpawn')
        TriggerEvent('esx:onPlayerSpawn')
        TriggerEvent('playerSpawned')
    end

    RegisterNetEvent('esx:playerLoaded')
    AddEventHandler('esx:playerLoaded', function(playerData, isNew, skin)
        PlayerLoaded(playerData, isNew, skin)
    end)

    Appearance = {
        ['default'] = {
            ["m"] = {
                mom = 43,
                dad = 29,
                face_md_weight = 61,
                skin_md_weight = 27,
                nose_1 = -5,
                nose_2 = 6,
                nose_3 = 5,
                nose_4 = 8,
                nose_5 = 10,
                nose_6 = 0,
                cheeks_1 = 2,
                cheeks_2 = -10,
                cheeks_3 = 6,
                lip_thickness = -2,
                jaw_1 = 0,
                jaw_2 = 0,
                chin_1 = 0,
                chin_2 = 0,
                chin_13 = 0,
                chin_4 = 0,
                neck_thickness = 0,
                hair_1 = 76,
                hair_2 = 0,
                hair_color_1 = 61,
                hair_color_2 = 29,
                tshirt_1 = 4,
                tshirt_2 = 2,
                torso_1 = 23,
                torso_2 = 2,
                decals_1 = 0,
                decals_2 = 0,
                arms = 1,
                arms_2 = 0,
                pants_1 = 28,
                pants_2 = 3,
                shoes_1 = 70,
                shoes_2 = 2,
                mask_1 = 0,
                mask_2 = 0,
                bproof_1 = 0,
                bproof_2 = 0,
                chain_1 = 22,
                chain_2 = 2,
                helmet_1 = -1,
                helmet_2 = 0,
                glasses_1 = 0,
                glasses_2 = 0,
                watches_1 = -1,
                watches_2 = 0,
                bracelets_1 = -1,
                bracelets_2 = 0,
                bags_1 = 0,
                bags_2 = 0,
                eye_color = 0,
                eye_squint = 0,
                eyebrows_2 = 0,
                eyebrows_1 = 0,
                eyebrows_3 = 0,
                eyebrows_4 = 0,
                eyebrows_5 = 0,
                eyebrows_6 = 0,
                makeup_1 = 0,
                makeup_2 = 0,
                makeup_3 = 0,
                makeup_4 = 0,
                lipstick_1 = 0,
                lipstick_2 = 0,
                lipstick_3 = 0,
                lipstick_4 = 0,
                ears_1 = -1,
                ears_2 = 0,
                chest_1 = 0,
                chest_2 = 0,
                chest_3 = 0,
                bodyb_1 = -1,
                bodyb_2 = 0,
                bodyb_3 = -1,
                bodyb_4 = 0,
                age_1 = 0,
                age_2 = 0,
                blemishes_1 = 0,
                blemishes_2 = 0,
                blush_1 = 0,
                blush_2 = 0,
                blush_3 = 0,
                complexion_1 = 0,
                complexion_2 = 0,
                sun_1 = 0,
                sun_2 = 0,
                moles_1 = 0,
                moles_2 = 0,
                beard_1 = 11,
                beard_2 = 10,
                beard_3 = 0,
                beard_4 = 0
            },
            ["f"] = {
                mom = 28,
                dad = 6,
                face_md_weight = 63,
                skin_md_weight = 60,
                nose_1 = -10,
                nose_2 = 4,
                nose_3 = 5,
                nose_4 = 0,
                nose_5 = 0,
                nose_6 = 0,
                cheeks_1 = 0,
                cheeks_2 = 0,
                cheeks_3 = 0,
                lip_thickness = 0,
                jaw_1 = 0,
                jaw_2 = 0,
                chin_1 = -10,
                chin_2 = 10,
                chin_13 = -10,
                chin_4 = 0,
                neck_thickness = -5,
                hair_1 = 43,
                hair_2 = 0,
                hair_color_1 = 29,
                hair_color_2 = 35,
                tshirt_1 = 111,
                tshirt_2 = 5,
                torso_1 = 25,
                torso_2 = 2,
                decals_1 = 0,
                decals_2 = 0,
                arms = 3,
                arms_2 = 0,
                pants_1 = 12,
                pants_2 = 2,
                shoes_1 = 20,
                shoes_2 = 10,
                mask_1 = 0,
                mask_2 = 0,
                bproof_1 = 0,
                bproof_2 = 0,
                chain_1 = 85,
                chain_2 = 0,
                helmet_1 = -1,
                helmet_2 = 0,
                glasses_1 = 33,
                glasses_2 = 12,
                watches_1 = -1,
                watches_2 = 0,
                bracelets_1 = -1,
                bracelets_2 = 0,
                bags_1 = 0,
                bags_2 = 0,
                eye_color = 8,
                eye_squint = -6,
                eyebrows_2 = 7,
                eyebrows_1 = 32,
                eyebrows_3 = 52,
                eyebrows_4 = 9,
                eyebrows_5 = -5,
                eyebrows_6 = -8,
                makeup_1 = 0,
                makeup_2 = 0,
                makeup_3 = 0,
                makeup_4 = 0,
                lipstick_1 = 0,
                lipstick_2 = 0,
                lipstick_3 = 0,
                lipstick_4 = 0,
                ears_1 = -1,
                ears_2 = 0,
                chest_1 = 0,
                chest_2 = 0,
                chest_3 = 0,
                bodyb_1 = -1,
                bodyb_2 = 0,
                bodyb_3 = -1,
                bodyb_4 = 0,
                age_1 = 0,
                age_2 = 0,
                blemishes_1 = 0,
                blemishes_2 = 0,
                blush_1 = 0,
                blush_2 = 0,
                blush_3 = 0,
                complexion_1 = 0,
                complexion_2 = 0,
                sun_1 = 0,
                sun_2 = 0,
                moles_1 = 12,
                moles_2 = 8,
                beard_1 = 0,
                beard_2 = 0,
                beard_3 = 0,
                beard_4 = 0
            }
        },
        ['codem-appearance'] = {
            ["m"] = {
                mom = 43,
                dad = 29,
                face_md_weight = 61,
                skin_md_weight = 27,
                nose_1 = -5,
                nose_2 = 6,
                nose_3 = 5,
                nose_4 = 8,
                nose_5 = 10,
                nose_6 = 0,
                cheeks_1 = 2,
                cheeks_2 = -10,
                cheeks_3 = 6,
                lip_thickness = -2,
                jaw_1 = 0,
                jaw_2 = 0,
                chin_1 = 0,
                chin_2 = 0,
                chin_13 = 0,
                chin_4 = 0,
                neck_thickness = 0,
                hair_1 = 76,
                hair_2 = 0,
                hair_color_1 = 61,
                hair_color_2 = 29,
                tshirt_1 = 4,
                tshirt_2 = 2,
                torso_1 = 23,
                torso_2 = 2,
                decals_1 = 0,
                decals_2 = 0,
                arms = 1,
                arms_2 = 0,
                pants_1 = 28,
                pants_2 = 3,
                shoes_1 = 70,
                shoes_2 = 2,
                mask_1 = 0,
                mask_2 = 0,
                bproof_1 = 0,
                bproof_2 = 0,
                chain_1 = 22,
                chain_2 = 2,
                helmet_1 = -1,
                helmet_2 = 0,
                glasses_1 = 0,
                glasses_2 = 0,
                watches_1 = -1,
                watches_2 = 0,
                bracelets_1 = -1,
                bracelets_2 = 0,
                bags_1 = 0,
                bags_2 = 0,
                eye_color = 0,
                eye_squint = 0,
                eyebrows_2 = 0,
                eyebrows_1 = 0,
                eyebrows_3 = 0,
                eyebrows_4 = 0,
                eyebrows_5 = 0,
                eyebrows_6 = 0,
                makeup_1 = 0,
                makeup_2 = 0,
                makeup_3 = 0,
                makeup_4 = 0,
                lipstick_1 = 0,
                lipstick_2 = 0,
                lipstick_3 = 0,
                lipstick_4 = 0,
                ears_1 = -1,
                ears_2 = 0,
                chest_1 = 0,
                chest_2 = 0,
                chest_3 = 0,
                bodyb_1 = -1,
                bodyb_2 = 0,
                bodyb_3 = -1,
                bodyb_4 = 0,
                age_1 = 0,
                age_2 = 0,
                blemishes_1 = 0,
                blemishes_2 = 0,
                blush_1 = 0,
                blush_2 = 0,
                blush_3 = 0,
                complexion_1 = 0,
                complexion_2 = 0,
                sun_1 = 0,
                sun_2 = 0,
                moles_1 = 0,
                moles_2 = 0,
                beard_1 = 11,
                beard_2 = 10,
                beard_3 = 0,
                beard_4 = 0
            },
            ["f"] = {
                mom = 28,
                dad = 6,
                face_md_weight = 63,
                skin_md_weight = 60,
                nose_1 = -10,
                nose_2 = 4,
                nose_3 = 5,
                nose_4 = 0,
                nose_5 = 0,
                nose_6 = 0,
                cheeks_1 = 0,
                cheeks_2 = 0,
                cheeks_3 = 0,
                lip_thickness = 0,
                jaw_1 = 0,
                jaw_2 = 0,
                chin_1 = -10,
                chin_2 = 10,
                chin_13 = -10,
                chin_4 = 0,
                neck_thickness = -5,
                hair_1 = 43,
                hair_2 = 0,
                hair_color_1 = 29,
                hair_color_2 = 35,
                tshirt_1 = 111,
                tshirt_2 = 5,
                torso_1 = 25,
                torso_2 = 2,
                decals_1 = 0,
                decals_2 = 0,
                arms = 3,
                arms_2 = 0,
                pants_1 = 12,
                pants_2 = 2,
                shoes_1 = 20,
                shoes_2 = 10,
                mask_1 = 0,
                mask_2 = 0,
                bproof_1 = 0,
                bproof_2 = 0,
                chain_1 = 85,
                chain_2 = 0,
                helmet_1 = -1,
                helmet_2 = 0,
                glasses_1 = 33,
                glasses_2 = 12,
                watches_1 = -1,
                watches_2 = 0,
                bracelets_1 = -1,
                bracelets_2 = 0,
                bags_1 = 0,
                bags_2 = 0,
                eye_color = 8,
                eye_squint = -6,
                eyebrows_2 = 7,
                eyebrows_1 = 32,
                eyebrows_3 = 52,
                eyebrows_4 = 9,
                eyebrows_5 = -5,
                eyebrows_6 = -8,
                makeup_1 = 0,
                makeup_2 = 0,
                makeup_3 = 0,
                makeup_4 = 0,
                lipstick_1 = 0,
                lipstick_2 = 0,
                lipstick_3 = 0,
                lipstick_4 = 0,
                ears_1 = -1,
                ears_2 = 0,
                chest_1 = 0,
                chest_2 = 0,
                chest_3 = 0,
                bodyb_1 = -1,
                bodyb_2 = 0,
                bodyb_3 = -1,
                bodyb_4 = 0,
                age_1 = 0,
                age_2 = 0,
                blemishes_1 = 0,
                blemishes_2 = 0,
                blush_1 = 0,
                blush_2 = 0,
                blush_3 = 0,
                complexion_1 = 0,
                complexion_2 = 0,
                sun_1 = 0,
                sun_2 = 0,
                moles_1 = 12,
                moles_2 = 8,
                beard_1 = 0,
                beard_2 = 0,
                beard_3 = 0,
                beard_4 = 0
            }
        },
        ['illenium-appearance'] = {
            ['m'] = {
                tattoos = {
                },
                props = {
                [1] = {
                    prop_id = 0,
                    texture = -1,
                    drawable = -1,
                    },
                [2] = {
                    prop_id = 1,
                    texture = -1,
                    drawable = -1,
                    },
                [3] = {
                    prop_id = 2,
                    texture = -1,
                    drawable = -1,
                    },
                [4] = {
                    prop_id = 6,
                    texture = -1,
                    drawable = -1,
                    },
                [5] = {
                    prop_id = 7,
                    texture = -1,
                    drawable = -1,
                    },
                },
                model = "mp_m_freemode_01",
                headOverlays = {
                moleAndFreckles = {
                    opacity = 0.5,
                    color = 0,
                    style = 0,
                    },
                ageing = {
                    opacity = 0,
                    color = 0,
                    style = 0,
                    },
                complexion = {
                    opacity = 0,
                    color = 0,
                    style = 0,
                    },
                chestHair = {
                    opacity = 0,
                    color = 0,
                    style = 0,
                    },
                beard = {
                    opacity = 0,
                    color = 20,
                    style = 0,
                    },
                eyebrows = {
                    opacity = 1,
                    color = 54,
                    style = 30,
                    },
                makeUp = {
                    opacity = 0,
                    color = 0,
                    style = 0,
                    },
                bodyBlemishes = {
                    opacity = 0,
                    color = 0,
                    style = 0,
                    },
                blemishes = {
                    opacity = 0,
                    color = 0,
                    style = 0,
                    },
                lipstick = {
                    opacity = 0,
                    color = 0,
                    style = 0,
                    },
                blush = {
                    opacity = 0,
                    color = 0,
                    style = 0,
                    },
                sunDamage = {
                    opacity = 0,
                    color = 0,
                    style = 0,
                    },
                },
                faceFeatures = {
                nosePeakHigh = -0.3,
                eyeBrownHigh = 0,
                noseBoneTwist = -0.3,
                cheeksBoneHigh = -0.2,
                jawBoneWidth = 0.5,
                eyeBrownForward = 0,
                cheeksWidth = 0.5,
                chinHole = 1,
                noseBoneHigh = 0.1,
                nosePeakLowering = 0.1,
                cheeksBoneWidth = -1,
                noseWidth = -0.7,
                neckThickness = 1,
                nosePeakSize = -0.1,
                eyesOpening = 0.8,
                chinBoneSize = 0,
                lipsThickness = 0,
                jawBoneBackSize = -0.6,
                chinBoneLowering = 0,
                chinBoneLenght = 0,
                },
                components = {
                [1] = {
                    texture = 0,
                    component_id = 0,
                    drawable = 0,
                    },
                [2] = {
                    texture = 0,
                    component_id = 1,
                    drawable = 0,
                    },
                [3] = {
                    texture = 0,
                    component_id = 2,
                    drawable = 64,
                    },
                [4] = {
                    texture = 0,
                    component_id = 3,
                    drawable = 12,
                    },
                [5] = {
                    texture = 0,
                    component_id = 4,
                    drawable = 1,
                    },
                [6] = {
                    texture = 0,
                    component_id = 5,
                    drawable = 0,
                    },
                [7] = {
                    texture = 0,
                    component_id = 6,
                    drawable = 157,
                    },
                [8] = {
                    texture = 0,
                    component_id = 7,
                    drawable = 0,
                    },
                [9] = {
                    texture = 3,
                    component_id = 8,
                    drawable = 88,
                    },
                [10] = {
                    texture = 0,
                    component_id = 9,
                    drawable = 0,
                    },
                [11] = {
                    texture = 0,
                    component_id = 10,
                    drawable = 0,
                    },
                [12] = {
                    texture = 0,
                    component_id = 11,
                    drawable = 0,
                    },
                },
                hair = {
                color = 20,
                highlight = 20,
                style = 64,
                },
                headBlend = {
                shapeFirst = 45,
                skinSecond = 0,
                shapeSecond = 45,
                skinMix = 0,
                skinFirst = 7,
                shapeMix = 0.4,
                },
                eyeColor = 24,
            },
            ['f'] = {
                props = {
                [1] = {
                    texture = -1,
                    drawable = -1,
                    prop_id = 0,
                    },
                [2] = {
                    texture = -1,
                    drawable = -1,
                    prop_id = 1,
                    },
                [3] = {
                    texture = -1,
                    drawable = -1,
                    prop_id = 2,
                    },
                [4] = {
                    texture = -1,
                    drawable = -1,
                    prop_id = 6,
                    },
                [5] = {
                    texture = -1,
                    drawable = -1,
                    prop_id = 7,
                    },
                },
                headBlend = {
                skinSecond = 6,
                skinMix = 0.6,
                shapeFirst = 33,
                shapeMix = 0.6,
                shapeSecond = 6,
                skinFirst = 33,
                },
                model = "mp_f_freemode_01",
                eyeColor = 8,
                faceFeatures = {
                nosePeakHigh = 0.4,
                chinBoneSize = 0,
                eyeBrownHigh = -0.5,
                noseBoneHigh = 0,
                jawBoneBackSize = 0,
                chinBoneLowering = -1,
                cheeksWidth = 0,
                neckThickness = -0.5,
                jawBoneWidth = 0,
                cheeksBoneWidth = 0,
                noseWidth = -1,
                nosePeakSize = 0.5,
                eyesOpening = -0.6,
                noseBoneTwist = 0,
                lipsThickness = 0,
                chinHole = 0,
                cheeksBoneHigh = 0,
                nosePeakLowering = 0,
                eyeBrownForward = -0.8,
                chinBoneLenght = 1,
                },
                components = {
                [1] = {
                    texture = 0,
                    component_id = 0,
                    drawable = 0,
                    },
                [2] = {
                    texture = 0,
                    component_id = 1,
                    drawable = 0,
                    },
                [3] = {
                    texture = 3,
                    component_id = 2,
                    drawable = 3,
                    },
                [4] = {
                    texture = 0,
                    component_id = 3,
                    drawable = 3,
                    },
                [5] = {
                    texture = 2,
                    component_id = 4,
                    drawable = 8,
                    },
                [6] = {
                    texture = 0,
                    component_id = 5,
                    drawable = 0,
                    },
                [7] = {
                    texture = 3,
                    component_id = 6,
                    drawable = 19,
                    },
                [8] = {
                    texture = 0,
                    component_id = 7,
                    drawable = 85,
                    },
                [9] = {
                    texture = 5,
                    component_id = 8,
                    drawable = 111,
                    },
                [10] = {
                    texture = 0,
                    component_id = 9,
                    drawable = 0,
                    },
                [11] = {
                    texture = 0,
                    component_id = 10,
                    drawable = 0,
                    },
                [12] = {
                    texture = 2,
                    component_id = 11,
                    drawable = 25,
                    },
                },
                hair = {
                style = 3,
                color = 34,
                highlight = 38,
                },
                headOverlays = {
                makeUp = {
                    opacity = 0,
                    color = 0,
                    style = 0,
                    },
                blush = {
                    opacity = 0,
                    color = 0,
                    style = 0,
                    },
                bodyBlemishes = {
                    opacity = 0,
                    color = 0,
                    style = 0,
                    },
                lipstick = {
                    opacity = 0,
                    color = 0,
                    style = 0,
                    },
                sunDamage = {
                    opacity = 0,
                    color = 0,
                    style = 0,
                    },
                moleAndFreckles = {
                    opacity = 0.8,
                    color = 0,
                    style = 12,
                    },
                blemishes = {
                    opacity = 0,
                    color = 0,
                    style = 0,
                    },
                eyebrows = {
                    opacity = 0.7,
                    color = 52,
                    style = 32,
                    },
                complexion = {
                    opacity = 0,
                    color = 0,
                    style = 0,
                    },
                ageing = {
                    opacity = 0,
                    color = 0,
                    style = 0,
                    },
                beard = {
                    opacity = 0,
                    color = 0,
                    style = 0,
                    },
                chestHair = {
                    opacity = 0,
                    color = 0,
                    style = 0,
                    },
                },
                tattoos = {
                },
            }  
        },
        ['fivem-appearance'] = {
            ['m'] = {
                props = {
                [1] = {
                    texture = -1,
                    drawable = -1,
                    prop_id = 0,
                    },
                [2] = {
                    texture = 0,
                    drawable = 0,
                    prop_id = 1,
                    },
                [3] = {
                    texture = -1,
                    drawable = -1,
                    prop_id = 2,
                    },
                [4] = {
                    texture = -1,
                    drawable = -1,
                    prop_id = 6,
                    },
                [5] = {
                    texture = -1,
                    drawable = -1,
                    prop_id = 7,
                    },
                },
                headBlend = {
                skinSecond = 0,
                skinMix = 0.3,
                shapeFirst = 21,
                shapeMix = 0.4,
                shapeSecond = 0,
                skinFirst = 21,
                },
                model = "mp_m_freemode_01",
                eyeColor = 0,
                faceFeatures = {
                jawBoneWidth = -0.2,
                noseBoneTwist = -0.3,
                eyeBrownHigh = 0,
                noseBoneHigh = 0.1,
                jawBoneBackSize = -0.2,
                chinBoneLowering = 0,
                eyeBrownForward = 0,
                neckThickness = 0,
                nosePeakHigh = 0,
                nosePeakLowering = 0.1,
                lipsThickness = -0.4,
                nosePeakSize = -0.1,
                chinHole = 0,
                cheeksWidth = 0.5,
                chinBoneSize = 0,
                eyesOpening = 0,
                cheeksBoneHigh = -0.2,
                noseWidth = -0.5,
                cheeksBoneWidth = -1,
                chinBoneLenght = 0,
                },
                components = {
                [1] = {
                    texture = 0,
                    component_id = 0,
                    drawable = 0,
                    },
                [2] = {
                    texture = 0,
                    component_id = 1,
                    drawable = 0,
                    },
                [3] = {
                    texture = 0,
                    component_id = 2,
                    drawable = 49,
                    },
                [4] = {
                    texture = 0,
                    component_id = 3,
                    drawable = 1,
                    },
                [5] = {
                    texture = 0,
                    component_id = 4,
                    drawable = 25,
                    },
                [6] = {
                    texture = 0,
                    component_id = 5,
                    drawable = 0,
                    },
                [7] = {
                    texture = 2,
                    component_id = 6,
                    drawable = 69,
                    },
                [8] = {
                    texture = 2,
                    component_id = 7,
                    drawable = 22,
                    },
                [9] = {
                    texture = 0,
                    component_id = 8,
                    drawable = 4,
                    },
                [10] = {
                    texture = 0,
                    component_id = 9,
                    drawable = 0,
                    },
                [11] = {
                    texture = 0,
                    component_id = 10,
                    drawable = 0,
                    },
                [12] = {
                    texture = 0,
                    component_id = 11,
                    drawable = 10,
                    },
                },
                hair = {
                style = 49,
                color = 47,
                highlight = 29,
                },
                headOverlays = {
                makeUp = {
                    style = 0,
                    color = 0,
                    opacity = 0,
                    },
                chestHair = {
                    style = 0,
                    color = 0,
                    opacity = 0,
                    },
                bodyBlemishes = {
                    style = 0,
                    color = 0,
                    opacity = 0,
                    },
                lipstick = {
                    style = 0,
                    color = 0,
                    opacity = 0,
                    },
                sunDamage = {
                    style = 0,
                    color = 0,
                    opacity = 0,
                    },
                moleAndFreckles = {
                    style = 0,
                    color = 0,
                    opacity = 0,
                    },
                blemishes = {
                    style = 0,
                    color = 0,
                    opacity = 0,
                    },
                blush = {
                    style = 0,
                    color = 0,
                    opacity = 0,
                    },
                complexion = {
                    style = 0,
                    color = 0,
                    opacity = 0,
                    },
                eyebrows = {
                    style = 0,
                    color = 0,
                    opacity = 0,
                    },
                beard = {
                    style = 11,
                    color = 0,
                    opacity = 1,
                    },
                ageing = {
                    style = 0,
                    color = 0,
                    opacity = 0,
                    },
                },
                tattoos = {
                },
            },
            ['f'] = {
                props = {
                   [1] = {
                      texture = -1,
                      drawable = -1,
                      prop_id = 0,
                    },
                   [2] = {
                      texture = -1,
                      drawable = -1,
                      prop_id = 1,
                    },
                   [3] = {
                      texture = -1,
                      drawable = -1,
                      prop_id = 2,
                    },
                   [4] = {
                      texture = -1,
                      drawable = -1,
                      prop_id = 6,
                    },
                   [5] = {
                      texture = -1,
                      drawable = -1,
                      prop_id = 7,
                    },
                 },
                headBlend = {
                   skinSecond = 6,
                   skinMix = 0.6,
                   shapeFirst = 33,
                   shapeMix = 0.6,
                   shapeSecond = 6,
                   skinFirst = 33,
                 },
                model = "mp_f_freemode_01",
                eyeColor = 8,
                faceFeatures = {
                   nosePeakHigh = 0.4,
                   chinBoneSize = 0,
                   eyeBrownHigh = -0.5,
                   noseBoneHigh = 0,
                   jawBoneBackSize = 0,
                   chinBoneLowering = -1,
                   cheeksWidth = 0,
                   neckThickness = -0.5,
                   jawBoneWidth = 0,
                   cheeksBoneWidth = 0,
                   noseWidth = -1,
                   nosePeakSize = 0.5,
                   eyesOpening = -0.6,
                   noseBoneTwist = 0,
                   lipsThickness = 0,
                   chinHole = 0,
                   cheeksBoneHigh = 0,
                   nosePeakLowering = 0,
                   eyeBrownForward = -0.8,
                   chinBoneLenght = 1,
                 },
                components = {
                   [1] = {
                      texture = 0,
                      component_id = 0,
                      drawable = 0,
                    },
                   [2] = {
                      texture = 0,
                      component_id = 1,
                      drawable = 0,
                    },
                   [3] = {
                      texture = 3,
                      component_id = 2,
                      drawable = 3,
                    },
                   [4] = {
                      texture = 0,
                      component_id = 3,
                      drawable = 3,
                    },
                   [5] = {
                      texture = 2,
                      component_id = 4,
                      drawable = 8,
                    },
                   [6] = {
                      texture = 0,
                      component_id = 5,
                      drawable = 0,
                    },
                   [7] = {
                      texture = 3,
                      component_id = 6,
                      drawable = 19,
                    },
                   [8] = {
                      texture = 0,
                      component_id = 7,
                      drawable = 85,
                    },
                   [9] = {
                      texture = 5,
                      component_id = 8,
                      drawable = 111,
                    },
                   [10] = {
                      texture = 0,
                      component_id = 9,
                      drawable = 0,
                    },
                   [11] = {
                      texture = 0,
                      component_id = 10,
                      drawable = 0,
                    },
                   [12] = {
                      texture = 2,
                      component_id = 11,
                      drawable = 25,
                    },
                 },
                hair = {
                   style = 3,
                   color = 34,
                   highlight = 38,
                 },
                headOverlays = {
                   makeUp = {
                      opacity = 0,
                      color = 0,
                      style = 0,
                    },
                   blush = {
                      opacity = 0,
                      color = 0,
                      style = 0,
                    },
                   bodyBlemishes = {
                      opacity = 0,
                      color = 0,
                      style = 0,
                    },
                   lipstick = {
                      opacity = 0,
                      color = 0,
                      style = 0,
                    },
                   sunDamage = {
                      opacity = 0,
                      color = 0,
                      style = 0,
                    },
                   moleAndFreckles = {
                      opacity = 0.8,
                      color = 0,
                      style = 12,
                    },
                   blemishes = {
                      opacity = 0,
                      color = 0,
                      style = 0,
                    },
                   eyebrows = {
                      opacity = 0.7,
                      color = 52,
                      style = 32,
                    },
                   complexion = {
                      opacity = 0,
                      color = 0,
                      style = 0,
                    },
                   ageing = {
                      opacity = 0,
                      color = 0,
                      style = 0,
                    },
                   beard = {
                      opacity = 0,
                      color = 0,
                      style = 0,
                    },
                   chestHair = {
                      opacity = 0,
                      color = 0,
                      style = 0,
                    },
                 },
                tattoos = {
                 },
            }  
        },
    }
end

