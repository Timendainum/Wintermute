-- startup
-- by Timendainum
---------------------------------------------------
--purpose
---------------------------------------------------
-- Update log -------------------------------------
-- 11/21/13 - created
---------------------------------------------------

----------------------------------------
-- declarations
local id = tostring(os.getComputerID())

----------------------------------------
-- boot sequence
shell.run("id")

----------------------------------------
-- load apis
print("Loading base APIs...")
shell.run("boot/apiloader", nil)

----------------------------------------
-- read config file
configComputers = config.readConfig("/etc/computers")
--textutils.pagedTabulate(configComputers)
thisConfig = { }

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
if thisConfig[3] ~= nil and str.contains(tostring(thisConfig[3]), "router") then
	print("Starting routing...")
	shell.run("routed")
end

net.netInit()
print("Network initialized.")


----------------------------------------
--conditional based on computer
-- load peripheral api
if thisConfig[4] ~= nil and string.len(thisConfig[4]) > 0  then
	print("Loading computer specific peri API... " .. thisConfig[4])
	if fs.exists(thisConfig[5]) then  
		os.loadAPI(thisConfig[4])
	else
		print("Unable to find " .. thisConfig[4])
	end
end

----------------------------------------
-- start additional daemons
print("Starting fsd...")
shell.run("/opt/fileserver/fsd")

--if the computer is a nperi server
if thisConfig[3] ~= nil and str.contains(thisConfig[3], "nperi") then
	print("Starting nperid...")
	shell.run("opt/nperi/nperid")
end

-- run server startup script
if thisConfig[5] ~= nil and string.len(thisConfig[5]) > 0 then
	print("Running computer specific startup... " .. thisConfig[5])
	if fs.exists(thisConfig[5]) then
		shell.run(thisConfig[5])
	else
		print("Unable to find " .. thisConfig[5])
	end
end