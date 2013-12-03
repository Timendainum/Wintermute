-- cow control program

local sensor = nperi.wrap("cowsensor2", "top")
local cows = {}

local function updateCows()
	local tResults = sensor.getTargets()
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