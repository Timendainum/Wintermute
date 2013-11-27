-- opt/lib/config
-- by Timendainum
---------------------------------------------------

---------------------------------------------------
-- functions
---------------------------------------------------
function readConfig(path)
	local result = { }
	if fs.exists(path) then
		print("Reading config file " .. path)
		local file = fs.open(path, "r")
		repeat
			line = file.readLine()
			if(line == nil) then
				--print("Nil line.")
			elseif str.startsWith(line, "--") then
				--print("Comment line.")
			else
				--print(line)
				local lineTable = str.seperate(line, ";")
				result[lineTable[1]] = lineTable
			end
		until line == nil
		file.close()
	else
		print("Unable to read " .. path)
	end
	return result 
end