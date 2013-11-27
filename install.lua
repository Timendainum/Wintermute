-- install
-- by Timendainum
---------------------------------------------------

---------------------------------------------------
-- functions
---------------------------------------------------
function fsProtect(path, file)
	-- make sure path exists
	if (string.len(path) > 0) and not fs.isDir(path) then
			fs.makeDir(path)
	else
		-- if file exists delete it
		if fs.exists(path .. file) then
			fs.delete(path .. file)
		end
	end
end

function installPre(path, file, code)
	local fullPath = path .. file
	print("Installing " .. fullPath)
	fsProtect(path, file)
	shell.run("github", fullPath, code)
	print("Loading " .. fullPath)
	os.loadAPI(fullPath)
end
	
---------------------------------------------------
-- main
---------------------------------------------------
print("Installing base system...")

---------------------------------------------------
print("Installing installer perquisites...")

local path = "/"
local file = "github"
local fullPath = path .. file
local code = "knix7nQp"
fsProtect(path, file)
shell.run("pastebin", "get", code, fullPath) 

installPre("/opt/lib/", "str", "Timendainum/Wintermute/master/opt/lib/str.lua")
installPre("/opt/lib/", "config", "Timendainum/Wintermute/master/opt/lib/config.lua")

---------------------------------------------------
print("Installing installer...")
path = "/opt/"
file = "installer"
fullPath = path .. file
code = "Timendainum/Wintermute/master/opt/installer.lua"
installPre(path, file, code)

---------------------------------------------------
--Executing installer
shell.run(fullPath)