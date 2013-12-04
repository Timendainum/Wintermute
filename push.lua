-- opt/netupdate/push
-- by Timendainum
-- based on script by Lyqyd
---------------------------------------------------
-- automated fsclient
---------------------------------------------------
-- declaraions
local tArgs = {...}
local port = 21
local timeout = 5
local slp = 0.01
--read files config
local files = config.read("etc/files")
---------------------------------------------------
-- functions
---------------------------------------------------
local function gatherResponse(conn)
        local messType, message = nil, nil
                while messType ~= "done" do
                        messType, message = connection.awaitResponse(conn)
                        if messType == "close" then
                                print("Connection closed by server.")
                                return
                        elseif messType == "data" then
                                if string.sub(message, 1, 2) == "p;" then
                                        message = string.match(message, ";(.*)")
                                        if message ~= "\n" then print(message) end
                                elseif string.sub(message, 1, 2) == "t;" then
                                        message = string.sub(message, 3)
                                        local result = {}
                                        for s in string.gmatch(message, "(.-);") do
                                                table.insert(result, s)
                                        end
                                        textutils.pagedTabulate(result)
                                end
                        else
                        end
                end
        return message
end

local function pushUpdateToServer(serverLabel)
	sleep(slp)
	--test for updating self
	if serverLabel == os.getComputerLabel() then
		print("Cannot push to self. Skipping " .. serverLabel .. ".")
		return
	end

	-- declarations
	local serverConnection = false
	local remoteDir = false

	
	--open server connection
	serverConnection, remoteDir = connection.open(serverLabel, port, timeout)
        if not serverConnection then
		print("--Connection to " .. serverLabel .. " Failed! <CR>")
		local junk = read()
		return
	else
		print("--Connected to ".. serverLabel .." Path: ".. remoteDir)
	end

	-- loop over files list and update files
	write("Sending files to " .. serverLabel .. ".")
	for k, v in pairs(files) do
		sleep(slp)
		local path = shell.resolve(str.replace(v[1], fs.getName(v[1]), ""))
		local fullPath = shell.resolve(v[1])
		--try to create remote directory
		-- (this will happen a lot, may want to detect for it and create it conditionally)
		if path ~= "/" and path ~= "" then
			write("m")
			connection.send(serverConnection, "fileMakeDirectory", path)
                        remoteDir = gatherResponse(serverConnection)
		end
		-- put the file
		local success = false
		local retrys = 1
		while not success do
			write("s")
			success = netfile.put(serverConnection, fullPath, fullPath, timeout)
			if retrys > 3 then
				break
			end
			
			if not success then
				retrys = retrys + 1
				sleep(slp)
			end
		end
		if success then
			write(".")
		else
			write("failed. <CR>")
			local junk = read()
			return
		end
	end
	print("success!")

	--close server connection
	if connection.close(serverConnection) then
		serverConnection = false
		print("--Connection Closed.")
	else
		print("--Could not close connection!")
	end
end

local function sendRebootToServer(serverLabel)
	sleep(slp)
	--test for updating self
	if serverLabel == os.getComputerLabel() then
		print("Cannot push to self. Skipping " .. serverLabel .. ".")
		return
	end

	-- declarations
	local serverConnection = false
	local remoteDir = false

	
	--open server connection
	serverConnection, remoteDir = connection.open(serverLabel, port, timeout)
        if not serverConnection then
		print("--Connection to " .. serverLabel .. " Failed! <CR>")
		local junk = read()
		return
	else
		print("--Connected to ".. serverLabel .." Path: ".. remoteDir)
	end
	
	print("Sending reboot command to " .. serverLabel .. ".")
	connection.send(serverConnection, "instruction", "reboot")

	--close server connection
	if connection.close(serverConnection) then
		serverConnection = false
		print("--Connection Closed.")
	else
		print("--Could not close connection!")
	end
end

---------------------------------------------------
-- main
---------------------------------------------------

if tArgs[1] == "all" then
	write("Are you sure you wish to push updates to all servers? (y/N)")
	local confirm = read()
	if confirm == "y" then
		for k,v in pairs(configComputers) do
			pushUpdateToServer(v[2])
		end
		print("Updates complete, sending reboot commands.")
		for k,v in pairs(configComputers) do
			sendRebootToServer(v[2])
		end
		print("Complete.")
	end
elseif tArgs[1] then
	write("Are you sure you wish to push updates to ")
	for k,v in pairs(tArgs) do
		write(" " .. v)
	end
	write("? (y/N)")
	local confirm = read()
	if confirm == "y" then
		for k,v in pairs(tArgs) do
			pushUpdateToServer(v)
		end
		print("Updates complete, sending reboot commands.")
		for k,v in pairs(tArgs) do
			sendRebootToServer(v)
		end
		print("Complete.")
	end
else
	print("Usage: push all")
	print("Pushes updates to all servers, except this one.")
	print("Usage: push <serverLabel> ...")
	print("Pushes updates to server(s) listed in arguments.")
end