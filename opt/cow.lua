-- cow control program

local cowSensor = nperi.wrap("cowsensor2", "top")
local cows = {}

local function updateCows()
	local tResults = nperi.call("cowsensor2", "top", "getTargets")
	if tResult ~= nil then
		cows = {}
		for k,v in pairs do
			if type(k) == "string" and string.len(k) > 3 and string.sub(k, 1, 3) == "Cow" then
				cows[k] = v
			end
		end
	else
		print("Unable to update cows, sensor result nil.")
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

--
while true do
	updateCows()
	txt.sPrint("There are ", countCows(), " cows in the farm.")
end






-- test
txt.sPrint("IsPresent: ", peripheral.isPresent("top"))
local p = sensor.wrap("top")
txt.sPrint("Wrap: ", p)
local tm = peripheral.getMethods("top")
if tm ~= nil then
	textutils.tabulate(tm)
else
	print("getMethods nil")
end

local tt = p.getTargets()

txt.sPrint(tt)

if tt ~= nil then
	print(textutils.serialize(tt))
else
	print("getMethods nil")
end







