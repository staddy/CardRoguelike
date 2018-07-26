extends Node2D

func _ready():
	pass

func _on_ResumeButton_pressed():
	get_tree().paused = false
	self.visible = false

func _on_ExitButton_pressed():
	get_tree().paused = false
	global.goto_scene(global.Main)
