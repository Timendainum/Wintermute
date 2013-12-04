-- opt/lib/periHelper
-- by Timendainum
---------------------------------------------------

---------------------------------------------------
-- functions
function wrapUp(sKey)
 if (peripheral.isPresent(sKey)) then
   print("peri:Wrapped " .. sKey)
   return peripheral.wrap(sKey)
 else
  print("Unable to wrap " .. sKey)
  return nil
 end
-- return nil
end