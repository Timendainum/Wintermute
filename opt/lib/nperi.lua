-- opt/lib/nperi
-- by Timendainum
---------------------------------------------------
--purpose
---------------------------------------------------
-- Update log -------------------------------------
-- 11/24/13 - created
---------------------------------------------------
-- local declarations
---------------------------------------------
local port = 88
local timeout = 5
local serverConnection = false
local response = false
local slp = 0.0001
local maxRetrys = 3

---------------------------------------------
-- local functions
---------------------------------------------
local function safeSend(mType, m)
	if serverConnection then
		local tSData = { m }
		local result = textutils.serialize(tSData)
		--txt.sPrint("Sending serialized data: ",  result)
		return connection.send(serverConnection, mType, result)
	else
		print("No connection to send!")
		return false
	end
end

local function gatherResponse()
	--print("Awaiting result...")
        local messType, message, response, retrys = nil, nil, nil, 0
        while messType ~= "done" do
		messType, message = connection.awaitResponse(serverConnection, timeout)
		-- preprocess message --
		if message == nil then
			response = nil
		elseif string.len(message) > 2 and string.sub(message, 1, 1) == "{" and string.sub(message, -1) == "}" then
			local tResult = textutils.unserialize(message)
			if tResult[1] then
				response = tResult[1]
			else
				response = nil
			end
		else
			response = nil
		end

		-- process message
		if messType == "close" then
			--txt.sPrint("Server responded with close: ", message)
                	return false
		elseif messType == "data" then
			--txt.sPrint("Server responded with data: ", message)
			return response
		elseif messType == "response" then
			--txt.sPrint("Server responded with response: ", message)
			return false
		else
			--txt.sPrint("Unrecognized packetType: ", messType, " message: ", message)
			retrys = retrys + 1
			if retrys >= maxRetrys then
				return nil
			end
                end
	end
	return response
end

local function connectToServer(server)
	sleep(slp)
	if not serverConnection then
		-- attempt to connect
		serverConnection, response = connection.open(server, port, timeout)
	        if not serverConnection then
	                txt.sPrint("--Connection to ", server, " Failed! <CR>")
	                serverConnection, response = false, false
			return false
	        else
	                --txt.sPrint("--Connected to ", server, " Response: ", response)
			return true
	        end
	else
		--print("Server already connected!")
		return true
	end
end

local function closeConnection()
        if connection.close(serverConnection) then
		safeSend("close", "close")
                serverConnection = false
                --print("--Connection Closed.")
        else
                --print("--Could not close connection!")
        end
end

local function processArgs(...)
	return {...}
end


---------------------------------------------
-- functions
---------------------------------------------
function isPresent(server, side)
        -- declarations
        local bResult = false
 
        -- open connection
        if not connectToServer(server) then
		return false
	end

	-- request
	--print("Requesting isPresent()")
	if safeSend("instruction", processArgs("isPresent", side)) then
		bResult = gatherResponse()
	end

	-- close connection
	closeConnection()
	return bResult
end

function getType(server, side)
        -- declarations
        local sResult = false
 
        -- open connection
        if not connectToServer(server) then
		return false
       end

	-- request
	--print("Requesting getType()")
	if safeSend("instruction", processArgs("getType", side)) then
		sResult = gatherResponse()
	end

	-- close connection
	closeConnection()
	return sResult 
end

function getMethods(server,  side)
	-- declarations
	local tResult = { }

        -- open connection
        if not connectToServer(server) then
		return false
	end

	-- request
	--print("Requesting getMethods()")
	if safeSend("instruction", processArgs("getMethods", side)) then
		tResult = gatherResponse()
	end

	-- close connection
	closeConnection()
	return tResult
end

function call(server, side, method, ...)
	-- declarations
	local result = nil
	local tArgs = {...}
	local command = {"call", side, method }
	for k,v in ipairs(tArgs) do
		table.insert(command, v)
	end

        -- open connection
        if not connectToServer(server) then
		return false
	end

	-- request
	--print("Requesting call()")
	
	if safeSend("instruction", command) then
		result = gatherResponse()
	end

	-- close connection
	closeConnection()
	return result
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

        -- open connection
        if not connectToServer(server) then
		return false
	end

	-- request
	--print("Requesting getNames()")
	if safeSend("instruction", processArgs("getNames")) then
		tResult = gatherResponse()
	end

	-- close connection
	closeConnection()
	return tResult
end