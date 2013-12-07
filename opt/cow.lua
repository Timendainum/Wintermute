--0 white
--1 orange
--2 magenta
--3 lightBlue
--4 yellow
--5 lime
--6 pink
--7 gray
--8 lightGray
--9 cyan
--10 purple
--11 blue
--12 brown
--13 green
--14 red
--15 black

-- cow control program
local server = "cowsensor2"
local side = "top"
local redSide = "left"
local cowSensor = nperi.wrap(server, side)
local mon = peripheral.wrap("monitor_7")

local cows = {}
local switches = {}
switches.spawner = colors.orange
switches.breeder = colors.magenta
switches.vet = colors.lightBlue
switches.rancher = colors.yellow
switches.grinder = colors.lime
switches.slaughter = colors.pink


local function updateCows()
	debug.log(30, "Updating cows...")
	local tResults = cowSensor.getTargets()
	if tResults ~= nil then
		cows = {}
		for k,v in pairs(tResults) do
			if type(k) == "string" and string.len(k) > 3 and string.sub(k, 1, 3) == "Cow" then
				cows[k] = v
			end
		end
	else
		debug.log(1, "Unable to update cows, sensor result nil.")
	end
end

local function countCows()
	if cows == nil then
		return 0
	else
		local result = 0
		for k,v in pairs(cows) do
			result = result + 1
		end
		return result 
	end
end

local function getSetting(color)
	return colors.test(redstone.getBundledInput(redSide), color)
end

local function setSetting(color, setting)
	if setting then
		redstone.setBundledOutput(redSide, colors.combine(redstone.getBundledOutput(redSide), color))
	else
		redstone.setBundledOutput(redSide, colors.subtract(redstone.getBundledOutput(redSide), color))
	end
end

------------------------------------------
-- Main

-- Default switch settings:
for k,v in ipairs(switches) do
	setSetting(v, false)
end

-- 29, 12
mon.clear()
mon.setCursorPos(1,1)
txt.centerWrite(mon, "Cow Breeder Control")
mon.setCursorPos(1,2)
mon.write("--Data-----------------------")
mon.setCursorPos(1,4)
mon.write("--Settings-------------------")

while true do
	updateCows()
	local cowCount = tonumber(countCows())
	debug.log(20, "There are ", cowCount, " cows in the farm.")
	
	--logic
	if cowCount >= 100 then
		setSetting(switches.spawner, false)
		setSetting(switches.breeder, false)
		setSetting(switches.vet, false)
		setSetting(switches.rancher, true)
		setSetting(switches.grinder, true)
		setSetting(switches.slaughter, true)
	elseif cowCount >= 10 then
		setSetting(switches.spawner, false)
		setSetting(switches.breeder, true)
		setSetting(switches.vet, false)
		setSetting(switches.rancher, false)
		setSetting(switches.grinder, false)
		setSetting(switches.slaughter, false)
	else
		setSetting(switches.spawner, true)
		setSetting(switches.breeder, true)
		setSetting(switches.vet, true)
		setSetting(switches.rancher, false)
		setSetting(switches.grinder, false)
		setSetting(switches.slaughter, false)
	end
		
	
	-- update screen
	mon.setCursorPos(5,3)
	mon.clearLine()
	mon.write("Cows:      " .. tostring(cowCount))

	mon.setCursorPos(5, 5)
	mon.clearLine()
	mon.write("Spawner:   " .. tostring(getSetting(switches.spawner)))
	mon.setCursorPos(5, 6)
	mon.clearLine()
	mon.write("Breeder:   " .. tostring(getSetting(switches.breeder)))
	mon.setCursorPos(5, 7)
	mon.clearLine()
	mon.write("Vet:       " .. tostring(getSetting(switches.vet)))
	mon.setCursorPos(5, 8)
	mon.clearLine()
	mon.write("Rancher:   " .. tostring(getSetting(switches.rancher)))
	mon.setCursorPos(5, 9)
	mon.clearLine()
	mon.write("Grinder:   " .. tostring(getSetting(switches.grinder)))
	mon.setCursorPos(5, 10)
	mon.clearLine()
	mon.write("Slaughter: " .. tostring(getSetting(switches.slaughter)))
	
	sleep(1)
end