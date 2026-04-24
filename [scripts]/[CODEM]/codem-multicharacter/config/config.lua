Config                   = {}
Config.Framework         = "qb"      -- esx, oldesx, qb, oldqb
Config.SQL               = "oxmysql" -- oxmysql, ghmattimysql, mysql-async
Config.EnableCamShake    = true
Config.HiddenCoords      = vector4(-812.23, 182.54, 76.74, 156.5)
Config.Thema             = "red" -- orange , white , purple, blue, green , red
Config.ServerLogo        = "https://r2.fivemanage.com/8Hb4twhFSbaNdR27bPGV4/m_logo.png"
Config.DeleteCharacter   = true
Config.Clothes           = "default" -- default, illenium-appearance, fivem-appearance default = codem-appearance
Config.Inventory         = "qb_inventory" -- qb_inventory, esx_inventory, ox_inventory,  codem-inventory, qs_inventory 
Config.UseQBApartments   = false -- for qb : If you want your player to spawn at qb apartments after character creation set this value to true, if not set it to false.
Config.SpawnSelector     = true --for esx or qb : After clicking the "Continue" button from the Players UI, set this value to true if you want to use ESX's or QBCore's Spawn Selector, or false if you don't.
Config.UseMSpawnSelector = false -- esx or qb : If you are using mSpawn Selector and want you to bring this resource after the mMulticharacter Remake resource set this value to true, if not set it to false.
Config.DefaultSpawn      = vector3(-1035.71, -2731.87, 12.86)
Config.DefaultBucket     = 0
Config.LoutOutPermission = "admin" -- user, admin
Config.MoneyType         = "£"
Config.Prefix            = 'char' -- dont changed for esx
Config.VersionChecker    = true

Config.Slots             = {
    { tebex = false, id = 1 },
}

Config.PlayerAnimation = {
    ['police'] = {
        animationfunctionname = 'PoliceJobAnimation',
        camblur = true,
        near = 0.8,
        fear = 1.8
    },
    ['unemployed'] = {
        animationfunctionname = 'CitizenJobAnimation',
        camblur = true,
        near = 0.8,
        fear = 1.8
    },
    ['ambulance'] = {
        animationfunctionname = 'AmbulanceJobAnimation',
        camblur = true,
        near = -1.0,
        fear = 1.8
    },
    ['mechanic'] = {
        animationfunctionname = 'MechanicJobAnimation',
        camblur = true,
        near = -1.0,
        fear = 3.0
    },
}

Config.AddActiveSlots = { -- min number #config.slots
    -- { license = "license:0e4d5cb133e83f255fac675908f1ecd7cb743", active_slots = 0 },
}

Config.DeleteTable = { users = 'identifier', owned_vehicles = 'owner', billing = 'identifier' } -- for esx
