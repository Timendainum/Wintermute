-- debug api
--------------------------------------------
local debugSeverity = 1
-- 0 	completely silent
-- 1 	Error
-- 10	Warning -- default
-- 20	Information
-- 30	Flow Information
-- 40	Logic Information
-- 50	Debug
-- 60	Spam
-- 64	Deepest Logic Possible

function log(severity, ...)
	severity = tonumber(severity)
	assert (type(severity) == "number" and severity >= 0 and severity <= 64, "invalid severity")
	if debugSeverity >= severity then
		txt.sPrint(...)
	end
end

function getSeverity()
	return debugSeverity
end

function setSeverity(severity)
	severity = tonumber(severity)
	assert (type(severity) == "number" and severity >= 0 and severity <= 64, "invalid severity")
	debugSeverity = severity
end
