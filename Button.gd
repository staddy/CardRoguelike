extends Node2D

signal pressed()

var selected = false setget set_selected
func set_selected(value):
	if value:
		$button_selection.visible = true
		selected = true
		z_index = 1
		#get_parent().move_child(self, get_parent().get_child_count() - 1)
	else:
		$button_selection.visible = false
		selected = false
		z_index = 0

func _ready():
	global.connect("unselect_all", self, "unselect")


func _on_Area2D_input_event(viewport, event, shape_idx):
	if global.lock():
		if (event is InputEventMouseButton and event.is_pressed()) or event is InputEventScreenTouch:
			emit_signal("pressed")
		global.unlock()

func _on_Area2D_mouse_entered():
	if !global.locked:
		global.emit_signal("unselect_all")
		self.selected = true


func _on_Area2D_mouse_exited():
	if !global.locked:
		self.selected = false
