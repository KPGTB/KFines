Config = {}

Config.Locale = 'en'
Config.PoliceJob = 'police'
Config.TimeToPay = 3 * 24 * 60 * 60 * 1000 -- Milliseconds
Config.NotPaidModifier = 1.25
Config.AllowFakePlayers = false -- Allow cops to create ticket for player that doesn't exist in database (support for Fake ID)
Config.ShowDistance = 20 -- Distance for ticket. At least 1 player (excluding cop) needs to be in that distance to create ticket.
Config.TimeZone = "+02:00" -- It will convert default UTC into your timezone (required by MySQL)
Config.NPC = { -- Pay Ticket NPC
    pos = vector3(440.6174, -978.9453, 30.68958),
    heading = 180.0,
    ped = "s_m_y_cop_01",
    distance = 3, -- Distance to show message
}
Config.WebhookURL = "" -- Discord webhook with logs