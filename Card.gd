extends Node2D

var pressed = false
var old_position

var initial_position
var speed = 10.0

var max_x
var max_y

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	#set_process_input(false)
	#$Area2D.visible = false
	var width = $card.get_texture().get_size().x
	var height = $card.get_texture().get_size().y
	max_x = get_viewport().get_visible_rect().size.x - width
	max_y = get_viewport().get_visible_rect().size.y - height
	initial_position = position

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _process(delta):
	if not pressed and position != initial_position:
		position += (initial_position - position) * speed * delta

func _input(event):
	if pressed:
		if (event is InputEventMouseMotion or event is InputEventScreenDrag) and pressed:
			self.position += (event.position - old_position)
			if(self.position.x < 0):
				self.position.x = 0
			elif(self.position.x > max_x):
				self.position.x = max_x
			if(self.position.y < 0):
				self.position.y = 0
			elif(self.position.y > max_y):
				self.position.y = max_y
			old_position = event.position
		elif not event.is_pressed():
			pressed = false


func _on_Area2D_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.is_pressed():
		old_position = event.position
		pressed = true


func _on_Area2D_mouse_entered():
	$selection.visible = true


func _on_Area2D_mouse_exited():
	$selection.visible = false
