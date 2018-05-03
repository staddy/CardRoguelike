extends Control

var type setget set_type
var value setget set_value

func set_type(type_):
	if has_node("icon"):
		if global.modifier_textures[type_] != null:
			$icon.texture = load(global.modifier_textures[type_])
	type = type_

func set_value(value_):
	if has_node("text"):
		$text.text = str(value_)
	value = value_
	visible = value != 0

func _ready():
	visible = value != 0

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
