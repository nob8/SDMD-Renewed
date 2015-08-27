"use strict";

var m_AbilityShopItemPanels = [];
var m_HeroListPanels = [];

function HelloWorld()
{
	$.Msg( "Hello, world!" );
}

function MakePanelsIfNeeded( nUsedPanels, panelArray, panelLayout, parent )
{
	while(panelArray.length <= nUsedPanels)
	{
		var abilityPanel = $.CreatePanel( "Panel", parent, "" );
		abilityPanel.BLoadLayout( panelLayout, false, false );
		panelArray.push( abilityPanel );
	}
}

/*
Update all the shop icons based on game state, displaying number of levels
left for each ability based on number purchased (stored in LUA)
*/
function UpdateAbilityShop()
{
	GameEvents.SendCustomGameEventToServer("reread_abilities", {});
	$.Msg( "Entered UpdateAbilityShop" );
	var abilityShopPanel = $( "#AbilityShop" );
	if(!abilityShopPanel)
	{
		$.Msg( "Failed to retrieve #AbilityShop" );
		return;
	}

	// update all the panels
	var nUsedItemPanels = 0;
	var nUsedHeroPanels = 0;
	var abilitiesNetTable = CustomNetTables.GetAllTableValues( "ability_shop_data" );
	$.Msg( "Retrieved ability_shop_data table. ", abilitiesNetTable );
	for ( var i = 0; i < abilitiesNetTable.length; ++i )
	{
		$.Msg( "Found abilities for ", abilitiesNetTable[i].key, "." );
		var heroSpellTable = abilitiesNetTable[i].value;
		$.Msg( "Hero abilities are ", heroSpellTable);
		$.Msg( "Creating hero panel" );
		MakePanelsIfNeeded(nUsedHeroPanels, m_HeroListPanels, "file://{resources}/layout/custom_game/basic_container.xml", abilityShopPanel);
		var heroListPanel = m_HeroListPanels[nUsedHeroPanels];
		nUsedHeroPanels++;
		for ( var key in heroSpellTable )
		{
			var shopItemData = heroSpellTable[ key ];
			$.Msg( "Found AbilityItem ", shopItemData );
			MakePanelsIfNeeded(nUsedItemPanels, m_AbilityShopItemPanels, "file://{resources}/layout/custom_game/ability_shop_item.xml", heroListPanel );
			var abilityPanel = m_AbilityShopItemPanels[ nUsedItemPanels ];
			$.Msg( "Sending SetItemData(",shopItemData["name"],",",shopItemData["itemID"],") ...");
			abilityPanel.data().SetItemData( shopItemData["name"], shopItemData["itemID"] );
			nUsedItemPanels++;
		}
	}

	// clear any remaining panels
	for ( var i = nUsedItemPanels; i < m_AbilityShopItemPanels.length; ++i )
	{
		var abilityPanel = m_AbilityShopItemPanels[ i ];
		abilityPanel.data().SetAbility( -1, -1, false );
	}
}

(function() {
	$.Msg( "AbilityShopPopulate loaded." );
	//Register Repopulate to run when game starts...
})();