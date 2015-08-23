function hpup(trigger)
	if(increasing_HP==nil) then
		increasing_HP=1000
	end
	print("HP UP")
	increasing_HP=increasing_HP+1000
	local inspect = require 'inspect'
	assert(io.open("C:\\Users\\Nick\\Downloads\\debugstuff.txt", 'w')):write(inspect(trigger))
	for k,v in pairs(trigger) do
		print(tostring(k) .. " - " .. tostring(v))
	end
	local unit=trigger.unit
	unit:SetMaxHealth(increasing_HP) --[[Returns:void
	No Description Set
	]]
	unit:SetBaseHealthRegen(math.min(increasing_HP/100,999-increasing_HP*0.03/10)) --[[Returns:void
	No Description Set
	]]
	unit:SetBaseStrength(increasing_HP/10)
	unit:SetBaseAgility(increasing_HP/10)
	unit:SetBaseIntellect(increasing_HP/10)
end

function hpdown(trigger)
	print("HP DOWN")
	if(increasing_HP==nil) then
		increasing_HP=1000
	end
	increasing_HP=increasing_HP-1000
	local inspect = require 'inspect'
	assert(io.open("C:\\Users\\Nick\\Downloads\\debugstuff.txt", 'w')):write(inspect(trigger))
	for k,v in pairs(trigger) do
		print(tostring(k) .. " - " .. tostring(v))
	end
	local unit=trigger.unit
	unit:SetMaxHealth(increasing_HP) --[[Returns:void
	No Description Set
	]]
	unit:SetBaseHealthRegen(math.min(increasing_HP/100,999-increasing_HP*0.03/10))
	unit:SetBaseStrength(increasing_HP/100)
	unit:SetBaseAgility(increasing_HP/100)
	unit:SetBaseIntellect(increasing_HP/100)
end

function printargs(data)
	print(data)
	for k,v in pairs(data) do
		print(tostring(k) .. " - " .. tostring(v))
	end
end

function iku_init_charges(trigger)
	print("iku charges initialized")
end

function iku_orb_attack(trigger)
	if(trigger.caster:GetMana()>=trigger.caster:GetMaxMana()*0.01) then
		if(iku_charge_pct==nil) then
			iku_charge_pct=0
		end
		iku_charge_pct = iku_charge_pct + trigger.ability:GetLevel()
		GameRules:SendCustomMessage("Iku charge at "..tostring(iku_charge_pct).."%.", trigger.caster:GetTeamNumber(), 1)
		trigger.caster:ReduceMana(trigger.caster:GetMaxMana()*0.01)
		print("Dealing "..tostring(trigger.caster:GetIntellect()*trigger.ability:GetLevel()).." extra damage!")
		ApplyDamage({victim=trigger.target, attacker=trigger.caster, damage=trigger.caster:GetIntellect()*trigger.ability:GetLevel(), damage_type=DAMAGE_TYPE_MAGICAL})
	else
		print("Not enough mana!!")
		GameRules:SendCustomMessage("Insufficient mana.", trigger.caster:GetTeamNumber(), 1)
	end
end

function iku_cast_veils(trigger)
	--GameRules:SendCustomMessage("Veils cast at "..tostring(iku_charge_pct).."%.", trigger.caster:GetTeamNumber(), 1)
	printargs(trigger)
	printargs(trigger.ability)
	if(iku_charge_pct==nil) then
		iku_charge_pct=0
	end
	if(iku_charge_pct >= 20) then
		print("Enough charge.")
		trigger.ability:OnChannelFinish(true)
		iku_charge_pct = iku_charge_pct - 20
		GameRules:SendCustomMessage("Cast veils of sky. Current charge is now "..tostring(iku_charge_pct), trigger.caster:GetTeamNumber(), 1)
	else
		print("Insufficient Charge: "..tostring(iku_charge_pct))
		GameRules:SendCustomMessage("Insufficient charge ("..tostring(iku_charge_pct).."%).", trigger.caster:GetTeamNumber(), 1)
		trigger.ability:RefundManaCost()
		trigger.ability:EndCooldown()
	end
end


function iku_apply_veils_buff(trigger)
	print("Veils buff ON!")
	print("Setting base agility to "..tostring(trigger.caster:GetBaseAgility()*trigger.ability:GetLevel()))
	bonusAGI = trigger.caster:GetBaseAgility()*(trigger.ability:GetLevel()-1)
	--trigger.caster:SetBaseAgility(trigger.caster:GetBaseAgility()*trigger.ability:GetLevel())
	trigger.caster:ModifyAgility(bonusAGI)
end

function iku_remove_veils_buff(trigger)
	print("Veils buff OFF!")
	print("Setting base agility to "..tostring(trigger.caster:GetBaseAgility()/trigger.ability:GetLevel()))
	--trigger.caster:SetBaseAgility(trigger.caster:GetBaseAgility()/trigger.ability:GetLevel())
	trigger.caster:ModifyAgility(-bonusAGI)
	bonusAGI=0
end