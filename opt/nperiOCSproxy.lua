--shell.run("opt/nperiOCSproxy", conn, tMessage[2], tMessage[3], unpack(tArgs))
debug.log(30, "nperiOCSproxy called: ", ...)

local args = {...}
local conn = args[1]
local side = args[2]
local method = args[3]
local tArgs = args[4]

debug.log(40, "Calling sensor.call(", side, ",", method, ", args: ", tArgs)
local tResult = {sensor.call(side, method, unpack(tArgs))}
debug.log(40, "Sensor call complete.")

--safeSend(conn, "data", unpack(tResult))
if nperi.connections[conn] then
	debug.log(50, "Sending data; conn: ", conn, " args: ", tResult)
	nets.send(conn, "data", unpack(tResult))
else
	debug.log(1, "No connection to send!")
end