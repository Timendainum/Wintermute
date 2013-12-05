-- boot/apiloader
-- by Timendainum
---------------------------------------------------
--load APIs
os.loadAPI("opt/lib/debug")
os.loadAPI("opt/lib/txt")
os.loadAPI("opt/lib/serial")
os.loadAPI("opt/lib/config")

--LyqydNet
os.loadAPI("opt/lib/connection")
os.loadAPI("opt/lib/net")
os.loadAPI("opt/lib/netfile")

--other
os.loadAPI("opt/lib/file")
os.loadAPI("opt/lib/nets")
os.loadAPI("opt/lib/nperi")
os.loadAPI("opt/lib/peri")
if fs.exists("ocs/apis/sensor") then
	os.loadAPI("ocs/apis/sensor")
end