tool
extends Control

enum Modifiers {DEXTERITY, STRENGTH, WEAKNESS, VULNERABILITY}
var textures = {DEXTERITY: "res://modifiers/images/dexterity.png",
				STRENGTH: "res://modifiers/images/strength.png",
				WEAKNESS: "res://modifiers/images/weakness.png",
				VULNERABILITY: "res://modifiers/images/vulnerability.png"}

export(Modifiers) var type = DEXTERITY setget set_type
export(int) var value = 0 setget set_value

func set_type(type_):
	$icon.texture = load(textures[type_])
	type = type_

func set_value(value_):
	$text.text = str(value_)
	value = value_

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
