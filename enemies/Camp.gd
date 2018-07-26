extends Area2D

func _ready():
	pass

func _on_Camp_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("left_click"):
		#global.step = global.current_loc.size
		global.unlock()
		global.goto_scene(global.Battle)
		print("Rest")

