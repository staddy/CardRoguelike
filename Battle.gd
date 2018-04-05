extends Node2D

var turn = 0
var Card = preload("res://Card.tscn")

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

var hp = 10 setget set_hp
func set_hp(value):
	hp = value
	$TextureProgress.value = value
	$TextureProgress.get_node("Label").text = str(hp) + " of " + str(max_hp)

var max_hp = 10 setget set_max_hp
func set_max_hp(value):
	max_hp = value
	$TextureProgress.max_value = value
	$TextureProgress.get_node("Label").text = str(hp) + " of " + str(max_hp)

var mana setget set_mana
func set_mana(value):
	# TODO: update value on the scene
	mana = value

var max_mana setget set_max_mana
func set_max_mana(value):
	# TODO: update value on the scene
	max_mana = value

func _ready():
	self.max_hp = 70
	self.hp = 70
	draw_pile = global.shuffle_list(global.deck)
	draw_cards()
	pass

func draw_cards():
	for i in range(global.default_hand_size):
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
	if draw_pile.size() == 0:
		reshuffle()
	var card = Card.instance()
	card.position = Vector2(0, 0)
	var id = draw_pile.pop_back()
	global.init_card(card, id)
	add_child(card)
	reposition_cards()

func play_card(card):
	if selected_card and selected_enemy:
		selected_enemy.remove()
		discard_card(card)
	pass

# move cards on screen to proper locations
func reposition_cards():
	var offset = ($CardsEnd.position.x - $CardsStart.position.x) / (cards.size() + 1)
	var i = 1
	for c in cards:
		c.initial_position = Vector2($CardsStart.position.x + i * offset, $CardsStart.position.y)
		i += 1

#func _process(delta):
#	pass
