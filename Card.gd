extends Node2D

var card_name setget set_card_name
var cost setget set_cost
var description setget set_description
var type

func set_card_name(value):
	card_name = value
	$Name.text = value

func set_cost(value):
	cost = value
	$Cost.text = str(value)

func set_description(value):
	description = value
	$Description.text = value

var pressed = false
var selected = false setget set_selected
var scale_factor = 1.5
func set_selected(value):
	if value:
		scale = Vector2(scale_factor, scale_factor)
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

var width
var height

var max_x
var max_y

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	#set_process_input(false)
	#$Area2D.visible = false
	global.connect("unselect_all", self, "unselect")
	width = $card.get_texture().get_size().x
	height = $card.get_texture().get_size().y
	max_x = get_viewport().get_visible_rect().size.x - width / 2
	max_y = get_viewport().get_visible_rect().size.y - height / 2
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
			if(self.position.x < width / 2):
				self.position.x = width / 2
			elif(self.position.x > max_x):
				self.position.x = max_x
			if(self.position.y < height / 2):
				self.position.y = height / 2
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