Config = {}

Config.Locale = 'en'
Config.TimeToPay = 3 * 24 * 60 * 60 * 1000
Config.NotPaidModifier = 1.25
Config.AllowFakePlayers = false
Config.ShowDistance = 20
Config.TimeZone = "+02:00" -- It will convert default UTC into your timezone (required by MySQL)
Config.NPC = {
    pos = vector3(440.6174, -978.9453, 30.68958),
    heading = 180.0,
    ped = "s_m_y_cop_01",
    distance = 3,
}
Config.WebhookURL = "https://discord.com/api/webhooks/1136249036630933596/oyoHobbQMZLB8i_8eI_B-PV6patHHc4trXiutMTKnsp5OKtbaVY6Y3YHzfgE4q95IVeD?thread_id=1136248990015430656"