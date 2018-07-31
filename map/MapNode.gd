tool
extends "res://ui/Button.gd"

export(int) var level = null
export(String) var type = null
export(bool) var visited = false setget set_visited
var connections = []

signal node_clicked(node)

func get_offset():
	if(texture != null):
		return Vector2(texture.get_size().x * rect_scale.x, texture.get_size().y * rect_scale.y) / 2
	else:
		return Vector2(0, 0)

func set_visited(value):
	visited = value
	if has_node("Visited"):
		$Visited.visible = visited

func _ready():
	if(!Engine.editor_hint):
		if get_parent().is_in_group("map"):
			get_parent().nodes.append(self)
	pass


func _on_MapNode_pressed():
	emit_signal("node_clicked", self)
	self.visited = true
