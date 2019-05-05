extends Node2D

var value = 9 setget set_value
var max_value = 9 setget set_max_value

func set_value(v):
	value = v
	for i in range(1, 10):
		$energy_slots.get_node("full" + str(i)).visible = value >= i

func set_max_value(v):
	max_value = v
	for i in range(1, 10):
		$energy_slots.get_node("empty" + str(i)).visible = max_value >= i

func _ready():
	pass