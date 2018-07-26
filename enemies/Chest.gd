extends Area2D

func _ready():
	pass

func _on_Chest_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("left_click"):
		global.goto_scene(global.LootWindow)
