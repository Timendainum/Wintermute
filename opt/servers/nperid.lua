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
		if connections[theConnection] then
			return nets.send(theConnection, mType, ...)
		else
			print("No connection to send!")
			return false
		end
	end

	while true do
		local conn, messType, tMessage = nets.listenIdle(port)
		--txt.sPrint("Recieved wakeup...", conn, messType, unpack(tMessage))
		if connections[conn] and connections[conn].status == "open" then
			if messType == "close" then
				--print("Received close.")
				connection.close(conn, disconnect, true)
				connections[conn].status = "closed"
			elseif messType == "instruction" then
				--txt.sPrint("Received instruction: ", unpack(tMessage))
				-- parse message
				if tMessage[1] then
					if tMessage[1] == "isPresent" then
						--print("Processing isPresent request")
						if tMessage[2] then
							safeSend(conn, "data", peripheral.isPresent(tMessage[2]))
						else
							safeSend(conn, "response", "Invalid arguments.")
						end
					elseif tMessage[1] == "getType" then
						--print("Processing getType request")
						if tMessage[2] then
							safeSend(conn, "data", peripheral.getType(tMessage[2]))
						else
							safeSend(conn, "response", "Invalid arguments.")
						end
					elseif tMessage[1] == "getMethods" then
						--print("processing getMethods request")
						if tMessage[2] then
    							safeSend(conn, "data", peripheral.getMethods(tMessage[2]))
						else
							safeSend(conn, "response", "Invalid arguments.")
						end
					elseif tMessage[1] == "call" then
						--print("processing call request")
						if tMessage[2] and tMessage[3] then
							local tArgs = { }
							for k,v in ipairs(tMessage) do
								if k > 3 then
									table.insert(tArgs, v)
								end
							end
    						if peripheral.getType() == "sensor" then
    							safeSend(conn, "data", sensor.call(tMessage[2], tMessage[3], unpack(tArgs)))
    						else
    							safeSend(conn, "data", peripheral.call(tMessage[2], tMessage[3], unpack(tArgs)))
    						end
						else
							safeSend(conn, "response", "Invalid arguments.")
						end
					elseif tMessage[1] == "getNames" then
						--print("processing getNames request")
						safeSend(conn, "data", peripheral.getNames())
					elseif tMessage[1] == "stop" then
						print("received stop")
						return true
					else
						print("Invalid command")
						safeSend(conn, "response", "Invalid command.")
					end
				else
					txt.sPrint("Invalid instruction: ", unpack(tMessage))
					safeSend(conn, "response", "Invalid instruction.")
				end
			end
			safeSend(conn, "done", "ready")
		elseif messType == "query" then
				--print("received query")
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