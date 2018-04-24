extends StaticBody2D

onready var map = get_parent()

var type = null
var level = null

func _ready():
	init()

func init():
	connect("input_event", self, "_on_town_input_event")

func action():
	if type == "door" and map.player.townLvl < 0:
		map.player.townLvl = self.level
		print("Begin the elevation!")
		map.get_node("Camera2D/Animation").play("approach")
		map.get_node("Camera2D/Timer").start()
	elif type == "top" and map.player.townLvl == map.town.h:
		map.player.townLvl = self.level
		print("Time for the final!")

func _on_town_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("left_click"):
		action()