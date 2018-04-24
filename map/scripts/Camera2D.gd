extends Camera2D

onready var root_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1)

var touch_bottom = false

var old_position
var pressed

func _ready():
	pass

func _physics_process(delta):
	if Input.is_action_pressed("ui_w"):
		if position.y > -960:
			position.y -= 5
	if Input.is_action_pressed("ui_s"):
		if position.y < 340:
			position.y += 5

func _input(event):
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		if pressed:
			self.position -= (event.position - old_position)
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
