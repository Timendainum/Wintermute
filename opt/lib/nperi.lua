-- opt/lib/nperi
-- by Timendainum
---------------------------------------------------

-- local declarations
---------------------------------------------
local port = 88
local timeout = 5
local serverConnections = {}
local response = false
local slp = 0.0001
local maxRetrys = 3

---------------------------------------------
-- local functions
---------------------------------------------
local function connectToServer(server)
	sleep(slp)
	if not serverConnections[server] then
		--txt.sPrint("Attempting to connect to ", server, " on port ", port)
		-- attempt to connect
		local myConn, response = connection.open(server, port, timeout)
		if not myConn then
			txt.sPrint("--Connection to ", server, " Failed!")
			serverConnections[server], response = false, false
			return false
		else
			--txt.sPrint("--Connected to ", server, " Response: ", response)
			serverConnections[server] = myConn
			return true
		end
	else
		--print("Server already connected!")
		return true
	end
end

local function safeSend(server, mType, ...)
	if connectToServer(server) then
		return nets.send(serverConnections[server], mType, ...)
	else
		return false
	end
end

local function gatherResponse(server)
	--print("Awaiting result...")
	local messType, tMessage = nil, nil, nil
	messType, tMessage = nets.awaitResponse(serverConnections[server], timeout)

	-- preprocess message --
	if tMessage == nil then
		tMessage = { nil }
	end

	-- process message
	if messType == "close" then
		-- close
		txt.sPrint("Server responded with close: ", tMessage[1])
		return false
	elseif messType == "data" then
		-- data
		txt.sPrint("Server responded with data: ", tMessage[1])
		return unpack(tMessage)
	elseif messType == "response" then
		-- response
		txt.sPrint("Server responded with response: ", tMessage[1])
		return false
	else
		-- anything else - invalid response
		return false
	end
end



local function closeConnection(server)
	if connection.close(serverConnections[server]) then
		safeSend(server, "close", "close")
		serverConnection = false
		--print("--Connection Closed.")
		return true
	else
		--print("--Could not close connection!")
		return false
	end
end

---------------------------------------------
-- functions
---------------------------------------------

function closeAllConnections()
	for k,v in pairs(serverConnections) do
		closeConnection(k)
	end
end

function isPresent(server, side)
	-- declarations
	local bResult = false

	-- request
	--print("Requesting isPresent()")
	if safeSend(server, "instruction", "isPresent", side) then
		bResult = gatherResponse(server)
	end

	return bResult
end

function getType(server, side)
	-- declarations
	local sResult = false

	-- request
	--print("Requesting getType()")
	if safeSend(server, "instruction", "getType", side) then
		sResult = gatherResponse(server)
	end
	
	return sResult
end

function getMethods(server,  side)
	-- declarations
	local tResult = { }

	-- request
	--print("Requesting getMethods()")
	if safeSend(server, "instruction", "getMethods", side) then
		tResult = gatherResponse(server)
	end

	return tResult
end

function call(server, side, method, ...)
	-- declarations
	local result = nil

	-- request
	--print("Requesting call()")
	if safeSend(server, "instruction", "call", side, method, ...) then
		result = { gatherResponse(server) }
	else
		return nil
	end

	return unpack(result)
end

function wrap(server,  side)
	if isPresent(server, side) then
		local tMethods = getMethods(server, side)
		local tResult  = { }
		for n,method in ipairs(tMethods) do
			tResult[method] = function(...)
				return call(server, side, method, ...)
			end
		end
		return tResult
	end
	return nil
end

function getNames(server)
	-- declarations
	local tResult = { }

	-- request
	--print("Requesting getNames()")
	if safeSend(server, "instruction", "getNames") then
		tResult = gatherResponse(server)
	end

	return tResult
end