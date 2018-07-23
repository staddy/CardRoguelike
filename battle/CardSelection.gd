extends Node2D

var Card = preload("res://cards/Card.tscn")

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

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

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
