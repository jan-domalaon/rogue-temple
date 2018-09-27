# By Jan Domalaon (MaritimesGameworks)

extends Node

# TODO: BUG - When the player enters level 0, he/she is not equipped with their appropriate starting build.

# This global script holds all of the player's variables
# This is transferred to the Player node in the level.
# Updates when inventory changes, at a new level, when the player gets damaged,
# at upgrades.

# Possible hunger system: each time the player eats, it fills the hunger meter.
# Normal has no buffs or debuffs.
# Satiated gives a buff to move speed and regenerates health.
# Full indicates the stage between satiated and stuffed, meaning that the player should stop eating.
# Stuffed reduces move speed less than normal but buffs HP and health regeneration.
const HUNGER_STAGES = ['NORMAL', 'SATIATED', 'FULL', 'STUFFED']
# Damage types: cut, blunt, pierce
const DAMAGE_TYPES = ['c', 'b', 'p']
# Default starting build
const DEF_STARTING_BUILD = 'HAA Bladesman'

onready var item_db = get_node('/root/item_db')
onready var weapon_db = get_node('/root/weapons_db')

var primary_dmg = 2
var secondary_dmg = 2
# Armor reduces the hp loss from dmg. HP Loss = dmg taken - (armor * 0.8). Cap is 100 currently.
# Armor is the total amount of armor points of all armor pieces.
var armor = 0
var health = 20
var gold = 0
var primary_attack_speed = 0.75
var secondary_attack_speed = 0.5
var equipped_weapon = ''
var weapon_type = ''
# Arcane resistance is resistance to magic spells. Same as armor formula. A resistance higher than the chance of debuff proc'ing ensures
# that the debuff doesn't occur.
var arcane_resistance = 5
# Inventory. Stores the item names of the objects.
var inventory = []
# Current game level that the player is in
var level_name = null
# Starting build
var starting_build = DEF_STARTING_BUILD
var got_build = false
var armor_equipped = {'Helmet': null, 'Body Armor': null, 'Left Glove': null, 'Right Glove': null, 'Left Boot': null, 'Right Boot': null,
'Shield': null}
var spell_tome_equipped = null
# RPG Stats
var strength = 10
var experience = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	# Nothing should be called here because this is called once the game starts.
	pass

func _process(delta):
	# This script will update whenever the player enters a new level
	# and when the player gets a new item.
	# Nothing should be called here because this is called once the game starts.
	pass

func get_armor_value(inventory):
	# Linear search through inventory. Check for armor pieces.
	for item in inventory:
		if item in item_db.ARMORS:
			armor += item_db.ARMORS[item].armor

