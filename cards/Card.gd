extends Node2D

var card_id
var card_name setget set_card_name
var cost setget set_cost
var description = "" setget set_description
var type = null
var image = null setget set_image
var value = 0
var value2 = 0
var effect = ""
var modifiers = []

var selection_ = preload("res://cards/selection.png")
var selection_play = preload("res://cards/selection_play.png")
var selection_attack = preload("res://cards/selection_attack.png")

var enemy = null

func update(id):
	set_description(description)

func set_card_name(value_):
	card_name = value_
	$Name.text = value_

func set_cost(value_):
	cost = value_
	$Cost.text = str(value_)

func set_description(value_):
	description = value_
	var parent = get_parent()
	var d = description
	if parent.is_in_group("battle"):
		var dmg = global.get_damage_to_enemy(self, value, parent.modifiers, null if enemy == null else enemy.modifiers)
		var block = global.get_block_player(self, value2, parent.modifiers)
		var color1 = "#FFFFFF"
		var color2 = "#FFFFFF"
		if dmg < value:
			color1 = "#b00000"
		elif dmg > value:
			color1 = "#00b000"
		d = d.replace("#dmg", "[color=" + color1 + "]" + str(dmg) + "[/color]")
		if block < value2:
			color2 = "#b00000"
		elif block > value2:
			color2 = "#00b000"
		d = d.replace("#block", "[color=" + color2 + "]" + str(block) + "[/color]")
	$Description.bbcode_text = d

func set_image(img):
	image = img
	if(image != null):
		$picture.texture = load(image)

var pressed = false
var selected = false setget set_selected
var scale_factor = 1.5

var old_z_index = 0

func set_selected(value_):
	if selected != value_:
		if value_:
			scale = Vector2(scale_factor, scale_factor)
			$selection.visible = true
			selected = true
			old_z_index = z_index
			z_index = 1
			#get_parent().move_child(self, get_parent().get_child_count() - 1)
		else:
			scale = Vector2(1, 1)
			$selection.visible = false
			selected = false
			z_index = old_z_index

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
	#set_process_input(false)
	#$Area2D.visible = false
	if(image != null):
		$picture.texture = load(image)
	global.connect("unselect_all", self, "unselect")
	width = $card.get_texture().get_size().x
	height = $card.get_texture().get_size().y
	max_x = get_viewport().get_visible_rect().size.x - width / 2
	max_y = get_viewport().get_visible_rect().size.y - height / 2
	if(initial_position == null):
		initial_position = position
	if get_parent().is_in_group("battle"):
		get_parent().cards.append(self)

#func _process(delta):
#	pass

func _process(delta):
	if not pressed and position != initial_position:
		position += (initial_position - position) * speed * delta

func _input(event):
	if selected:
		var parent = get_parent()
		if parent.is_in_group("battle"):
			if event.get("position") != null:
				if (type == "attack" or (type == "skill" and effect == "target")) and parent.selected_enemy != null:
					enemy = parent.selected_enemy
					$selection.texture = selection_attack
				elif (type == "skill" and effect != "target") and event.position.y < parent.get_node("Play").position.y:
					enemy = null
					$selection.texture = selection_play
				else:
					enemy = null
					$selection.texture = selection_
				update(null)
		if pressed:
			if event is InputEventMouseMotion or event is InputEventScreenDrag:
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
	
			elif (event is InputEventMouseButton or event is InputEventScreenTouch) and not event.is_pressed():
				self.selected = false
				pressed = false
				if parent.is_in_group("battle"):
					if event.position.y < parent.get_node("Play").position.y:
						parent.play_card(self, parent.selected_enemy)
					parent.selected_enemy = null
					parent.selected_card = null
				global.unlock()

func remove():
	var parent = get_parent()
	if parent.is_in_group("battle"):
		parent.cards.erase(self)
		if parent.selected_card == self:
			parent.selected_card = null
	queue_free()


func _on_Area2D_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.is_pressed():
		if global.lock():
			old_position = event.position
			global.emit_signal("unselect_all")
			self.selected = true
			pressed = true
			if get_parent().is_in_group("battle"):
				get_parent().selected_card = self
			


func _on_Area2D_mouse_entered():
	if get_parent().is_in_group("battle"):
		if get_parent().selected_card != null:
			return
	global.emit_signal("unselect_all")
	self.selected = true


func _on_Area2D_mouse_exited():
	if !global.locked:
		self.selected = false
		enemy = null
		update(null)