-- opt/fileserver/fsd
-- by Lyqyd
-- Forked by Timendainum
---------------------------------------------------
connections = {}
local port = 21

function netWrite(text)
	connection.send(conn, "data", "p;"..text)
end

function netPagedTabulate(...)
	local tTables = {...}
	for n, tCurr in pairs(tTables) do
		table.sort(tCurr)
		local string = "t;"
		for i=1, #tCurr do
			string = string..table.remove(tCurr, 1)..";"
		end
		connection.send(conn, "data", string)
	end
end

function fileDaemon ()
	while true do
		conn, messType, message = connection.listenIdle(port)
		--term.redirect(connection.text(conn))
		if connections[conn] and connections[conn].status == "open" then
			localDir = shell.dir()
			shell.setDir(connections[conn].directory)
			if messType == "data" then 
				local commandArgs = {}
				for match in string.gmatch(message, "[^ \t]+") do
					table.insert(commandArgs, match)
				end
				if commandArgs[1] == "cd" then
					if #commandArgs < 2 then
						netWrite("Usage: cd <path>")
					else
						local sNewDir = shell.resolve(commandArgs[2])
						if fs.isDir(sNewDir) then
							connections[conn].directory = sNewDir
							shell.setDir(sNewDir)
						else
							netWrite("Not a directory")
						end
					end
				end
			elseif messType == "fileList" then
				local sDir = connections[conn].directory
				if string.len(message) > 2 then
					sDir = shell.resolve(string.match(message, "ls (.*)"))
				end
				local tAll = fs.list(sDir)
				local tFiles = {}
				local tDirs = {}
				for n, sItem in pairs(tAll) do
					if string.sub(sItem, 1, 1) ~= "." then
						local sPath = fs.combine(sDir, sItem)
						if fs.isDir(sPath) then
							table.insert(tDirs, sItem)
						else
							table.insert(tFiles, sItem)
						end
					end
				end
				table.sort(tDirs)
				table.sort(tFiles)
				netPagedTabulate(tDirs, tFiles)
			elseif messType == "fileStatus" then
				local path = shell.resolve(message)
				local exists = fs.exists(path)
				local isDir = fs.isDir(path)
				local readOnly = fs.isReadOnly(path)
				local size = fs.getSize(path)
				local string = ""
				if exists then string = string.."e;" end
				if isDir then string = string.."d;" end
				if readOnly then string = string.."r;" end
				if size then string = string.."s;"..size end
				connection.send(conn, "fileInformation", string)
			elseif messType == "fileCopy" or messType == "fileMove" then
				source, dest = string.match(message, "(%w+) (%w+)")
				source = shell.resolve(source)
				dest = shell.resolve(dest)
				if fs.exists(dest) and fs.isDir(dest) then
					dest = fs.combine(dest, fs.getName(source))
				end
				if messType == "fileCopy" then
					fs.copy(source, dest)
				else
					fs.move(source, dest)
				end
			elseif messType == "fileMakeDirectory" or messType == "fileDelete" then
				local path = shell.resolve(message)
				if messType == "fileMakeDirectory" then
					fs.makeDir(path)
				else
					fs.delete(path)
				end
			elseif messType == "fileQuery" then
				lFile = shell.resolve(message)
				if fs.exists(lFile) then
					netfile.send(conn, lFile)
				end
			elseif messType == "fileSend" then
				connections[conn].filename = shell.resolve(message)
				connections[conn].file = nil
				connection.send(conn, "fileResponse", "ok")
			elseif messType == "fileData" then
				connections[conn].file = message
			elseif messType == "fileEnd" then
				if connections[conn].filename then
					file = io.open(connections[conn].filename, "w")
					if file then
						file:write(connections[conn].file.."\n")
						file:close()
					end
				end
				connections[conn].filename = nil
				connections[conn].file = nil
			elseif messType == "query" then
				connections[conn].directory = "/"
				connection.send(conn, "response", connections[conn].directory)
			elseif messType == "close" then
				connection.close(conn, disconnect, true)
				connections[conn].status = "closed"
				connections[conn].filename = nil
				connections[conn].file = nil
			elseif messType == "instruction" then
				if message == "stop" then
					return true
				end
				if message == "reboot" then
					os.reboot()
				end
			end
			shell.setDir(localDir)
			if conn then connection.send(conn, "done", connections[conn].directory) end
		elseif messType == "query" then
			local connect = {}
			connect.status = "open"
			connect.name = connection.name(conn)
			connect.directory = "/"
			table.insert(connections, conn, connect)
			connection.send(conn, "response", connections[conn].directory)
		end
		term.restore()
	end
end

net.daemonAdd("filed", fileDaemon, port)