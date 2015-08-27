-- Generated from template
require("util")
require("timers")
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
	constants = {ability_start_id = 2000, total_ability_count = 72}
	GameRules.AddonTemplate = SDMDGameMode()
	GameRules.AddonTemplate:InitGameMode()
	ListenToGameEvent("npc_spawned", levelInnates, nil)
	CustomGameEventManager:RegisterListener( "reread_abilities", initializeAbilityShopTable )
	initializeAbilityShopTable()
end

function initializeAbilityShopTable()
	--for i=constants.ability_start_id,constants.total_ability_count,1 do
	--end
	local abilitiesTable = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")
	local itemAbilitiesTable = LoadKeyValues("scripts/npc/npc_items_custom.txt")
	LogEndLine("Parsing npc_abilities_custom kv.")
	LogDeepPrint(abilitiesTable, "[Abilities]")
	LogEndLine("Parsing npc_items_custom kv")
	LogDeepPrint(itemAbilitiesTable, "[Items]")
	local tNetTableData = {}
	local tLastHeroName =  ""
	local tHeroAbilityIndex = 0
	for k,v in pairs(abilitiesTable) do
		--Split out the hero name
		print("retrieved ability name.")
		print(k)
		print("Attempting to retrieve item with name item_ability_"..k)
		local tItemID = itemAbilitiesTable["item_ability_"..k]
		--print(LogDeepToString(v, "[AbilityShop]"))
		if(tItemID) then
			local _, _, tHeroName = string.find(k, "^(.-)_.-$")
			if(tHeroName ~= tLastHeroName and tLastHeroName ~= "") then
				print("New hero detected. Switching from "..tLastHeroName.." to "..tHeroName)
				CustomNetTables:SetTableValue("ability_shop_data", tLastHeroName, tNetTableData)
				tHeroAbilityIndex = 0
				tLastHeroName = tHeroName
				tNetTableData = {}
			end
			print("split out hero name "..tHeroName)
			print("Retrieved item id "..tItemID.ID)
			print("Retrieved item texture"..tItemID.AbilityTextureName)
			print("Attempting to add row to table.")
			tNetTableData[tHeroAbilityIndex] = {name = k, itemID = tItemID.ID, itemTextureName = tItemID.AbilityTextureName}
			print("Added table row "..LogDeepToString(tNetTableData[tHeroAbilityIndex]))
			tHeroAbilityIndex = tHeroAbilityIndex + 1
		end
	end
	print("Assembled nettable contents:")
	print(LogDeepToString(tNetTableData))
	CustomNetTables:SetTableValue("ability_shop_data", tLastHeroName, tNetTableData)
	print("Set custom net table data\n")
end

function levelInnates(trigger)
	print("NPC spawn trigger active")
	local unit=EntIndexToHScript(trigger.entindex)
	local n=6
	--local abilityname="AUTOLEVEL"..tostring(n)
	if(unit:GetAbilityByIndex(0) ~= nil) then
		unit:GetAbilityByIndex(0):SetLevel(1)
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