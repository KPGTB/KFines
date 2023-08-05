-- NUI

RegisterNUICallback("pay", function(id,cb)
    TriggerServerEvent("kfines:pay", id)
    cb(true)
end)

RegisterNUICallback("apply", function(data, cb)
	TriggerServerEvent("kfines:apply", data)
    cb(true)
end)

RegisterNetEvent("kfines:open", function(completed, data)
    if completed then
        SendReactMessage("setData",data)
        Citizen.Wait(100)
    end

    SendReactMessage("prepare",
        {
            completed = completed,
            payTime = Config.TimeToPay,
        }
    )
    SetReactVisible(true)
    SetNuiFocus(true, true)
    CloseMenus()
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    SendReactMessage("setLocale", GetLang())
end)

RegisterNUICallback("exit", function(req,res)
    SetNuiFocus(false, false)
    SendReactMessage("reset")
    res(true)
end)

-- NPC Handle

local nearNPC = false

Citizen.CreateThread(function()    
    while true do
        ped = PlayerPedId()
        distance = #(GetEntityCoords(ped) - Config.NPC.pos)

        if distance < Config.NPC.distance then
            nearNPC = true
            Citizen.Wait(2000)
        else
            nearNPC = false
            Citizen.Wait(100)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if nearNPC then
            ShowHelpNotification(_U('npc_notify'))
        end
        Citizen.Wait(50)
    end
end)

RegisterNetEvent("kfines:menu:open", function(data)
    if data.name == "paid" then PaidMenu() 
    elseif data.name == "pay" then PayMenu() 
    elseif data.name == "info" then InfoMenu() 
    end
end)

RegisterNetEvent("kfines:menu:ticket", function(data)
    if data.paid then
        data.value.paid = true
    end

    TriggerEvent("kfines:open", data.completed, data.value)
end)

RegisterCommand("--kfines:npc", function()
    if not nearNPC then return end

    elements = {
        {label = _U("menu_main_paid"), name = "paid", event = "kfines:menu:open", args = {name = "paid"}},
        {label = _U("menu_main_pay"), name = "pay", event = "kfines:menu:open", args = {name = "pay"}},
    }

    if GetJob() == Config.PoliceJob and IsBoss() then
        table.insert(elements,{label = _U("menu_main_info"), name = "info", event = "kfines:menu:open", args = {name = "info"}})
    end

    OpenMenu("finesMainMenu", _U("menu_main"), "right", elements)
end, false)
Citizen.CreateThread(function()
    Citizen.Wait(2000)
    RegisterKeyMapping('--kfines:npc', _U('interact_bind'), 'keyboard', 'e')
    TriggerEvent('chat:removeSuggestion', '/--kfines:npc')
end)

function PaidMenu()
    local elements = {}

    TriggerServerCallback("traffic_tickets_get", function(result)
        for _,v in pairs(result) do
            label = _U("menu_ticket", v.id, v.fine)
            if v.afterTime then
                label = _U("menu_ticket_after", v.id, v.fine, ((v.fine * Config.NotPaidModifier) - v.fine))
            end
            table.insert(elements, {
                label = label,
                event = "kfines:menu:ticket",
                args = {
                    completed = true,
                    value = v
                }
            })
        end

        OpenMenu("finesPaidMenu", _U("menu_main_paid"), "right", elements)
    end, true)
end

function PayMenu()
    local elements = {}

    TriggerServerCallback("traffic_tickets_get", function(result)
        for _,v in pairs(result) do
            table.insert(elements, {
                label = _U("menu_ticket", v.id, v.fine),
                event = "kfines:menu:ticket",
                args = {
                    completed = true,
                    value = v
                }
            })
        end

        OpenMenu("finesPayMenu", _U("menu_main_pay"), "right", elements)
    end, false)
end

function InfoMenu()
    local elements = {}

    TriggerServerCallback("traffic_tickets_get_all", function(result)
        paid = 0
        toPay = 0

        paidMoney = 0
        toPayMoney = 0

        for _,v in pairs(result) do
            if v.paid then
                paid = paid + 1
                if v.afterTime then
                    paidMoney = paidMoney + (Config.NotPaidModifier * v.fine)
                else
                    paidMoney = paidMoney + v.fine
                end
            else
                toPay = toPay + 1
                toPayMoney = toPayMoney + v.fine
            end

            label = _U("menu_ticket_info", v.id, v.fine, v.paid)
            if v.afterTime then
                label = _U("menu_ticket_after_info", v.id, v.fine, ((v.fine * Config.NotPaidModifier) - v.fine), v.paid)
            end

            table.insert(elements, {
                label = label,
                event = "kfines:menu:ticket",
                args = {
                    completed = true,
                    value = v,
                    paid = true,
                }
            })
        end

        table.insert(elements, 1, {label = _U("menu_info_paid", paid, paidMoney)})
        table.insert(elements, 2, {label = _U("menu_info_to_pay", toPay, toPayMoney)})

        OpenMenu("finesInfoMenu",  _U("menu_main_info"), "right", elements)
    end)
end

-- Spawn NPC
Citizen.CreateThread(function()

    hash = Config.NPC.ped
    pos = Config.NPC.pos
    heading = Config.NPC.heading

    RequestModel(hash)
    while not HasModelLoaded(hash) do Citizen.Wait(1) end

    local ped = CreatePed(1, hash, pos.x, pos.y, pos.z-1, heading, false, true)

    SetPedCombatAttributes(ped, 46, true)                     
    SetPedFleeAttributes(ped, 0, 0)                      
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetEntityAsMissionEntity(ped, true, true)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
end)