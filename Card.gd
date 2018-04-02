extends Node2D

var pressed = false
var selected = false setget set_selected
func set_selected(value):
	if value:
		scale = Vector2(1.5, 1.5)
		$selection.visible = true
		selected = true
		z_index = 1
		#get_parent().move_child(self, get_parent().get_child_count() - 1)
	else:
		scale = Vector2(1, 1)
		$selection.visible = false
		selected = false
		z_index = 0

func unselect():
	self.selected = false

var old_position

var initial_position = null
var speed = 10.0

var max_x
var max_y

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	#set_process_input(false)
	#$Area2D.visible = false
	global.connect("unselect_all", self, "unselect")
	var width = $card.get_texture().get_size().x
	var height = $card.get_texture().get_size().y
	max_x = get_viewport().get_visible_rect().size.x - width
	max_y = get_viewport().get_visible_rect().size.y - height
	if(initial_position == null):
		initial_position = position

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _process(delta):
	if not pressed and position != initial_position:
		position += (initial_position - position) * speed * delta

func _input(event):
	if pressed and selected:
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
			self.selected = false
			pressed = false
			global.unlock()


func _on_Area2D_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.is_pressed():
		if global.lock():
			old_position = event.position
			global.emit_signal("unselect_all")
			self.selected = true
			pressed = true


func _on_Area2D_mouse_entered():
	if !global.locked:
		global.emit_signal("unselect_all")
		self.selected = true


func _on_Area2D_mouse_exited():
	if !global.locked:
		self.selected = false