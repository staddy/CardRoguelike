extends StaticBody2D

onready var root_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1)

var type = null
var level = null

func _ready():
	init()

func init():
	connect("input_event", self, "_on_town_input_event")

func action():
	if type == "door" and root_scene.player.townLvl < 0:
		root_scene.player.townLvl = self.level
		print("Begin the elevation!")
	elif type == "top" and root_scene.player.townLvl == root_scene.town.h:
		root_scene.player.townLvl = self.level
		print("Time for the final!")

func _on_town_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("left_click"):
		action()