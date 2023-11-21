function ShowHelpNotification(msg)
    SetTextComponentFormat('STRING')
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function GetJob()
    return QBCore.Functions.GetPlayerData().job.name
end

function IsBoss(job,grade)
    return QBCore.Functions.GetPlayerData().job.isboss
end

function OpenMenu(name, title, align,elements, func)
    local menu = {
        {
            header = title,
            icon = 'fas fa-ticket',
            isMenuHeader = true, 
        }
    }

    for _,v in pairs(elements) do
        table.insert(menu, {
            header = v.label,
            params = {
                event = v.event,
                args = v.args,
            }
        })
    end

    exports['qb-menu']:openMenu(menu)
end

function TriggerServerCallback(name, func, ...)
    QBCore.Functions.TriggerCallback(name,func,...)
end

function CloseMenus() end
