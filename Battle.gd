extends Node2D

var turn = 0
var Card = preload("res://Card.tscn")

var draw_pile = []
var cards = []
var discard_pile = []

var selected_card = null
var selected_enemy = null

func _ready():
	draw_pile = global.shuffle_list(global.deck)
	cards = []
	discard_pile = []
	draw_cards()
	pass

func draw_cards():
	for i in range(global.default_hand_size):
		draw_card()
	pass

func discard_card(card):
	discard_pile.append(card.card_id)
	cards.remove(cards.find(card))
	card.queue_free()
	pass

func reshuffle():
	draw_pile = global.shuffle_list(discard_pile)
	discard_pile.clear()

func draw_card():
	if draw_pile.size() == 0:
		reshuffle()
	var card = Card.instance()
	card.position = Vector2(0, 0)
	var id = draw_pile.pop_back()
	global.init_card(card, id)
	cards.append(card)
	add_child(card)
	reposition_cards()

func play_card(card):
	if selected_card and selected_enemy:
		cards.remove(cards.find(selected_card))
		selected_card.queue_free()
		selected_enemy.queue_free()
		reposition_cards()
	pass

func reposition_cards():
	var offset = ($CardsEnd.position.x - $CardsStart.position.x) / (cards.size() + 1)
	var i = 1
	for c in cards:
		c.initial_position = Vector2($CardsStart.position.x + i * offset, $CardsStart.position.y)
		i += 1

#func _process(delta):
#	pass
