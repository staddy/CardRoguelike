extends Area2D

var offset = 16

var tree = 0
var other = 0
var type = 0
var turn = 0
var access = 0 # 0 - core tree, 1 - branch, 2 - bridge

func _ready():
	connect("input_event", self, "_on_other_icon_input_event")

func action():
	prints(self, "tree:", self.tree, "other:", self.other, "position:", position, "turn:", self.turn)

func _on_other_icon_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("left_click"):
		action()
	#if Input.is_action_pressed("rigth_click"):
