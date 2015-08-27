"use strict";

var m_AbilityName = -1;
var m_ItemID = -1;
var m_ItemTextureName = -1;

function SetItemData( abilityName, itemID, itemTextureName )
{
	var bChanged = ( abilityName !== m_AbilityName );
	m_AbilityName = abilityName;
	m_ItemID = itemID;
	m_ItemTextureName = itemTextureName;

	UpdateAbility();
}

function UpdateAbility()
{
	var abilityButton = $( "#AbilityButton" );
	//$.GetContextPanel().SetHasClass( "is_active", ( m_Ability == Abilities.GetLocalPlayerActiveAbility() ) );

	//TODO: If all the ranks have been used, stop from buying more.
	//abilityButton.enabled = ;
	
	$( "#AbilityImage" ).abilityname = m_AbilityName;
	//$( "#AbilityImage" ).contextEntityIndex = m_Ability;
	//$.Msg("Getting #AbilityTitle: ", $("#AbilityTitle"));
	//$( "#AbilityTitle" ).text = $.Localize("#DOTA_Tooltip_ability_"+m_AbilityName);
	//$( "#ManaCost" ).text = manaCost;
	
}

function AbilityShowTooltip()
{
	var abilityButton = $( "#AbilityButton" );
	$.DispatchEvent( "DOTAShowAbilityTooltip", abilityButton, m_AbilityName );
}

function AbilityHideTooltip()
{
	var abilityButton = $( "#AbilityButton" );
	$.DispatchEvent( "DOTAHideAbilityTooltip", abilityButton );
}

function ActivateAbility()
{
	$.Msg(m_AbilityName," has been clicked!");
}

function RightClickAbility()
{
	$.Msg(m_AbilityName," has been right-clicked!");
}

(function()
{
	$.GetContextPanel().data().SetItemData = SetItemData;
})();
