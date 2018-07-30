extends Control

var image = null setget set_image

func set_image(img):
	image = img
	if(image != null):
		$picture.texture = load(image)

func _ready():
	pass
