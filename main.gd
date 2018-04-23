extends Node2D

func _ready():
	#OS.set_window_maximized(true)
	OS.set_window_fullscreen(true)
	pass

#func _process(delta):
#	pass




func _on_Button_pressed():
	get_tree().quit()

func _on_Button2_pressed():
	global.init_deck()
	global.goto_scene(global.Battle)

func _on_Button3_pressed():
	global.goto_scene(global.Map)
