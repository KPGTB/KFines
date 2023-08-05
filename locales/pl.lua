translations = {
    ['nui_department'] = "Los Santos Police Department",
    ['nui_title'] = "Mandat Karny",
    ['nui_city'] = "City of Los Santos",
    ['nui_type_officer'] = "Policjant",
    ['nui_type_citizen'] = "Obywatel",
    ['nui_type_ticket'] = "Mandat",
    ['nui_input_name'] = "Imię i nazwisko",
    ['nui_input_rank'] = "Stopień",
    ['nui_input_badge'] = "Odznaka",
    ['nui_input_sex'] = "Płeć",
    ['nui_input_dob'] = "Data urodzenia",
    ['nui_male'] = "Mężczyzna",
    ['nui_female'] = "Kobieta",
    ['nui_input_fine'] = "Kara",
    ['nui_input_reason'] = "Powód",
    ['nui_input_payuntil'] = "Czas zapłaty",
    ['nui_input_signature'] = "Podpis",
    ['nui_apply'] = "Zatwierdź",
    ['nui_pay'] = "Zapłać",
    ['nui_exit'] = "Wyjdź",
    ["fine"] = "~g~Mandat wysłany",
    ["not_found"] = "~r~Obywatel nie znaleziony",
    ['npc_notify'] = "Wciśnij ~INPUT_PICKUP~ aby użyć NPC",
    ['interact_bind'] = "Interakcja z NPC",
    ['menu_main'] = "Menu Mandatów",
    ['menu_main_paid'] = "Opłacone Mandaty",
    ['menu_main_pay'] = "Opłać Mandat",
    ['menu_main_info'] = "Podsumowanie",
    ['menu_ticket'] = "%s. $%s",
    ['menu_ticket_after'] = "%s. $%s + $%s (PO CZASIE)",
    ['paid'] = "Zapłaciłeś $%s za mandat z ID %s",
    ['menu_info_paid'] = "Opłacone mandaty %s ($%s)",
    ['menu_info_to_pay'] = "Mandaty do opłacenia %s ($%s)",
    ['menu_ticket_info'] = "%s. $%s (Opłacony: %s)",
    ['menu_ticket_after_info'] = "%s. $%s + $%s (Po czasie) (Opłacony: %s)",
    ['fill_ticket'] = "Wypełnij każdą lukę w mandacie",
}
local fileLocale = "pl"

if framework == "esx" then
    Locales[fileLocale] = translations
elseif framework == "qb" and Config.Locale == fileLocale then
    Lang = Locale:new({
        phrases = translations,
        warnOnMissing = true
    })
end