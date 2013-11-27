-- install
-- by Timendainum
---------------------------------------------------
--purpose
---------------------------------------------------
-- Update log -------------------------------------
-- 11/20/13 - created
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

function installLoadAPI(path, file, code)
	local fullPath = path .. file
--	if not fs.exists(fullPath) then
		print("Installing " .. fullPath)
		fsProtect(path, file)
		shell.run("pastebin", "get", code, fullPath)
		print("Loading " .. fullPath)
		os.loadAPI(fullPath)
--	end
end

---------------------------------------------------
-- main
---------------------------------------------------
print("Installing base system...")

---------------------------------------------------
print("Installing installer perquisites...")
installLoadAPI("/opt/lib/", "str", "0vL79TVn")
installLoadAPI("/opt/lib/", "config", "USfi5q1Y")

local path = "/"
local file = "github"
local fullPath = path .. file
local code = "knix7nQp"
fsProtect(path, file)
shell.run("pastebin", "get", code, fullPath) 

---------------------------------------------------
print("Installing installer...")
local path = "/opt/"
local file = "installer"
local fullPath = path .. file
local code = "YCYfYzFj"

fsProtect(path, file)
shell.run("pastebin", "get", code, fullPath) 

---------------------------------------------------
--Executing installer
shell.run(fullPath , nil)