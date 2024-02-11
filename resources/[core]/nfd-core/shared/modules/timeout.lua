local TimeoutCount = 0
local CancelledTimeouts = {}

NFD.Shared.Modules.Timeout.SetTimeout = function(msec, cb)
    local id <const> = TimeoutCount + 1

    SetTimeout(msec, function()
        if CancelledTimeouts[id] then
            CancelledTimeouts[id] = nil
            return
        end

        cb()
    end)

    TimeoutCount = id

    return id
end

NFD.Shared.Modules.Timeout.ClearTimeout = function(id)
    CancelledTimeouts[id] = true
end
