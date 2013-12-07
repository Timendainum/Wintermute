-- opt/lib/nets
-- by Timendainum
-- Network serialization wrapper functions for LyqydNet
-- For LyqydNet by Lyqyd
-- http://www.computercraft.info/forums2/index.php?/topic/1708-lyqydnet-rednet-api/
---------------------------------------------------


---------------------------------------------------
-- local functions
local function processMessageType(raw)
	debug.log(50, "processMessageType called: ", raw)
	local result = "nil"
	if raw ~= nil then
		if type(raw) == "string" then
			result = raw
		else
			result = "invalid"
		end
	end
	debug.log(50, "processMessageType done: ", result)
	return result
end

local function processMessage(raw)
	debug.log(50, "processMessage called: ", raw)
	local tMessage = {}
	-- preprocess message --
	if raw == nil then
		tMessage = nil
	elseif string.len(raw) > 2 and string.sub(raw, 1, 1) == "{" and string.sub(raw, -1) == "}" then
		local tResult = serial.unserialize(raw)
		if tResult[1] then
			tMessage = tResult
		else
			tMessage = nil
		end
	else
		tMessage = { raw }
	end

	if tMessage == nil then
		tMessage = { nil }
	end
	
	-- handle response
	debug.log(50, "processMessage done: ", unpack(tMessage))

	return tMessage
end


---------------------------------------------------
-- functions
-- send
function send(conn, messageType, ...)
	debug.log(40, "send called: conn: ", conn, "  messageType: ",messageType, ...)
	if conn then
		local tSData = {...}
		local result = serial.serialize(tSData)
		debug.log(50, "nets.send(): Sending serialized data: ",  result)
		return connection.send(conn, messageType, result)
	else
		debug.log(1, "nets.send() failed, no connection to send.")
		return false
	end
end

-- awaitResponse
function awaitResponse(conn, timeout)
	debug.log(40, "awaitResponse called: conn: ", conn, " timeout:", timeout)
	if conn then
		local rawMessType, messType, rawMessage, tMessage = nil, "nil", nil, nil
		debug.log(50, "nets.awaitResponse() Awaiting server response...")
		rawMessType, rawMessage = connection.awaitResponse(conn, timeout)

		-- preprocess messType
		messType = processMessageType(rawMessType)

		tMessage = processMessage(rawMessage)
		
		-- handle response
		debug.log(50, "Server responded with messType: ", messType, " tMessage: ", tMessage)
		return messType, tMessage
	else
		debug.log(1, "nets.awaitResponse() failed, no connection to await.")
		return false
	end
end

-- listenIdle()
function listenIdle(port)
	debug.log(40, "listenIdle called...")
	local conn, rawMessType, messType, rawMessage, tMessage = nil, nil, "nil", nil, {}
	debug.log(50, "nets.listenIdle()  listening...")
	conn, rawMessType, rawMessage = connection.listenIdle(port)
	
	-- preprocess messType
	messType = processMessageType(rawMessType)

	-- preprocess message --
	tMessage = processMessage(rawMessage)

	-- handle response
	debug.log(50, "Heard conn: ", conn, "messType: ", messType, " tMessage: ", tMessage)
	return conn, messType, tMessage
end

-- listenIdle()
function listen(port)
	debug.log(40, "listen called...")
	local conn, rawMessType, messType, rawMessage, tMessage = nil, nil, "nil", nil, {}
	debug.log(50, "nets.listen()  listening...")
	conn, rawMessType, rawMessage = connection.listen(port)
	
	-- preprocess messType
	messType = processMessageType(rawMessType)

	-- preprocess message --
	tMessage = processMessage(rawMessage)

	-- handle response
	debug.log(50, "Heard conn: ", conn, "messType: ", messType, " tMessage: ", tMessage)
	return conn, messType, tMessage
end
