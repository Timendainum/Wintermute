-- opt/lib/periHelper
-- by Timendainum
---------------------------------------------------
--purpose
---------------------------------------------------
-- Update log -------------------------------------
-- 11/21/13 - created
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