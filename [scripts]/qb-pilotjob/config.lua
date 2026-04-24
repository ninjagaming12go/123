Config = {}

Config.JobPed = {
    model = "s_m_m_pilot_02",
    coords = vector4(-972.4728, -2935.0205, 13.9451, 75.1789)
}

Config.LegalFlights = {
    { from = "LSIA", to = "Sandy Shores", payout = 4500, difficulty = "Easy" },
    { from = "LSIA", to = "Grapeseed", payout = 6000, difficulty = "Medium" },
    { from = "LSIA", to = "Aircraft Carrier", payout = 9000, difficulty = "Hard" }
}

Config.IllegalFlights = {
    { from = "Grapeseed Barn", to = "Alamo Drop", payout = 12000, difficulty = "Medium" },
    { from = "Raton Canyon Ridge", to = "Grapeseed Barn", payout = 15000, difficulty = "Hard" },
    { from = "Alamo Drop", to = "Raton Canyon Ridge", payout = 18000, difficulty = "Extreme" }
}
Config.LandingZones = {
    ["LSIA"] = {
        coords = vector3(-1037.0, -2737.0, 13.8),
        waypoint = vector3(-1037.0, -2737.0, 13.8)
    },
    ["Sandy Shores"] = {
        coords = vector3(1740.0, 3295.0, 41.1),
        waypoint = vector3(1740.0, 3295.0, 41.1)
    },
    ["Grapeseed"] = {
        coords = vector3(2123.0, 4785.0, 41.0),
        waypoint = vector3(2123.0, 4785.0, 41.0)
    },

    -- Illegal strips
    ["Grapeseed Barn"] = {
        coords = vector3(2445.0, 4968.0, 46.8),
        waypoint = vector3(2445.0, 4968.0, 46.8)
    },
    ["Alamo Drop"] = {
        coords = vector3(1350.0, 4320.0, 38.0),
        waypoint = vector3(1350.0, 4320.0, 38.0)
    },
    ["Raton Canyon Ridge"] = {
        coords = vector3(-1500.0, 4400.0, 40.0),
        waypoint = vector3(-1500.0, 4400.0, 40.0)
    },

    -- Aircraft carrier (special case)
    ["Aircraft Carrier"] = {
        coords = vector3(3088.5735, -4791.6602, 15.2613),
        waypoint = vector3(3088.5735, -4791.6602, 15.2613) -- nearest map tile
    }
}
Config.DealerPed = {
    model = "s_m_m_pilot_01",
    coords = vector4(-964.8337, -2965.2017, 13.9451, 272.5568)
}
Config.DealerSpawn = {
    coords = vector4(-960.0, -2975.0, 13.0, 90.0) -- adjust as needed
}

Config.Planes = {
    { model = "velum", label = "Velum", price = 200000, rent = 7000, level = 1, img = "images/velum.png" },
    { model = "mammatus", label = "Mammatus", price = 350000, rent = 12000, level = 25, img = "images/mammatus.png" }, 
    { model = "luxor", label = "Luxor", price = 900000, rent = 25000, level = 45,  img = "images/luxor.png" }
}
