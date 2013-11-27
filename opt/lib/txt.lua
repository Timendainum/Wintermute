--- opt/lib/txt
-- Created by Timendainum
---------------------------------------------------
--Text tools to help making writing to monitors
--easier.
---------------------------------------------------
-- Update log -------------------------------------
-- 11/17/13 - added newLine function
---------------------------------------------------


--centerWrite
function centerWrite(o, t)
  --Get Term size
  local x,y = o.getSize()
  local halfX = math.ceil(x/2)
  print("x: " .. x .. " y: " .. y .. " halfX: " .. halfX)

  --get cursor
  local cX, cY = o.getCursorPos()

  --calc center
  local halfLength = math.ceil(string.len(t)/2)
  print("halfLenth: " .. halfLength)
    
  --Set pos and write
  local newX = halfX - halfLength
  print("newX: " .. newX)

  print("x: " .. newX .. " y: " .. y ..  " Text: " .. t)
  o.setCursorPos(newX, cY)
  o.write(t)
end

function numberString(num)
	local x = tonumber(num)
	local billion = 1000000000
	local million = 1000000
	local thousand = 1000

	-- billon
	if x > billion then
		x = x / billion .. "B"
	-- million 
	elseif x > million then
		x = x / million .. "M"
	elseif x > thousand then
		x = x / thousand .. "K"
	end
	return string.format("%.2f", x)
end

function sPrint(...)
	local tArgs = {...}
	result = ""
	for k,v in ipairs(tArgs) do
		result = result .. tostring(v)
	end
	print(result)
end