-- opt/nperi/nperid
-- Forked by Timendainum
-- adapted from script by Lyqyd
---------------------------------------------------

---------------------------------------------------
-- declarations
connections = {}
local port = 88

---------------------------------------------------
-- functions

function nPeriDaemon ()
	local function safeSend(theConnection, mType, ...)
		debug.log(50, "safeSend called: conn:", theConnection, " mType: ", mType, "others:", ...)
		if connections[theConnection] then
			return nets.send(theConnection, mType, ...)
		else
			debug.log(1, "No connection to send!")
			return false
		end
	end

	while true do
		local conn, messType, tMessage = nets.listenIdle(port)
		debug.log(30, "Recieved wakeup...", conn, messType, unpack(tMessage))
		if connections[conn] and connections[conn].status == "open" then
			if messType == "close" then
				debug.log(20, "Received close.")
				connection.close(conn, disconnect, true)
				connections[conn].status = "closed"
			elseif messType == "instruction" then
				debug.log(30, "Received instruction: ", unpack(tMessage))
				-- parse message
				if tMessage[1] then
					if tMessage[1] == "isPresent" then
						debug.log(40, "Processing isPresent request")
						if tMessage[2] then
							safeSend(conn, "data", peripheral.isPresent(tMessage[2]))
						else
							safeSend(conn, "response", "Invalid arguments.")
						end
					elseif tMessage[1] == "getType" then
						debug.log(40, "Processing getType request")
						if tMessage[2] then
							safeSend(conn, "data", peripheral.getType(tMessage[2]))
						else
							safeSend(conn, "response", "Invalid arguments.")
						end
					elseif tMessage[1] == "getMethods" then
						debug.log(40, "processing getMethods request")
						if tMessage[2] then
    							safeSend(conn, "data", peripheral.getMethods(tMessage[2]))
						else
							safeSend(conn, "response", "Invalid arguments.")
						end
					elseif tMessage[1] == "call" then
						debug.log(40, "processing call request: ", tMessage[2], " " ,tMessage[3])
						if tMessage[2] and tMessage[3] then
							local tArgs = { }
							local bArgs = false
							for k,v in ipairs(tMessage) do
								if k > 3 then
									table.insert(tArgs, v)
									bArgs = true
								end
							end
							--[[
    						if peripheral.getType(tMessage[2]) == "sensor" then
    							print("Processing sensor call..")
   								safeSend(conn, "data", sensor.call(tMessage[2], tMessage[3], unpack(tArgs)))
    						else
    							print("Processing peripheral call..")
   								safeSend(conn, "data", peripheral.call(tMessage[2], tMessage[3], unpack(tArgs)))
    						end
    						]]--
    						if peripheral.getType(tMessage[2]) == "sensor" then
    							debug.log(40, "Processing sensor call..")
    							if bArgs then
    								safeSend(conn, "data", sensor.call(tMessage[2], tMessage[3], unpack(tArgs)))
    							else
    								safeSend(conn, "data", sensor.call(tMessage[2], tMessage[3]))
    							end
    						else
    							debug.log(40, "Processing peripheral call..")
    							if bArgs then
    								safeSend(conn, "data", peripheral.call(tMessage[2], tMessage[3], unpack(tArgs)))
    							else
    								safeSend(conn, "data", peripheral.call(tMessage[2], tMessage[3]))
    							end
    						end
    						
						else
							debug.log(40, "invalid arguments")
							safeSend(conn, "response", "Invalid arguments.")
						end
					elseif tMessage[1] == "getNames" then
						debug.log(40, "processing getNames request")
						safeSend(conn, "data", peripheral.getNames())
					elseif tMessage[1] == "stop" then
						debug.log(40, "received stop")
						return true
					else
						debug.log(40, "Invalid command")
						safeSend(conn, "response", "Invalid command.")
					end
				else
					
					debug.log(30, "Invalid instruction: ", unpack(tMessage))
					safeSend(conn, "response", "Invalid instruction.")
				end
			end
			safeSend(conn, "done", "ready")
		elseif messType == "query" then
				debug.log(20, "Received connection request.")
				local connect = {}
				connect.status = "open"
				connect.name = connection.name(conn)
				table.insert(connections, conn, connect)
				safeSend(conn, "response", "ready")
		end
		term.restore()
	end
end

net.daemonAdd("nperid", nPeriDaemon , port)