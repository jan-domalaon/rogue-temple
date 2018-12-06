# By Jan Domalaon (MaritimesGameworks)

extends Node

# Contains the starting builds for the player. Runs once at the level 0
# ie the first level of the game.


# BUILD = [weapon, helmet, body armor, left glove, right glove, left boot, right boot, shield,
# spell tome/training manual, misc. items(to n)]

# Holy Adamist Army Bladesman: Iron sword, iron shield, bucket helm, standard HAA chainmail, chainmail gloves, iron greaves
# HAA training manual, 2 bandages, anam (food), prayer beads
#onready var HAA_BLADESMAN = {'Weapon': 'Iron Sword', 'Helmet': 'Bucket Helmet', 'Body Armor':'Chainmail Armor', 
#							 'Boots': 'Iron Greaves', 'Gloves': 'Chainmail Gloves', 'Shield': 'Iron Shield', 
#							 'Spell Tome': 'Standard HAA Training Guide',
#							 'Misc': ['Healing Potion', 'Healing Potion', 'Anam', 'Prayer Beads']}
# Holy Adamist Army Maceman: Iron Mace, iron shield, bucket helm, chainmail, chainmail gloves, leather boots
# 2 crab rangoons
export var HAA_MACEMAN				= {'Equipment': {"Primary": ["Iron Mace", "WEAPON"], 
												 	 "Secondary": ["Ranger Bow", "WEAPON"], 
												 	 "Shield": ["Iron Shield", "SHIELD"], 
												 	 "Helmet": ["Bucket Helm", "HELMET"], 
												 	 "Armor": ["Chainmail Armor", "ARMOR"], 
												 	 "Gloves": ["Chainmail Gloves", "GLOVES"], 
												 	 "Boots": ["Leather Boots", "BOOTS"]}, 
								    'Inventory Space': [["Crab Rangoon", "FOODSTUFF"], 
													   ["Crab Rangoon", "FOODSTUFF"]],
									'Health': 20,
									'Max Health': 20}


# Chosen build
export var chosen_build = "HAA_MACEMAN"

