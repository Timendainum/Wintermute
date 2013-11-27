-- by Timendainum
---------------------------------------------------
-- -- fission_startup
------------------------------------------
-- declarations
local mon = peri.monitor
local steamName = "rednet_cable_2"
local rodName = "rednet_cable_3"
local fuelName = "rednet_cable_4"
local redSide = "bottom"

local steam = colors.lightBlue
local rod = colors.orange
local fuel = colors.magenta


------------------------------------------
-- util functions
------------------------------------------
function getSteam()
	return colors.test(redstone.getBundledInput(redSide), rod)
end

function setSteam(setting)
	if setting then
		redstone.setBundledOutput(redSide, colors.combine(redstone.getBundledOutput(redSide), steam))
	else
		redstone.setBundledOutput(redSide, colors.subtract(redstone.getBundledOutput(redSide), steam))
	end
end

function getRod()
	return colors.test(redstone.getBundledInput(redSide), rod)
end

function setRod(setting)
	if setting then
		redstone.setBundledOutput(redSide, colors.combine(redstone.getBundledOutput(redSide), rod))
	else
		redstone.setBundledOutput(redSide, colors.subtract(redstone.getBundledOutput(redSide), rod))
	end
end

function getFuel()
	return colors.test(redstone.getBundledInput(redSide), fuel)
end

function setFuel(setting)
	if setting then
		redstone.setBundledOutput(redSide, colors.combine(redstone.getBundledOutput(redSide), fuel))
	else
		redstone.setBundledOutput(redSide, colors.subtract(redstone.getBundledOutput(redSide), fuel))
	end
end

------------------------------------------
-- ux functions
------------------------------------------
function uxUpdateStoredEnergy(mon)
	local e = peri.getFissionStoredEnergy()
	local d = txt.numberString(e)
	mon.setCursorPos(1,4)
	mon.clearLine()
	mon.write("Stored Energy: " .. d)
end

function uxUpdateInputStoredEnergy(mon)
	local d = txt.numberString(peri.getFissionInputStoredEnergy())
	mon.setCursorPos(1,5)
	mon.clearLine()
	mon.write("Input Stored Energy: " .. d)
end

function uxUpdateOutputStoredEnergy(mon)
	local d = txt.numberString(peri.getFissionOutputStoredEnergy())
	mon.setCursorPos(1,6)
	mon.clearLine()
	mon.write("Output Stored Energy: " .. d)
end

function uxUpdateStates(mon)
	mon.setCursorPos(1,9)
	mon.clearLine()
	mon.write("Steam:" .. tostring(getSteam()))
	mon.setCursorPos(1,10)
	mon.clearLine()  
	mon.write("Control Rod:" .. tostring(getRod()))
	mon.setCursorPos(1,11)
	mon.clearLine()  
	mon.write("Fuel:" .. tostring(getFuel()))
end

------------------------------------------
-- main program
------------------------------------------


-- monitor setup
x, y = mon.getSize()
print("Monitor Size: " .. x .. ", " .. y)

mon.clear()
mon.setCursorPos(1,1)
txt.centerWrite(mon, "Fission Reactor Control")
mon.setCursorPos(1,2)
mon.write("---------------------------------------")
mon.setCursorPos(1,8)
mon.clearLine()
mon.write("---------------------------------------")

--update mon loop


while 1 do
	peri.updateFissionStoredEnergy()
	print("Updating screens.")
	uxUpdateStoredEnergy(mon)
	uxUpdateInputStoredEnergy(mon)
	uxUpdateOutputStoredEnergy(mon)

	if peri.getFissionStoredEnergy() == 0 and getSteam() and not getRod() then
		setFuel(true)
	else
		setFuel(false)
	end

	uxUpdateStates(mon)
	print("..pause...")
	os.sleep(1)
end