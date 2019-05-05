extends Node2D

var effects = preload("res://effects/Effects.tscn")
# 0 - basic sword attack
var effectsMas = []

func _ready():
	add_classes()
	pass
	
func add_classes():
	var e = effects.instance()
	for c in e.get_children():
		if c.is_in_group("effect"):
			effectsMas.append(c)

func add_effect(num, pos):
	var e = effectsMas[num].duplicate()
	e.position = pos
	global.current_scene.add_child(e)