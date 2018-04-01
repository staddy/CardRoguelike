extends Node2D

signal pressed()

func _ready():
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Area2D_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton and event.is_pressed()) or event is InputEventScreenTouch:
		emit_signal("pressed")

func _on_Area2D_mouse_entered():
	$button_selection.visible = true


func _on_Area2D_mouse_exited():
	$button_selection.visible = false
