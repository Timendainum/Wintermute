-- opt/nperi/nperid
-- Forked by Timendainum
-- adapted from script by Lyqyd
---------------------------------------------------
--purpose
---------------------------------------------------
-- Update log -------------------------------------
-- 11/21/13 - forked
---------------------------------------------------
connections = {}
local port = 88


function nPeriDaemon ()
	local function safeSend(theConnection, mType, m)
		--print("Starting safeSend()")
		if connections[theConnection] then
			dataType = type(m)
			--txt.sPrint("dataType: ", dataType)
                        local tSData = { m }
       	                local result = textutils.serialize(tSData)
               	        --txt.sPrint("Sending serialized data:", result)
                       	return connection.send(theConnection, mType, result)
		else
			print("No connection to send!")
			return false
		end
	end

	while true do
		conn, messType, message = connection.listenIdle(port)
		if connections[conn] and connections[conn].status == "open" then
			if messType == "close" then
				--print("Received close.")
				connection.close(conn, disconnect, true)
				connections[conn].status = "closed"
			elseif messType == "instruction" then
				txt.sPrint("Received instruction: ", message)
				-- parse message
				local tCommand = textutils.unserialize(message)[1]
				if tCommand[1] then
					if tCommand[1] == "isPresent" then
						--print("Processing isPresent request")
						if tCommand[2] then
							safeSend(conn, "data", peripheral.isPresent(tCommand[2]))
						else
							safeSend(conn, "response", "Invalid arguments.")
						end
					elseif tCommand[1] == "getType" then
						--print("Processing getType request")
						if tCommand[2] then
							safeSend(conn, "data", peripheral.getType(tCommand[2]))
						else
							safeSend(conn, "response", "Invalid arguments.")
						end
					elseif tCommand[1] == "getMethods" then
						--print("processing getMethods request")
						if tCommand[2] then
    							safeSend(conn, "data", peripheral.getMethods(tCommand[2]))
						else
							safeSend(conn, "response", "Invalid arguments.")
						end
					elseif tCommand[1] == "call" then
						--print("processing call request")
						if tCommand[2] and tCommand[3] then
							local tArgs = { }
							for k,v in ipairs(tCommand) do
								if k > 3 then
									table.insert(tArgs, v)
								end
							end
    							safeSend(conn, "data", peripheral.call(tCommand[2], tCommand[3], unpack(tArgs)))
						else
							safeSend(conn, "response", "Invalid arguments.")
						end
					elseif tCommand[1] == "getNames" then
						--print("processing getNames request")
						safeSend(conn, "data", peripheral.getNames())
					elseif tCommand[1] == "stop" then
						print("received stop")
						return true
					else
						--print("Invalid command")
						safeSend(conn, "response", "Invalid command.")
					end
				else
					--txt.sPrint("Invalid instruction: ", message)
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