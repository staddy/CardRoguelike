extends Node2D

var turn = -1
var Card = preload("res://cards/Card.tscn")

var initial_cards = []

# holds cards ids
var draw_pile = []
# auto managed list of cards on screen
var cards = []
# holds cards ids
var discard_pile = []

# auto managed list of enemies on screen
var enemies = []

# auto managed
var selected_card = null
var selected_enemy = null

var enemy_turn = false
var current_enemy = 0

var hp = 10 setget set_hp
func set_hp(value):
	hp = value
	$HP/TextureProgress.value = value
	$HP/Label.text = str(hp) + "  " + str(max_hp)

var max_hp = 10 setget set_max_hp
func set_max_hp(value):
	max_hp = value
	$HP/TextureProgress.max_value = value
	$HP/Label.text = str(hp) + "  " + str(max_hp)

var block = 0 setget set_block
func set_block(value):
	block = value
	if block == 0:
		# TODO: add back block_sprite
		#$block_sprite.visible = false
		$Block.visible = false
	else:
		# TODO: add back block_sprite
		#$block_sprite.visible = true
		$Block.visible = true
		$Block.text = str(block)

onready var modifiers = get_node("ModifiersContainer")

var mana setget set_mana
func set_mana(value):
	if value > 9:
		show_warning("You have reached maximum mana available")
		mana = 9
	else:
		mana = value
	$Energy.value = mana
	$Mana.text = str(mana)
	if mana == 0:
		$Mana.set("custom_colors/font_color", Color(0.4, 0.4, 0.4))
		$MaxMana.set("custom_colors/font_color", Color(0.4, 0.4, 0.4))
	else:
		$Mana.set("custom_colors/font_color", Color("#a3d577"))
		$MaxMana.set("custom_colors/font_color", Color("#a3d577"))

var max_mana setget set_max_mana
func set_max_mana(value):
	if value > 9:
		show_warning("You have reached maximum mana available")
		max_mana = 9
	else:
		max_mana = value
	$Energy.max_value = max_mana
	$MaxMana.text = str(max_mana)

func update_cards():
	for c in cards:
		c.update()

func _ready():
	for e in enemies:
		e.init()
	initial_cards = global.cards.duplicate()
	self.max_hp = 70
	self.hp = 70
	self.max_mana = global.current_max_mana
	draw_pile = global.shuffle_list(global.deck)
	new_turn()
	pass

func draw_cards():
	for i in range(global.default_draw_size):
		draw_card()
	pass

# remove card as a scene object, add it's id to discard pile
func discard_card(card):
	discard_pile.append(card.card_id)
	card.remove()
	reposition_cards()

# move shuffled cards from discard pile to draw pile
func reshuffle():
	draw_pile = global.shuffle_list(discard_pile)
	discard_pile.clear()

# create a random card from draw pile as a scene object
# if draw pile is empty move shuffled cards from discard pile to it first
func draw_card():
	if cards.size() == global.max_hand_size:
		show_warning("Your hand is full")
		return
	if draw_pile.size() == 0:
		reshuffle()
	if draw_pile.size() == 0:
		show_warning("No more cards to draw")
		return
	var card = Card.instance()
	card.position = Vector2(0, 0)
	var id = draw_pile.pop_back()
	add_child(card)
	card.init(id, initial_cards[id])
	reposition_cards()

func play_card(card, enemy):
	if enemy_turn:
		return
	if card.type == "attack":
		if card.effect != "all" and enemy == null:
			return
	elif card.type == "skill":
		if card.effect == "target" and enemy == null:
			return
	if self.mana < card.cost:
		show_warning("Not enough mana")
		return
	self.mana = self.mana - card.cost
	
	if card.type == "attack":
		if card.effect == "all":
			for e in enemies:
				Effects.add_effect(0, e.position)
				e.damage(global.get_damage_to_enemy(card.value, modifiers, e.modifiers, card.get("strength_multiplier")))
		elif card.effect == "use_block":
			enemy.damage(global.get_damage_to_enemy(self.block, modifiers, enemy.modifiers, card.get("strength_multiplier")))
		elif card.effect == "only_attack":
			var k = 0
			for c in cards:
				if c.type == "attack":
					k += 1
			if cards.size() == k:
				enemy.damage(global.get_damage_to_enemy(card.value, modifiers, enemy.modifiers, card.get("strength_multiplier")))
			else:
				return
		else:
			Effects.add_effect(0, enemy.position)
			enemy.damage(global.get_damage_to_enemy(card.value, modifiers, enemy.modifiers, card.get("strength_multiplier")))
	elif card.type == "skill":
		if card.effect == "block":
			self.block += global.get_block_player(card.value2, modifiers)
		elif card.effect == "sacrifice":
			self.hp -= card.value2
			self.mana += card.value
		else:
			pass
	for i in range(0, card.modifiers.size(), 3):
		if card.modifiers[i + 1] == "all":
			for e in enemies:
				apply(e, card.modifiers[i], card.modifiers[i + 2])
		elif card.modifiers[i + 1] == "self":
			apply(self, card.modifiers[i], card.modifiers[i + 2])
		elif card.modifiers[i + 1] == "target" and enemy != null:
			apply(enemy, card.modifiers[i], card.modifiers[i + 2])
	discard_card(card)
	pass

func apply(target, modifier, value):
	target.modifiers.add(modifier, value)

# move cards on screen to proper locations
func reposition_cards():
	var offset = ($CardsEnd.position.x - $CardsStart.position.x) / (cards.size() + 1)
	var i = 1
	for c in cards:
		c.initial_position = Vector2($CardsStart.position.x + i * offset, $CardsStart.position.y)
		c.z_index = -i
		i += 1

func damage_player(value):
	if value <= block:
		self.block = block - value
		return
	self.hp = (self.hp - (value - self.block))
	self.block = 0
	pass

func enemy_finished():
	# ATTENTION! (enemy can die during his turn)
	if current_enemy < enemies.size():
		current_enemy += 1
		enemies[current_enemy - 1].turn()
	else:
		new_turn()
	pass

func end_turn():
	modifiers.process()
	# TODO: disable button and cards
	if enemy_turn:
		return
	enemy_turn = true
	for i in range(cards.size() - 1, -1, -1):
		discard_card(cards[i])
	current_enemy = 0
	enemy_finished()
	pass

func new_turn():
	enemy_turn = false
	turn += 1
	self.block = 0
	self.mana = self.max_mana
	draw_cards()

func show_warning(message):
	$Warning.text = message
	$Warning.get_node("AnimationPlayer").play("visible")
	$Warning.get_node("Timer").start()

func enemy_dead():
	if enemies.size() == 0:
		show_warning("Victory!")
		global.return_to_previous()

func _on_Timer_timeout():
	$Warning.get_node("AnimationPlayer").play("fade_out")

func _on_EndTurnButton_pressed():
	end_turn()
