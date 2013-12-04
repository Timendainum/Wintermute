-- install
-- by Timendainum
---------------------------------------------------

---------------------------------------------------
-- functions
---------------------------------------------------
local function fsProtect(file)
	-- make sure path exists
	local path = string.gsub(file, fs.getName(file), "")
	if string.len(path) > 0 and not fs.isDir(path) then
			fs.makeDir(path)
	else
		-- if file exists delete it
		if fs.exists(file) then
			fs.delete(file)
		end
	end
end

local function installPre(file, path)
	print("Installing prerequisite: " .. file)
	fsProtect(file)
	shell.run("github", path, file)
end

local function installPreAPI(file, path)
	print("Installing prerequisite API: " .. file)
	installPre(file, path)
	print("Loading " .. file)
	os.loadAPI(file)
end
	
---------------------------------------------------
-- main
---------------------------------------------------
print("Installing base system...")

---------------------------------------------------
print("Installing installer perequisites...")

print("Installing github...")
local file = "github"
local code = "knix7nQp"
fsProtect(file)
shell.run("pastebin", "get", code, file) 

installPreAPI("opt/lib/txt", "Timendainum/Wintermute/master/opt/lib/txt.lua")
installPreAPI("opt/lib/config", "Timendainum/Wintermute/master/opt/lib/config.lua")

---------------------------------------------------
file = "opt/installer"
code = "Timendainum/Wintermute/master/opt/installer.lua"
installPre(file, code)

---------------------------------------------------
--Executing installer
shell.run(fullPath)