extends Area2D

onready var map = get_parent()

var offset = 16

var tree = 1
var level = 1

var other = 0
var branchSize = 1
var realSize = 1
var atl = false
var mark = false
var connect = null
var use = false
var turn = 0

var type = null

func _ready():
	init()

func init():
	connect("input_event", self, "_on_map_icons_input_event")
	connect("body_entered", self, "_on_map_icons_body_entered")

func action():
	if map.player.townLvl == self.level-1:
		print("Let`s go!")
		map.player.townLvl = self.level
	else:
		 print("Sorry. No passage.")
	"""
	if type == 0:
		print(type)
	elif type == 1:
		print(type)
	elif type == 2:
		print(type)
	elif type == 3:
		print(type)
	elif type == 4:
		print(type)
	elif type == 5:
		print(type)
	elif type == 6:
		print(type)
	"""

func _on_map_icons_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("left_click"):
		action()

func _on_map_icons_body_entered(body):
	var completed = false
	for i in body.get_children().size():
		if !completed and body.get_child(i).is_in_group("window"):
			if !body.windows.a.connect:
				body.windows.a["src"] = self
				body.windows.a["connect"] = true
			elif !body.windows.b.connect:
				body.windows.b["src"] = self
				body.windows.b["connect"] = true
			elif !body.windows.c.connect:
				body.windows.c["src"] = self
				body.windows.c["connect"] = true
			completed = true
	
	
	