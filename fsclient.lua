-- fsclient
-- by Lyqyd
-- Forked by Timendainum
---------------------------------------------------
--purpose
---------------------------------------------------
-- Update log -------------------------------------
-- 11/21/13 - forked
---------------------------------------------------
local tArgs = {...}
local port = 21

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

local tNetShellHistory = {}
local serverConnection = false
local remoteDir = false
if tArgs[1] then
	serverConnection, remoteDir = connection.open(tArgs[1], port, 2)
	if not serverConnection then print("Connection Failed!") else print("Connected to "..tArgs[1]..".") end
	if remoteDir then remoteDir = string.match(remoteDir, ";(.*)") end
end
while true do
	if remoteDir then write(remoteDir.."> ") else write("fsclient: ") end
	local sLine = read(nil, tNetShellHistory)
	table.insert( tNetShellHistory, sLine )
	local commandArgs = {}
	for match in string.gmatch(sLine, "[^ \t]+") do
		table.insert( commandArgs, match )
	end
	if commandArgs[1] == "open" then
		if commandArgs[2] then
			serverConnection, remoteDir = connection.open(commandArgs[2], port, 2)
			if not serverConnection then print("Connection Failed!") else print("Connected to "..string.match(sLine, "open (.*)")..".") end
		else
			print("No server specified!")
		end
	elseif commandArgs[1] == "get" then
		if #commandArgs < 3 then
			print("Usage: get <remote file> <local file>")
		else
			local success = netfile.get(serverConnection, commandArgs[2], commandArgs[3], 4)
			if success then print("Transfer Successful.") else print("Transfer Failed.") end
		end
	elseif commandArgs[1] == "put" then
		if #commandArgs < 3 then
			print("Usage: put <local file> <remote file>")
		else
			local success = netfile.put(serverConnection, commandArgs[2], commandArgs[3], 4)
			if success then print("Transfer Successful.") else print("Transfer Failed.") end
		end
	elseif commandArgs[1] == "close" then
		if connection.close(serverConnection) then
			serverConnection = false
			print("Connection Closed.")
		else
			print("Could not close connection!")
		end
	elseif commandArgs[1] == "exit" then
		if serverConnection then connection.close(serverConnection) end
		return
	elseif commandArgs[1] == "cd" then
		if #commandArgs < 2 then
			print("Usage: cd <directory>")
		else
			connection.send(serverConnection, "data", sLine)
			remoteDir = gatherResponse(serverConnection)
		end
	elseif commandArgs[1] == "cp" then
		if #commandArgs < 3 then
			print("Usage: cp <file> <destination>")
		else
			connection.send(serverConnection, "fileCopy", commandArgs[2].." "..commandArgs[3])
			remoteDir = gatherResponse(serverConnection)
		end
	elseif commandArgs[1] == "ls" then
		if #commandArgs < 2 then
			connection.send(serverConnection, "fileList", "ls")
			remoteDir = gatherResponse(serverConnection)
		else
			connection.send(serverConnection, "fileList", "ls "..commandArgs[2])
			remoteDir = gatherResponse(serverConnection)
		end
	elseif commandArgs[1] == "mkdir" then
		if #commandArgs < 2 then
			print("Usage: mkdir <directory>")
		else
			connection.send(serverConnection, "fileMakeDirectory", commandArgs[2])
			remoteDir = gatherResponse(serverConnection)
		end
	elseif commandArgs[1] == "mv" then
		if #commandArgs < 3 then
			print("Usage: mv <file> <destination>")
		else
			connection.send(serverConnection, "fileMove", commandArgs[2].." "..commandArgs[3])
			remoteDir = gatherResponse(serverConnection)
		end
	elseif commandArgs[1] == "rm" then
		if #commandArgs < 2 then
			print("Usage: rm <file>")
		else
			connection.send(serverConnection, "fileDelete", commandArgs[2])
			remoteDir = gatherResponse(serverConnection)
		end
	else
		print("Invalid command.")
		print("Commands:")
		print("Usage: open <server name>")
		print("Usage: get <remote file> <local file>")
		print("Usage: put <local file> <remote file>")
		print("Usage: close")
		print("Usage: exit")
		print("Usage: cd <directory>")
		print("Usage: cp <file> <destination>")
		print("Usage: ls")
		print("Usage: mkdir <directory>")
		print("Usage: mv <file> <destination>")
		print("Usage: rm <file>")
	end
end