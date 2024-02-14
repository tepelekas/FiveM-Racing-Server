NFD.Shared = {}
NFD.Shared.Functions = {}
NFD.Shared.Modules = {}
NFD.Shared.Modules.Math = {}
NFD.Shared.Modules.Table = {}
NFD.Shared.Modules.Timeout = {}
local Charset = {}

for i = 48, 57 do
    table.insert(Charset, string.char(i))
end
for i = 65, 90 do
    table.insert(Charset, string.char(i))
end
for i = 97, 122 do
    table.insert(Charset, string.char(i))
end

function NFD.Shared.Functions.GetRandomString(length)
    math.randomseed(GetGameTimer())

    return length > 0 and NFD.Shared.Functions.GetRandomString(length - 1) .. Charset[math.random(1, #Charset)] or ""
end

function NFD.Shared.Functions.GetRandomInt(length)
    math.randomseed(GetGameTimer())

    return length > 0 and NFD.Shared.Functions.GetRandomInt(length - 1) .. Charset[math.random(1, #Charset)] or ""
end

function NFD.Shared.Functions.GetConfig()
	return Config
end

function NFD.Shared.Functions.DumpTable(table, nb)
    if nb == nil then
        nb = 0
    end

    if type(table) == "table" then
        local s = ""
        for _ = 1, nb + 1, 1 do
            s = s .. "    "
        end

        s = "{\n"
        for k, v in pairs(table) do
            if type(k) ~= "number" then
                k = '"' .. k .. '"'
            end
            for _ = 1, nb, 1 do
                s = s .. "    "
            end
            s = s .. "[" .. k .. "] = " .. NFD.Shared.Functions.DumpTable(v, nb + 1) .. ",\n"
        end

        for _ = 1, nb, 1 do
            s = s .. "    "
        end

        return s .. "}"
    else
        return tostring(table)
    end
end

function NFD.Shared.Functions.FirstToUpper(value)
    if not value then return nil end
    return (value:gsub("^%l", string.upper))
end
