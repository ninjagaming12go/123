Config = {}
Config.UseTarget = GetConvar('UseTarget', 'false') == 'true'

-- Deliveries
Config.ShopsInvJsonFile = './json/shops-inventory.json'
Config.TruckDeposit = 125
Config.MaxDeliveries = 20
Config.DeliveryPrice = 500
Config.RewardItem = 'cryptostick'
Config.Fuel = 'LegacyFuel'

Config.DeliveryLocations = {
    ['main'] = { label = 'GO Postal', coords = vector4(69.0862, 127.6753, 79.2123, 156.7736) },
    ['vehicleWithdraw'] = vector4(71.9318, 120.8389, 79.0823, 160.5110),
    ['vehicleDeposit'] = vector3(62.7282, 124.9846, 79.0926),
    ['stores'] = {} -- auto generated
}

Config.Vehicles = {
    ['boxville2'] = { ['label'] = 'Boxville StepVan', ['cargodoors'] = { [0] = 2, [1] = 3 }, ['trunkpos'] = 1.5 },
}

Config.Products = {
    ['liquor'] = {
        { name = 'beer',    price = 7,  amount = 50 },
        { name = 'whiskey', price = 10, amount = 50 },
        { name = 'vodka',   price = 12, amount = 50 },
    },
    ['hardware'] = {
        { name = 'lockpick',          price = 200, amount = 50 },
        { name = 'weapon_wrench',     price = 250, amount = 250 },
        { name = 'weapon_hammer',     price = 250, amount = 250 },
        { name = 'repairkit',         price = 250, amount = 50, requiredJob = { 'mechanic', 'police' } },
        { name = 'screwdriverset',    price = 350, amount = 50 },
        { name = 'phone',             price = 850, amount = 50 },
        { name = 'radio',             price = 250, amount = 50 },
        { name = 'binoculars',        price = 50,  amount = 50 },
        { name = 'firework1',         price = 50,  amount = 50 },
        { name = 'firework2',         price = 50,  amount = 50 },
        { name = 'firework3',         price = 50,  amount = 50 },
        { name = 'firework4',         price = 50,  amount = 50 },
        { name = 'fitbit',            price = 400, amount = 150 },
        { name = 'cleaningkit',       price = 150, amount = 150 },
        { name = 'advancedrepairkit', price = 500, amount = 50, requiredJob = 'mechanic' },
    },
    ['weedshop'] = {
        { name = 'joint',          price = 10,  amount = 50 },
        { name = 'weapon_poolcue', price = 100, amount = 50 },
        { name = 'weed_nutrition', price = 20,  amount = 50 },
        { name = 'empty_weed_bag', price = 2,   amount = 1000 },
        { name = 'rolling_paper',  price = 2,   amount = 1000 },
    },
    ['gearshop'] = {
        { name = 'diving_gear', price = 2500, amount = 10 },
        { name = 'jerry_can',   price = 200,  amount = 50 },
    },
    ['leisureshop'] = {
        { name = 'parachute',   price = 2500, amount = 10 },
        { name = 'binoculars',  price = 50,   amount = 50 },
        { name = 'diving_gear', price = 2500, amount = 10 },
        { name = 'diving_fill', price = 500,  amount = 10 },
    },
    ['weapons'] = {
        { name = 'weapon_knife',         price = 250,  amount = 250 },
        { name = 'weapon_bat',           price = 250,  amount = 250 },
        { name = 'weapon_hatchet',       price = 250,  amount = 250 },
        { name = 'pistol_ammo',          price = 250,  amount = 250, requiredLicense = 'weapon' },
        { name = 'weapon_pistol',        price = 2500, amount = 5,   requiredLicense = 'weapon' },
        { name = 'weapon_snspistol',     price = 1500, amount = 5,   requiredLicense = 'weapon' },
        { name = 'weapon_vintagepistol', price = 4000, amount = 5,   requiredLicense = 'weapon' },
    },
    ['blackmarket'] = {
        { name = 'security_card_01',  price = 5000, amount = 50 },
        { name = 'security_card_02',  price = 5000, amount = 50 },
        { name = 'advanced_lockpick', price = 5000, amount = 50 },
        { name = 'electronickit',     price = 5000, amount = 50 },
        { name = 'gatecrack',         price = 5000, amount = 50 },
        { name = 'thermite',          price = 5000, amount = 50 },
        { name = 'trojan_usb',        price = 5000, amount = 50 },
        { name = 'drill',             price = 5000, amount = 50 },
        { name = 'radioscanner',      price = 5000, amount = 50 },
        { name = 'cryptostick',       price = 5000, amount = 50 },
        { name = 'joint',             price = 5000, amount = 50 },
        { name = 'cokebaggy',         price = 5000, amount = 50 },
        { name = 'crack_baggy',       price = 5000, amount = 50 },
        { name = 'xtcbaggy',          price = 5000, amount = 50 },
        { name = 'coke_brick',        price = 5000, amount = 50 },
        { name = 'weed_brick',        price = 5000, amount = 50 },
        { name = 'coke_small_brick',  price = 5000, amount = 50 },
        { name = 'oxy',               price = 5000, amount = 50 },
        { name = 'meth',              price = 5000, amount = 50 },
        { name = 'weed_whitewidow',   price = 5000, amount = 50 },
        { name = 'weed_skunk',        price = 5000, amount = 50 },
        { name = 'weed_purplehaze',   price = 5000, amount = 50 },
        { name = 'weed_ogkush',       price = 5000, amount = 50 },
        { name = 'weed_amnesia',      price = 5000, amount = 50 },
        { name = 'weed_ak47',         price = 5000, amount = 50 },
        { name = 'markedbills',       price = 5000, amount = 50, info = { worth = 5000 } },
    },
    ['prison'] = {
        { name = 'sandwich',     price = 4, amount = 50 },
        { name = 'water_bottle', price = 4, amount = 50 },
    },
    ['police'] = {
        { name = 'weapon_pistol',       price = 0, amount = 50, info = { attachments = { { component = 'COMPONENT_AT_PI_FLSH', label = 'Flashlight' } } } },
        { name = 'weapon_stungun',      price = 0, amount = 50, info = { attachments = { { component = 'COMPONENT_AT_AR_FLSH', label = 'Flashlight' } } } },
        { name = 'weapon_pumpshotgun',  price = 0, amount = 50, info = { attachments = { { component = 'COMPONENT_AT_AR_FLSH', label = 'Flashlight' } } } },
        { name = 'weapon_smg',          price = 0, amount = 50, info = { attachments = { { component = 'COMPONENT_AT_SCOPE_MACRO_02', label = '1x Scope' }, { component = 'COMPONENT_AT_AR_FLSH', label = 'Flashlight' } } } },
        { name = 'weapon_carbinerifle', price = 0, amount = 50, info = { attachments = { { component = 'COMPONENT_AT_AR_FLSH', label = 'Flashlight' }, { component = 'COMPONENT_AT_SCOPE_MEDIUM', label = '3x Scope' } } } },
        { name = 'weapon_nightstick',   price = 0, amount = 50 },
        { name = 'weapon_flashlight',   price = 0, amount = 50 },
        { name = 'pistol_ammo',         price = 0, amount = 50 },
        { name = 'smg_ammo',            price = 0, amount = 50 },
        { name = 'shotgun_ammo',        price = 0, amount = 50 },
        { name = 'rifle_ammo',          price = 0, amount = 50 },
        { name = 'handcuffs',           price = 0, amount = 50 },
        { name = 'empty_evidence_bag',  price = 0, amount = 50 },
        { name = 'police_stormram',     price = 0, amount = 50 },
        { name = 'armor',               price = 0, amount = 50 },
        { name = 'radio',               price = 0, amount = 50 },
        { name = 'heavyarmor',          price = 0, amount = 50 },
    },
    ['ambulance'] = {
        { name = 'radio',                   price = 0, amount = 50 },
        { name = 'bandage',                 price = 0, amount = 50 },
        { name = 'painkillers',             price = 0, amount = 50 },
        { name = 'firstaid',                price = 0, amount = 50 },
        { name = 'weapon_flashlight',       price = 0, amount = 50 },
        { name = 'weapon_fireextinguisher', price = 0, amount = 50 },
    },
    ['mechanic'] = {
        { name = 'veh_toolbox',       price = 5000, amount = 50 },
        { name = 'veh_armor',         price = 5000, amount = 50 },
        { name = 'veh_brakes',        price = 5000, amount = 50 },
        { name = 'veh_engine',        price = 5000, amount = 50 },
        { name = 'veh_suspension',    price = 5000, amount = 50 },
        { name = 'veh_transmission',  price = 5000, amount = 50 },
        { name = 'veh_turbo',         price = 5000, amount = 50 },
        { name = 'veh_interior',      price = 5000, amount = 50 },
        { name = 'veh_exterior',      price = 5000, amount = 50 },
        { name = 'veh_wheels',        price = 5000, amount = 50 },
        { name = 'veh_neons',         price = 5000, amount = 50 },
        { name = 'veh_xenons',        price = 5000, amount = 50 },
        { name = 'veh_tint',          price = 5000, amount = 50 },
        { name = 'veh_plates',        price = 5000, amount = 50 },
        { name = 'nitrous',           price = 5000, amount = 50 },
        { name = 'tunerlaptop',       price = 5000, amount = 50 },
        { name = 'repairkit',         price = 5000, amount = 50 },
        { name = 'advancedrepairkit', price = 5000, amount = 50 },
        { name = 'tirerepairkit',     price = 5000, amount = 50 },
    }
}

Config.Locations = {
    -- LTD Gasoline Locations
    ['ltdgasoline'] = {
        ['label'] = 'LTD Gasoline',
        ['coords'] = vector4(-47.02, -1758.23, 29.42, 45.05),
        ['ped'] = 'mp_m_shopkeep_01',
        ['scenario'] = 'WORLD_HUMAN_STAND_MOBILE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Open Shop',
        ['products'] = Config.Products['normal'],
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-40.51, -1747.45, 29.29, 326.39)
    },

    ['ltdgasoline2'] = {
        ['label'] = 'LTD Gasoline',
        ['coords'] = vector4(-706.06, -913.97, 19.22, 88.04),
        ['ped'] = 'mp_m_shopkeep_01',
        ['scenario'] = 'WORLD_HUMAN_STAND_MOBILE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Open Shop',
        ['products'] = Config.Products['normal'],
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-702.89, -917.44, 19.21, 181.96)
    },

    ['ltdgasoline3'] = {
        ['label'] = 'LTD Gasoline',
        ['coords'] = vector4(-1820.02, 794.03, 138.09, 135.45),
        ['ped'] = 'mp_m_shopkeep_01',
        ['scenario'] = 'WORLD_HUMAN_STAND_MOBILE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Open Shop',
        ['products'] = Config.Products['normal'],
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-1829.29, 801.49, 138.41, 41.39)
    },

    ['ltdgasoline4'] = {
        ['label'] = 'LTD Gasoline',
        ['coords'] = vector4(1164.71, -322.94, 69.21, 101.72),
        ['ped'] = 'mp_m_shopkeep_01',
        ['scenario'] = 'WORLD_HUMAN_STAND_MOBILE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Open Open Shop',
        ['products'] = Config.Products['normal'],
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(1160.62, -312.06, 69.28, 3.77)
    },

    ['ltdgasoline5'] = {
        ['label'] = 'LTD Gasoline',
        ['coords'] = vector4(1697.87, 4922.96, 42.06, 324.71),
        ['ped'] = 'mp_m_shopkeep_01',
        ['scenario'] = 'WORLD_HUMAN_STAND_MOBILE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Open Shop',
        ['products'] = Config.Products['normal'],
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(1702.68, 4917.28, 42.22, 139.27)
    },

    -- Rob's Liquor Locations
    ['robsliquor'] = {
        ['label'] = 'Rob\'s Liqour',
        ['coords'] = vector4(-1221.58, -908.15, 12.33, 35.49),
        ['ped'] = 'mp_m_shopkeep_01',
        ['scenario'] = 'WORLD_HUMAN_STAND_MOBILE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Open Shop',
        ['products'] = Config.Products['liquor'],
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-1226.92, -901.82, 12.28, 213.26)
    },

    ['robsliquor2'] = {
        ['label'] = 'Rob\'s Liqour',
        ['coords'] = vector4(-1486.59, -377.68, 40.16, 139.51),
        ['ped'] = 'mp_m_shopkeep_01',
        ['scenario'] = 'WORLD_HUMAN_STAND_MOBILE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Open Shop',
        ['products'] = Config.Products['liquor'],
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-1468.29, -387.61, 38.79, 220.13)
    },

    ['robsliquor3'] = {
        ['label'] = 'Rob\'s Liqour',
        ['coords'] = vector4(-2966.39, 391.42, 15.04, 87.48),
        ['ped'] = 'mp_m_shopkeep_01',
        ['scenario'] = 'WORLD_HUMAN_STAND_MOBILE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Open Shop',
        ['products'] = Config.Products['liquor'],
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-2961.49, 376.25, 15.02, 111.41)
    },

    ['robsliquor4'] = {
        ['label'] = 'Rob\'s Liqour',
        ['coords'] = vector4(1165.17, 2710.88, 38.16, 179.43),
        ['ped'] = 'mp_m_shopkeep_01',
        ['scenario'] = 'WORLD_HUMAN_STAND_MOBILE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Open Shop',
        ['products'] = Config.Products['liquor'],
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(1194.52, 2722.21, 38.62, 9.37)
    },

    ['robsliquor5'] = {
        ['label'] = 'Rob\'s Liqour',
        ['coords'] = vector4(1134.2, -982.91, 46.42, 277.24),
        ['ped'] = 'mp_m_shopkeep_01',
        ['scenario'] = 'WORLD_HUMAN_STAND_MOBILE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Open Shop',
        ['products'] = Config.Products['liquor'],
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(1129.73, -989.27, 45.97, 280.98)
    },

    -- Hardware Store Locations
    ['hardware'] = {
        ['label'] = 'Hardware Store',
        ['coords'] = vector4(45.68, -1749.04, 29.61, 53.13),
        ['ped'] = 'mp_m_waremech_01',
        ['scenario'] = 'WORLD_HUMAN_CLIPBOARD',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-wrench',
        ['targetLabel'] = 'Open Hardware Store',
        ['products'] = Config.Products['hardware'],
        ['showblip'] = true,
        ['blipsprite'] = 402,
        ['blipscale'] = 0.8,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(89.15, -1745.29, 30.09, 315.25)
    },

    ['hardware2'] = {
        ['label'] = 'Hardware Store',
        ['coords'] = vector4(2747.71, 3472.85, 55.67, 255.08),
        ['ped'] = 'mp_m_waremech_01',
        ['scenario'] = 'WORLD_HUMAN_CLIPBOARD',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-wrench',
        ['targetLabel'] = 'Open Hardware Store',
        ['products'] = Config.Products['hardware'],
        ['showblip'] = true,
        ['blipsprite'] = 402,
        ['blipscale'] = 0.8,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(2704.68, 3457.21, 55.54, 176.28)
    },

    ['hardware3'] = {
        ['label'] = 'Hardware Store',
        ['coords'] = vector4(-421.83, 6136.13, 31.88, 228.2),
        ['ped'] = 'mp_m_waremech_01',
        ['scenario'] = 'WORLD_HUMAN_CLIPBOARD',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-wrench',
        ['targetLabel'] = 'Hardware Store',
        ['products'] = Config.Products['hardware'],
        ['showblip'] = true,
        ['blipsprite'] = 402,
        ['blipscale'] = 0.8,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-438.25, 6146.9, 31.48, 136.99)
    },

    
    -- Weedshop Locations
    ['weedshop'] = {
        ['label'] = 'Smoke On The Water',
        ['coords'] = vector4(-1168.26, -1573.2, 4.66, 105.24),
        ['ped'] = 'a_m_y_hippy_01',
        ['scenario'] = 'WORLD_HUMAN_AA_SMOKE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-cannabis',
        ['targetLabel'] = 'Open Weed Shop',
        ['products'] = Config.Products['weedshop'],
        ['showblip'] = true,
        ['blipsprite'] = 140,
        ['blipscale'] = 0.8,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-1162.13, -1568.57, 4.39, 328.52)
    },

    -- Sea Word Locations
    ['seaword'] = {
        ['label'] = 'Sea Word',
        ['coords'] = vector4(-1687.03, -1072.18, 13.15, 52.93),
        ['ped'] = 'a_m_y_beach_01',
        ['scenario'] = 'WORLD_HUMAN_STAND_IMPATIENT',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-fish',
        ['targetLabel'] = 'Sea Word',
        ['products'] = Config.Products['gearshop'],
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.8,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-1674.18, -1073.7, 13.15, 333.56)
    },

    -- Leisure Shop Locations
    ['leisureshop'] = {
        ['label'] = 'Leisure Shop',
        ['coords'] = vector4(-1505.91, 1511.95, 115.29, 257.13),
        ['ped'] = 'a_m_y_beach_01',
        ['scenario'] = 'WORLD_HUMAN_STAND_MOBILE_CLUBHOUSE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-leaf',
        ['targetLabel'] = 'Open Leisure Shop',
        ['products'] = Config.Products['leisureshop'],
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.8,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-1507.64, 1505.52, 115.29, 262.2)
    },

    ['police'] = {
        ['label'] = 'Police Shop',
        ['coords'] = vector4(461.8498, -981.0677, 30.6896, 91.5892),
        ['ped'] = 'mp_m_securoguard_01',
        ['scenario'] = 'WORLD_HUMAN_COP_IDLES',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-gun',
        ['targetLabel'] = 'Open Armory',
        ['products'] = Config.Products['police'],
        ['delivery'] = vector4(459.0441, -1008.0366, 28.2627, 271.4695),
        ['requiredJob'] = 'police',
    },

    ['ambulance'] = {
        ['label'] = 'Ambulance Shop',
        ['coords'] = vector4(309.93, -602.94, 43.29, 71.0820),
        ['ped'] = 's_m_m_doctor_01',
        ['scenario'] = 'WORLD_HUMAN_STAND_MOBILE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-hand',
        ['targetLabel'] = 'Open Armory',
        ['products'] = Config.Products['ambulance'],
        ['delivery'] = vector4(283.5821, -614.8570, 43.3792, 159.2903),
        ['requiredJob'] = 'ambulance'
    },

    ['mechanic'] = {
        ['label'] = 'Mechanic Shop',
        ['coords'] = vector4(-343.66, -140.78, 39.02, 0),
        ['products'] = Config.Products['mechanic'],
        ['delivery'] = vector4(-354.3936, -128.2882, 39.4307, 251.4931),
        ['requiredJob'] = 'mechanic',
    },

    ['mechanic2'] = {
        ['label'] = 'Mechanic Shop',
        ['coords'] = vector4(1189.36, 2641.00, 38.44, 0),
        ['products'] = Config.Products['mechanic'],
        ['delivery'] = vector4(1189.9852, 2651.1873, 37.8351, 317.7137),
        ['requiredJob'] = 'mechanic2'
    },

    ['mechanic3'] = {
        ['label'] = 'Mechanic Shop',
        ['coords'] = vector4(-1156.56, -1999.85, 13.19, 0),
        ['products'] = Config.Products['mechanic'],
        ['delivery'] = vector4(-1131.9661, -1972.0144, 13.1603, 358.8637),
        ['requiredJob'] = 'mechanic3'
    },

    ['bennys'] = {
        ['label'] = 'Mechanic Shop',
        ['coords'] = vector4(-195.80, -1318.24, 31.08, 0),
        ['products'] = Config.Products['mechanic'],
        ['delivery'] = vector4(-232.5028, -1311.7202, 31.2960, 180.3716),
        ['requiredJob'] = 'bennys'
    },

    ['beeker'] = {
        ['label'] = 'Mechanic Shop',
        ['coords'] = vector4(100.92, 6616.00, 32.47, 0),
        ['products'] = Config.Products['mechanic'],
        ['delivery'] = vector4(119.3033, 6626.7358, 31.9558, 46.1566),
        ['requiredJob'] = 'beeker'
    },

    ['prison'] = {
        ['label'] = 'Canteen Shop',
        ['coords'] = vector4(1777.59, 2560.52, 44.62, 187.83),
        ['ped'] = false,
        ['products'] = Config.Products['prison'],
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.8,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(1845.8175, 2585.9312, 45.6721, 96.7577)
    },

    ['blackmarket'] = {
        ['label'] = 'Black Market',
        ['coords'] = vector4(-594.7032, -1616.3647, 33.0105, 170.6846),
        ['ped'] = 'a_m_y_smartcaspat_01',
        ['scenario'] = 'WORLD_HUMAN_AA_SMOKE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-clipboard',
        ['targetLabel'] = 'Open Shop',
        ['products'] = Config.Products['blackmarket'],
        ['delivery'] = vector4(-428.6385, -1728.1962, 19.7838, 75.6646)
    },
}
