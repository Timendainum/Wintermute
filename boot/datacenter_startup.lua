-- by Timendainum
---------------------------------------------------
-- declarations
local mon = nperi.wrap("coreperi", "monitor_1")

if mon == nil then
	print("Unable to connect to monitor_1.")
	return
end

--write welcome message
mon.clear()

mon.setCursorPos(1,2)
txt.centerWrite(mon, "Wintermute Control and Storage Computer")

mon.setCursorPos(1,3)
txt.centerWrite(mon, "Take what you need, but...")

mon.setCursorPos(1,4)
txt.centerWrite(mon, "Please do not use up rare materials.")