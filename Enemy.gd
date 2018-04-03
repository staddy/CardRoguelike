extends Node2D

func _ready():
	if get_parent().is_in_group("battle"):
		get_parent().enemies.append(self)
	pass

#func _process(delta):
#	pass


func _on_Area2D_mouse_entered():
	$selection.visible = true
	if get_parent().is_in_group("battle"):
		get_parent().selected_enemy = self
	pass # replace with function body


func _on_Area2D_mouse_exited():
	$selection.visible = false
	if get_parent().is_in_group("battle"):
		get_parent().selected_enemy = null
	pass # replace with function body

func remove():
	var parent = get_parent()
	if parent.is_in_group("battle"):
		parent.enemies.remove(parent.enemies.find(self))
		if parent.selected_enemy == self:
			parent.selected_enemy = null
	queue_free()
