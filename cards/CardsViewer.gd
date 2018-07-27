extends Node2D

var pressed = false
var old_position = 0

func _ready():
	$CardsArea/CardsContainer/Card.play_mode = false
	pass

func _input(event):
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		if pressed:
			$CardsArea/CardsContainer.position.y -= (event.position - old_position).y
			if $CardsArea/CardsContainer.position.y > 0:
				$CardsArea/CardsContainer.position.y = 0
			"""if(self.position.x < width / 2):
				self.position.x = width / 2
			elif(self.position.x > max_x):
				self.position.x = max_x
			if(self.position.y < height / 2):
				self.position.y = height / 2
			elif(self.position.y > max_y):
				self.position.y = max_y"""
			old_position = event.position
	elif event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.is_pressed():
			old_position = event.position
			pressed = true
		else:
			pressed = false
