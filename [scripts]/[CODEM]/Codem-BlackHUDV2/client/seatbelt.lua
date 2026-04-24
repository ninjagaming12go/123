
seatbeltOn = false
if Config.EnableSeatbelt then
    lastSpeed = 0
    function CheckVehicleHasSeatbelt(vehicle)
        if DoesEntityExist(vehicle) then
            local class = GetVehicleClass(vehicle)
            if class == 0 or class == 1 or class == 2  or class == 3 or class == 4 or class == 5 or class == 6 or class == 7 or class == 9 or class == 12 or class == 22 or class == 20 or class == 18 or class == 17   then
                return true 
            end
            return false
        else
            return false
        end
    end
    if Config.SeatbeltSound then
        CreateThread(function()
            while true do
                local ped = playerPed
                local car = GetVehiclePedIsIn(ped)
                if DoesEntityExist(car) and CheckVehicleHasSeatbelt(car) then
                    if not seatbeltOn then
                        local speed = GetEntitySpeed(car) * 3.6
                        if speed > Config.SeatbeltSoundSpeedLimit then
                            SendNUIMessage({
                                type="PLAY_SEATBELT_SOUND",
                            })
                        end
                    end
                end
                Wait(2800)
            end
        end)
    end
    local seatbeltSpam = 0
    function playSound(action)
        local ped = playerPed
        local car = GetVehiclePedIsIn(ped)
        local seatPlayerId = {}
        if IsCar(car) then
            for i=1, GetVehicleModelNumberOfSeats(GetEntityModel(car)) do
                if not IsVehicleSeatFree(car, i-2) then 
                    local otherPlayerId = GetPedInVehicleSeat(car, i-2) 
                    local playerHandle = NetworkGetPlayerIndexFromPed(otherPlayerId)
                    local playerServerId = GetPlayerServerId(playerHandle)
                    table.insert(seatPlayerId, playerServerId)
                end
            end
            if #seatPlayerId > 0 then TriggerServerEvent("seatbelt:server:PlaySound", action, seatPlayerId) end 
        end
    end
    
    RegisterNetEvent('seatbelt:client:PlaySound')
    AddEventHandler('seatbelt:client:PlaySound', function(action, volume)
        SendNUIMessage({type = action, volume = volume})
    end)

    RegisterKeyMapping('seatbelt', 'Toggle Seatbelt', 'keyboard', Config.DefaultSeatbeltControlKey)
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1500)
            if seatbeltSpam > 0 then
                Citizen.Wait(3500)
                seatbeltSpam = 0
            end
        end
    end)
    
    RegisterNetEvent('codem-blackhudv2:seatbelt:toggle')
    AddEventHandler('codem-blackhudv2:seatbelt:toggle', function(toggle)
        local car = GetVehiclePedIsIn(playerPed)
	    if car ~= 0 and IsCar(car) then
            local vehicleClass = GetVehicleClass(GetVehiclePedIsIn(playerPed))
            if vehicleClass == 8 or vehicleClass == 13 or vehicleClass == 14 or vehicleClass == 21 then
                return 
            end
            if seatbeltSpam >= 3 then
                if Config.EnableSpamNotification  then
                    Config.Notification(Config.Notifications["spam"]["message"], Config.Notifications["spam"]["type"])
                end
                return
            end        
            seatbeltOn = toggle
            if seatbeltOn then
                SendNUIMessage({
                    type="update_seatbelt",
                    toggle = true
                })                
                playSound("buckle")
                Config.Notification(Config.Notifications["took_seatbelt"]["message"], Config.Notifications["took_seatbelt"]["type"])
            else
                SendNUIMessage({
                    type="update_seatbelt",
                    toggle = false
                })
                playSound("unbuckle")
                Config.Notification(Config.Notifications["took_off_seatbelt"]["message"], Config.Notifications["took_off_seatbelt"]["type"])
            end              
        end
    end)

    RegisterCommand('seatbelt', function()
        if IsPedHangingOnToVehicle(playerPed) then
            return
        end
        local car = GetVehiclePedIsIn(playerPed)
	    if car ~= 0 and IsCar(car) then
            local vehicleClass = GetVehicleClass(GetVehiclePedIsIn(playerPed))
            if vehicleClass == 8 or vehicleClass == 13 or vehicleClass == 14 or vehicleClass == 21 then
                return 
            end
            if seatbeltSpam >= 3 then
                if Config.EnableSpamNotification  then
                    Config.Notification(Config.Notifications["spam"]["message"], Config.Notifications["spam"]["type"])
                end
                return
            end        
            seatbeltOn = not seatbeltOn
            if seatbeltOn then
                SendNUIMessage({
                    type="update_seatbelt",
                    toggle = true
                })                
                playSound("buckle")
                Config.Notification(Config.Notifications["took_seatbelt"]["message"], Config.Notifications["took_seatbelt"]["type"])
            else
                SendNUIMessage({
                    type="update_seatbelt",
                    toggle = false
                })
                playSound("unbuckle")
                Config.Notification(Config.Notifications["took_off_seatbelt"]["message"], Config.Notifications["took_off_seatbelt"]["type"])
            end              
        end
              				  
    end, false)    
    function Fwv(entity)  
        local hr = GetEntityHeading(entity) + 90.0
        if hr < 0.0 then hr = 360.0 + hr end
        hr = hr * 0.0174533
        return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
    end
    function IsCar(veh)
        local vc = GetVehicleClass(veh)
        return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
    end  
    RegisterNetEvent('codem-blackhud-v2:client:EjectPlayer')
    AddEventHandler('codem-blackhud-v2:client:EjectPlayer', function(velocity)
        print("Ejecting player")
	    if not seatbeltOn then
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
	        local fw = Fwv(ped)
            lastSpeed = 0
            SetEntityCoords(ped, coords.x + fw.x, coords.y + fw.y, coords.z - .47, true, true, true)
            SetEntityVelocity(ped, lastVelocity.x, lastVelocity.y, lastVelocity.z)
	        Wait(500)
            ApplyDamageToPed(ped, math.random(10, 30),false)
            SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0) 
            seatbeltOn = false 
            SendNUIMessage({
                type="update_seatbelt",
                toggle = false
            })  
        end
    end)
    
    CreateThread(function()
        while true do
            local ped = PlayerPedId()
            local Vehicle = GetVehiclePedIsIn(ped)
            if IsPedInAnyVehicle(ped) and CheckVehicleHasSeatbelt(Vehicle) then
                local vehicle = Vehicle
                local speed = GetEntitySpeed(vehicle) * 3.6
                if lastSpeed > (Config.SeatBeltFlySpeed ) and (lastSpeed - speed) > (speed * 1.7) then
                    if not seatbeltOn then
                        print("Ejecting player", lastSpeed, speed)
                        local seatPlayerId = {}
                        for i=1, GetVehicleModelNumberOfSeats(GetEntityModel(vehicle)) do                       
                            if not IsVehicleSeatFree(vehicle, i-2) then 
                                local otherPlayerId = GetPedInVehicleSeat(vehicle, i-2) 
                                local playerHandle = NetworkGetPlayerIndexFromPed(otherPlayerId)
                                local playerServerId = GetPlayerServerId(playerHandle)
                                table.insert(seatPlayerId, playerServerId)
                            end
                        end
                        seatbeltOn = false
                        SendNUIMessage({
                            type="update_seatbelt",
                            toggle = false
                        }) 
                        if #seatPlayerId > 0 then TriggerServerEvent("codem-blackhud-v2:server:EjectPlayer", seatPlayerId) end       
                    end
                end   
                lastSpeed = speed
                lastVelocity = GetEntityVelocity(vehicle)
            else
                if seatbeltOn then
                    seatbeltOn = false
                    SendNUIMessage({
                        type="update_seatbelt",
                        toggle = false
                    }) 
                    lastSpeed = 0
                end
                Wait(2000)
            end
            Wait(150)
        end
    end)
end
