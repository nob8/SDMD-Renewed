--/////////////////////////////////////////////////////////////////////////////
--// AREA TRANSITION FUNCTIONS
--/////////////////////////////////////////////////////////////////////////////
warplocations = {}
function Activate()
	print("Initializing sdmd_warps.lua")
	warplocations.GateBox_Mansion = GetGroundPosition(Vector(2304,7350,128), nil)
	warplocations.GateBox_Exterior = GetGroundPosition(Vector(-5440,2450,128), nil)
	warplocations.AbilityShopBox_Mansion = GetGroundPosition(Vector(-3840,6528,128), nil)
	warplocations.AbilityShopBox_Shop = GetGroundPosition(Vector(-3840,4608,128), nil)
end
warp_strings = { "GateBox_Mansion", "GateBox_Exterior", "AbilityShopBox_Mansion", "AbilityShopBox_Shop"}
function warp(trigger)
	local inspect = require 'inspect'
	print(trigger.activator)
	print(trigger.caller)
	--print_r(trigger)
	local warpname = ""
	for i=0, #warp_strings do
		if(trigger.caller == Entities:FindByName(nil, warp_strings[i])) then
			warpname = warp_strings[i]
		end
	end
	print("Accessing warplocations with " .. warpname)
	print(warplocations[warpname])
	print(warplocations.AbilityShopBox_Mansion)
	FindClearSpaceForUnit(trigger.activator, warplocations[warpname], true)
	trigger.activator:Stop()
end