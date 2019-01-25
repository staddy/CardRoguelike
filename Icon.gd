extends "res://ui/Button.gd"

var can_move_to = []
var visited = false

func _ready():
	pass

func _on_Icon_pressed():
	if global.current_scene.current_icon == null:
		if global.current_scene.start_icons.has(self):
			global.current_scene.current_icon = self
			visited()
			visited = true
		else:
			print("You can`t go there")
	else:
		if global.current_scene.current_icon.can_move_to.has(self):
			global.current_scene.current_icon = self
			visited()
			visited = true
		else:
			print("You can`t go there")

func visited():
	modulate = Color("#a5adff")
	print("You visited ", self)
	pass