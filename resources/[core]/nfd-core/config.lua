Config = {
    Locale = GetConvar('nfd:locale', 'en'),

    StartingMoney = 5000,

    AdminGroups = {
        ['owner'] = true,
        ['dev'] = true,
        ['superadmin'] = true,
        ['admin'] = true,
        ['mod'] = true,
        ['support'] = true
    },

    DefaultSpawnPoint = {
        x = 950.8208,
        y = -2993.7441,
        z = -47.6470,
        heading = 148.8116
    },

    DiscordPresence = {
        ["IsEnabled"] = false, -- If set to true, then discord rich presence will be enabled
        ["ApplicationId"] = '764764967098253324', -- The discord application id
        ["IconLarge"] = 'fivem-logo', -- The name of the large icon
        ["IconLargeHoverText"] = 'Fivem Roleplay', -- The hover text of the large icon
        ["IconSmall"] = 'discord-logo', -- The name of the small icon
        ["IconSmallHoverText"] = 'Join our Discord !', -- The hover text of the small icon
        ["UpdateRate"] = 60000, -- How often the player count should be updated
        ["ShowPlayerCount"] = true, -- If set to true the player count will be displayed in the rich presence
        ["MaxPlayers"] = GetConvarInt("sv_maxclients", 64), -- Maximum amount of players
        ['EnableButtons'] = false, -- If set to true enables discord buttons in rich presence
        ["Buttons"] = {
            {
                text = 'Play Now!',
                url = 'fivem://connect/localhost:30120'
            },
            {
                text = 'Join Discord!',
                url = 'https://discord.gg/uSSaURpxGz'
            }
        }
    },

    EnableDebug = false,
    EnableWantedLevel = false,
    DisableWeaponAutoSwap = true,
    AdminLogging = false,
    DisableVehicleRewards = true,
    DisableDispatchServices = true,
    DisableWeaponWheel = true,
    DisableAimAssist = true,

    RemoveHudComponents       = {
        [1] = true,   --WANTED_STARS,
        [2] = true,   --WEAPON_ICON
        [3] = true,   --CASH
        [4] = true,   --MP_CASH
        [5] = true,   --MP_MESSAGE
        [6] = true,   --VEHICLE_NAME
        [7] = true,   --AREA_NAME
        [8] = true,   --VEHICLE_CLASS
        [9] = true,   --STREET_NAME
        [10] = false, --HELP_TEXT
        [11] = true,  --FLOATING_HELP_TEXT_1
        [12] = true,  --FLOATING_HELP_TEXT_2
        [13] = true,  --CASH_CHANGE
        [14] = true,  --RETICLE
        [15] = true,  --SUBTITLE_TEXT
        [16] = false, --RADIO_STATIONS
        [17] = true,  --SAVING_GAME,
        [18] = true,  --GAME_STREAM
        [19] = true,  --WEAPON_WHEEL
        [20] = true,  --WEAPON_WHEEL_STATS
        [21] = true,  --HUD_COMPONENTS
        [22] = true,  --HUD_WEAPONS
    },

    DisableScenarios = true, -- Disable Scenarios
    Scenarios = {
        'WORLD_VEHICLE_ATTRACTOR',
        'WORLD_VEHICLE_AMBULANCE',
        'WORLD_VEHICLE_BICYCLE_BMX',
        'WORLD_VEHICLE_BICYCLE_BMX_BALLAS',
        'WORLD_VEHICLE_BICYCLE_BMX_FAMILY',
        'WORLD_VEHICLE_BICYCLE_BMX_HARMONY',
        'WORLD_VEHICLE_BICYCLE_BMX_VAGOS',
        'WORLD_VEHICLE_BICYCLE_MOUNTAIN',
        'WORLD_VEHICLE_BICYCLE_ROAD',
        'WORLD_VEHICLE_BIKE_OFF_ROAD_RACE',
        'WORLD_VEHICLE_BIKER',
        'WORLD_VEHICLE_BOAT_IDLE',
        'WORLD_VEHICLE_BOAT_IDLE_ALAMO',
        'WORLD_VEHICLE_BOAT_IDLE_MARQUIS',
        'WORLD_VEHICLE_BOAT_IDLE_MARQUIS',
        'WORLD_VEHICLE_BROKEN_DOWN',
        'WORLD_VEHICLE_BUSINESSMEN',
        'WORLD_VEHICLE_HELI_LIFEGUARD',
        'WORLD_VEHICLE_CLUCKIN_BELL_TRAILER',
        'WORLD_VEHICLE_CONSTRUCTION_SOLO',
        'WORLD_VEHICLE_CONSTRUCTION_PASSENGERS',
        'WORLD_VEHICLE_DRIVE_PASSENGERS',
        'WORLD_VEHICLE_DRIVE_PASSENGERS_LIMITED',
        'WORLD_VEHICLE_DRIVE_SOLO',
        'WORLD_VEHICLE_FIRE_TRUCK',
        'WORLD_VEHICLE_EMPTY',
        'WORLD_VEHICLE_MARIACHI',
        'WORLD_VEHICLE_MECHANIC',
        'WORLD_VEHICLE_MILITARY_PLANES_BIG',
        'WORLD_VEHICLE_MILITARY_PLANES_SMALL',
        'WORLD_VEHICLE_PARK_PARALLEL',
        'WORLD_VEHICLE_PARK_PERPENDICULAR_NOSE_IN',
        'WORLD_VEHICLE_PASSENGER_EXIT',
        'WORLD_VEHICLE_POLICE_BIKE',
        'WORLD_VEHICLE_POLICE_CAR',
        'WORLD_VEHICLE_POLICE',
        'WORLD_VEHICLE_POLICE_NEXT_TO_CAR',
        'WORLD_VEHICLE_QUARRY',
        'WORLD_VEHICLE_SALTON',
        'WORLD_VEHICLE_SALTON_DIRT_BIKE',
        'WORLD_VEHICLE_SECURITY_CAR',
        'WORLD_VEHICLE_STREETRACE',
        'WORLD_VEHICLE_TOURBUS',
        'WORLD_VEHICLE_TOURIST',
        'WORLD_VEHICLE_TANDL',
        'WORLD_VEHICLE_TRACTOR',
        'WORLD_VEHICLE_TRACTOR_BEACH',
        'WORLD_VEHICLE_TRUCK_LOGS',
        'WORLD_VEHICLE_TRUCKS_TRAILERS',
        'WORLD_VEHICLE_DISTANT_EMPTY_GROUND',
        'WORLD_HUMAN_PAPARAZZI'
    },

    DisableNPCDrops = true, -- stops NPCs from dropping weapons on death
    DisabledPickups = {
        `PICKUP_WEAPON_ADVANCEDRIFLE`,
        `PICKUP_WEAPON_APPISTOL`,
        `PICKUP_WEAPON_ASSAULTRIFLE`,
        `PICKUP_WEAPON_ASSAULTRIFLE_MK2`,
        `PICKUP_WEAPON_ASSAULTSHOTGUN`,
        `PICKUP_WEAPON_ASSAULTSMG`,
        `PICKUP_WEAPON_AUTOSHOTGUN`,
        `PICKUP_WEAPON_BAT`,
        `PICKUP_WEAPON_BATTLEAXE`,
        `PICKUP_WEAPON_BOTTLE`,
        `PICKUP_WEAPON_BULLPUPRIFLE`,
        `PICKUP_WEAPON_BULLPUPRIFLE_MK2`,
        `PICKUP_WEAPON_BULLPUPSHOTGUN`,
        `PICKUP_WEAPON_CARBINERIFLE`,
        `PICKUP_WEAPON_CARBINERIFLE_MK2`,
        `PICKUP_WEAPON_COMBATMG`,
        `PICKUP_WEAPON_COMBATMG_MK2`,
        `PICKUP_WEAPON_COMBATPDW`,
        `PICKUP_WEAPON_COMBATPISTOL`,
        `PICKUP_WEAPON_COMPACTLAUNCHER`,
        `PICKUP_WEAPON_COMPACTRIFLE`,
        `PICKUP_WEAPON_CROWBAR`,
        `PICKUP_WEAPON_DAGGER`,
        `PICKUP_WEAPON_DBSHOTGUN`,
        `PICKUP_WEAPON_DOUBLEACTION`,
        `PICKUP_WEAPON_FIREWORK`,
        `PICKUP_WEAPON_FLAREGUN`,
        `PICKUP_WEAPON_FLASHLIGHT`,
        `PICKUP_WEAPON_GRENADE`,
        `PICKUP_WEAPON_GRENADELAUNCHER`,
        `PICKUP_WEAPON_GUSENBERG`,
        `PICKUP_WEAPON_GolfClub`,
        `PICKUP_WEAPON_HAMMER`,
        `PICKUP_WEAPON_HATCHET`,
        `PICKUP_WEAPON_HEAVYPISTOL`,
        `PICKUP_WEAPON_HEAVYSHOTGUN`,
        `PICKUP_WEAPON_HEAVYSNIPER`,
        `PICKUP_WEAPON_HEAVYSNIPER_MK2`,
        `PICKUP_WEAPON_HOMINGLAUNCHER`,
        `PICKUP_WEAPON_KNIFE`,
        `PICKUP_WEAPON_KNUCKLE`,
        `PICKUP_WEAPON_MACHETE`,
        `PICKUP_WEAPON_MACHINEPISTOL`,
        `PICKUP_WEAPON_MARKSMANPISTOL`,
        `PICKUP_WEAPON_MARKSMANRIFLE`,
        `PICKUP_WEAPON_MARKSMANRIFLE_MK2`,
        `PICKUP_WEAPON_MG`,
        `PICKUP_WEAPON_MICROSMG`,
        `PICKUP_WEAPON_MINIGUN`,
        `PICKUP_WEAPON_MINISMG`,
        `PICKUP_WEAPON_MOLOTOV`,
        `PICKUP_WEAPON_MUSKET`,
        `PICKUP_WEAPON_NIGHTSTICK`,
        `PICKUP_WEAPON_PETROLCAN`,
        `PICKUP_WEAPON_PIPEBOMB`,
        `PICKUP_WEAPON_PISTOL`,
        `PICKUP_WEAPON_PISTOL50`,
        `PICKUP_WEAPON_PISTOL_MK2`,
        `PICKUP_WEAPON_POOLCUE`,
        `PICKUP_WEAPON_PROXMINE`,
        `PICKUP_WEAPON_PUMPSHOTGUN`,
        `PICKUP_WEAPON_PUMPSHOTGUN_MK2`,
        `PICKUP_WEAPON_RAILGUN`,
        `PICKUP_WEAPON_RAYCARBINE`,
        `PICKUP_WEAPON_RAYMINIGUN`,
        `PICKUP_WEAPON_RAYPISTOL`,
        `PICKUP_WEAPON_REVOLVER`,
        `PICKUP_WEAPON_REVOLVER_MK2`,
        `PICKUP_WEAPON_RPG`,
        `PICKUP_WEAPON_SAWNOFFSHOTGUN`,
        `PICKUP_WEAPON_SMG`,
        `PICKUP_WEAPON_SMG_MK2`,
        `PICKUP_WEAPON_SMOKEGRENADE`,
        `PICKUP_WEAPON_SNIPERRIFLE`,
        `PICKUP_WEAPON_SNSPISTOL`,
        `PICKUP_WEAPON_SNSPISTOL_MK2`,
        `PICKUP_WEAPON_SPECIALCARBINE`,
        `PICKUP_WEAPON_SPECIALCARBINE_MK2`,
        `PICKUP_WEAPON_STICKYBOMB`,
        `PICKUP_WEAPON_STONE_HATCHET`,
        `PICKUP_WEAPON_STUNGUN`,
        `PICKUP_WEAPON_SWITCHBLADE`,
        `PICKUP_WEAPON_VINTAGEPISTOL`,
        `PICKUP_WEAPON_WRENCH`
    }
}
