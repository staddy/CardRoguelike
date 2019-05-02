extends Node2D

func _ready():
	Engine.target_fps = 60
	# Register built-in cvars
	Console.register('fps_max', {
		'args': [TYPE_INT],
		'description': 'The maximal framerate at which the application can run',
		'target': [global, 'set_target_fps'],
	})
	Console.register('toggle_fps', {
		'description': 'Toggle framerate meter',
		'target': [global, 'toggle_fps'],
	})
	#OS.set_window_maximized(true)
	#OS.set_window_fullscreen(true)
	pass

func _on_Elevate_pressed():
	global.init_deck()
	global.init_player()
	global.goto_scene(scenes.Map)

func _on_Exit_pressed():
	get_tree().quit()


func _on_Button_pressed():
	global.init_deck()
	global.init_player()
	global.goto_scene(global.Map)
