"use strict";

var m_AbilityPanels = [];

function HelloWorld()
{
	$.Msg( "Hello, world!" );
}

/*
Update all the shop icons based on game state, displaying number of levels
left for each ability based on number purchased (stored in LUA)
*/
function UpdateAbilityShop()
{
	$.Msg( "Entered UpdateAbilityShop" );
	var abilityShopPanel = $( "#AbilityShop" );
	if(!abilityShopPanel)
	{
		$.Msg( "Failed to retrieve #AbilityShop" );
		return;
	}

	// update all the panels
	var nUsedPanels = 0;
	var abilitiesNetTable = CustomNetTables.GetAllTableValues( "ability_shop_data" );
	$.Msg( "Retrieved ability_shop_data table. ", abilitiesNetTable );
	for ( var i = 0; i < abilitiesNetTable.length; ++i )
	{
		/*
		var ability = Entities.GetAbility( queryUnit, i );
		if ( ability == -1 )
			continue;

		if ( !Abilities.IsDisplayedAbility(ability) )
			continue;
		
		if ( nUsedPanels >= m_AbilityPanels.length )
		{
			// create a new panel
			var abilityPanel = $.CreatePanel( "Panel", abilityListPanel, "" );
			abilityPanel.BLoadLayout( "file://{resources}/layout/custom_game/action_bar_ability.xml", false, false );
			m_AbilityPanels.push( abilityPanel );
		}

		// update the panel for the current unit / ability
		var abilityPanel = m_AbilityPanels[ nUsedPanels ];
		abilityPanel.data().SetAbility( ability, queryUnit, Game.IsInAbilityLearnMode() );
		nUsedPanels++;
		*/
		$.Msg( "Found abilities for ", abilitiesNetTable[i].key, "." );
		var heroSpellTable = abilitiesNetTable[i].value;
		$.Msg( "Hero abilities are ", heroSpellTable);
		for ( var key in heroSpellTable )
		{
			var abilityName = heroSpellTable[ key ];
			$.Msg( "Found Ability ", abilityName );
			if( nUsedPanels >= m_AbilityPanels.length )
			{
				var abilityPanel = $.CreatePanel( "Panel", abilityShopPanel, "" );
				abilityPanel.BLoadLayout( "file://{resources}/layout/custom_game/action_bar_ability.xml", false, false );
				m_AbilityPanels.push( abilityPanel );
			}
		}
	}

	// clear any remaining panels
	for ( var i = nUsedPanels; i < m_AbilityPanels.length; ++i )
	{
		var abilityPanel = m_AbilityPanels[ i ];
		abilityPanel.data().SetAbility( -1, -1, false );
	}
}

(function() {
	$.Msg( "AbilityShopPopulate loaded." );
	//Register Repopulate to run when game starts...
})();