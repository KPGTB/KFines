QBCore = exports['qb-core']:GetCoreObject()
framework = "qb"

function _U(msg, ...)
    return string.format(Lang:t(msg),...)
end

function GetLang()
    return Lang.phrases
end
