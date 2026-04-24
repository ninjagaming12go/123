spamControl = false

if Config.Framework == 'qb' or Config.Framework == 'oldqb' then
    RegisterNUICallback('DeleteCharacter', function(data, cb)
        if data.citizenid == nil then
            cb(false)
            return
        end
        local delete = TriggerCallback("m-multichar-server-DeleteCharacter", data.citizenid)
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
        local playerjob = data.job and data.job.jobname or 'unemployed'
        local animationfunctionname = Config.PlayerAnimation[playerjob] and
            Config.PlayerAnimation[playerjob].animationfunctionname or 'CitizenJobAnimation'
        if animationfunctionname == "CitizenJobAnimation" then
            playerjob = "unemployed"
        end
        if _G[animationfunctionname] then
            local positionname = findLastLocation(data.position) or 'unknown'
            NuiMessage('UPDATE_LAST_LOCATION', positionname)
            _G[animationfunctionname](data.citizenid)
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
    RegisterNetEvent("codem-multichar-creatingFirstChar")
    AddEventHandler("codem-multichar-creatingFirstChar", function()
        SetNuiFocus(false, false)
        DoScreenFadeOut(500)
        Wait(2000)
        SetEntityCoords(PlayerPedId(), Config.DefaultSpawn.x, Config.DefaultSpawn.y, Config.DefaultSpawn.z)
        TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
        TriggerEvent('QBCore:Client:OnPlayerLoaded')
        TriggerServerEvent('qb-houses:server:SetInsideMeta', 0, false)
        TriggerServerEvent('qb-apartments:server:SetInsideMeta', 0, 0, false)
        Wait(500)
        SetEntityVisible(PlayerPedId(), true)
        Wait(500)
        DoScreenFadeIn(250)
        TriggerEvent('qb-weathersync:client:EnableSync')
        TriggerEvent('qb-clothes:client:CreateFirstCharacter')
        FreezeEntityPosition(PlayerPedId(), false) -- fixed stuck
        DestroyMulticharCamera()
        DeleteNotSelectedPedorVehicle()
    end)

    RegisterNetEvent("codem-multicharacter-LoadPlayer")
    AddEventHandler("codem-multicharacter-LoadPlayer", function(coords, plyData)
        if Config.UseQBApartments then
            local result = TriggerCallback("qb-apartments:client:EnterApartment", plyData.citizenid)
            if result then
                DoScreenFadeOut(1000)
                Wait(1000)
                TriggerEvent("apartments:client:SetHomeBlip", result.type)
                SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)
                SetEntityHeading(PlayerPedId(), coords.w)
                FreezeEntityPosition(PlayerPedId(), false)
                SetEntityVisible(PlayerPedId(), true)
                local PlayerData = Core.Functions.GetPlayerData()
                local insideMeta = PlayerData.metadata["inside"]
                if insideMeta.house then
                    TriggerEvent('qb-houses:client:LastLocationHouse', insideMeta.house)
                elseif insideMeta.apartment.apartmentType and insideMeta.apartment.apartmentId then
                    TriggerEvent('qb-apartments:client:LastLocationHouse', insideMeta.apartment.apartmentType, insideMeta.apartment.apartmentId)
                else
                    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)
                    SetEntityHeading(PlayerPedId(), coords.w)
                    FreezeEntityPosition(PlayerPedId(), false)
                    SetEntityVisible(PlayerPedId(), true)
                end
            end
            DestroyMulticharCamera()
            DeleteNotSelectedPedorVehicle()
            SetNuiFocus(false, false)
            TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
            TriggerEvent('QBCore:Client:OnPlayerLoaded')
            Wait(2000)
            DoScreenFadeIn(1000)

        else
            DoScreenFadeOut(1000)
            Wait(1000)
            SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)
            SetEntityHeading(PlayerPedId(), coords.w)
            FreezeEntityPosition(PlayerPedId(), false)
            SetEntityVisible(PlayerPedId(), true)
            TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
            TriggerEvent('QBCore:Client:OnPlayerLoaded')
            TriggerServerEvent('qb-houses:server:SetInsideMeta', 0, false)
            TriggerServerEvent('qb-apartments:server:SetInsideMeta', 0, 0, false)
            TriggerEvent('qb-weathersync:client:EnableSync')
            SetNuiFocus(false, false)
            DestroyMulticharCamera()
            DeleteNotSelectedPedorVehicle()
            Wait(1500)
            DoScreenFadeIn(1000)

        end

    end)
    
    RegisterNUICallback('continuePlayer', function(data, cb)
        if spamControl then
            cb(false)
            return
        end

        spamControl = true
        local cData = data
        DoScreenFadeOut(1000)
        Wait(1000)
        SetNuiFocus(false, false)
        TriggerServerEvent('m-multichar-server-LoadPlayer', cData)
        cb("ok")
        DestroyMulticharCamera()
        DeleteNotSelectedPedorVehicle()
        Wait(1000)
        DoScreenFadeIn(1000)
    end)
end
