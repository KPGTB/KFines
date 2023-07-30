local visible

function SendReactMessage(action,data)
    SendNUIMessage({
        action = action,
        data = data
    })
end

function SetReactVisible(visible) 
    SendReactMessage("visible", visible)
    UpdateReactVisible()
end

function ToggleReactVisible()
    SetReactVisible(not visible)
end

function IsReactVisible()
    return visible
end

---
---
---

Citizen.CreateThread(function()
    UpdateReactVisible()
end)

function UpdateReactVisible()
    SendReactMessage("visible_check")
end

RegisterNUICallback("visible_check_cb", function(data,cb)
    visible = data
    cb(true)
end)

