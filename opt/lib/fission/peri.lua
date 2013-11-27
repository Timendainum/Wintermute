-- opt/lib/fission/peri
-- Created by Timendainum
---------------------------------------------------
-- Update log -------------------------------------
-- 11/18/13 - created
---------------------------------------------------

---------------------------------------------------
-- declarations
monitor = nil
drive = nil

-- cells indexed by cellId as number
cells = {}
-- indexed by cellId, value as number
cellsEnergy = {}

-- reference: cells indexed by cellId as number
local inputCellIds = {1, 2, 11, 12, 21, 22, 31, 32, 41, 42}
local outputCellIds = {9, 10, 19, 20, 29, 30, 39, 40, 49, 50}

---------------------------------------------------
function updateFissionStoredEnergy()
	print("Updating network data")
	cellsEnergy = {}
	for key, value in ipairs(cells) do
		cellsEnergy[key] = cells[key].getEnergyStored()
		write(".")
	end
	print("done!")
end

function getFissionStoredEnergy()
	local result = 0
	for k,v in ipairs(cellsEnergy) do
		result = result + v
	end
	return tonumber(result)
end

function getFissionInputStoredEnergy()
	local result = 0
	for k,v in ipairs(inputCellIds) do
		result = result + cellsEnergy[v]
	end
	return tonumber(result)
end

function getFissionOutputStoredEnergy()
	local result = 0
	for k,v in ipairs(outputCellIds) do
		result = result + cellsEnergy[v]
	end
	return tonumber(result)
end

---------------------------------------------------
-- main program
---------------------------------------------------
-- peripherals
monitor = peripheral.wrap("monitor_4")
drive = peripheral.wrap("drive_5")

-- build main energy cell table
print("Wrapping networked peripherals")
for x = 1, 50 do
	local name = "redstone_energy_cell_" .. tostring(x)
	cells[x] = nperi.wrap("powerperi", name)
	if cells[x] == nil then
		print(name .. " is nil! <CR>")
		local junk = read()
	else
		write(".")
	end
end
print(" done!")