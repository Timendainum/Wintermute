local peri = peripheral.getNames()

n = 1
while peri[n] ~= nil do
  print(peri[n])
  n = n + 1
end