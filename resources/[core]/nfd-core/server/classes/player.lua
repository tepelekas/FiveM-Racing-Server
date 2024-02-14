local _GetPlayerPed = GetPlayerPed
local _GetEntityCoords = GetEntityCoords
local _ExecuteCommand = ExecuteCommand
local _SetEntityCoords = SetEntityCoords
local _SetEntityHeading = SetEntityHeading
local _TriggerClientEvent = TriggerClientEvent
local _DropPlayer = DropPlayer
local _TriggerEvent = TriggerEvent
local _assert = assert

function CreateDatabasePlayer(playerId, identifier, license, group, money, name, metadata)
	local self = {
        money = money,
        group = group,
        identifier = identifier,
<<<<<<< HEAD
        name = GetPlayerName(playerId),
=======
        name = name,
>>>>>>> origin/beta
        source = playerId,
        variables = {},
        metadata = metadata,
        license = 'license:' .. identifier,
        admin = NFD.Functions.IsPlayerAdmin(playerId)
    }

	_ExecuteCommand(('add_principal identifier.%s group.%s'):format(self.license, self.group))

	local stateBag = Player(self.source).state
<<<<<<< HEAD
	stateBag:set("group", self.group, true)
=======
	stateBag:set("identifier", self.identifier, true)
	stateBag:set("license", self.license, true)
	stateBag:set("group", self.group, true)
	stateBag:set("name", self.name, true)
>>>>>>> origin/beta
	stateBag:set("metadata", self.metadata, true)

	function self.triggerEvent(eventName, ...)
		_assert(type(eventName) == "string", "eventName should be string!")
        _TriggerClientEvent(eventName, self.source, ...)
	end

	function self.setCoords(coordinates)
		local ped <const> = _GetPlayerPed(self.source)
        local vector = type(coordinates) == "vector4" and coordinates or type(coordinates) == "vector3" and vector4(coordinates, 0.0) or vec(coordinates.x, coordinates.y, coordinates.z, coordinates.heading or 0.0)
        _SetEntityCoords(ped, vector.xyz, false, false, false, false)
        _SetEntityHeading(ped, vector.w)
	end

    function self.getCoords(vector)
        local ped <const> = _GetPlayerPed(self.source)
        local coordinates <const> = _GetEntityCoords(ped)

        return vector and coordinates or { x = coordinates.x, y = coordinates.y, z = coordinates.z }
    end

    function self.kick(reason)
        _DropPlayer(self.source, reason)
    end

    function self.setMoney(money)
        _assert(type(money) == "number", "money should be number!")
        money = NFD.Shared.Modules.Math.Round(money)
        self.money = money

        self.triggerEvent("nfd:client:setMoney", money)
        _TriggerEvent("nfd:server:setMoney", self.source, money, reason)
    end

    function self.getMoney()
        return self.money
    end

    function self.addMoney(money, reason)
        _assert(type(money) == "number", "money should be number!")
        money = NFD.Shared.Modules.Math.Round(money)
        reason = reason or "unknown"
        self.money += money

        self.triggerEvent("nfd:client:setMoney", self.money)
        _TriggerEvent("nfd:server:addMoney", self.source, money, reason)
    end

    function self.removeMoney(money, reason)
        _assert(type(money) == "number", "money should be number!")
        money = NFD.Shared.Modules.Math.Round(money)
        reason = reason or "unknown"
        self.money -= money

        self.triggerEvent("nfd:client:setMoney", self.money)
        _TriggerEvent("nfd:server:removeMoney", self.source, money, reason)
    end

    function self.getIdentifier()
        return self.identifier
    end

    function self.getLicense()
        return self.license
    end

	function self.setGroup(newGroup)
		_ExecuteCommand(('remove_principal identifier.%s group.%s'):format(self.license, self.group))
		self.group = newGroup
		Player(self.source).state:set("group", self.group, true)
		self.triggerEvent('nfd:client:onGroupUpdate', self.source, self.group)
		_ExecuteCommand(('add_principal identifier.%s group.%s'):format(self.license, self.group))
		-- Save permissions to file
        local file = LoadResourceFile(GetCurrentResourceName(), "permissions.cfg")
        local table, result = string.find(file, tostring(self.license))
		local savefile = file:gsub(('\nadd_principal identifier.%s group.%s'):format(self.license, self.group) .. ' #' .. self.name, '')
		if Config.AdminGroups[self.group] and result == nil then
			SaveResourceFile(GetCurrentResourceName(), 'permissions.cfg', file .. '\n' .. ('add_principal identifier.%s group.%s'):format(self.license, self.group) .. ' #' .. self.name)
		elseif result ~= nil then
            SaveResourceFile(GetCurrentResourceName(), 'permissions.cfg', savefile)
        else
			self.triggerEvent('nfd:client:showNotification', 'Player already has permissions', 'error')
		end
	end

	function self.getGroup()
		return self.group
	end

    function self.set(k, v)
        self.variables[k] = v
        Player(self.source).state:set(k, v, true)
    end

    function self.get(k)
        return self.variables[k]
    end

    function self.getName()
        return self.name
    end

<<<<<<< HEAD
=======
    function self.setName(newName)
        self.name = newName
        Player(self.source).state:set("name", self.name, true)
    end

>>>>>>> origin/beta
    function self.showNotification(msg, notifyType, length)
        self.triggerEvent("nfd:client:showNotification", msg, notifyType, length)
    end

    function self.showAdvancedNotification(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
        self.triggerEvent("nfd:client:showAdvancedNotification", sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
    end

    function self.showHelpNotification(msg, thisFrame, beep, duration)
        self.triggerEvent("nfd:client:showHelpNotification", msg, thisFrame, beep, duration)
    end

    function self.getMeta(index, subIndex)
        if not index then
            return self.metadata
        end

        if type(index) ~= "string" then
            return print("[^1ERROR^7] Player.getMeta ^5index^7 should be ^5string^7!")
        end

        local metaData = self.metadata[index]
        if metaData == nil then
            return Config.EnableDebug and print(("[^1ERROR^7] Player.getMeta ^5%s^7 not exist!"):format(index)) or nil
        end

        if subIndex and type(metaData) == "table" then
            local _type = type(subIndex)

            if _type == "string" then
                local value = metaData[subIndex]
                return value
            end

            if _type == "table" then
                local returnValues = {}

                for i = 1, #subIndex do
                    local key = subIndex[i]
                    if type(key) == "string" then
                        returnValues[key] = self.getMeta(index, key)
                    else
                        print(("[^1ERROR^7] Player.getMeta subIndex should be ^5string^7 or ^5table^7! that contains ^5string^7, received ^5%s^7!, skipping..."):format(type(key)))
                    end
                end

                return returnValues
            end

            return print(("[^1ERROR^7] Player.getMeta subIndex should be ^5string^7 or ^5table^7!, received ^5%s^7!"):format(_type))
        end

        return metaData
    end

    function self.setMeta(index, value, subValue)
        if not index then
            return print("[^1ERROR^7] Player.setMeta ^5index^7 is Missing!")
        end

        if type(index) ~= "string" then
            return print("[^1ERROR^7] Player.setMeta ^5index^7 should be ^5string^7!")
        end

        if value == nil then
            return print("[^1ERROR^7] Player.setMeta value is missing!")
        end

        local _type = type(value)

        if not subValue then
            if _type ~= "number" and _type ~= "string" and _type ~= "table" then
                return print(("[^1ERROR^7] Player.setMeta ^5%s^7 should be ^5number^7 or ^5string^7 or ^5table^7!"):format(value))
            end

            self.metadata[index] = value
        else
            if _type ~= "string" then
                return print(("[^1ERROR^7] Player.setMeta ^5value^7 should be ^5string^7 as a subIndex!"):format(value))
            end

            if not self.metadata[index] or type(self.metadata[index]) ~= "table" then
                self.metadata[index] = {}
            end

            self.metadata[index] = type(self.metadata[index]) == "table" and self.metadata[index] or {}
            self.metadata[index][value] = subValue
        end

        Player(self.source).state:set("metadata", self.metadata, true)
    end

    function self.clearMeta(index, subValues)
        if not index then
            return print("[^1ERROR^7] Player.clearMeta ^5index^7 is Missing!")
        end

        if type(index) ~= "string" then
            return print("[^1ERROR^7] Player.clearMeta ^5index^7 should be ^5string^7!")
        end

        local metaData = self.metadata[index]
        if metaData == nil then
            return Config.EnableDebug and print(("[^1ERROR^7] Player.clearMeta ^5%s^7 does not exist!"):format(index)) or nil
        end

        if not subValues then
            -- If no subValues is provided, we will clear the entire value in the metaData table
            self.metadata[index] = nil
        elseif type(subValues) == "string" then
            -- If subValues is a string, we will clear the specific subValue within the table
            if type(metaData) == "table" then
                metaData[subValues] = nil
            else
                return print(("[^1ERROR^7] Player.clearMeta ^5%s^7 is not a table! Cannot clear subValue ^5%s^7."):format(index, subValues))
            end
        elseif type(subValues) == "table" then
            -- If subValues is a table, we will clear multiple subValues within the table
            for i = 1, #subValues do
                local subValue = subValues[i]
                if type(subValue) == "string" then
                    if type(metaData) == "table" then
                        metaData[subValue] = nil
                    else
                        print(("[^1ERROR^7] Player.clearMeta ^5%s^7 is not a table! Cannot clear subValue ^5%s^7."):format(index, subValue))
                    end
                else
                    print(("[^1ERROR^7] Player.clearMeta subValues should contain ^5string^7, received ^5%s^7, skipping..."):format(type(subValue)))
                end
            end
        else
            return print(("[^1ERROR^7] Player.clearMeta ^5subValues^7 should be ^5string^7 or ^5table^7, received ^5%s^7!"):format(type(subValues)))
        end

        Player(self.source).state:set("metadata", self.metadata, true)
    end

    return self
end
