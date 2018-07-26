extends Node

var elevate = false
var current_location = null
var step = 0

var enemies = []

func loc_generate():
	var monster = current_location.monsters[int(round(rand_range(0, current_location.monsters.size()-1)))].instance()
	monster.position = current_location.spawn_position.position
	global.current_scene.add_child(monster)
	enemies.append(monster)
	step += 1