-- opt/lib/nets
-- by Timendainum
-- Network serialization wrapper functions for LyqydNet
-- For LyqydNet by Lyqyd
-- http://www.computercraft.info/forums2/index.php?/topic/1708-lyqydnet-rednet-api/
---------------------------------------------------


---------------------------------------------------
-- local functions
local function processMessageType(raw)
	local result = "nil"
	if raw ~= nil then
		if type(raw) == "string" then
			result = raw
		else
			result = "invalid"
		end
	end
	return result
end

local function processMessage(raw)
	local tMessage = {}
	-- preprocess message --
	if raw == nil then
		tMessage = nil
	elseif string.len(raw) > 2 and string.sub(raw, 1, 1) == "{" and string.sub(raw, -1) == "}" then
		local tResult = textutils.unserialize(raw)
		if tResult[1] then
			tMessage = tResult
		else
			tMessage = nil
		end
	else
		tMessage = nil
	end

	-- handle response
	return tMessage
end


---------------------------------------------------
-- functions
-- send
function send(conn, messageType, ...)
	print("send called...")
	if conn then
		local tSData = {...}
		local result = textutils.serialize(tSData)
		txt.sPrint("nets.send(): Sending serialized data: ",  result)
		return connection.send(conn, messageType, result)
	else
		print("nets.send() failed, no connection to send.")
		return false
	end
end

-- awaitResponse
function awaitResponse(conn, timeout)
	print("awaitResponse called...")
	if conn then
		local rawMessType, messType, rawMessage, tMessage = nil, "nil", nil, nil
		rawMessType, rawMessage = connection.awaitResponse(conn, timeout)

		-- preprocess messType
		messType = processMessageType(rawMessType)

		tMessage = processMessage(rawMessage)
		
		-- handle response
		return messType, tMessage
	else
		print("nets.awaitResponse() failed, no connection to await.")
		return false
	end
end

-- listenIdle()
function listenIdle(port)
	print("listenIdle called...")
	local conn, rawMessType, messType, rawMessage, tMessage = nil, nil, "nil", nil, {}
	conn, rawMessType, rawMessage = connection.listenIdle(port)
	
	-- preprocess messType
	messType = processMessageType(rawMessType)

	-- preprocess message --
	tMessage = processMessage(rawMessage)

	-- handle response
	return messType, tMessage
end