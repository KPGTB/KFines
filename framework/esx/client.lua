local ESX = exports["es_extended"]:getSharedObject()

function ShowHelpNotification(msg)
    ESX.ShowHelpNotification(msg)
end

function GetJob()
    return ESX.GetPlayerData().job.name
end

function GetGrade()
    return ESX.GetPlayerData().job.grade_name
end

function OpenMenu(name, title, align,elements, func)
    ESX.UI.Menu.Open("default", GetCurrentResourceName(), name, {
        title = title,
        align = align,
        elements = elements,
    }, function(data,menu)
        func(data.current.name, data.current.value)
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
