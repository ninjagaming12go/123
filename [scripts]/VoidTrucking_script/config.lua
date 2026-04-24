TruckingConfig = {}

TruckingConfig.JobNPC = {
    coords = vector4(861.7810, -3182.0735, 6, 355.9990)
}

TruckingConfig.DealershipPed = {
    model = `s_m_m_trucker_01`,
    coords = vector4(889.6353, -3175.7881, 4.9, 102.8859)
}

TruckingConfig.TrailerModels = {
    "trailers",
    "trailers2",
    "trailers3",
    "trailers4",
    "tanker",
    "tanker2",
    "docktrailer"
}

TruckingConfig.TrailerPickupLocations = {
    vector3(936.3455, -3207.3235, 5.9007),
}

TruckingConfig.TrailerDropoffLocations = {
    { pos = vector3(-803.7121, -1284.0316, 5.0003), pay = 5000 },
}
TruckingConfig.XPPerJob = 2580
TruckingConfig.XPRequiredBase = 28000
TruckingConfig.XPRequiredGrowth = 1.25
TruckingConfig.TrailerBonusPerExtra = 0.0
TruckingConfig.BasePay = 5000
TruckingConfig.BasePayPerLevel = 30
TruckingConfig.LegalJobBonus = 150
TruckingConfig.DamageMultiplier = 2.0
TruckingConfig.MaxDamagePenalty = 1000

TruckingConfig.DealershipTrucks = {
    {
        model = "packer",
        label = "Packer",
        level = 1,
        price = 25000,
        rent = 1500,
        render = "packer.png"
    },
    {
        model = "hauler",
        label = "Hauler",
        level = 15,
        price = 45000,
        rent = 2500,
        render = "hauler.png"
    },
    {
        model = "phantom",
        label = "Phantom",
        level = 30,
        price = 65000,
        rent = 3500,
        render = "phantom.png"
    },
    {
        model = "phantom_custom",
        label = "Phantom Custom",
        level = 50,
        price = 95000,
        rent = 5000,
        render = "phantom_custom.png"
    }
}

TruckingConfig.DealershipSpawn = {
    coords = vector4(923.62, -3160.12, 5.90, 90.0)
}

TruckingConfig.TruckingOwnedMeta = "trucking_trucks"
TruckingConfig.TruckingLevelMeta = "truckinglevel"

TruckingConfig.GarageName = "truckinggarage"
