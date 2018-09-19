# By Jan Domalaon (MaritimesGameworks)

extends Node

# Contains the starting builds for the player. Runs once at the level 0
# ie the first level of the game.
onready var weapons_db 		= get_node('/root/weapon_database')
onready var item_db 		= get_node('/root/item_database')
onready var weapons 		= weapons_db.WEAPONS
onready var potions 		= item_db.POTIONS
onready var foodstuffs 		= item_db.FOODSTUFF
onready var body_armor 		= item_db.BODY_ARMOR
onready var helmets 		= item_db.HELMETS
onready var gloves			= item_db.GLOVES
onready var boots			= item_db.BOOTS
onready var trinkets 		= item_db.TRINKETS
onready var spell_tomes 	= item_db.SPELL_TOMES

# BUILD = [weapon, helmet, body armor, left glove, right glove, left boot, right boot, shield,
# spell tome/training manual, misc. items(to n)]

# Holy Adamist Army Bladesman: Iron sword, iron shield, bucket helm, standard HAA chainmail, chainmail gloves, iron greaves
# HAA training manual, 2 bandages, anam (food), prayer beads
onready var HAA_BLADESMAN = {'Weapon': 'Iron Sword', 'Helmet': 'Bucket Helmet', 'Body Armor':'Chainmail Armor', 
							 'Boots': 'Iron Greaves', 'Gloves': 'Chainmail Gloves', 'Shield': 'Iron Shield', 
							 'Spell Tome': 'Standard HAA Training Guide',
							 'Misc': ['Healing Potion', 'Healing Potion', 'Anam', 'Prayer Beads']}

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

