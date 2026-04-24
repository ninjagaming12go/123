Config = {}

--[[---------------------------------------------------------------------------
░██████╗░███████╗███╗░░██╗███████╗██████╗░░█████╗░██╗░░░░░
██╔════╝░██╔════╝████╗░██║██╔════╝██╔══██╗██╔══██╗██║░░░░░
██║░░██╗░█████╗░░██╔██╗██║█████╗░░██████╔╝███████║██║░░░░░
██║░░╚██╗██╔══╝░░██║╚████║██╔══╝░░██╔══██╗██╔══██║██║░░░░░
╚██████╔╝███████╗██║░╚███║███████╗██║░░██║██║░░██║███████╗
░╚═════╝░╚══════╝╚═╝░░╚══╝╚══════╝╚═╝░░╚═╝╚═╝░░╚═╝╚══════╝
---------------------------------------------------------------------------]]--

Config.Framework = "newqb" -- esx, newqb, oldqb 
Config.NewESX = false 
Config.SQL = "oxmysql" -- oxmysql, ghmattimysql, mysql-async
Config.Blip = true -- true or false
Config.RealParking = false -- if false all garages are shared (you can get every car from every garage) / if true you can only get cars from the garage where it was stored before
Config.InteractionHandler = "drawtext" -- "qb-target", "ox_target" "drawtext","custom" is a custom interaction handler
Config.InteractionHandler2 = "drawmarker"  -- "drawtext", "drawmarker","custom" is a custom interaction handler
Config.Sell = true -- if you are using vehicle sell please set this to true 
Config.Transfer = true -- if you are using vehicle transfer please set this to true
Config.Repair = true -- if you are using vehicle repair please set this to true
Config.Out = true -- checks whether the vehicle is outside (may cause the garage to open late)
Config.AutoReset = true -- reintroduces vehicles back into the garage after restarting the server
Config.Red = 255 -- red
Config.Green = 10 -- green
Config.Blue = 20 -- blue
Config.Alpha = 155  -- alpha
Config.Debug = false -- if you want to see debug messages set this to true

--[[---------------------------------------------------------------------------
██╗░░░██╗███████╗██╗░░██╗██╗░█████╗░██╗░░░░░███████╗  ░██████╗███████╗████████╗████████╗██╗███╗░░██╗░██████╗░
██║░░░██║██╔════╝██║░░██║██║██╔══██╗██║░░░░░██╔════╝  ██╔════╝██╔════╝╚══██╔══╝╚══██╔══╝██║████╗░██║██╔════╝░
╚██╗░██╔╝█████╗░░███████║██║██║░░╚═╝██║░░░░░█████╗░░  ╚█████╗░█████╗░░░░░██║░░░░░░██║░░░██║██╔██╗██║██║░░██╗░
░╚████╔╝░██╔══╝░░██╔══██║██║██║░░██╗██║░░░░░██╔══╝░░  ░╚═══██╗██╔══╝░░░░░██║░░░░░░██║░░░██║██║╚████║██║░░╚██╗
░░╚██╔╝░░███████╗██║░░██║██║╚█████╔╝███████╗███████╗  ██████╔╝███████╗░░░██║░░░░░░██║░░░██║██║░╚███║╚██████╔╝
░░░╚═╝░░░╚══════╝╚═╝░░╚═╝╚═╝░╚════╝░╚══════╝╚══════╝  ╚═════╝░╚══════╝░░░╚═╝░░░░░░╚═╝░░░╚═╝╚═╝░░╚══╝░╚═════╝░
---------------------------------------------------------------------------]]--

Config.PlateLetters  = 4 -- plate letters
Config.PlateNumbers  = 4 -- plate numbers
Config.PlateUseSpace = false -- use space in plate
Config.MileageFormat = "KM" -- "KM" "MI"
Config.EnableFuel = false -- Do NOT Touch if you have any fuel system
Config.FuelSystem = 'LegacyFuel' -- LegacyFuel / x-fuel / ox-fuel / nd-fuel / frfuel / cdn-fuel / hyon_gas_stationConfig.DefaultSellPrice = 10000 -- default price for vehicles that are not in the database
Config.Vehiclekey = true -- Do NOT Touch if you have any car lock system
Config.VehicleKeySystem = "qb-vehiclekeys" -- cd_garage / qs-vehiclekeys / wasabi-carlock / qb-vehiclekeys
Config.VehicleRemovekey = true -- Do NOT Touch if you have any car lock system
Config.VehicleRemoveKeySystem = "qb-vehiclekeys" -- cd_garage / qs-vehiclekeys / qb-vehiclekeys
Config.JobVehicleMax = true -- true if you want the job tool to be at maximum value when spawning
Config.RepairPrice = 1000 -- repair price
Config.RepairMoneyType = 'bank' -- money type 'bank', 'normal'
Config.Vale = false -- Impound & destory & display of exploded vehicles in the garage or in an impound garage (if you are using vale system set this to true and set false to impound system)
Config.Impound = true -- Impound system (if you are using impound system set this to true and set false to vale system)
Config.ImpoundPrice = 1500 -- Impound price
Config.ValePrice = 1000 -- price for vale
Config.MoneyType = 'bank' -- money type  'bank', 'normal'

--[[---------------------------------------------------------------------------
███╗░░██╗░█████╗░████████╗██╗███████╗██╗░█████╗░░█████╗░████████╗██╗░█████╗░███╗░░██╗
████╗░██║██╔══██╗╚══██╔══╝██║██╔════╝██║██╔══██╗██╔══██╗╚══██╔══╝██║██╔══██╗████╗░██║
██╔██╗██║██║░░██║░░░██║░░░██║█████╗░░██║██║░░╚═╝███████║░░░██║░░░██║██║░░██║██╔██╗██║
██║╚████║██║░░██║░░░██║░░░██║██╔══╝░░██║██║░░██╗██╔══██║░░░██║░░░██║██║░░██║██║╚████║
██║░╚███║╚█████╔╝░░░██║░░░██║██║░░░░░██║╚█████╔╝██║░░██║░░░██║░░░██║╚█████╔╝██║░╚███║
╚═╝░░╚══╝░╚════╝░░░░╚═╝░░░╚═╝╚═╝░░░░░╚═╝░╚════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░╚════╝░╚═╝░░╚══╝
---------------------------------------------------------------------------]]--

Config.NotificationText = {
    ["NO_ID"] = {
        text = 'Write the id of the person you will transfer the vehicle to',
        timeout = 3000,
    },
    ["NO_PLAYER"] = {
        text = 'No player with that id',
        timeout = 3000,
    },
    ["ERR_YOURSELF"] = {
        text = "You can't transfer it to yourself",
        timeout = 3000,
    },
    ["ERR_TRANSFER"] = {
        text = "An error occurred during the transfer",
        timeout = 3000,
    },
    ["SUCCESTRANSFER"] = {
        text = 'The transfer was successful',
        timeout = 3000,
    },
    ["ERR_SELL"] = {
        text = 'An error occurred during the sell',
        timeout = 3000,
    },
    ["SUCCESFULL_SELL"] = {
        text = 'Vehicle successfully sold',
        timeout = 3000,
    },
    ["SUCCESSFAVORITE"] = {
        text = 'Vehicle successfully added favorite',
        timeout = 5000,
    },
    ["SUCCESSUNFAVORITE"] = {
        text = 'Vehicle successfully removed favorite',
        timeout = 5000,
    },
    ['SUCCESSVALE'] = {
        text = 'Fee paid',
        timeout = 5000,
    },
    ['FAILVALE'] = {
        text = 'Not enough money',
        timeout = 5000,
    },
    ['NO_MONEY'] = {
        text = 'Not enough money',
        timeout = 5000,
    },
    ['SUCCESSREPAIR'] = {
        text = 'Vehicle successfully repaired',
        timeout = 5000,
    },
    ['FAILREPAIR'] = {
        text = 'Not enough money',
        timeout = 5000,
    },
    ['OCCUPIED'] = {
        text = 'Spawn place is occupied',
        timeout = 5000,
    },
    ['FAILSTORED'] = {
        text = 'The vehicle is not yours',
        timeout = 5000,
    },
    ['FAILSTORED2'] = {
        text = 'This vehicle is not suitable for this garage',
        timeout = 5000,
    },
    ['FAILCLASS'] = {
        text = 'This class is not allowed in this garage',
        timeout = 5000,
    },
    ['ALREADYREPAIRED'] = {
        text = 'This vehicle has already been repaired',
        timeout = 5000,
    },
    ["IMPUND"] = {
        text = "You can't park here",
        timeout = 5000,    
    },
    ["NO_ACCESS"] = {
        text = "You don't have access to this garage",
        timeout = 5000,
    }
    
}

Config.ClientNotification = function(message, type, length) -- You can change notification event here
    if Config.Framework == "esx" then
        TriggerEvent("esx:showNotification", message)
    else
        TriggerEvent('QBCore:Notify', message, type, length)
    end
end

Config.ServerNotification = function(source, message, type, length) -- You can change notification event here
    if Config.Framework == "esx" then
        TriggerClientEvent("esx:showNotification",source, message)
    else
        TriggerClientEvent('QBCore:Notify', source, message, type, length)
    end
end

--[[---------------------------------------------------------------------------
░█████╗░░█████╗░██████╗░ ░██████╗███████╗████████╗████████╗██╗███╗░░██╗░██████╗░░██████╗
██╔══██╗██╔══██╗██╔══██╗ ██╔════╝██╔════╝╚══██╔══╝╚══██╔══╝██║████╗░██║██╔════╝░██╔════╝
██║░░╚═╝███████║██████╔╝ ╚█████╗░█████╗░░░░░██║░░░░░░██║░░░██║██╔██╗██║██║░░██╗░╚█████╗░
██║░░██╗██╔══██║██╔══██╗ ░╚═══██╗██╔══╝░░░░░██║░░░░░░██║░░░██║██║╚████║██║░░╚██╗░╚═══██╗
╚█████╔╝██║░░██║██║░░██║ ██████╔╝███████╗░░░██║░░░░░░██║░░░██║██║░╚███║╚██████╔╝██████╔╝
░╚════╝░╚═╝░░╚═╝╚═╝░░╚═╝ ╚═════╝░╚══════╝░░░╚═╝░░░░░░╚═╝░░░╚═╝╚═╝░░╚══╝░╚═════╝░╚═════╝░
---------------------------------------------------------------------------]]--

Config.ManuelCarName = {
    ['08charger'] = "Police Car",
}

Config.CarLogo = { -- 
    ['tribike3'] = "Western", -- ['Carname'] = "LogoName"
    ['08charger'] = "Western",
}

Config.CarImage = { -- you have to write here the car name you saw in the garage.
    ['Porsche Panemara'] = "porschepanemara", -- ['Carname'] = "Image Name"
    ['Police Car'] = "t20",
}

Config.Weight = {
    [0]  = 1000,-- Compacts  
    [1]  = 1500,-- Sedans  
    [2]  = 2000,-- SUVs  
    [3]  = 2500,-- Coupes 
    [4]  = 3000,-- Muscle 
    [5]  = 4000,-- Sports Classics 
    [6]  = 5000,-- Sports 
    [7]  = 6000,-- Super
    [8]  = 7000,-- Motorcycles  
    [9]  = 8000,--  Off-road 
    [10] = 9000,-- Industrial
    [11] = 10000,-- Utility
    [12] = 11000,-- Vans  
    [13] = 12000,-- Cycles
    [14] = 13000,-- Boats  
    [15] = 14000,-- Helicopters
    [16] = 15000,-- Planes 
    [17] = 16000,-- Service
    [18] = 17000,-- Emergency 
    [19] = 18000, -- Military  
    [20] = 19000 -- Commercial  
}

Config.Text = {
    [0] = 'Compacts in Grand Theft Auto V and Grand Theft Auto Online. These are defined by the Vehicle Class System introduced in GTA V. Those cars are such as Brioso 300 Widebody, Club, Blista Kanjo, Brioso 300, Blista, Brioso R/A, Dilettante, Asbo etc.',  -- Compacts 
    [1] = 'Sedans in Grand Theft Auto V and Grand Theft Auto Online. These are defined by the Vehicle Class System introduced in GTA V. For Sedans in the Grand Theft Auto series, see Sedans. Those cars are such as Emperor, Rhinehart, Tailgater S, Cinquemila, Asea, Super Diamond etc. ',  -- Sedans
    [2] = 'SUVs in Grand Theft Auto V and Grand Theft Auto Online. These are defined by the Vehicle Class System introduced in GTA V. For a list of all SUVs and SUTs in the Grand Theft Auto series, see SUVs. Those cars are such as XLS, Granger 3600LX, Astron, Patriot, I-Wagen, Rebla GTS, Cavalcade, Dubsta etc. ',  -- SUVs 
    [3] = 'Coupes in Grand Theft Auto V and Grand Theft Auto Online. These are defined by the Vehicle Class System introduced in GTA V. For other Coupes in the Grand Theft Auto series, see Coupes. Those cars are such as Kanjo SJ, Sentinel, Previon, Postlude, Sentinel XS, F620, Oracle, Felon GT etc. ',  -- Coupes 
    [4] = 'Muscle Cars in Grand Theft Auto V and Grand Theft Auto Online. These are defined by the Vehicle Class System introduced in GTA V. For other muscle cars in the Grand Theft Auto series, see Muscle Cars. Those cars are such as Vigero ZX, Ruiner ZZ-8, Greenwood, Phoenix, Dominator GTT, Duke O Death, Chino, Hustler etc. ',  -- Muscle 
    [5] = 'Sports Classics Vehicles in Grand Theft Auto V and Grand Theft Auto Online. These are defined by the Vehicle Class System introduced in GTA V. For other classic cars in the Grand Theft Auto series, see Classic Cars. Those cars are such as Mamba, Toreador, Stirling GT, Turismo Classic, Ardent, Zion Classic, 190z, JB 700 etc.',  -- Sports Classics 
    [6] = 'Sports Cars in Grand Theft Auto V and Grand Theft Auto Online. These are defined by the Vehicle Class System introduced in GTA V. For other sports cars in the Grand Theft Auto series, see Sports Cars. Those cars are such as Hotring Sabre, Locust, 10F Widebody, Paragon R, Corsita, ZR-350, Imorgon, Elegy Retro Custom etc.',  -- Sports 
    [7] = 'Supercars and hypercars in Grand Theft Auto V and Grand Theft Auto Online. These are defined by the Vehicle Class System introduced in GTA V. For other supercars in the Grand Theft Auto series, see Super Cars. Those cars are such as LM87, Torero XO, Cyclone II, Sultan RS, Champion, Vacca, Turismo R, Vigilante etc.',  -- Super
    [8] = 'Motorcycles in Grand Theft Auto V and Grand Theft Auto Online. These are defined by the Vehicle Class System introduced in GTA V. For other motorcycles in the Grand Theft Auto series, see Motorcycles. Those vehicles are such as Oppressor Mk II, Hakuchou Custom, Oppressor, Bati 800, PCJ 600, Faggio etc.',  -- Motorcycles
    [9] = 'Off-Road Vehicles in Grand Theft Auto V and Grand Theft Auto Online. These are defined by the Vehicle Class System introduced in GTA V. For Off-Road vehicles in the Grand Theft Auto series, see Off-Road Vehicles. Those cars are such as Dune FAV, Nightshark, Mesa Grande, Draugur, Patriot Mil-Spec, Everon etc.',  --  Off-road 
    [10] = 'Industrial Vehicles in Grand Theft Auto V and Grand Theft Auto Online. These are defined by the Vehicle Class System introduced in GTA V. For other Industrial Vehicles, see Industrial Vehicles. Those cars are such as Guardian, Dozer, Flatbed, Dump, Dock Handler, Mixer etc.', -- Industrial
    [11] = 'Utility Vehicles in Grand Theft Auto V and Grand Theft Auto Online. These are defined by the Vehicle Class System introduced in GTA V. For utility vehicles in the entire Grand Theft Auto series, see Utility Vehicles. Those vehicles are such as Mobile Operations Center, Sadler, Towtruck, Caddy, Slamtruck, Trailer, Tractor etc.', -- Utility 
    [12] = 'Vans in Grand Theft Auto V and Grand Theft Auto Online. These are defined by the Vehicle Class System introduced in GTA V. For all vans in the Grand Theft Auto series, see Vans. Those cars are such as Bison, Speedo Custom, Rumpo Custom, Journey, Surfer, Burrito, Youga Custom etc.', -- Vans
    [13] = 'Cycles (bicycles) in Grand Theft Auto V and Grand Theft Auto Online. These are defined by the Vehicle Class System introduced in GTA V. For other bicycles in the Grand Theft Auto series, see Bicycles. Those bicycles are such as BMX, Fixter, Scorcher, Tri-Cycles Race Bike etc.', -- Cycles 
    [14] = 'Boats in Grand Theft Auto V and Grand Theft Auto Online. These are defined by the Vehicle Class System introduced in GTA V. Those boats are such as Kosatka, Submersible, Kraken, Avisa, Marquis, Dinghy, Predator etc.', -- Boats 
    [15] = 'Helicopters in Grand Theft Auto V and Grand Theft Auto Online. These are defined by the Vehicle Class System introduced in GTA V. For helicopters in the Grand Theft Auto series, see Helicopters. Those helicopters are such as Sparrow, Akula, Cargobob, Hunter, Police Maverick etc. ', -- Helicopters 
    [16] = 'Planes in Grand Theft Auto V and Grand Theft Auto Online. These are defined by the Vehicle Class System introduced in GTA V. For other planes/aircraft in the series, see Fixed-Wing Aircraft. Those aircrafts are such as P-996 LAZER, RO-86 Alkonost, Hydra, Volatol etc.', -- Planes  
    [17] = 'Public Service Vehicles in Grand Theft Auto V and Grand Theft Auto Online. These are defined by the Vehicle Class System introduced in GTA V. Those vehicles are such as Bus, Festival Bus, Taxi, Dune, Dashound, Trashmaster etc.', -- Service
    [18] = 'Emergency Vehicles in Grand Theft Auto V and Grand Theft Auto Online. These are defined by the Vehicle Class System introduced in GTA V. For other emergency vehicles in the Grand Theft Auto series, see Emergency Vehicles. Those vehicles are such as FIB Buffalo, Police Buffalo, Police Cruiser, Fire Truck, Ambulance, Police Roadcruiser, Police Riot etc. ', -- Emergency 
    [19] = 'Military Vehicles in Grand Theft Auto V and Grand Theft Auto Online. These are defined by the Vehicle Class System introduced in GTA V. For other military vehicles, see Military Vehicles. Those vehicles are such as TM-02 Khanjali, APC, Anti-Aircraft Trailer, Rhino etc. ', -- Military
    [20] = 'Commercial Vehicles in Grand Theft Auto V and Grand Theft Auto Online. These are defined by the Vehicle Class System introduced in GTA V. Those vehicles are such as Terrorbyte, Securicar, Mule, Pounder Custom, Phantom Wedge, Hauler Custom, Phantom, Mule Custom etc.'  -- Commercial 
}

--[[---------------------------------------------------------------------------
░█████╗░██████╗░███████╗███╗░░██╗
██╔══██╗██╔══██╗██╔════╝████╗░██║
██║░░██║██████╔╝█████╗░░██╔██╗██║
██║░░██║██╔═══╝░██╔══╝░░██║╚████║
╚█████╔╝██║░░░░░███████╗██║░╚███║
░╚════╝░╚═╝░░░░░╚══════╝╚═╝░░╚══╝
---------------------------------------------------------------------------]]--

Config.OpenTrigger = function()

    if Config.InteractionHandler == "drawtext" then
        Citizen.CreateThread(function()
            while true do
                local sleep = 2500
                if response then
                    local ped = PlayerPedId()
                    local pos = GetEntityCoords(ped)
                    for k,v in pairs(Config.Garages) do
                        if v.npc["show"] then
                            local dist = #(pos - vector3(v["npc"].npc.x, v["npc"].npc.y, v["npc"].npc.z))
                            if dist < 5 then
                                sleep = 5
                                DrawText3Ds(v["npc"].npc.x, v["npc"].npc.y, v["npc"].npc.z + 0.90, "[~g~E~w~] - Open Garage")
                                if IsControlJustPressed(0, 38) then
                                    openGarage(k,nil)
                                end
                            end
                        end
                    end
                end
                Citizen.Wait(sleep)
            end
        end)
    elseif Config.InteractionHandler == "qb-target" then
        for k,v in pairs(Config.Garages) do
            while true do
                local sleep = 1000
                if response then
                    local ped = PlayerPedId()
                    local pos = GetEntityCoords(ped)
                    for k,v in pairs(Config.Garages) do
                        if v.npc["show"] then
                            local dist = #(pos - vector3(v["npc"].npc.x, v["npc"].npc.y, v["npc"].npc.z))
                            if dist < 5 then
                                exports['qb-target']:AddTargetModel(v.npc["npcModel"], {
                                    options = {
                                        {
                                            icon = "fas fa-car",
                                            label = "Open Garage",
                                            action = function()
                                                openedGarage = k
                                                openGarage(openedGarage,nil)
                                            end
                                        },
                                    },
                                    distance = 2.5
                                })
                            end
                        end
                    end
                end
                Citizen.Wait(sleep)
            end
        end
    elseif Config.InteractionHandler == "ox_target" then
        for k,v in pairs(Config.Garages) do
            while true do
                local sleep = 1000
                if response then
                    local ped = PlayerPedId()
                    local pos = GetEntityCoords(ped)
                    for k,v in pairs(Config.Garages) do
                        if v.npc["show"] then
                            local dist = #(pos - vector3(v["npc"].npc.x, v["npc"].npc.y, v["npc"].npc.z))
                            if dist < 5 and not v.target then
                                exports.ox_target:addSphereZone({
                                    coords = vec3(v["npc"].npc.x, v["npc"].npc.y, v["npc"].npc.z),
                                    radius = 1,
                                    options = {
                                        {
                                            name = 'garage',
                                            icon = 'fas fa-car',
                                            label = 'Open Garage',
                                            onSelect = function(data)
                                                openGarage(k)
                                            end
                                        }
                                    }
                                })
                                v.target = true
                            end
                        end
                    end
                end
                Citizen.Wait(sleep)
            end
        end
    elseif Config.InteractionHandler == "custom" then
        for k,v in pairs(Config.Garages) do
            while true do
                local sleep = 1000
                if response then
                    local ped = PlayerPedId()
                    local pos = GetEntityCoords(ped)
                    for k,v in pairs(Config.Garages) do
                        if v.npc["show"] then
                            local dist = #(pos - vector3(v["npc"].npc.x, v["npc"].npc.y, v["npc"].npc.z))
                            if dist < 5 then
                                -- export
                                openGarage(k,nil)
                            end
                        end
                    end
                end
                Citizen.Wait(sleep)
            end
        end
    end
end

Config.StoredTrigger = function()


    if Config.InteractionHandler2 == "drawtext" then
        Citizen.CreateThread(function()
            while true do
                local sleep = 1000
                if response then
                    local ped = PlayerPedId()
                    local pos = GetEntityCoords(ped)
                    local GetPlayerCar = GetVehiclePedIsIn(ped)
                    local plate = GetVehicleNumberPlateText(GetPlayerCar)
                    for k,v in pairs(Config.Garages) do
                        if Config.Framework == 'esx' then
                            acess = Config.Garages[k].access
                        else
                            if Config.Garages[k].gang ~= "none" then
                                acess = Config.Garages[k].gang
                            else
                                acess = Config.Garages[k].access
                            end
                        end
                        local dist = #(pos - vector3(v["car"].garage.x, v["car"].garage.y, v["car"].garage.z))
                        if dist < 4 and IsPedInAnyVehicle(ped,false) and v.garage ~= 'impound' and v.garage ~= 'impoundboat' and v.garage ~= 'impoundplane' then
                            sleep = 5
                            DrawText3Ds(v["car"].garage.x, v["car"].garage.y, v["car"].garage.z, "[~g~E~w~] - Store Vehicle")
                            
                            if IsControlJustPressed(0, 38) then
                                if v.garage == "jobgarage" then
                                    if GetJob(k) == acess then
                                        RemoveVehicleKeys(plate,GetEntityModel(GetPlayerCar),GetPlayerCar)
                                        Citizen.Wait(100)
                                        TaskLeaveVehicle(ped, GetPlayerCar, 0)
                                        Citizen.Wait(1500)
                                        DeleteEntity(GetPlayerCar)
                                    end
                                else
                                    owned = Callback('codem-garage:checkowned' , plate)
                                    class = GetVehicleClass(GetPlayerCar)
                                    if owned then
                                        if verify(v.garage,class) then
                                            TriggerServerEvent('codem-garage:stored', plate,1,k)
                                            RemoveVehicleKeys(plate,GetEntityModel(GetPlayerCar),GetPlayerCar)
                                            if Config.Framework == "esx" then
                                                TriggerServerEvent('codem-garage:saveProps', plate, frameworkObject.Game.GetVehicleProperties(GetPlayerCar))
                                            else
                                                TriggerServerEvent('codem-garage:saveProps', plate, frameworkObject.Functions.GetVehicleProperties(GetPlayerCar))
                                            end
                                            TaskLeaveVehicle(ped, GetPlayerCar, 0)
                                            Citizen.Wait(1500)
                                            DeleteEntity(GetPlayerCar)
                                        else
                                            Config.ClientNotification(Config.NotificationText["FAILCLASS"].text, Config.NotificationText["FAILCLASS"].type, Config.NotificationText["FAILCLASS"].timeout)
                                        end
                                    else
                                        Config.ClientNotification(Config.NotificationText["FAILSTORED"].text, Config.NotificationText["FAILSTORED"].type, Config.NotificationText["FAILSTORED"].timeout)
                                    end
                            
                                end

                            end
                        end
                    end
                end
                Citizen.Wait(sleep)
            end
        end)
    elseif Config.InteractionHandler2 == "drawmarker" then
        Citizen.CreateThread(function()
            while true do
                local sleep = 1000
                if response then
                    local ped = PlayerPedId()
                    local pos = GetEntityCoords(ped)
                    local GetPlayerCar = GetVehiclePedIsIn(ped)
                    local plate = GetVehicleNumberPlateText(GetPlayerCar)
                    for k,v in pairs(Config.Garages) do
                        if Config.Framework == 'esx' then
                            acess = Config.Garages[k].access
                        else
                            if Config.Garages[k].gang ~= "none" then
                                acess = Config.Garages[k].gang
                            else
                                acess = Config.Garages[k].access
                            end
                        end
                        local dist = #(pos - vector3(v["car"].garage.x, v["car"].garage.y, v["car"].garage.z))
                        if dist < 8 and IsPedInAnyVehicle(ped,false) and v.garage ~= 'impound' and v.garage ~= 'impoundboat' and v.garage ~= 'impoundplane' then
                            sleep = 5
                            DrawText3Ds(v["car"].garage.x, v["car"].garage.y, v["car"].garage.z, "[~g~E~w~] - Store Vehicle")
                            DrawMarker(1, v["car"].garage.x , v["car"].garage.y, v["car"].garage.z - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 6.0, 0.20,  Config.Red, Config.Green, Config.Blue, Config.Alpha, false, false, false, 1, false, false, false)
                            if IsControlJustPressed(0, 38) then
                                if v.garage == "jobgarage" then
                                    if GetJob(k) == acess then
                                        RemoveVehicleKeys(plate,GetEntityModel(GetPlayerCar),GetPlayerCar)
                                        Citizen.Wait(100)
                                        TaskLeaveVehicle(ped, GetPlayerCar, 0)
                                        Citizen.Wait(1500)
                                        DeleteEntity(GetPlayerCar)
                                    end
                                else
                                    owned = Callback('codem-garage:checkowned' , plate)
                                    class = GetVehicleClass(GetPlayerCar)
                                    if owned then
                                        if verify(v.garage,class) then
                                            TriggerServerEvent('codem-garage:stored', plate,1,k)
                                            RemoveVehicleKeys(plate,GetEntityModel(GetPlayerCar),GetPlayerCar)
                                            if Config.Framework == "esx" then
                                                TriggerServerEvent('codem-garage:saveProps', plate, frameworkObject.Game.GetVehicleProperties(GetPlayerCar))
                                            else
                                                TriggerServerEvent('codem-garage:saveProps', plate, frameworkObject.Functions.GetVehicleProperties(GetPlayerCar))
                                            end
                                            TaskLeaveVehicle(ped, GetPlayerCar, 0)
                                            Citizen.Wait(1500)
                                            DeleteEntity(GetPlayerCar)
                                        else
                                            Config.ClientNotification(Config.NotificationText["FAILCLASS"].text, Config.NotificationText["FAILCLASS"].type, Config.NotificationText["FAILCLASS"].timeout)
                                        end
                                    else
                                        Config.ClientNotification(Config.NotificationText["FAILSTORED"].text, Config.NotificationText["FAILSTORED"].type, Config.NotificationText["FAILSTORED"].timeout)
                                    end
                            
                                end

                            end
                        end
                    end
                end
                Citizen.Wait(sleep)
            end
        end)
    end
end

--[[---------------------------------------------------------------------------
███████╗██╗░░░██╗███╗░░██╗░█████╗░████████╗██╗░█████╗░███╗░░██╗
██╔════╝██║░░░██║████╗░██║██╔══██╗╚══██╔══╝██║██╔══██╗████╗░██║
█████╗░░██║░░░██║██╔██╗██║██║░░╚═╝░░░██║░░░██║██║░░██║██╔██╗██║
██╔══╝░░██║░░░██║██║╚████║██║░░██╗░░░██║░░░██║██║░░██║██║╚████║
██║░░░░░╚██████╔╝██║░╚███║╚█████╔╝░░░██║░░░██║╚█████╔╝██║░╚███║
╚═╝░░░░░░╚═════╝░╚═╝░░╚══╝░╚════╝░░░░╚═╝░░░╚═╝░╚════╝░╚═╝░░╚══╝
---------------------------------------------------------------------------]]--

Config.MenuOpen = function() -- This Executed when the menu is opened (useful to hide hud or any other elements on the screen)
    -- TriggerEvent('codem-blackhudv2:SetForceHide', true, true)
    -- TriggerEvent('codem-venicehud:SetForceHide', true)
end

Config.MenuClose = function() -- This Executed when the menu is opened (useful to show hud again or any other elements on the screen)
    -- TriggerEvent('codem-blackhudv2:SetForceHide', false, false)
    -- TriggerEvent('codem-venicehud:SetForceHide', false)
end

function GiveVehicleKeys(plate,model,vehicle) 
    if Config.Vehiclekey then
        if Config.VehicleKeySystem == 'cd_garage' then
            TriggerEvent('cd_garage:AddKeys', exports['cd_garage']:GetPlate(vehicle))
        elseif Config.VehicleKeySystem == 'qs-vehiclekeys' then
            local vehicleName = GetDisplayNameFromVehicleModel(model)
            exports['qs-vehiclekeys']:GiveKeys(plate, vehicleName)
        elseif Config.VehicleKeySystem == 'wasabi-carlock' then
            exports.wasabi_carlock:GiveKey(plate)
        elseif Config.VehicleKeySystem == 'qb-vehiclekeys' then
            TriggerServerEvent('qb-vehiclekeys:server:AcquireVehicleKeys', plate)
        end
    end
end

function RemoveVehicleKeys(plate,model,vehicle) 
    if Config.VehicleRemovekey then
        if Config.VehicleRemoveKeySystem == 'cd_garage' then
            TriggerServerEvent('cd_garage:RemovePersistentVehicles', exports['cd_garage']:GetPlate(vehicle))
        elseif Config.VehicleRemoveKeySystem == 'qs-vehiclekeys' then
            exports['qs-vehiclekeys']:RemoveKeysAuto()
        elseif Config.VehicleRemoveKeySystem == 'wasabi-carlock' then
            exports.wasabi_carlock:RemoveKey(plate)
        elseif Config.VehicleRemoveKeySystem == 'qb-vehiclekeys' then
            TriggerServerEvent('qb-vehiclekeys:client:RemoveKeys', plate)
        end
    end
end

DrawText3Ds = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

Config.SetVehicleFuel = function(vehicle,fuel_level)
    if Config.EnableFuel then
        if Config.FuelSystem == 'LegacyFuel' then
            return exports["LegacyFuel"]:SetFuel(vehicle, fuel_level)
        elseif Config.FuelSystem == 'x-fuel' then
            return exports["x-fuel"]:SetFuel(vehicle, fuel_level)
        elseif Config.FuelSystem == 'ox-fuel' then
            return GetVehicleFuelLevel(vehicle, fuel_level)
        elseif Config.FuelSystem == 'nd-fuel' then
            return exports["nd-fuel"]:SetFuel(vehicle, fuel_level)
        elseif Config.FuelSystem == 'frfuel' then
            return exports.frfuel:setFuel(vehicle, fuel_level)
        elseif Config.FuelSystem == 'cdn-fuel' then
            return exports['cdn-fuel']:SetFuel(vehicle, fuel_level)
        elseif Config.FuelSystem == 'hyon_gas_station' then
            return exports["hyon_gas_station"]:SetFuel(vehicle, fuel_level)
        end
    else
        if fuel_level == nil then fuel_level = 90 end
        return SetVehicleFuelLevel(vehicle, fuel_level + 0.0)
    end
end

Config.GetVehicleEstimatedMaxSpeed = function(vehicle)
    if Config.MileageFormat == "MI" then
        return math.ceil(GetVehicleModelEstimatedMaxSpeed(vehicle) * 2.24) or 200
    end
    return math.ceil(GetVehicleModelEstimatedMaxSpeed(vehicle) * 3.605936) or 200
end

Config.GetVehicleEstimatedAcceleration = function(vehicle)
    return GetVehicleModelAcceleration(vehicle)
end


function GetJob(k)
    frameworkObject = GetFrameworkObject()
    if Config.Framework == "esx" then
        return frameworkObject.PlayerData.job.name
    else
        if Config.Garages[k].gang == "none" or Config.Garages[k].gang == nil then
            return frameworkObject.Functions.GetPlayerData().job.name
        else
            return frameworkObject.Functions.GetPlayerData().gang.name
        end
    end
end

function GetJobGrade(k)
    frameworkObject = GetFrameworkObject()
    if Config.Framework == "esx" then
        return frameworkObject.PlayerData.job.grade
    else
        if Config.Garages[k].gang == "none" then
            return frameworkObject.Functions.GetPlayerData().job.grade.level
        else
            return frameworkObject.Functions.GetPlayerData().gang.grade.level
        end
    end
end

function GetName(source)
    if Config.Framework == "esx" then
        local xPlayer = frameworkObject.GetPlayerFromId(tonumber(source))
        if xPlayer then
            return xPlayer.getName()
        else
            return "Magni#0247"
        end
    else
        local Player = frameworkObject.Functions.GetPlayer(tonumber(source))
        if Player then
            return Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
        else
            return "Magni#0247"
        end
    end
end

Config.Class = { -- If you don't know what the stored part is for, don't touch it
    ["normal"] = {
        [0] = true,
        [1] = true,
        [2] = true,
        [3] = true,
        [4] = true,
        [5] = true,
        [6] = true,
        [7] = true,
        [8] = true,
        [9] = true,
        [10] = true,
        [11] = true,
        [12] = true,
        [13] = true,
        [14] = false,
        [15] = false,
        [16] = false,
        [17] = true,
        [18] = true,
        [19] = true,
        [20] = true,
        [21] = false,
        [22] = true,
    },
    ["aircraft"] = {
        [0] = false,
        [1] = false,
        [2] = false,
        [3] = false,
        [4] = false,
        [5] = false,
        [6] = false,
        [7] = false,
        [8] = false,
        [9] = false,
        [10] = false,
        [11] = false,
        [12] = false,
        [13] = false,
        [14] = false,
        [15] = true,
        [16] = true,
        [17] = false,
        [18] = false,
        [19] = false,
        [20] = false,
        [21] = false,
        [22] = false,
    },
    ["boat"] = {
        [0] = false,
        [1] = false,
        [2] = false,
        [3] = false,
        [4] = false,
        [5] = false,
        [6] = false,
        [7] = false,
        [8] = false,
        [9] = false,
        [10] = false,
        [11] = false,
        [12] = false,
        [13] = false,
        [14] = true,
        [15] = false,
        [16] = false,
        [17] = false,
        [18] = false,
        [19] = false,
        [20] = false,
        [21] = false,
        [22] = false,
    },
}

--[[---------------------------------------------------------------------------
░██████╗░░█████╗░██████╗░░█████╗░░██████╗░███████╗░██████╗
██╔════╝░██╔══██╗██╔══██╗██╔══██╗██╔════╝░██╔════╝██╔════╝
██║░░██╗░███████║██████╔╝███████║██║░░██╗░█████╗░░╚█████╗░
██║░░╚██╗██╔══██║██╔══██╗██╔══██║██║░░╚██╗██╔══╝░░░╚═══██╗
╚██████╔╝██║░░██║██║░░██║██║░░██║╚██████╔╝███████╗██████╔╝
░╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚═╝░╚═════╝░╚══════╝╚═════╝░
---------------------------------------------------------------------------]]--

Config.Garages = {
    ["Garage A"] = {
        ["garage"] = "normal", -- "normal" - "aircraft" - "boat" - "jobgarage" - "impound" 
        ["gang"] = "none", -- "none" or "gang name" 
        ["access"] = "none", -- "none" or "job name"  
        ["blip"] = {
            ["show"]       = true,
            ["blipName"]   = "Garage",
            ["blipType"]   = 357,
            ["blipColour"] =  3
        },
        ["npc"] = {
            ["npcModel"] = "a_m_m_prolhost_01",
            ["npc"]      = vector4(213.15, -809.9, 31.01, 339.02)
        },
        ["car"] = {
            ["showcar"] = vector4(236.39, -779.89, 30.67,161.68),
            ["garage"] = vector3(214.984619, -790.628540, 30.830078),
            ["spawncar"] = vector4(216.67,-787.25,30.70,161.68)
        },
        ["camera"] = { 
            ["x"] = 234.57,
            ["y"] = -785.1,
            ["z"] = 30.59,
            ["rotationX"] = 0.0,
            ["rotationY"] = 0.0, 
            ["rotationZ"] = -20.0
        },
    },
    ["Garage B"] = {
        ["garage"] = "normal", -- "normal" - "aircraft" - "boat" - "jobgarage" - "impound"
        ["gang"] = "none", -- "none" or "gang name" 
        ["access"] = "none", -- "none" or "job name"  
        ["blip"] = {
            ["show"] = true,  -- true or false
            ["blipName"] = "Garage",
            ["blipType"] = 357,
            ["blipColour"] =  3
        },
        ["npc"] = {
            ["npcModel"] = "a_m_m_prolhost_01",
            ["npc"]      =  vector4(275.95, -344.06, 45.17, 165.24)
        },
        ["car"] = {
            ["showcar"] = vector4(274.63, -330.28, 44.70, 164.27),
            ["garage"] = vector3(271.68, -341.61, 44.92),
            ["spawncar"] = vector4(292.79, -332.22, 44.92, 161.25)
        },
        ["camera"] = { 
            ["x"] = 273.08,
            ["y"] = -335.04,
            ["z"] = 44.92,
            ["rotationX"] = 0.0,
            ["rotationY"] = 0.0, 
            ["rotationZ"] = -20.0
        },
    },

    ["Garage D"] = {
        ["garage"] = "normal", -- "normal" - "aircraft" - "boat" - "jobgarage" - "impound"
        ["gang"] = "none", -- "none" or "gang name" 
        ["access"] = "none", -- "none" or "job name"  
        ["blip"] = {
            ["show"] = true,  -- true or false
            ["blipName"] = "Garage",
            ["blipType"] = 357,
            ["blipColour"] =  3
        },
        ["npc"] = {
            ["npcModel"] = "a_m_m_prolhost_01",
            ["npc"]      =  vector4(68.35, 13.85, 69.21, 167.77)
        },
        ["car"] = {
            ["showcar"]  = vector4(59.35, 24.31, 69.73, 245.08),
            ["garage"]   = vector3(73.24, 11.78, 68.85),
            ["spawncar"] = vector4(73.24, 11.78, 68.85, 155.92)
        },

        ["camera"] = { 
            ["x"] = 64.78,
            ["y"] = 22.19,
            ["z"] = 69.54,
            ["rotationX"] = 0.0,
            ["rotationY"] = 0.0, 
            ["rotationZ"] = 70.0
        },
    },

    ["Garage E"] = {
        ["garage"] = "normal", -- "normal" - "aircraft" - "boat" - "jobgarage" - "impound"
        ["gang"] = "none", -- "none" or "gang name" 
        ["access"] = "none", -- "none" or "job name"  
        ["blip"] = {
            ["show"] = true,  -- true or false
            ["blipName"] = "Garage",
            ["blipType"] = 357,
            ["blipColour"] =  3
        },
        ["npc"] = {
            ["npcModel"] = "a_m_m_prolhost_01",
            ["npc"]      =  vector4(362.6, 299.35, 103.88, 165.63)
        },
        ["car"] = {
            ["showcar"]  = vector4(376.33, 288.82, 103.2, 69.26),
            ["garage"]   = vector3(367.98, 296.57, 103.42),
            ["spawncar"] = vector4(367.98, 296.57, 103.42, 345.36)
        },
        ["camera"] = { 
            ["x"] = 371.18,
            ["y"] = 290.66,
            ["z"] = 103.31,
            ["rotationX"] = 0.0,
            ["rotationY"] = 0.0, 
            ["rotationZ"] = -110.0
        },
    },

    ["Garage F"] = {
        ["garage"] = "normal", -- "normal" - "aircraft" - "boat" - "jobgarage" - "impound"
        ["gang"] = "none", -- "none" or "gang name" 
        ["access"] = "none", -- "none" or "job name"  
        ["blip"] = {
            ["show"] = true,  -- true or false
            ["blipName"] = "Garage",
            ["blipType"] = 357,
            ["blipColour"] =  3
        },
        ["npc"] = {
            ["npcModel"] = "a_m_m_prolhost_01",
            ["npc"]      =  vector4(-1158.51, -740.67, 19.89, 41.16)
        },
        ["car"] = {
            ["showcar"]  = vector4(-1145.2, -759.03, 18.82, 39.92),
            ["garage"]   = vector3(-1169.03, -743.49, 19.63),
            ["spawncar"] = vector4(-1169.03, -743.49, 19.63, 42.38)
        },
        ["camera"] = { 
            ["x"] = -1148.57,
            ["y"] = -754.86,
            ["z"] = 18.97,
            ["rotationX"] = 0.0,
            ["rotationY"] = 0.0, 
            ["rotationZ"] = -140.0
        },
    },

    ["Garage G"] = {
        ["garage"] = "normal", -- "normal" - "aircraft" - "boat" - "jobgarage" - "impound"
        ["gang"] = "none", -- "none" or "gang name" 
        ["access"] = "none", -- "none" or "job name"  
        ["blip"] = {
            ["show"] = true,  -- true or false
            ["blipName"] = "Garage",
            ["blipType"] = 357,
            ["blipColour"] =  3
        },
        ["npc"] = {
            ["npcModel"] = "a_m_m_prolhost_01",
            ["npc"]      =  vector4(-795.33, -2023.8, 9.17, 66.37)
        },
        ["car"] = {
            ["showcar"]  = vector4(-763.11, -2042.28, 8.91, 37.29),
            ["garage"]   = vector3(-791.39, -2030.26, 8.87),
            ["spawncar"] = vector4(-790.11, -2022.68, 8.87, 58.85)
        },
        ["camera"] = { 
            ["x"] = -766.54,
            ["y"] = -2037.82,
            ["z"] = 8.9,
            ["rotationX"] = 0.0,
            ["rotationY"] = 0.0, 
            ["rotationZ"] = -143.0
        },
    },

    ["Garage H"] = {
        ["garage"] = "normal", -- "normal" - "aircraft" - "boat" - "jobgarage" - "impound"
        ["gang"] = "none", -- "none" or "gang name" 
        ["access"] = "none", -- "none" or "job name"  
        ["blip"] = {
            ["show"] = true,  -- true or false
            ["blipName"] = "Garage",
            ["blipType"] = 357,
            ["blipColour"] =  3
        },
        ["npc"] = {
            ["npcModel"] = "a_m_m_prolhost_01",
            ["npc"]      =  vector4(-468.87, -819.67, 30.52, 358.04)
        },
        ["car"] = {
            ["showcar"]  = vector4(-472.02, -800.43, 30.54, 183.47),
            ["garage"]   = vector3(-453.49, -814.23, 30.58),
            ["spawncar"] = vector4(-472.16, -812.83, 30.53, 179.63)
        },
        ["camera"] = { 
            ["x"] = -472.16,
            ["y"] = -806.15,
            ["z"] = 30.54,
            ["rotationX"] = 0.0,
            ["rotationY"] = 0.0, 
            ["rotationZ"] = -3.0
        },
    },

    ["Garage I"] = {
        ["garage"] = "normal", -- "normal" - "aircraft" - "boat" - "jobgarage" - "impound"
        ["gang"] = "none", -- "none" or "gang name" 
        ["access"] = "none", -- "none" or "job name"  
        ["blip"] = {
            ["show"] = true,  -- true or false
            ["blipName"] = "Garage",
            ["blipType"] = 357,
            ["blipColour"] =  3
        },
        ["npc"] = {
            ["npcModel"] = "a_m_m_prolhost_01",
            ["npc"]      =  vector4(1142.38, 2661.28, 38.16, 92.19)
        },
        ["car"] = {
            ["showcar"]  = vector4(1121.15, 2665.03, 38.02, 266.97),
            ["garage"]   = vector3(1137.59, 2653.02, 38.0),
            ["spawncar"] = vector4(1137.57, 2674.86, 38.25, 1.08)
        },
        ["camera"] = { 
            ["x"] = 1127.68,
            ["y"] = 2664.84,
            ["z"] = 38.02,
            ["rotationX"] = 0.0,
            ["rotationY"] = 0.0, 
            ["rotationZ"] = 88.0
        },
    },

    ["Garage J"] = {
        ["garage"] = "normal", -- "normal" - "aircraft" - "boat" - "jobgarage" - "impound"
        ["gang"] = "none", -- "none" or "gang name" 
        ["access"] = "none", -- "none" or "job name"  
        ["blip"] = {
            ["show"] = true,  -- true or false
            ["blipName"] = "Garage",
            ["blipType"] = 357,
            ["blipColour"] =  3
        },
        ["npc"] = {
            ["npcModel"] = "a_m_m_prolhost_01",
            ["npc"]      =  vector4(83.51, 6420.3, 31.76, 313.17)
        },
        ["car"] = {
            ["showcar"]  = vector4(112.65, 6396.47, 31.31, 42.5),
            ["garage"]   = vector3(79.68, 6417.33, 31.28),
            ["spawncar"] = vector4(85.93, 6426.8, 31.34, 38.93)
        },
        ["camera"] = { 
            ["x"] = 107.37,
            ["y"] = 6402.14,
            ["z"] = 31.33,
            ["rotationX"] = 0.0,
            ["rotationY"] = 0.0, 
            ["rotationZ"] = -138.0
        },
    },

    ["Garage T"] = {
        ["garage"] = "normal", -- "normal" - "aircraft" - "boat" - "jobgarage" - "impound"
        ["gang"] = "none", -- "none" or "gang name" 
        ["access"] = "none", -- "none" or "job name"  
        ["blip"] = {
            ["show"] = true,  -- true or false 
            ["blipName"] = "Garage", -- blipname
            ["blipType"] = 357, -- https://docs.fivem.net/docs/game-references/blips/
            ["blipColour"] =  3 -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
        },
        ["npc"] = {
            ["npcModel"] = "a_m_m_prolhost_01", -- https://docs.fivem.net/docs/game-references/ped-models/
            ["npc"]      =  vector4(302.3, -189.94, 61.57, 73.01) -- npc coord
        },
        ["car"] = {
            ["showcar"] = vector4(274.64, -189.47, 61.57,252.0), -- the area showing your vehicles at the camera angle
            ["garage"] = vector3(301.1, -183.12, 61.59), -- a place to put the car in the garage
            ["spawncar"] = vector4(288.09, -194.55, 61.57, 249.13) -- spawned location of the vehicle
        },
        
        ["camera"] = { 
            ["x"] = 279.92, 
            ["y"] = -191.36,
            ["z"] = 61.57,
            ["rotationX"] = 0.0,
            ["rotationY"] = 0.0, 
            ["rotationZ"] = 61.57
        },
    },

    ["House Garage"] = { -- [please don't change anything here if you are going to change it just change camera settings npc location and showcar]
        ["garage"] = "normal",
        ["gang"] = "none", -- "none" or "gang name" 
        ["access"] = "none", -- "none" or "job name"  
        ["blip"] = {
            ["show"] = false,  -- true or false 
            ["blipName"] = "House Grage", -- blipname
            ["blipType"] = 357, -- https://docs.fivem.net/docs/game-references/blips/
            ["blipColour"] =  3 -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
        },
        ["npc"] = {
            ["npcModel"] = "a_m_m_prolhost_01", -- https://docs.fivem.net/docs/game-references/ped-models/
            ["show"]     = false,
            ["npc"]      =  vector4(-1169.920, -3235.9912, 13.92, 110.55) -- npc coord
        },
        ["car"] = {
            ["showcar"] = vector4(-1191.454, -3227.03, 13.92, 243.77), -- the area showing your vehicles at the camera angle
            ["garage"] = vector3(301.1, -183.12, -80.59), -- 
            ["spawncar"] = vector4(288.09, -194.55, 61.57, 249.13) -- spawned location of the vehicle
        },
        ["camera"] = { 
            ["x"] = -1183.331, 
            ["y"] = -3231.731,
            ["z"] = 13.929,
            ["rotationX"] = 0.0,
            ["rotationY"] = 0.0, 
            ["rotationZ"] = 60.0
        },
    },

    ["Impound Garage"] = {
        ["garage"] = "impound", -- "normal" - "aircraft" - "boat" - "jobgarage"  - "impound"
        ["gang"] = "none", -- "none" or "gang name" 
        ["access"] = "none", -- "none" or "job name"  
        ["blip"] = {
            ["show"] = true,  -- true or false 
            ["blipName"] = "Impound Garage", -- blipname
            ["blipType"] = 357, -- https://docs.fivem.net/docs/game-references/blips/
            ["blipColour"] =  3 -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
        },
        ["npc"] = {
            ["npcModel"] = "a_m_m_prolhost_01", -- https://docs.fivem.net/docs/game-references/ped-models/
            ["npc"]      =  vector4(406.88, -1625.23, 29.29, 229.89) -- npc coord
        },
        ["car"] = {
            ["showcar"] = vector4(401.4, -1639.93, 29.29, 230.79), -- the area showing your vehicles at the camera angle
            ["garage"] = vector3(301.1, -183.12, 61.59), -- a place to put the car in the garage
            ["spawncar"] = vector4(408.0, -1645.66, 29.29, 228.92) -- spawned location of the vehicle
        },
        
        ["camera"] = { 
            ["x"] = 406.0, 
            ["y"] = -1643.48,
            ["z"] = 29.29,
            ["rotationX"] = 0.0,
            ["rotationY"] = 0.0, 
            ["rotationZ"] = 50.29
        },
    },

    ["Impound Plane"] = {
        ["garage"] = "impoundplane", -- "normal" - "aircraft" - "boat" - "jobgarage"  - "impound"
        ["gang"] = "none", -- "none" or "gang name" 
        ["access"] = "none", -- "none" or "job name"  
        ["blip"] = {
            ["show"] = true,  -- true or false 
            ["blipName"] = "Impound Plane", -- blipname
            ["blipType"] = 357, -- https://docs.fivem.net/docs/game-references/blips/
            ["blipColour"] =  3 -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
        },
        ["npc"] = {
            ["npcModel"] = "a_m_m_prolhost_01", -- https://docs.fivem.net/docs/game-references/ped-models/
            ["npc"]      =  vector4(-1030.2700, -3016.2981, 13.9451, 339.0091) -- npc coord
        },
        ["car"] = {
            ["showcar"] = vector4(-984.8884, -3012.5442, 13.9451, 61.4311), -- the area showing your vehicles at the camera angle
            ["garage"] = vector3(301.1, -183.12, 61.59), -- a place to put the car in the garage
            ["spawncar"] = vector4(-979.8100, -2995.3179, 13.9451, 69.5126) -- spawned location of the vehicle
        },
           
        ["camera"] = { 
            ["x"] = -994.1927,
            ["y"] = -3008.1982,
            ["z"] = 13.9451,
            ["rotationX"] = 0.0,
            ["rotationY"] = 0.0, 
            ["rotationZ"] = 236.9789
        },
    },

    ["Impound Boat"] = {
        ["garage"] = "impoundboat", -- "normal" - "aircraft" - "boat" - "jobgarage"  - "impound" - "impoundboat" - "impoundplane"
        ["gang"] = "none", -- "none" or "gang name" 
        ["access"] = "none", -- "none" or "job name"  
        ["blip"] = {
            ["show"] = true,  -- true or false 
            ["blipName"] = "Impound Boat", -- blipname
            ["blipType"] = 357, -- https://docs.fivem.net/docs/game-references/blips/
            ["blipColour"] =  3 -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
        },
        ["npc"] = {
            ["npcModel"] = "a_m_m_prolhost_01", -- https://docs.fivem.net/docs/game-references/ped-models/
            ["npc"]      =  vector4(-769.6438, -1425.6458, 1.5963, 230.0002) -- npc coord
        },
        ["car"] = {
            ["showcar"] = vector4(-786.5604, -1424.5520, -0.5149, 133.5016), -- the area showing your vehicles at the camera angle
            ["garage"] = vector3(301.1, -183.12, 61.59), -- a place to put the car in the garage
            ["spawncar"] = vector4(-786.5604, -1424.5520, -0.5149, 133.5016) -- spawned location of the vehicle
        },
        ["camera"] = { 
            ["x"] = -795.9548, 
            ["y"] = -1436.9437,
            ["z"] = 3.0567,
            ["rotationX"] = 0.0,
            ["rotationY"] = 0.0, 
            ["rotationZ"] = 322.4765
        },
    },

    ["Garage K"] = {
        ["garage"] = "boat", -- "normal" - "aircraft" - "boat" - "jobgarage" - "impound"
        ["gang"] = "none", -- "none" or "gang name" 
        ["access"] = "none", -- "none" or "job name"  
        ["blip"] = {
            ["show"] = true,  -- true or false
            ["blipName"] = "Boat Garage",
            ["blipType"] = 356,
            ["blipColour"] =  3
        },
        ["npc"] = {
            ["npcModel"] = "a_m_m_prolhost_01",
            ["npc"]      =  vector4(-717.9, -1327.46, 1.6, 50.86)
        },
        ["car"] = {
            ["showcar"] = vector4(-723.7, -1329.22, -0.11, 229.03),
            ["garage"] = vector3(-718.03, -1334.21, 1.0),
            ["spawncar"] = vector4(-718.05, -1334.24, -0.44, 222.71)
        },
        ["camera"] = { 
            ["x"] = -719.57,
            ["y"] = -1332.72,
            ["z"] = 1.41,
            ["rotationX"] = 0.0,
            ["rotationY"] = 0.0, 
            ["rotationZ"] = 50.0
        },
    },
    
    ["Garage L"] = {
        ["garage"] = "aircraft", -- "normal" - "aircraft" - "boat" - "jobgarage" - "impound"
        ["gang"] = "none", -- "none" or "gang name" 
        ["access"] = "none", -- "none" or "job name"  
        ["blip"] = {
            ["show"] = true,  -- true or false
            ["blipName"] = "Aircraft Garage",
            ["blipType"] = 359,
            ["blipColour"] =  3
        },
        ["npc"] = {
            ["npcModel"] = "a_m_m_prolhost_01",
            ["npc"]      =  vector4(-1251.69, -3399.94, 13.94, 59.19)
        },
        ["car"] = {
            ["showcar"] = vector4(-1273.01, -3402.28, 13.94, 331.01),
            ["garage"] = vector3(-1246.91, -3355.14, 13.95),
            ["spawncar"] = vector4(-1246.91, -3355.14, 13.95, 330.68)
        },
        ["camera"] = { 
            ["x"] = -1268.42,
            ["y"] = -3394.32,
            ["z"] = 13.94,
            ["rotationX"] = 0.0,
            ["rotationY"] = 0.0, 
            ["rotationZ"] = -210.0
        },
    },

    ["police"] = { 
        ["garage"] = "jobgarage", -- "normal" - "aircraft" - "boat" - "jobgarage" - "impound"
        ["gang"] = "none", -- "none" or "gang name" 
        ["access"] = "police",
        ["blip"] = {
            ["show"] = true,  -- true or false
            ["blipName"] = "Police Garage",
            ["blipType"] = 357,
            ["blipColour"] =  3
        },
        ["npc"] = {
            ["npcModel"] = "ig_solomon",
            ["npc"]      = vector4(450.97, -1028.03, 28.57, 1.57)
        },
        ["car"] = {
            ["showcar"] = vector4(442.60, -1018.14, 28.67, 90.87),
            ["garage"] = vector3(447.5771, -1021.1351, 28.4547),
            ["spawncar"] = vector4(436.25, -1021.39, 28.71,94.97)
        },
        ["cars"] = {
            [1] = {
                grade = 0,
                model = "police",
            },
            [2] = {
                grade = 0,
                model = "police3",
            },
            [3] = {
                grade = 0,
                model = "police4",
            },
            [4] = {
                grade = 0,
                model = "police2",
            },
        },
        ["camera"] = { 
            ["x"] = 436.81,
            ["y"] = -1018.28,
            ["z"] = 28.77,
            ["rotationX"] = 0.0,
            ["rotationY"] = 0.0, 
            ["rotationZ"] = -90.0
        },
    },
    
    ["ambulance"] = { 
        ["garage"] = "jobgarage", -- "normal" - "aircraft" - "boat" - "jobgarage" - "impound"
        ["gang"] = "none", -- "none" or "gang name" 
        ["access"] = "ambulance",
        ["blip"] = {
            ["show"] = true,  -- true or false
            ["blipName"] = "Ambulance Garage",
            ["blipType"] = 357,
            ["blipColour"] =  3
        },
        ["npc"] = {
            ["npcModel"] = "ig_solomon",
            ["npc"]      = vector4(294.77, -599.60, 43.29,158.74)
        },
        ["car"] = {
            ["showcar"] = vector4(289.08, -610.98, 43.36, 70.19),
            ["garage"] = vector3(275.72, -604.91, 42.97),
            ["spawncar"] = vector4(282.78, -606.48, 43.13, 79.31)
        },
        ["cars"] = {
            [1] = {
                grade = 0,
                model = 'ambulance'
            }
        },
        ["camera"] = { 
            ["x"] = 282.93,
            ["y"] = -608.79,
            ["z"] = 43.26,
            ["rotationX"] = 0.0,
            ["rotationY"] = 0.0, 
            ["rotationZ"] = -110.0
        },
    },
    
}