Config = {}

Config.EnableCreator = false -- enable the creator commands? (to add new banks, see README)
Config.Debug = false -- enable debug prints?

Config.Language = "en" -- see shared/locales.lua

Config.InteractSystem = "auto" -- target or native (press E)
Config.UsableItems = true -- allow using items (drill, thermite etc) from the inventory?
Config.ServerSideOnly = false -- should ALL entities be created on the server?

Config.Framework = "auto" --[[
    The framework you use. Modify in in the framework folder.
    - esx
    - qb-core
    - qbox
    - custom
]]

Config.PoliceJobs = { "police", "sheriff", "leo" }
Config.AllowPoliceLockVault = true -- allow police officers to lock the vault?
Config.AllowPoliceRob = false -- allow police officers to rob banks?
Config.RequiredPolice = 0 -- default required police for all banks, can be overriden in Config.Banks

Config.GiveBlackMoney = true

Config.RequireBag = false -- require a bag to rob (place thermite, grab cash etc)
Config.KeepBag = false -- should the player keep the bag from the animation after it finishes? (only works if RequireBag is false)

Config.GrabCamera = true -- show a camera when grabbing from a stack (cash & gold)?

Config.DefaultThermiteTime = 10 -- the time it takes for thermite to unlock the door after the animation (in seconds)
Config.DefaultVaultTime = 0 -- the time it takes for the vault to open after hacking (in seconds)
Config.ShowProgress = true -- show a progressbar when thermite is melting door & when vault is opening?

Config.GlobalCooldown = 60 -- global cooldown in minutes. If a bank has been robbed, no other bank can be robbed for this amount of time
Config.Alarm = true -- play alarm when a bank is being robbed?

Config.MarkerColor = { r = 125, g = 75, b = 195, a = 100 }

Config.RequiredItems = {
    drill = {
        {
            item = "drill",
            amount = 1,
            remove = false,
            usable = true
        },
        {
            item = "drill_bit",
            amount = 1,
            remove = true
        }
    },
    thermite = {
        {
            item = "thermite",
            amount = 1,
            remove = true,
            usable = true
        }
    },
    keycard = {
        {
            item = "laptop",
            amount = 1,
            remove = false,
            usable = true
        },
        {
            item = "usb_device",
            amount = 1,
            remove = false
        }
    },
    loot = {}
}

Config.Rewards = {
    {
        tier = 1,
        cash = {
            {
                min = 1000000,
                max = 2000000
                -- since no item is defined, it will give money
            }
        },
        cash_trolley = {
            {
                min = 2000000,
                max = 4000000
            }
        },
        gold = {
            {
                min = 3000000,
                max = 100000,
                item = "gold"
            }
        },
        drill = {
            {
                min = 1000000,
                max = 5000000,
                item = "gold",
                chance = 100 -- 33% to get 1-5 gold
            },
            {
                min = 250000000,
                max = 750000000
            }
        }
    },
    {
        tier = 2,
        cash = {
            {
                min = 5000,
                max = 10000
            }
        },
        cash_trolley = {
            {
                min = 15000,
                max = 30000
            }
        },
        gold = {
            {
                min = 1,
                max = 5,
                item = "gold"
            }
        },
        drill = {
            {
                min = 1,
                max = 3,
                item = "gold",
                chance = 25
            },
            {
                min = 2000,
                max = 5000
            }
        }
    }
}

Config.ThermiteMinigame = {
    required = false,
    minigame = "memorygame",
    --[[
        You can modify this in client/functions.lua `function ThermiteHack()`

        ps-ui: https://forum.cfx.re/t/project-sloth-free-standalone-ps-ui/4873444
        memorygame: https://github.com/pushkart2/memorygame
        ox_lib: https://github.com/overextended/ox_lib
    ]]
    params = {
        correctBlocks = 10,
        incorrectBlocks = 3,
        timeToShow = 5,
        timeToLose = 25,
        gridSize = 8
    }
}

Config.KeycardHack = "ultra-voltlab"
--[[
    You can modify this in client/functions.lua `function KeycardHack()`

    ps-ui: https://forum.cfx.re/t/project-sloth-free-standalone-ps-ui/4873444
    ultra-voltlab: https://forum.cfx.re/t/release-voltlab-hacking-minigame-cayo-perico-mission/3933171
    ultra-keypadhack: https://forum.cfx.re/t/release-casino-keypad-hacking-minigame-memory-minigame/4800359
    howdy-hackminigame: https://forum.cfx.re/t/free-howdys-hack-minigame/4814601
    datacrack: https://forum.cfx.re/t/standalone-datacrack-hacking-mini-game/1066972
    utk_fingerprint: https://forum.cfx.re/t/finger-print-hacking-mini-game-standalone/1185122
    electus_hacking: https://forum.cfx.re/t/qb-esx-paid-electus-hacking-hacker-job-terminal-hack/4989175
]]

Config.Banks = {
    {
        name = "Pacific Standard",
        tier = 1,
        coords = vector3(232.5, 215.6, 106.3), -- blip location
        resetTime = 180, -- minutes after a bank has been robbed before it can be robbed again
        -- requiredPolice = 5, -- required police for this bank
        doors = {
            {
                model = `hei_v_ilev_bk_gate_pris`,
                moltenModel = `hei_v_ilev_bk_gate_molten`,
                coords = vector4(256.31155395508, 220.65785217285, 106.42955780029, 339.76065063477),
                thermiteHeading = 340.0,
                required = true, -- require before being able to hack?
                -- thermiteTime = 5, -- time it takes to melt the door (in seconds), if unset it will use Config.DefaultThermiteTime
            },
            {
                model = `hei_v_ilev_bk_gate2_pris`,
                moltenModel = `hei_v_ilev_bk_gate2_molten`,
                coords = vector4(262.19808959961, 222.51879882813, 106.42955780029, 250.5080871582),
                thermiteHeading = 250.0,
                required = true
            },
            {
                model = `hei_v_ilev_bk_safegate_pris`,
                moltenModel = `hei_v_ilev_bk_safegate_molten`,
                coords = vector4(251.85757446289, 221.06547546387, 101.83240509033, 160.00001525879),
                thermiteHeading = 160.0,
                required = false
            },
            {
                model = `hei_v_ilev_bk_safegate_pris`,
                moltenModel = `hei_v_ilev_bk_safegate_molten`,
                coords = vector4(261.30041503906, 214.50514221191, 101.83240509033, 250.29228210449),
                thermiteHeading = 250.0,
                required = false
            }
        },
        keycard = {
            coords = vector4(252.86, 228.54, 102.09, 70.0),
            -- vaultTime = 5, -- time it takes to open the vault (in seconds) after successful hack, if unset it will use Config.DefaultVaultTime
        },
        vault = {
            model = `v_ilev_bk_vaultdoor`,
            coords = vector4(255.22825622559, 223.97601318359, 102.39321899414, 160.00001525879),
            unlockedHeading = 0.0
        },
        loot = {
            {
                type = "gold",
                coords = vector4(264.2614, 213.7286, 101.5309, 250.0)
            },
            {
                type = "cash_trolley",
                coords = vector4(265.12, 212.18, 101.155, 40.0)
            },
            {
                type = "cash_trolley",
                coords = vector4(266.44, 215.24, 101.155, 100.0)
            }
        },
        drill = {
            {
                coords = vector4(261.12, 217.79, 101.90, 340.0)
            },
            {
                coords = vector4(259.78, 218.28, 101.90, 340.0)
            },
            {
                coords = vector4(258.44, 218.76, 101.90, 340.0)
            },

            {
                coords = vector4(259.47, 213.41, 101.90, 160.0)
            },
            {
                coords = vector4(258.14, 213.89, 101.90, 160.0)
            },
            {
                coords = vector4(256.80, 214.38, 101.90, 160.0)
            }
        }
    },
    {
        name = "Fleeca Bank [Great Ocean Highway]",
        tier = 2,
        coords = vector3(-2964.8, 482.9, 15.7),
        resetTime = 90,
        vault = {
            model = `hei_prop_heist_sec_door`,
            coords = vector4(-2958.54, 482.47, 15.84, 358.0),
            unlockedHeading = 255.0
        },
        keycard = {
            coords = vector4(-2956.50, 482.06, 15.90, 353.0),
        },
        doors = {
            {
                model = `v_ilev_gb_vaubar`,
                moltenModel = `v_ilev_gb_vaubar`,
                coords = vector4(-2956.12, 485.42, 16.00, 267.0),
                thermiteHeading = 270.0,
                required = false
            }
        },
        loot = {
            {
                type = "cash",
                coords = vector4(-2954.13, 484.11, 15.53, 270.0)
            },
            {
                type = "gold",
                coords = vector4(-2954.08, 485.00, 15.53, 270.0)
            },
            {
                type = "cash_trolley",
                coords = vector4(-2954.98, 482.55, 15.15, 10.0)
            }
        },
        drill = {
            {
                coords = vector4(-2958.83, 484.09, 15.91, 88.0)
            },

            {
                coords = vector4(-2954.04, 486.64, 15.91, 358.0)
            },
            {
                coords = vector4(-2952.20, 484.80, 15.91, 268.0)
            },
        }
    },
    {
        name = "Fleeca Bank [Alta]",
        tier = 2,
        coords = vector3(314.9, -276.7, 54.2),
        resetTime = 90,
        vault = {
            model = `v_ilev_gb_vauldr`,
            coords = vector4(312.36, -282.73, 54.30, 250.0),
            unlockedHeading = 160.0
        },
        keycard = {
            coords = vector4(311.53, -284.61, 54.36, 250.0)
        },
        doors = {
            {
                model = `v_ilev_gb_vaubar`,
                moltenModel = `v_ilev_gb_vaubar`,
                coords = vector4(314.62, -285.99, 54.46, 160.0),
                thermiteHeading = 160.0,
                required = false
            }
        },
        loot = {
            {
                type = "cash",
                coords = vector4(312.82, -287.46, 54.00, 160.0)
            },
            {
                type = "cash_trolley",
                coords = vector4(314.27, -289.30, 53.62, 340.0)
            },
            {
                type = "cash_trolley",
                coords = vector4(311.20, -288.19, 53.62, 340.0)
            }
        },
        drill = {
            {
                coords = vector4(314.00, -282.92, 54.14, 340.0)
            }
        }
    },
    {
        name = "Fleeca [Legion Square]",
        tier = 2,
        coords = vector3(150.5, -1038.2, 29.4),
        resetTime = 90,
        vault = {
            model = `v_ilev_gb_vauldr`,
            coords = vector4(148.03, -1044.36, 29.51, 250.0),
            unlockedHeading = 160.0
        },
        keycard = {
            coords = vector4(147.20, -1046.24, 29.57, 250.0)
        },
        doors = {
            {
                model = `v_ilev_gb_vaubar`,
                moltenModel = `v_ilev_gb_vaubar`,
                coords = vector4(150.29, -1047.62, 29.67, 160.0),
                thermiteHeading = 160.0,
                required = false
            }
        },
        loot = {
            {
                type = "cash",
                coords = vector4(148.49, -1049.09, 29.21, 160.0)
            },
            {
                type = "cash_trolley",
                coords = vector4(149.94, -1050.93, 28.83, 340.0)
            },
            {
                type = "cash_trolley",
                coords = vector4(146.87, -1049.82, 28.83, 340.0)
            }
        },
        drill = {
            {
                coords = vector4(149.65, -1044.55, 29.56, 340.0)
            }
        }
    },
    {
        name = "Fleeca [Rockford Hills]",
        tier = 2,
        coords = vector3(-1213.9, -328.8, 37.8),
        resetTime = 90,
        vault = {
            model = `v_ilev_gb_vauldr`,
            coords = vector4(-1211.26, -334.56, 37.92, 297.0),
            unlockedHeading = 207.0
        },
        keycard = {
            coords = vector4(-1210.45, -336.44, 37.98, 297.0)
        },
        doors = {
            {
                model = `v_ilev_gb_vaubar`,
                moltenModel = `v_ilev_gb_vaubar`,
                coords = vector4(-1207.33, -335.13, 38.08, 207.0),
                thermiteHeading = 207.0,
                required = false
            }
        },
        loot = {
            {
                type = "cash",
                coords = vector4(-1207.48, -337.52, 37.60, 207.0)
            },
            {
                type = "cash_trolley",
                coords = vector4(-1208.05, -339.14, 37.23, 15.0)
            },
            {
                type = "cash_trolley",
                coords = vector4(-1205.21, -337.73, 37.23, 37.0)
            }
        },
        drill = {
            {
                coords = vector4(-1210.01, -333.50, 37.98, 27.0)
            }
        }
    },
    {
        name = "Fleeca [Burton]",
        tier = 2,
        coords = vector3(-350.1, -47.4, 49.05),
        resetTime = 90,
        vault = {
            model = `v_ilev_gb_vauldr`,
            coords = vector4(-352.74, -53.57, 49.18, 251.0),
            unlockedHeading = 160.0
        },
        keycard = {
            coords = vector4(-353.53, -55.46, 49.24, 251.0)
        },
        doors = {
            {
                model = `v_ilev_gb_vaubar`,
                moltenModel = `v_ilev_gb_vaubar`,
                coords = vector4(-350.41, -56.80, 49.33, 161.0),
                thermiteHeading = 161.0,
                required = false
            }
        },
        loot = {
            {
                type = "cash",
                coords = vector4(-352.22, -58.35, 48.86, 161.0)
            },
            {
                type = "cash_trolley",
                coords = vector4(-350.74, -60.15, 48.49, 358.0)
            },
            {
                type = "cash_trolley",
                coords = vector4(-353.86, -59.07, 48.49, 324.0)
            }
        },
        drill = {
            {
                coords = vector4(-351.10, -53.73, 49.23, 341.0)
            }
        }
    },
    {
        name = "Fleeca [Blaine County]",
        tier = 2,
        coords = vector3(1175.21, 2704.35, 38.10),
        resetTime = 90,
        vault = {
            model = `v_ilev_gb_vauldr`,
            coords = vector4(1175.54, 2710.86, 38.23, 90.0),
            unlockedHeading = 0.0,
        },
        keycard = {
            coords = vector4(1175.67, 2712.90, 38.29, 90.0)
        },
        doors = {
            {
                model = `v_ilev_gb_vaubar`,
                moltenModel = `v_ilev_gb_vaubar`,
                coords = vector4(1172.29, 2713.15, 38.39, 0.0),
                thermiteHeading = 0.0,
                required = false
            }
        },
        loot = {
            {
                type = "cash",
                coords = vector4(1173.51, 2715.26, 37.92, 0.0)
            },
            {
                type = "cash_trolley",
                coords = vector4(1171.51, 2716.40, 37.54, 191.0)
            },
            {
                type = "cash_trolley",
                coords = vector4(1174.75, 2716.32, 37.54, 168.0)
            }
        },
        drill = {
            {
                coords = vector4(1173.94, 2710.47, 38.28, 180.0)
            }
        }
    },
    {
        name = "Fleeca [Paleto Bay]",
        tier = 2,
        coords = vector3(-110.29, 6463.24, 31.62),
        resetTime = 90,
        vault = {
            model = `v_ilev_cbankvauldoor01`,
            coords = vector4(-104.60, 6473.44, 31.80, 45.0),
            unlockedHeading = 150.0,
        },
        keycard = {
            coords = vector4(-105.85, 6472.14, 32.03, 47.0)
        },
        doors = {},
        loot = {
            {
                type = "cash",
                coords = vector4(-104.60, 6477.13, 31.49, 311.0)
            },
            {
                type = "cash_trolley",
                coords = vector4(-105.08, 6478.66, 31.10, 141.0)
            },
            {
                type = "cash_trolley",
                coords = vector4(-102.45, 6476.74, 31.10, 125.0)
            },
        },
        drill = {
            {
                coords = vector4(-107.19, 6473.18, 31.90, 133.0)
            }
        }
    }
}

Config.ThermiteOffsets = {
    [`hei_v_ilev_bk_gate_pris`] = {
        anim = vector3(1.2, -0.05, -0.08),
        smoke = vector3(1.2, 0.8, -0.05),
        drip = vector3(1.2, -0.1, -0.15),
        marker = vector3(0.6, 0.0, 0.0)
    },
    [`hei_v_ilev_bk_gate2_pris`] = {
        anim = vector3(1.2, -0.05, -0.08),
        smoke = vector3(1.2, 0.8, -0.05),
        drip = vector3(1.2, -0.1, -0.15),
        marker = vector3(0.6, 0.0, 0.0)
    },
    [`hei_v_ilev_bk_safegate_pris`] = {
        anim = vector3(-1.15, -0.05, -0.08),
        smoke = vector3(-1.15, 0.8, -0.05),
        drip = vector3(-1.15, -0.1, -0.15),
        marker = vector3(-0.6, 0.0, 0.0)
    },
    [`v_ilev_gb_vaubar`] = {
        anim = vector3(1.35, -0.05, -0.08),
        smoke = vector3(1.35, 0.8, -0.05),
        drip = vector3(1.35, -0.1, -0.15),
        marker = vector3(0.7, 0.0, 0.0)
    },
}

Config.LootModels = {
    cash = `h4_prop_h4_cash_stack_01a`,
    cash_trolley = `hei_prop_hei_cash_trolly_01`,
    cash_trolley_empty = `hei_prop_hei_cash_trolly_03`,

    gold = `h4_prop_h4_gold_stack_01a`
}
