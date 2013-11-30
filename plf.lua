-- plf
-- by Timendainum
-- peripheral list functions
---------------------------------------------------
local tArgs = {...}
local tResult = {}


---------------------------------------------------
-- validate args
if not tArgs[1] then
	print("Invalid arguments.")
	print("Usage local: plf <peripheral name>")
	print("Usage local network: plf <server_label> <peripheral name>")
	return false
end

---------------------------------------------------
-- if networked peripheral
if tArgs[2] then
	tResult = nperi.getMethods(tArgs[1], tArgs[2])
else
	---------------------------------------------------
	-- local peripheral
	tResult = peripheral.getMethods(tArgs[1])
end


---------------------------------------------------
-- display result
if tResult == nil then
	print("Nil result, possibly cannot find the peripheral specified.")
else
	print(textutils.tabulate(tResult))
end
