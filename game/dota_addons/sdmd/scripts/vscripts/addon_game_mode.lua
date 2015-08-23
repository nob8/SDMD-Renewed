-- Generated from template
--require("sdmd_warps.lua")
--require("sdmd_triggers.lua")
if SDMDGameMode == nil then
	SDMDGameMode = class({})
end

function Precache( context )
		--Precache things we know we'll use.  Possible file types include (but not limited to):
		PrecacheResource( "model", "*.vmdl", context )
		PrecacheResource( "soundfile", "*.vsndevts", context )
		PrecacheResource( "particle", "*.vpcf", context )
		PrecacheResource( "particle_folder", "particles/folder", context )
end



-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = SDMDGameMode()
	GameRules.AddonTemplate:InitGameMode()
	ListenToGameEvent("npc_spawned", levelInnates, nil)
	initializeAbilityShopTable()
end

function initializeAbilityShopTable()
	CustomNetTables:SetTableValue("ability_shop_data", "iku", {{name = "iku_veils_like_sky", itemID = "2000"}})
	print("Set custom net table data\n")
end

function levelInnates(trigger)
	print("NPC spawn trigger active")
	local unit=EntIndexToHScript(trigger.entindex)
	local n=6
	--local abilityname="AUTOLEVEL"..tostring(n)
	if(unit:GetAbilityByIndex(0) ~= nil) then
		unit:GetAbilityByIndex(0):SetLevel(6)
	end
	local ability = unit:GetAbilityByIndex(n)
	while  ability ~= nil do
		print("Leveling "..ability:GetName() .." on "..unit:GetName())
		ability:SetLevel(1)
		n=n+1
		ability = unit:GetAbilityByIndex(n)
	end
end

function SDMDGameMode:InitGameMode()
	print( "Template addon is loaded." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
	GameRules:SetHeroSelectionTime( 60.0 )
	GameRules:SetPreGameTime( 600.0 )
	GameRules:SetPostGameTime( 60.0 )
	GameRules:SetTreeRegrowTime( 1.0 )
end

-- Evaluate the state of the game
function SDMDGameMode:OnThink()

	if GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end