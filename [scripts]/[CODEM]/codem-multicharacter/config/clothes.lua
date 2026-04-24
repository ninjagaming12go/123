SetClothes = function(citizenid, coords, heading, anim, animationTable)
    if Config.Clothes == "default" or Config.Clothes == "fivem-appearance" or Config.Clothes == "illenium-appearance" or Config.Clothes == 'codem-appearance' then
        local characterData = TriggerCallback('m-multichar:server:getSkin', citizenid)

        if characterData == nil then
            return
        end
        local model
        if Config.Clothes == 'illenium-appearance' then
            characterData = json.decode(characterData)
            model = characterData['model']
        elseif Config.Clothes == 'fivem-appearance' then
            characterData = json.decode(characterData)
            model = characterData.model
        else
            if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
                characterData = json.decode(characterData)
                if characterData['sex'] == "m" or characterData['sex'] == 0 then
                    model = "mp_m_freemode_01"
                else
                    model = "mp_f_freemode_01"
                end
            elseif Config.Framework == 'qb' or Config.Framework == 'oldqb' then
                model = characterData and characterData.model or nil
                model = model ~= nil and tonumber(model) or false
            end
        end

        if model == nil or model == false then
            Citizen.CreateThread(function()
                ClearOldPed()
                local ped = PlayerPedId()
                SetEntityCoords(ped, coords.x, coords.y, coords.z - 5.0)
                SetEntityHeading(ped, heading)
                SetEntityVisible(ped, true)
                local randommodels = {
                    "mp_m_freemode_01",
                    "mp_f_freemode_01",
                }
                local model = GetHashKey(randommodels[math.random(1, #randommodels)])

                RequestModel(model)
                while not HasModelLoaded(model) do
                    Citizen.Wait(0)
                end
                DeleteEntity(createdPeds[citizenid])
                DeletePed(createdPeds[citizenid])
                createdPeds[citizenid] = nil
                createdPeds[citizenid] = CreatePed(2, model, coords.x, coords.y, coords.z - 0.98, heading, false, true)
                SetPedComponentVariation(createdPeds[citizenid], 0, 0, 0, 2)
                FreezeEntityPosition(createdPeds[citizenid], false)
                SetEntityInvincible(createdPeds[citizenid], true)
                PlaceObjectOnGroundProperly(createdPeds[citizenid])
                SetBlockingOfNonTemporaryEvents(createdPeds[citizenid], true)
                if anim ~= nil then
                    TaskStartScenarioInPlace(createdPeds[citizenid], anim, 0, true)
                end
                if animationTable ~= nil then
                    RequestAnimDict(animationTable[1])
                    while not HasAnimDictLoaded(animationTable[1]) do
                        Wait(1)
                    end
                    TaskPlayAnim(createdPeds[citizenid], animationTable[1], animationTable[2], 8.0, -8.0, -1, 1, 0, false,
                        false, false)
                    if animationTable[3] then
                        RequestAnimDict(animationTable[3])
                        while not HasAnimDictLoaded(animationTable[3]) do
                            Wait(1)
                        end
                        Wait(1000)
                        TaskPlayAnim(createdPeds[citizenid], animationTable[3], animationTable[4], 8.0, -8.0, -1, 1, 0,
                            false, false, false)
                    end
                end
            end)
        else
            ClearOldPed()
            Citizen.CreateThread(function()
                local ped = PlayerPedId()
                SetEntityCoords(ped, coords.x, coords.y, coords.z - 5)
                SetEntityHeading(ped, heading)
                SetEntityVisible(ped, true)
                RequestModel(model)
                while not HasModelLoaded(model) do
                    Citizen.Wait(0)
                end
                DeleteEntity(createdPeds[citizenid])
                DeletePed(createdPeds[citizenid])
                createdPeds[citizenid] = nil
                createdPeds[citizenid] = CreatePed(2, model, coords.x, coords.y, coords.z - 0.98, heading, false, true)
                SetPedComponentVariation(createdPeds[citizenid], 0, 0, 0, 2)
                FreezeEntityPosition(createdPeds[citizenid], false)
                SetEntityInvincible(createdPeds[citizenid], true)
                PlaceObjectOnGroundProperly(createdPeds[citizenid])
                SetBlockingOfNonTemporaryEvents(createdPeds[citizenid], true)
                if Config.Clothes == 'fivem-appearance' then
                    exports['fivem-appearance']:setPedAppearance(createdPeds[citizenid], characterData)
                elseif Config.Clothes == 'illenium-appearance' then
                    exports['illenium-appearance']:setPedAppearance(createdPeds[citizenid], characterData)
                else
                    if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
                        ApplySkinForPed(createdPeds[citizenid], characterData)
                    elseif Config.Framework == 'qb' or Config.Framework == 'oldqb' then
                        data = json.decode(characterData.skin)
                        TriggerEvent('qb-clothing:client:loadPlayerClothing', data, createdPeds[citizenid])
                    end
                end

                if anim ~= nil then
                    TaskStartScenarioInPlace(createdPeds[citizenid], anim, 0, true)
                end

                if animationTable ~= nil then
                    RequestAnimDict(animationTable[1])
                    while not HasAnimDictLoaded(animationTable[1]) do
                        Wait(1)
                    end
                    TaskPlayAnim(createdPeds[citizenid], animationTable[1], animationTable[2], 8.0, -8.0, -1, 1, 0, false,
                        false, false)
                    if animationTable[3] then
                        RequestAnimDict(animationTable[3])
                        while not HasAnimDictLoaded(animationTable[3]) do
                            Wait(1)
                        end
                        Wait(1000)
                        TaskPlayAnim(createdPeds[citizenid], animationTable[3], animationTable[4], 8.0, -8.0, -1, 1, 0,
                            false, false, false)
                    end
                end
            end)
        end
    end
end

function ApplySkinForPed(playerPed, Character)
    local face_weight = (Character['face_md_weight'] / 100) + 0.0
    local skin_weight = (Character['skin_md_weight'] / 100) + 0.0
    SetPedHeadBlendData(playerPed, Character['mom'], Character['dad'], 0, Character['mom'], Character['dad'], 0,
        face_weight, skin_weight, 0.0, false)

    SetPedFaceFeature(playerPed, 0, (Character['nose_1'] / 10) + 0.0)                                  -- Nose Width
    SetPedFaceFeature(playerPed, 1, (Character['nose_2'] / 10) + 0.0)                                  -- Nose Peak Height
    SetPedFaceFeature(playerPed, 2, (Character['nose_3'] / 10) + 0.0)                                  -- Nose Peak Length
    SetPedFaceFeature(playerPed, 3, (Character['nose_4'] / 10) + 0.0)                                  -- Nose Bone Height
    SetPedFaceFeature(playerPed, 4, (Character['nose_5'] / 10) + 0.0)                                  -- Nose Peak Lowering
    SetPedFaceFeature(playerPed, 5, (Character['nose_6'] / 10) + 0.0)                                  -- Nose Bone Twist
    SetPedFaceFeature(playerPed, 6, (Character['eyebrows_5'] / 10) + 0.0)                              -- Eyebrow height
    SetPedFaceFeature(playerPed, 7, (Character['eyebrows_6'] / 10) + 0.0)                              -- Eyebrow depth
    SetPedFaceFeature(playerPed, 8, (Character['cheeks_1'] / 10) + 0.0)                                -- Cheekbones Height
    SetPedFaceFeature(playerPed, 9, (Character['cheeks_2'] / 10) + 0.0)                                -- Cheekbones Width
    SetPedFaceFeature(playerPed, 10, (Character['cheeks_3'] / 10) + 0.0)                               -- Cheeks Width
    SetPedFaceFeature(playerPed, 11, (Character['eye_squint'] / 10) + 0.0)                             -- Eyes squint
    SetPedFaceFeature(playerPed, 12, (Character['lip_thickness'] / 10) + 0.0)                          -- Lip Fullness
    SetPedFaceFeature(playerPed, 13, (Character['jaw_1'] / 10) + 0.0)                                  -- Jaw Bone Width
    SetPedFaceFeature(playerPed, 14, (Character['jaw_2'] / 10) + 0.0)                                  -- Jaw Bone Length
    SetPedFaceFeature(playerPed, 15, (Character['chin_1'] / 10) + 0.0)                                 -- Chin Height
    SetPedFaceFeature(playerPed, 16, (Character['chin_2'] / 10) + 0.0)                                 -- Chin Length
    SetPedFaceFeature(playerPed, 17, (Character['chin_3'] / 10) + 0.0)                                 -- Chin Width
    SetPedFaceFeature(playerPed, 18, (Character['chin_4'] / 10) + 0.0)                                 -- Chin Hole Size
    SetPedFaceFeature(playerPed, 19, (Character['neck_thickness'] / 10) + 0.0)                         -- Neck Thickness

    SetPedHairColor(playerPed, Character['hair_color_1'], Character['hair_color_2'])                   -- Hair Color
    SetPedHeadOverlay(playerPed, 3, Character['age_1'], (Character['age_2'] / 10) + 0.0)               -- Age + opacity
    SetPedHeadOverlay(playerPed, 0, Character['blemishes_1'], (Character['blemishes_2'] / 10) + 0.0)   -- Blemishes + opacity
    SetPedHeadOverlay(playerPed, 1, Character['beard_1'], (Character['beard_2'] / 10) + 0.0)           -- Beard + opacity
    SetPedEyeColor(playerPed, Character['eye_color'])                                                  -- Eyes color
    SetPedHeadOverlay(playerPed, 2, Character['eyebrows_1'], (Character['eyebrows_2'] / 10) + 0.0)     -- Eyebrows + opacity
    SetPedHeadOverlay(playerPed, 4, Character['makeup_1'], (Character['makeup_2'] / 10) + 0.0)         -- Makeup + opacity
    SetPedHeadOverlay(playerPed, 8, Character['lipstick_1'], (Character['lipstick_2'] / 10) + 0.0)     -- Lipstick + opacity
    SetPedComponentVariation(playerPed, 2, Character['hair_1'], Character['hair_2'], 2)                -- Hair
    SetPedHeadOverlayColor(playerPed, 1, 1, Character['beard_3'], Character['beard_4'])                -- Beard Color
    SetPedHeadOverlayColor(playerPed, 2, 1, Character['eyebrows_3'], Character['eyebrows_4'])          -- Eyebrows Color
    SetPedHeadOverlayColor(playerPed, 4, 2, Character['makeup_3'], Character['makeup_4'])              -- Makeup Color
    SetPedHeadOverlayColor(playerPed, 8, 1, Character['lipstick_3'], Character['lipstick_4'])          -- Lipstick Color
    SetPedHeadOverlay(playerPed, 5, Character['blush_1'], (Character['blush_2'] / 10) + 0.0)           -- Blush + opacity
    SetPedHeadOverlayColor(playerPed, 5, 2, Character['blush_3'])                                      -- Blush Color
    SetPedHeadOverlay(playerPed, 6, Character['complexion_1'], (Character['complexion_2'] / 10) + 0.0) -- Complexion + opacity
    SetPedHeadOverlay(playerPed, 7, Character['sun_1'], (Character['sun_2'] / 10) + 0.0)               -- Sun Damage + opacity
    SetPedHeadOverlay(playerPed, 9, Character['moles_1'], (Character['moles_2'] / 10) + 0.0)           -- Moles/Freckles + opacity
    SetPedHeadOverlay(playerPed, 10, Character['chest_1'], (Character['chest_2'] / 10) + 0.0)          -- Chest Hair + opacity
    SetPedHeadOverlayColor(playerPed, 10, 1, Character['chest_3'])                                     -- Torso Color

    if Character['bodyb_1'] == -1 then
        SetPedHeadOverlay(playerPed, 11, 255, (Character['bodyb_2'] / 10) + 0.0) -- Body Blemishes + opacity
    else
        SetPedHeadOverlay(playerPed, 11, Character['bodyb_1'], (Character['bodyb_2'] / 10) + 0.0)
    end

    if Character['bodyb_3'] == -1 then
        SetPedHeadOverlay(playerPed, 12, 255, (Character['bodyb_4'] / 10) + 0.0)
    else
        SetPedHeadOverlay(playerPed, 12, Character['bodyb_3'], (Character['bodyb_4'] / 10) + 0.0) -- Blemishes 'added body effect' + opacity
    end

    if Character['ears_1'] == -1 then
        ClearPedProp(playerPed, 2)
    else
        SetPedPropIndex(playerPed, 2, Character['ears_1'], Character['ears_2'], 2) -- Ears Accessories
    end

    SetPedComponentVariation(playerPed, 8, Character['tshirt_1'], Character['tshirt_2'], 2)  -- Tshirt
    SetPedComponentVariation(playerPed, 11, Character['torso_1'], Character['torso_2'], 2)   -- torso parts
    SetPedComponentVariation(playerPed, 3, Character['arms'], Character['arms_2'], 2)        -- Arms
    SetPedComponentVariation(playerPed, 10, Character['decals_1'], Character['decals_2'], 2) -- decals
    SetPedComponentVariation(playerPed, 4, Character['pants_1'], Character['pants_2'], 2)    -- pants
    SetPedComponentVariation(playerPed, 6, Character['shoes_1'], Character['shoes_2'], 2)    -- shoes
    SetPedComponentVariation(playerPed, 1, Character['mask_1'], Character['mask_2'], 2)      -- mask
    SetPedComponentVariation(playerPed, 9, Character['bproof_1'], Character['bproof_2'], 2)  -- bulletproof
    SetPedComponentVariation(playerPed, 7, Character['chain_1'], Character['chain_2'], 2)    -- chain
    SetPedComponentVariation(playerPed, 5, Character['bags_1'], Character['bags_2'], 2)      -- Bag

    if Character['helmet_1'] == -1 then
        ClearPedProp(playerPed, 0)
    else
        SetPedPropIndex(playerPed, 0, Character['helmet_1'], Character['helmet_2'], 2) -- Helmet
    end

    if Character['glasses_1'] == -1 then
        ClearPedProp(playerPed, 1)
    else
        SetPedPropIndex(playerPed, 1, Character['glasses_1'], Character['glasses_2'], 2) -- Glasses
    end

    if Character['watches_1'] == -1 then
        ClearPedProp(playerPed, 6)
    else
        SetPedPropIndex(playerPed, 6, Character['watches_1'], Character['watches_2'], 2) -- Watches
    end

    if Character['bracelets_1'] == -1 then
        ClearPedProp(playerPed, 7)
    else
        SetPedPropIndex(playerPed, 7, Character['bracelets_1'], Character['bracelets_2'], 2) -- Bracelets
    end
end
