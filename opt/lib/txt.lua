--- opt/lib/txt
-- Created by Timendainum
---------------------------------------------------
--Text tools to help making writing to monitors
--easier.
---------------------------------------------------

--centerWrite
function centerWrite(o, t)
	--Get Term size
	local x,y = o.getSize()
	local halfX = math.ceil(x/2)
	print("x: " .. tostring(x) .. " y: " .. tostring(y) .. " halfX: " .. halfX)

	--get cursor
	local cX, cY = o.getCursorPos()

	--calc center
	local halfLength = math.ceil(string.len(t)/2)
	print("halfLenth: " .. halfLength)
		
	--Set pos and write
	local newX = halfX - halfLength
	print("newX: " .. newX)

	print("x: " .. newX .. " y: " .. y ..	" Text: " .. t)
	o.setCursorPos(newX, cY)
	o.write(t)
end

function numberString(num)
	local nNumber = tonumber(num)
	local billion = 1000000000
	local million = 1000000
	local thousand = 1000
	local postfix = ""

	-- billon
	if nNumber > billion then
		nNumber = nNumber / billion
		postfix = "B"
	-- million 
	elseif nNumber > million then
		nNumber = nNumber / million
		postfix = "M"
	elseif nNumber > thousand then
		nNumber = nNumber / thousand
		postfix = "K"
	end
	nNumber = nNumber * 100
	nNumber = math.ceil(nNumber)
	nNumber = nNumber / 100
	return tostring(nNumber) .. postfix
end

function sPrint(...)
	local tArgs = {...}
	result = ""
	for k,v in ipairs(tArgs) do
		result = result .. tostring(v)
	end
	print(result)
end