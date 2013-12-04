---------------------------------------------------
-- functions
---------------------------------------------------
function fsProtect(file)
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

function safePBGet(file, code)
	print("Getting " .. file .. " from pastebin...")
	fsProtect(file)
	shell.run("pastebin", "get", code, file)	
end

function safeGHGet(file, path)
	print("Getting " .. file .. " from github...")
	fsProtect(file)
	shell.run("github", path, file)
end