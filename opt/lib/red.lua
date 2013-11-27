-- opt/lib/red
-- Forked by Timendainum
---------------------------------------------------
--[[
Output API, By SuPeRMiNoR2 (With help from immibis)
LICENSE
http://creativecommons.org/licenses/by/3.0/deed.en_US
This license only applies to THIS PROGRAM, not to minecraft, computercraft, or redpower
You may edit, and/or use this program/API in your own programs/APIS. You do not have to leave this license comment in, but you can if you want :)
---------------------------------------------------
Update Log
---------------------------------------------------
11-13-13	Forked
]]--
 
--Version: 2 BETA!, This is a beta!!

local side = "back"

function allOff()
  redstone.setBundledOutput(side, 0)
end

function set(color, state)
 if not color then
  error("Invalid color", 2)
 end
 local func = (state and coloredstone.combine or coloredstone.subtract)
 redstone.setBundledOutput(side, func(redstone.getBundledOutput(side), color))
end

function get(color)
 print(side)
 return redstone.testBundledInput(side, color)
end

function toggle(color)
 cstate = get(color)
 if cstate == false then
 set(color, true)
 end
 if cstate == true then
 set(color, false)
 end
end

function setAdv(sided, color, state)
 if not color then
  error("Invalid color", 2)
 end
 local func = (state and coloredstone.combine or coloredstone.subtract)
 redstone.setBundledOutput(sided, func(redstone.getBundledOutput(sided), color))
end

function setSide(s)
 side = s
end