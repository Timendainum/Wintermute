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
	print("")
end

---------------------------------------------------
-- if networked peripheral
if tArgs[2] then
	tResult = nperi.getMethods(tArgs[1], tArgs[2])
else
	---------------------------------------------------
	-- local peripheral
	tResult = peripheral.(tArgs[1])
end


---------------------------------------------------
-- display result
if tResult == nil then
	print("Nil result, possibly cannot find the peripheral specified.")
else
	print(textutils.tabulate(tResult))
end
