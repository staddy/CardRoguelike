extends Control

var image = null setget set_image
var description = null setget set_description

func set_image(img):
	image = img
	if(image != null):
		$picture.texture = load(image)

func set_description(dsc):
	description = dsc
	if(description != null):
		hint_tooltip = description

func _ready():
	pass
