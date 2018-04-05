extends Node2D

var hp = 10 setget set_hp
func set_hp(value):
	hp = value
	$TextureProgress.value = value
	$Label.text = str(hp) + " of " + str(max_hp)

var max_hp = 10 setget set_max_hp
func set_max_hp(value):
	max_hp = value
	$TextureProgress.max_value = value
	$Label.text = str(hp) + " of " + str(max_hp)

func _ready():
	if get_parent().is_in_group("battle"):
		get_parent().enemies.append(self)
	self.hp = 30
	self.max_hp = 30
	pass

#func _process(delta):
#	pass


func _on_Area2D_mouse_entered():
	$sprite.material = global.outlined_material
	if get_parent().is_in_group("battle"):
		get_parent().selected_enemy = self
	pass # replace with function body


func _on_Area2D_mouse_exited():
	$sprite.material = global.material_
	if get_parent().is_in_group("battle"):
		if get_parent().selected_enemy == self:
			get_parent().selected_enemy = null
	pass # replace with function body

func remove():
	var parent = get_parent()
	if parent.is_in_group("battle"):
		parent.enemies.remove(parent.enemies.find(self))
		if parent.selected_enemy == self:
			parent.selected_enemy = null
	queue_free()
