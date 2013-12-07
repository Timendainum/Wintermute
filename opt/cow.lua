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
			if v.Name == "Cow" then
				cows[k] = v
			end
		end
	else
		debug.log(1, "Unable to update cows, sensor result nil.")
	end
end

-- returns total, adults, children
local function countCows()
	local total, adults, children = 0, 0, 0
	if cows ~= nil then
		local result = 0
		for k,v in pairs(cows) do
			total = total + 1
			local details = cowSensor.getTargetDetails(k)
			if details ~= nil then
				if details.IsChild then
					children = children + 1
				else
					adults = adults + 1
				end
			end
		end
	end
	return total, adults, children
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
	local total, adults, children = countCows()
	
	debug.log(20, "There are ", tostring(total), " cows in the farm, " .. adults .. " are adults and " .. children .. " are children.")
	
	--logic
	if total >= 100 then
		if adults > 50 then
			setSetting(switches.spawner, false)
			setSetting(switches.breeder, false)
			setSetting(switches.vet, false)
			setSetting(switches.rancher, true)
			setSetting(switches.grinder, true)
			setSetting(switches.slaughter, true)	
		else
			setSetting(switches.spawner, false)
			setSetting(switches.breeder, false)
			setSetting(switches.vet, false)
			setSetting(switches.rancher, true)
			setSetting(switches.grinder, false)
			setSetting(switches.slaughter, false)	
		end
	elseif total >= 10 then
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