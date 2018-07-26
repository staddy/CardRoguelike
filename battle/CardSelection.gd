extends Node2D

var N = 3
var cards = []
var Card = preload("res://cards/Card.tscn")

func reposition_cards():
	var offset = ($CardsEnd.position.x - $CardsStart.position.x) / (cards.size() + 1)
	var i = 1
	for c in cards:
		c.initial_position = Vector2($CardsStart.position.x + i * offset, $CardsStart.position.y)
		c.z_index = -i
		i += 1

func draw_card():
	var card = Card.instance()
	card.position = Vector2(0, 0)
	var id = 0#draw_pile.pop_back()
	add_child(card)
	card.init(id)
	card.play_mode = false
	card.connect("clicked", self, "card_selected")
	reposition_cards()

func card_selected(id):
	global.return_to_previous()

func _ready():
	for i in N:
		draw_card()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
