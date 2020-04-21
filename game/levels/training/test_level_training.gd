extends Node

var level_name = 'Training Level 0'
var level = 0

# Starting level test. Equips the player with the appropriate build.

# Enter tree so that build is given before player enters the tree.
func _enter_tree():
	var player_vars = get_node('/root/player_variables')
	var weapon_db = get_node('/root/weapon_database')
	var item_db = get_node('/root/item_database')
	var builds = get_node('/root/builds')
	if player_vars.got_build == false:
		if player_vars.starting_build == 'HAA Bladesman':
			print('Given HAA Bladesman build!')
			# Add uneqipped items to inventory.
			player_vars.inventory += builds.HAA_BLADESMAN['Misc']
			# Equip player with armor, weapons, spell tome from build.
			player_vars.armor_equipped['Helmet'] = builds.HAA_BLADESMAN['Helmet']
			player_vars.armor_equipped['Body Armor'] = builds.HAA_BLADESMAN['Body Armor']
			player_vars.armor_equipped['Left Glove'] = builds.HAA_BLADESMAN['Left Glove']
			player_vars.armor_equipped['Right Glove'] = builds.HAA_BLADESMAN['Right Glove']
			player_vars.armor_equipped['Left Boot'] = builds.HAA_BLADESMAN['Left Boot']
			player_vars.armor_equipped['Right Boot'] = builds.HAA_BLADESMAN['Right Boot']
			player_vars.armor_equipped['Shield'] = builds.HAA_BLADESMAN['Shield']
			# Equip weapon and spell tome
			player_vars.equipped_weapon = builds.HAA_BLADESMAN['Weapon']
#			player_vars.weapon_type = weapon_db.WEAPONS[builds.HAA_BLADESMAN['Weapon']].weapon_type
			player_vars.spell_tome_equipped = builds.HAA_BLADESMAN['Spell Tome']
			player_vars.got_build == true
			player_vars.inventory.sort()

func _ready():
	# Set level changes
	get_node('YSort/next_level_change').add_to_group('next_level_change')
