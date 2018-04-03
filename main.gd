extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	#OS.set_window_maximized(true)
	#OS.set_window_fullscreen(true)
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Button_pressed():
	get_tree().quit()


func _on_Button2_pressed():
	global.init_deck()
	global.goto_scene(global.Battle)
