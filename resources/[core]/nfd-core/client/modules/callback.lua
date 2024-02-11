local RequestId = 0
local serverRequests = {}

local clientCallbacks = {}

---@param eventName string
---@param callback function
---@param ... any
NFD.Modules.Callbacks.TriggerServerCallback = function(eventName, callback, ...)
    serverRequests[RequestId] = callback

    TriggerServerEvent("nfd:callback:triggerServerCallback", eventName, RequestId, GetInvokingResource() or "unknown", ...)

    RequestId = RequestId + 1
end

RegisterNetEvent("nfd:callback:serverCallback", function(requestId, invoker, ...)
    if not serverRequests[requestId] then
        return print(("[^1ERROR^7] Server Callback with requestId ^5%s^7 Was Called by ^5%s^7 but does not exist."):format(requestId, invoker))
    end

    serverRequests[requestId](...)
    serverRequests[requestId] = nil
end)

---@param eventName string
---@param callback function
NFD.Modules.Callbacks.RegisterClientCallback = function(eventName, callback)
    clientCallbacks[eventName] = callback
end

RegisterNetEvent("nfd:callback:triggerClientCallback", function(eventName, requestId, invoker, ...)
    if not clientCallbacks[eventName] then
        return print(("[^1ERROR^7] Client Callback not registered, name: ^5%s^7, invoker resource: ^5%s^7"):format(eventName, invoker))
    end

    clientCallbacks[eventName](function(...)
        TriggerServerEvent("nfd:callback:clientCallback", requestId, invoker, ...)
    end, ...)
end)

NFD.Modules.Callbacks.RegisterClientCallback('nfd:client:GetVehicleType', function(cb, model)
    cb(NFD.Functions.GetVehicleType(model))
end)