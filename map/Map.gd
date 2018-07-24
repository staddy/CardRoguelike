extends Node2D

func _ready():
	pass

func _on_Button_pressed():
	global.init_deck()
	global.goto_subscene(global.Battle)
