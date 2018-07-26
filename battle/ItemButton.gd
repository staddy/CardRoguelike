extends "res://ui/Button.gd"

signal picked()

func _ready():
	pass

func _on_ItemButton_pressed():
	global.current_card_item = self
	global.goto_subscene(global.CardSelection)
	#remove()

func remove():
	get_parent().remove_child(self)
	emit_signal("picked")
	queue_free()