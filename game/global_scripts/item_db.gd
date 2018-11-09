# By Jan Domalaon (MaritimesGameworks)

# Item name and resource paths for all the items in the game.


extends Node


const ARMOR_TYPES = ["ARMOR", "GLOVES", "BOOTS", "HELMET"]
const WEAPON_TYPES = ["BOW", "STAFF", "MACE", "BLADE"]


const POTION = 	{'Bandages': '', 'Burgundy Potion': '', 'Cerulean Potion': '', 'Ochre Potion': '', 'Ultramarine Potion': ''}


const FOODSTUFF = 	{'Anam': '',
					 'Fruits': 'res://game/items/foodstuff/fruits/fruits.tscn',
					 'Crab Rangoon': 'res://game/items/foodstuff/crab_rangoon/crab_rangoon.tscn',
					 'Captain Redmans Rum': 'res://game/items/foodstuff/captain_redmans_rums'}


const ARMOR = 		{'Chainmail Armor': 'res://game/items/armors/chainmail/chainmail.tscn'}


const HELMET = 	{'Bucket Helm': 'res://game/items/helmets/bucket_helm/bucket_helm.tscn'}


const GLOVES =		{'Chainmail Gloves': 'res://game/items/gloves/chainmail_gloves/chainmail_gloves.tscn'}


const BOOTS = 		{'Leather Boots': 'res://game/items/boots/leather_boots/leather_boots.tscn'}


const TRINKET = 	{'Prayer Beads': ''}


const SPELL_TOME = {'Standard HAA Training Guide': ''}


const WEAPON = {'Iron Sword': 'res://game/items/weapons/iron_sword/iron_sword.tscn', 
				'Iron Mace': 'res://game/items/weapons/iron_mace/iron_mace.tscn',
				'Ranger Bow': 'res://game/items/weapons/ranger_bow/ranger_bow.tscn',
				'Wooden Staff': 'res://game/items/weapons/wooden_staff/wooden_staff.tscn'}


const SHIELD = {'Iron Shield': 'res://game/items/shields/iron_shield/iron_shield.tscn'}


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

