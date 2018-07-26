extends Node2D

var bats = preload("res://enemies/Bats.tscn")
var enemy = preload("res://enemies/Enemy.tscn")
var insect = preload("res://enemies/Insect.tscn")
var slime = preload("res://enemies/Slime.tscn")

var locations = {
	loc_0 = {
		_name = "Location 0",
		access = 0,
		desc = "",
		difficulty_level = "easy",
		size = int(round(rand_range(8, 12))),
		monsters = [bats, enemy, insect, slime],
		bosses = [],
		spawn_position = null
	}
}

func _ready():
	randomize(true)

func _on_Button_pressed():
	global.init_deck()
	locs.elevate = true
	locs.current_location = locations.loc_0
	global.goto_subscene(global.Battle)
