extends Node2D

onready var container = get_node("ScrollContainer")
onready var box = container.get_node("VBoxContainer")

var selectble = false
var card_selected = null

#var control_shape = {}

func _ready():
	#control_shape = {x1 = container.get_position().x, y1 = container.get_position().y, x2 = container.get_position().x+container.get_size().x, y2 = container.get_position().y+container.get_size().y}
	pass

func collision_check(mouse_pos):
	for c in box.get_children():
		if !c.is_in_group("fuck") and c.get_child(0):
			var card = c.get_child(0)
			var shape = {x1 = 0, y1 = 0, x2 = 0, y2 = 0}
			shape.x1 = card.global_position.x - card.get_node("card").get_texture().get_size().x
			shape.y1 = card.global_position.y - card.get_node("card").get_texture().get_size().y
			shape.x2 = card.global_position.x + card.get_node("card").get_texture().get_size().x
			shape.y2 = card.global_position.y + card.get_node("card").get_texture().get_size().y
			if selectble and mouse_pos.x > shape.x1 and mouse_pos.x < shape.x2 and mouse_pos.y > shape.y1 and mouse_pos.y < shape.y2:
				card.selected = true
				card_selected = card
			else:
				card.selected = false

func _on_ScrollContainer_gui_input(ev):
	var mouse_pos = get_global_mouse_position()
	collision_check(mouse_pos)
	if Input.is_action_pressed("left_click"):
		if card_selected != null:
			card_selected.test_click()
	
func _on_ScrollContainer_mouse_entered():
	selectble = true
func _on_ScrollContainer_mouse_exited():
	if card_selected != null:
		selectble = false
		card_selected.selectble = false
		card_selected = null