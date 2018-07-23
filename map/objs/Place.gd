extends Area2D

export var content = ""
export var access = ""

func _ready():
	$city_name.set_text(get_name())

func _on_City_mouse_entered():
	$sprite_selected.visible = true

func _on_City_mouse_exited():
	$sprite_selected.visible = false

func _on_Place_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("left_click"):
		if content.find("city") != -1:
			if player_list.access == int(access):
				global.goto_scene(global.City)
			else:
				print("Sorry. U don`t access")
		if content.find("pit") != -1:
			global.init_deck()
			global.goto_scene(global.Battle)