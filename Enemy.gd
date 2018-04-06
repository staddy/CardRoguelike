extends Node2D

var attack_icon = preload("res://attack_icon.png")
var block_icon = preload("res://block_icon.png")

var intent = "attack" setget set_intent
func set_intent(value):
	intent = value
	if value == "block":
		$intent_icon.texture = block_icon
	elif value == "attack":
		$intent_icon.texture = attack_icon
	else:
		$intent_icon.texture = null

var intent_value = 7 setget set_intent_value
func set_intent_value(value):
	intent_value = value
	$Intent.text = str(intent_value)

var hp = 10 setget set_hp
func set_hp(value):
	hp = value
	$TextureProgress.value = value
	$Label.text = str(hp) + " of " + str(max_hp)

var max_hp = 10 setget set_max_hp
func set_max_hp(value):
	max_hp = value
	$TextureProgress.max_value = value
	$Label.text = str(hp) + " of " + str(max_hp)

var block = 0 setget set_block
func set_block(value):
	block = value
	if block == 0:
		$block_sprite.visible = false
		$Block.visible = false
	else:
		$block_sprite.visible = true
		$Block.visible = true
		$Block.text = str(block)

func set_basic_intents():
	if randi()%3 == 0:
		self.intent = "block"
		self.intent_value = 7 + randi()%4
	else:
		self.intent = "attack"
		self.intent_value = 11 + randi()%3

func _ready():
	if get_parent().is_in_group("battle"):
		get_parent().enemies.append(self)
	set_basic_intents()
	self.block = 0
	self.max_hp = 30 + randi()%3
	self.hp = self.max_hp
	pass

#func _process(delta):
#	pass


func _on_Area2D_mouse_entered():
	$sprite.material = global.outlined_material
	if get_parent().is_in_group("battle"):
		get_parent().selected_enemy = self
	pass # replace with function body


func _on_Area2D_mouse_exited():
	$sprite.material = global.material_
	if get_parent().is_in_group("battle"):
		if get_parent().selected_enemy == self:
			get_parent().selected_enemy = null
	pass # replace with function body

func remove():
	var parent = get_parent()
	if parent.is_in_group("battle"):
		parent.enemies.remove(parent.enemies.find(self))
		if parent.selected_enemy == self:
			parent.selected_enemy = null
	queue_free()

func turn():
	$AnimationPlayer.play("attack")

# TODO: it's kind of "turn", should be renamed (structure changed)
func attack():
	self.block = 0
	if self.intent == "block":
		self.block = self.intent_value
	elif self.intent == "attack":
		var parent = get_parent()
		if parent.is_in_group("battle"):
			parent.damage_player(self.intent_value)
	set_basic_intents()

func damage(value):
	if value <= block:
		self.block = block - value
		return
	self.hp = (self.hp - (value - self.block))
	self.block = 0
	if self.hp <= 0:
		remove()


func _on_AnimationPlayer_animation_finished(anim_name):
	if get_parent().is_in_group("battle"):
		if anim_name == "attack":
			get_parent().enemy_finished()
	pass # replace with function body
