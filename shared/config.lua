Config = {}

Config.Locale = 'en'
Config.TimeToPay = 3 * 24 * 60 * 60 * 1000 -- Milliseconds
Config.NotPaidModifier = 1.25
Config.AllowFakePlayers = false -- Allow cops to create ticket for player that doesn't exist in database (support for Fake ID)
Config.ShowDistance = 20 -- Distance for ticket. At least 1 player (excluding cop) needs to be in that distance to create ticket.
Config.TimeZone = "+02:00" -- It will convert default UTC into your timezone (required by MySQL)
Config.WebhookURL = "" -- Discord webhook with logs
Config.Jobs = {
    lspd = { -- Unique name of category
        name = "Los Santos Police Department", -- Name displayed in ticket
        location = "City of Los Santos", -- City name in ticket
        logo = "lspd.png", -- Logo from /web/assets folder
        society = "society_police", -- Society account to give money from tickets
        allowedJobs = {{ -- table of allowed jobs
            job = "police", -- job name
            grade = "boss" -- job grade
        },{
            job = "offpolice",
            grade = "boss"
        }},
        npcs = {{ -- table of npcs where player can pay for ticket from this category
            pos = vector3(440.6174, -978.9453, 30.68958),
            heading = 180.0,
            ped = "s_m_y_cop_01",
            distance = 3,  -- distance to show message
        }}
    },
    bcso = {
        name = "Blaine County Sheriff's Office",
        location = "Blaine County",
        logo = "bcso.png",
        society = "society_sheriff",
        allowedJobs = {{
            job = "sheriff",
            grade = "boss",
        },{
            job = "offsheriff",
            grade = "boss"
        }},
        npcs = {{
            pos = vector3(1852.4,3688.6,34.26),
            heading = 210.0,
            ped = "s_m_y_sheriff_01",
            distance = 3,
        }}
    }
}