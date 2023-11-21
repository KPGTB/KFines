local translations = {
    ['nui_title'] = "Traffic Ticket",
    ['nui_type_officer'] = "Police Officer",
    ['nui_type_citizen'] = "Citizen",
    ['nui_type_ticket'] = "Ticket",
    ['nui_input_name'] = "Name & Surname",
    ['nui_input_rank'] = "Rank",
    ['nui_input_badge'] = "Badge",
    ['nui_input_sex'] = "Sex",
    ['nui_input_dob'] = "Date of birth",
    ['nui_male'] = "Male",
    ['nui_female'] = "Female",
    ['nui_input_fine'] = "Fine",
    ['nui_input_reason'] = "Reason",
    ['nui_input_payuntil'] = "Pay Until",
    ['nui_input_signature'] = "Signature",
    ['nui_apply'] = "Apply",
    ['nui_pay'] = "Pay",
    ['nui_exit'] = "Exit",
    ["fine"] = "~g~Fine sent",
    ["not_found"] = "~r~Citizen not found",
    ['npc_notify'] = "Press ~INPUT_PICKUP~ to interact with NPC",
    ['interact_bind'] = "Interact with NPC",
    ['menu_main'] = "Traffic Tickets Menu",
    ['menu_main_paid'] = "Paid Tickets",
    ['menu_main_pay'] = "Pay for Tickets",
    ['menu_main_info'] = "Tickets Info",
    ['menu_ticket'] = "%s. $%s",
    ['menu_ticket_after'] = "%s. $%s + $%s (AFTER TIME)",
    ['paid'] = "You paid $%s for ticket with ID %s",
    ['menu_info_paid'] = "Paid Tickets %s ($%s)",
    ['menu_info_to_pay'] = "Tickets to Pay %s ($%s)",
    ['menu_ticket_info'] = "%s. $%s (Paid: %s)",
    ['menu_ticket_after_info'] = "%s. $%s + $%s (AFTER TIME) (Paid: %s)",
    ['fill_ticket'] = "Fill every gap in ticket",
}
local fileLocale = "en"

if framework == "esx" then
    Locales[fileLocale] = translations
elseif framework == "qb" and Config.Locale == fileLocale then
    Lang = Locale:new({
        phrases = translations,
        warnOnMissing = true
    })
end
