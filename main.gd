extends Node2D

func _ready():
	#OS.set_window_maximized(true)
	#OS.set_window_fullscreen(true)
	pass

func _on_Elevate_pressed():
	global.init_deck()
	global.init_player()
	global.goto_scene(global.Map)

func _on_Start_pressed():
	#global.init_deck()
	global.goto_scene(global.Battle)

func _on_Exit_pressed():
	get_tree().quit()
