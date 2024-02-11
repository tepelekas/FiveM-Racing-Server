function NFD.Modules.Streaming.RequestModel(modelHash, cb)
    modelHash = (type(modelHash) == "number" and modelHash or joaat(modelHash))

    if not HasModelLoaded(modelHash) and IsModelInCdimage(modelHash) then
        RequestModel(modelHash)

        while not HasModelLoaded(modelHash) do
            Wait(0)
        end
    end

    if cb ~= nil then
        cb()
    end
end

function NFD.Modules.Streaming.RequestStreamedTextureDict(textureDict, cb)
    if not HasStreamedTextureDictLoaded(textureDict) then
        RequestStreamedTextureDict(textureDict)

        while not HasStreamedTextureDictLoaded(textureDict) do
            Wait(0)
        end
    end

    if cb ~= nil then
        cb()
    end
end

function NFD.Modules.Streaming.RequestNamedPtfxAsset(assetName, cb)
    if not HasNamedPtfxAssetLoaded(assetName) then
        RequestNamedPtfxAsset(assetName)

        while not HasNamedPtfxAssetLoaded(assetName) do
            Wait(0)
        end
    end

    if cb ~= nil then
        cb()
    end
end

function NFD.Modules.Streaming.RequestAnimSet(animSet, cb)
    if not HasAnimSetLoaded(animSet) then
        RequestAnimSet(animSet)

        while not HasAnimSetLoaded(animSet) do
            Wait(0)
        end
    end

    if cb ~= nil then
        cb()
    end
end

function NFD.Modules.Streaming.RequestAnimDict(animDict, cb)
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)

        while not HasAnimDictLoaded(animDict) do
            Wait(0)
        end
    end

    if cb ~= nil then
        cb()
    end
end
