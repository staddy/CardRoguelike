tool
extends Control

signal pressed()

export (Texture) var texture = null setget set_texture
export (Texture) var texture_hover = null setget set_texture_hover

func set_texture(t):
	texture = t
	self.rect_size = texture.get_size()
	if has_node("Sprite"):
		$Sprite.texture = t

func set_texture_hover(t):
	texture_hover = t
	if has_node("SpriteHover"):
		$SpriteHover.texture = t

export var text = "" setget set_text
func set_text(value):
	text = value
	if has_node("Label"):
		$Label.text = value

var selected = false setget set_selected
func set_selected(value):
	if value:
		if has_node("Sprite"):
			$Sprite.visible = false
		if has_node("SpriteHover"):
			$SpriteHover.visible = true
		#$button_selection.visible = true
		selected = true
		#z_index = 1
		#get_parent().move_child(self, get_parent().get_child_count() - 1)
	else:
		if has_node("Sprite"):
			$Sprite.visible = true
		if has_node("SpriteHover"):
			$SpriteHover.visible = false
		#$button_selection.visible = false
		selected = false
		#z_index = 0

func unselect():
	self.selected = false

func _ready():
	if texture != null:
		if has_node("Sprite"):
			$Sprite.texture = texture
		self.rect_size = texture.get_size()
	if texture_hover != null:
		if has_node("SpriteHover"):
			$SpriteHover.texture = texture_hover
	#if(!Engine.editor_hint):
	#	get_node("/root/global").connect("unselect_all", self, "unselect")
	pass

func _on_Button_mouse_entered():
	#if !get_node("/root/global").locked:
	#	get_node("/root/global").emit_signal("unselect_all")
	self.selected = true


func _on_Button_mouse_exited():
	#if !get_node("/root/global").locked:
	self.selected = false


func _on_Button_gui_input(event):
	#if get_node("/root/global").lock():
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.is_pressed():
		self.selected = false
		emit_signal("pressed")
	#	get_node("/root/global").unlock()
