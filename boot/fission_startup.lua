-- by Timendainum
---------------------------------------------------
-- -- fission_startup
------------------------------------------
-- declarations
local steamName = "rednet_cable_2"
local rodName = "rednet_cable_3"
local fuelName = "rednet_cable_4"
local redSide = "bottom"

local steam = colors.lightBlue
local rod = colors.orange
local fuel = colors.magenta

-- declarations
local mon = nil

local server = "powerperi"

-- cells indexed by cellId as number
local cells = {}
-- indexed by cellId, value as number
local cellsEnergy = {}

-- reference: cells indexed by cellId as number
local inputCellIds = {1, 2, 11, 12, 21, 22, 31, 32, 41, 42}
local outputCellIds = {9, 10, 19, 20, 29, 30, 39, 40, 49, 50}


---------------------------------------------------
local function updateFissionStoredEnergy()
	print("Updating network data")
	cellsEnergy = {}
	for key, value in ipairs(cells) do
		cellsEnergy[key] = cells[key].getEnergyStored()
		write(".")
	end
	print("done!")
end

local function getFissionStoredEnergy()
	local result = 0
	for k,v in ipairs(cellsEnergy) do
		result = result + v
	end
	return result
end

local function getFissionInputStoredEnergy()
	local result = 0
	for k,v in ipairs(inputCellIds) do
		result = result + cellsEnergy[v]
	end
	return result
end

local function getFissionOutputStoredEnergy()
	local result = 0
	for k,v in ipairs(outputCellIds) do
		result = result + cellsEnergy[v]
	end
	return result
end

------------------------------------------
-- util functions
------------------------------------------
local function getSteam()
	return colors.test(redstone.getBundledInput(redSide), steam)
end

local function setSteam(setting)
	if setting then
		redstone.setBundledOutput(redSide, colors.combine(redstone.getBundledOutput(redSide), steam))
	else
		redstone.setBundledOutput(redSide, colors.subtract(redstone.getBundledOutput(redSide), steam))
	end
end

local function getRod()
	return colors.test(redstone.getBundledInput(redSide), rod)
end

local function setRod(setting)
	if setting then
		redstone.setBundledOutput(redSide, colors.combine(redstone.getBundledOutput(redSide), rod))
	else
		redstone.setBundledOutput(redSide, colors.subtract(redstone.getBundledOutput(redSide), rod))
	end
end

local function getFuel()
	return colors.test(redstone.getBundledInput(redSide), fuel)
end

local function setFuel(setting)
	if setting then
		redstone.setBundledOutput(redSide, colors.combine(redstone.getBundledOutput(redSide), fuel))
	else
		redstone.setBundledOutput(redSide, colors.subtract(redstone.getBundledOutput(redSide), fuel))
	end
end

------------------------------------------
-- ux functions
------------------------------------------
local function uxUpdateStoredEnergy(mon)
	local e = getFissionStoredEnergy()
	local d = txt.numberString(e)
	mon.setCursorPos(1,4)
	mon.clearLine()
	mon.write("Stored Energy: " .. d)
end

local function uxUpdateInputStoredEnergy(mon)
	local e = getFissionInputStoredEnergy()
	local d = txt.numberString(e)
	mon.setCursorPos(1,5)
	mon.clearLine()
	mon.write("Input Stored Energy: " .. d)
end

local function uxUpdateOutputStoredEnergy(mon)
	local e = getFissionOutputStoredEnergy()
	local d = txt.numberString(e)
	mon.setCursorPos(1,6)
	mon.clearLine()
	mon.write("Output Stored Energy: " .. d)
end

local function uxUpdateStates(mon)
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


---------------------------------------------------
-- main program
---------------------------------------------------
-- peripherals
mon = peripheral.wrap("monitor_4")
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


-- connect to server
while not nperi.connect(server) do
	debug.log(1, "Unable to connect to ", server, ".")
	sleep(1)
end

-- build main energy cell table
print("Wrapping networked peripherals")
for x = 1, 50 do
	local name = "redstone_energy_cell_" .. tostring(x)
	
	while cells[x] == nil do
		cells[x] = nperi.wrap(server, name)
		if cells[x] == nil then
			print(name .. " is nil! <CR> to try again!")
			local junk = read()
		else
			write(".")
		end
	end
end
print(" done!")

--update mon loop
while true do
	updateFissionStoredEnergy()
	print("Updating screens.")
	uxUpdateStoredEnergy(mon)
	uxUpdateInputStoredEnergy(mon)
	uxUpdateOutputStoredEnergy(mon)

	if getFissionStoredEnergy() <= 2000000 and getFissionOutputStoredEnergy() <= 2000000 and getSteam() and not getRod() then
		setFuel(true)
	else
		setFuel(false)
	end

	uxUpdateStates(mon)
	print("..pause...")
	os.sleep(1)
end