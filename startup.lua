-- startup
-- by Timendainum
---------------------------------------------------

----------------------------------------
-- declarations
local id = tostring(os.getComputerID())
-- global configs
configComputers = {}
configFiles = {}

----------------------------------------
-- boot sequence
shell.run("id")

----------------------------------------
-- load apis
print("Loading base APIs...")
shell.run("boot/apiloader", nil)

----------------------------------------
-- read config file
configComputers = config.read("etc/computers")
configFiles = config.read("etc/files")
local thisConfig = { }

----------------------------------------
-- label computer
if configComputers[id] ~= nil then
	thisConfig = configComputers[id]
	os.setComputerLabel(thisConfig[2])
	print("Computer label: " .. os.getComputerLabel())
else
	print("ERROR: No computer label set!")
end

----------------------------------------
--start network
print("Starting Network...")
shell.run("modread")
shell.run("netd")

--if the computer is a router
if thisConfig[3] ~= nil and string.find(tostring(thisConfig[3]), "router") then
	print("Starting routing...")
	shell.run("routed")
end

net.netInit()
print("Network initialized.")


----------------------------------------
-- start additional daemons
print("Starting fsd...")
shell.run("/opt/servers/fsd")

--if the computer is a nperi server
if thisConfig[3] ~= nil and string.find(thisConfig[3], "nperi") then
	print("Starting nperid...")
	shell.run("opt/servers/nperid")
end

-- run server startup script
if thisConfig[4] ~= nil and string.len(thisConfig[4]) > 0 then
	print("Running computer specific startup... " .. thisConfig[4])
	if fs.exists(thisConfig[4]) then
		shell.run(thisConfig[4])
	else
		print("Unable to find " .. thisConfig[5])
	end
end