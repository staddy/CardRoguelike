extends Camera2D

var touch_bottom = false

var old_position
var pressed

func _ready():
	position = Vector2(360, 0)

func _input(event):
	if Input.is_action_just_pressed("ui_up"):
		zoom += Vector2(0.1, 0.1)
	if Input.is_action_just_pressed("ui_down"):
		zoom -= Vector2(0.1, 0.1)
	if get_parent().can_drag:
		if event is InputEventMouseMotion or event is InputEventScreenDrag:
			if pressed:
				self.position -= (event.position - old_position)
				old_position = event.position
				###					###
				if position.x < 360:
					position.x = 360
				if position.x > 1700:
					position.x = 1700
				if position.y < 160:
					position.y = 160
				if position.y > 1100:
					position.y = 1100
				###					###
		elif event is InputEventMouseButton or event is InputEventScreenTouch:
			if event.is_pressed():
				old_position = event.position
				pressed = true
			else:
				pressed = false