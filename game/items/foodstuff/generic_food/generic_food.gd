# By Jan Domalaon
# Generic food script. Handles food-specific consume() from generic_consumable


extends "res://game/items/generic_consumable.gd"


# Amount of HP this food gives
export var food_heal = 1


func consume(character):
	# Heal character if health + food_heal <= max_health
	if (character.health + food_heal <= character.max_health):
		print(food_heal)
		character.health += food_heal
	# Elif health + food_heal > max_health, then give max health
	elif (character.health + food_heal > character.max_health):
		print("character health maxed by food")
		character.health = character.max_health
	print(item_name + " food consumed!")


func can_consume(character):
	# If false, then this character is still at full health
	return character.health < character.max_health