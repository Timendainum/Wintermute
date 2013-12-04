-- opt/lib/config
-- by Timendainum
---------------------------------------------------

---------------------------------------------------
-- functions
---------------------------------------------------
function read(path)
	local result = { }
	if fs.exists(path) then
		print("Reading config file " .. path)
		local file = fs.open(path, "r")
		repeat
			line = file.readLine()
			if line == nil then
				--print("Nil line.")
			elseif string.len(line) > 2 and string.sub(line, 1, 2) == "--" then
				--print("Comment line.")
			else
				--print(line)
				local lineTable = txt.split(line, ";")
				result[lineTable[1]] = lineTable
			end
		until line == nil
		file.close()
	else
		print("Unable to read " .. path)
	end
	return result 
end