extends "res://ui/Button.gd"

signal picked()

func _ready():
	pass

func _on_ItemButton_pressed():
	remove()

func remove():
	get_parent().remove_child(self)
	emit_signal("picked")
	queue_free()