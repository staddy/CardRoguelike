extends Node2D

var attack_icon = preload("res://enemies/images/attack_icon.png")
var block_icon = preload("res://enemies/images/block_icon.png")
var cast_icon = preload("res://enemies/images/cast_icon.png")

onready var modifiers = get_node("ModifiersContainer")

var dead = false

var intent = "attack" setget set_intent
func set_intent(value):
	intent = value
	if value == "block":
		$intent_icon.texture = block_icon
	elif value == "attack":
		$intent_icon.texture = attack_icon
	elif value == "cast":
		$intent_icon.texture = cast_icon
	else:
		$intent_icon.texture = null

var intent_value = 7 setget set_intent_value
func set_intent_value(value):
	intent_value = value
	if intent == "attack":
		$Intent.text = str(global.get_damage_to_player(null, intent_value, modifiers, get_parent().modifiers))
	elif intent == "block":
		$Intent.text = str(global.get_block_enemy(intent_value, modifiers))
	else:
		$Intent.text = ""

func update_intent_value():
	set_intent_value(intent_value)

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

func set_intents():
	if randi()%3 == 0:
		self.intent = "block"
		self.intent_value = 7 + randi()%4
	elif randi()%2 == 0:
		self.intent = "attack"
		self.intent_value = 4 + randi()%2
	else:
		self.intent = "cast"
		self.intent_value = 0

func init():
	set_intents()
	self.block = 0
	self.max_hp = 30 + randi()%3
	self.hp = self.max_hp

func _ready():
	if get_parent().is_in_group("battle"):
		get_parent().enemies.append(self)

func _on_Area2D_mouse_entered():
	if not dead:
		$sprite.material = global.outlined_material
		if get_parent().is_in_group("battle"):
			get_parent().selected_enemy = self

func _on_Area2D_mouse_exited():
	$sprite.material = global.material_
	if get_parent().is_in_group("battle"):
		if get_parent().selected_enemy == self:
			get_parent().selected_enemy = null

func remove():
	var parent = get_parent()
	dead = true
	$Area2D.monitoring = false
	$Area2D.monitorable = false
	if parent.is_in_group("battle"):
		parent.enemies.remove(parent.enemies.find(self))
		if parent.selected_enemy == self:
			parent.selected_enemy = null
		parent.enemy_dead()
	if $AnimationPlayer.has_animation("death"):
		$AnimationPlayer.play("death")

func turn():
	if self.intent == "block" and $AnimationPlayer.has_animation("block"):
		$AnimationPlayer.play("block")
	if self.intent == "cast" and $AnimationPlayer.has_animation("cast"):
		$AnimationPlayer.play("cast")
	else:
		$AnimationPlayer.play("attack")

func block(value):
	self.block = global.get_block_enemy(value, modifiers)

func attack(value):
	var parent = get_parent()
	if parent.is_in_group("battle"):
		parent.damage_player(global.get_damage_to_player(null, value, modifiers, get_parent().modifiers))

func cast(value):
	pass

func process_action():
	if self.intent == "block":
		block(self.intent_value)
	elif self.intent == "attack":
		attack(self.intent_value)
	elif self.intent == "cast":
		cast(self.intent_value)

func action():
	self.block = 0
	process_action()
	modifiers.process()
	set_intents()

func damage(value):
	if value <= block:
		self.block = block - value
		return
	self.hp = (self.hp - (value - self.block))
	self.block = 0
	if self.hp <= 0:
		remove()

func _on_AnimationPlayer_animation_finished(anim_name):
	if not dead and anim_name != "idle":
		if get_parent().is_in_group("battle"):
			get_parent().enemy_finished()
		if $AnimationPlayer.has_animation("idle"):
			$AnimationPlayer.play("idle")
