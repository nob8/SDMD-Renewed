--/////////////////////////////////////////////////////////////////////////////
--// AREA TRANSITION FUNCTIONS
--/////////////////////////////////////////////////////////////////////////////
function Activate()
	print("Initializing sdmd_warps.lua")
end

function warp(trigger)
	local inspect = require 'inspect'
	print(trigger.activator)
	print(trigger.caller)
	print("Trigger info contains:")
	--print(inspect(trigger, {depth=4}))
	--assert(io.open("C:\\Users\\Nick\\Downloads\\debugstuff.txt", 'w')):write(inspect(trigger))
	if(trigger.caller==Entities:FindByName(nil, "GateBox_Mansion")) then
		print("Trigger identified as GateBox_Mansion")
		local test=GetGroundPosition(Vector(2304,7350,128), trigger.activator)
		print("Moving unit to:")
		print(test)
		local unit = trigger.activator
		FindClearSpaceForUnit(unit, test, true)
		unit:Stop()

	elseif(trigger.caller==Entities:FindByName(nil, "GateBox_Exterior")) then
		print("Trigger identified as GateBox_Exterior")
		local test=GetGroundPosition(Vector(-5440,2450,128), trigger.activator)
		print("Moving unit to:")
		print(test)
		local unit = trigger.activator
		FindClearSpaceForUnit(unit, test, true)
		unit:Stop() 
	end
end

