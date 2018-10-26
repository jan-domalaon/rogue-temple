extends VBoxContainer


const hp_text = "Health: "
const armor_text = "Armor: "
const ms_text = "Max Speed: "
const xp_text = "Experience: "
const lvl_text = "Strength: "


func _ready():
	# Root -> canvaslayer -> inventory -> player
	get_owner().get_parent().get_parent().get_parent().connect("update_player_stats", self, "on_update_player_stats")


func on_update_player_stats(hp, max_hp, armor, max_ms, xp, next_lvl_xp, lvl):
	$hp_label.text = hp_text + str(hp) + "/" + str(max_hp)
	$armor_label.text = armor_text + str(armor)
	$ms_label.text = ms_text + str(max_ms)
	$xp_label.text = xp_text + str(xp) + "/" + str(next_lvl_xp)
	$lvl_label.text = lvl_text + str(lvl)