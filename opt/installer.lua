-- opt/installer
-- Created by Timendainum
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

local function safePBGet(file, code)
	print("Getting " .. file .. " from pastebin...")
	fsProtect(file)
	shell.run("pastebin", "get", code, file)	
end

local function safeGHGet(file, path)
	print("Getting " .. file .. " from github...")
	fsProtect(file)
	shell.run("github", path, file)
end

---------------------------------------------------
-- main
---------------------------------------------------
print("Executing installer...")

local id = os.getComputerID()

-- download config file
print("Downloading computers config...")
safePBGet("etc/computers", "68GLky6A")

-- read config file
local configComputers = config.read("etc/computers")

print("Downloading files config...")
safePBGet("etc/files", "4gY5mnLG")

-- read config file
local configFiles = config.read("etc/files")

print("Installing...")
-- loop over files and install
for k, v in pairs(configFiles) do
	if v[2] == "pb" then
		safePBGet(v[1], v[3])
	elseif v[2] == "gh" then
		safeGHGet(v[1], v[3])
	end
end

print("Installation complete, you should reboot now.")