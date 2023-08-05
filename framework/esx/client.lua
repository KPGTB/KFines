function ShowHelpNotification(msg)
    ESX.ShowHelpNotification(msg)
end

function GetJob()
    return ESX.GetPlayerData().job.name
end

function IsBoss()
    return ESX.GetPlayerData().job.grade_name == Config.BossGrade
end

function OpenMenu(name, title, align,elements)
    ESX.UI.Menu.Open("default", GetCurrentResourceName(), name, {
        title = title,
        align = align,
        elements = elements,
    }, function(data,menu)
        if data.current.event ~= nil then
            TriggerEvent(data.current.event, data.current.args)
        end
        menu.close()
    end, function(data,menu)
        menu.close()
    end)
end

function TriggerServerCallback(name, func, ...)
    ESX.TriggerServerCallback(name,func,...)
end

function CloseMenus()
    ESX.UI.Menu.CloseAll()
end
