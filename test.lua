-- test
-- by Timendainum
---------------------------------------------------
print("nperi/nperid testing script")
print("---------------------------")
local server = "test2"
local periName1 = "monitor_5"
local periName2 = "glowstone_illuminator_0"
local periName3 = "crap"

print("Server: " .. server)
print("peri1: " .. periName1)
print("peri2: " .. periName2)
print("Press enter to begin testing.")
local junk = read()

---------------------------------------------------
print("Testing isPresent()")
if nperi.isPresent(server, periName1) then
	print("peri1 found on server!")
else
	print("peri1 not found on server! :(")
end
print("Press enter for next test.")
local junk = read()

if nperi.isPresent(server, periName2) then
	print("peri2 found on server!")
else
	print("peri2 not found on server! :(")
end
print("Press enter for next test.")
local junk = read()

if nperi.isPresent(server, periName3) then
	print("peri3 found on server!")
else
	print("peri3 not found on server! :(")
end
print("Press enter for next test.")
local junk = read()
---------------------------------------------------
print("Testing getType()")
local pType = nperi.getType(server, periName1)
if pType ~= nil then
	print("peri1 type: " .. pType)
else
	print("nil response for peri1! :(")
end
print("Press enter for next test.")
local junk = read()

pType= nperi.getType(server, periName2)
if pType ~= nil then
	print("peri2 type: " .. pType)
else
	print("nil response for peri2! :(")
end
print("Press enter for next test.")
local junk = read()

pType = nperi.getType(server, periName3)
if pType ~= nil then
	print("peri13 type: " .. pType)
else
	print("nil response for peri13 :(")
end
print("Press enter for next test.")
local junk = read()
---------------------------------------------------
print("Testing getMethods()")

print("Getting methods for peri1...")
local tMethods = nperi.getMethods(server, periName1)
if tMethods ~= nil then
	print("Display getMethods() for peri1:")
	for k,v in pairs(tMethods) do
		print(v)
	end
else
	print("nil result :(")
end
print("Press enter for next test.")
local junk = read()

print("Getting methods for peri2...")
local tMethods = nperi.getMethods(server, periName2)
if tMethods ~= nil then
	print("Display getMethods() for peri2:")
	for k,v in pairs(tMethods) do
		print(v)
	end
else
	print("nil result :(")
end
print("Press enter for next test.")
local junk = read()

print("Getting methods for peri3...")
local tMethods = nperi.getMethods(server, periName3)
if tMethods ~= nil then
	print("Display getMethods() for peri3:")
	for k,v in pairs(tMethods) do
		print(v)
	end
else
	print("nil result :(")
end
print("Press enter for next test.")
local junk = read()
---------------------------------------------------
print("Testing call()")
local callResponse = nperi.call(server, periName1,"write","This is a test! ")
if callResponse ~= nil then
        print("peri1 response: " .. callResponse)
else
        print("nil response for peri1! :(")
end
print("Press enter for next test.")
local junk = read()

print("Testing call()")
local callResponse = nperi.call(server, periName2,"setColor", colors.white)
if callResponse ~= nil then
        print("peri2 response: " .. callResponse)
else
        print("nil response for peri2! :(")
end
print("Press enter for next test.")
local junk = read()
---------------------------------------------------
print("Testing getNames()")
local tNames = nperi.getNames(server)
print("Display getNames() result:")
for k,v in pairs(tNames) do
	print(v)
end
---------------------------------------------------
print("All tests completed.")