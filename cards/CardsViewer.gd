extends Node2D

var Card = preload("res://cards/Card.tscn")

var pressed = false
var old_position = 0

var card_size = Vector2(160, 214)
var columns = 5
var rows = 2

var N = 0

var X_OFFSET = -325
var Y_OFFSET = -130

var VIEWER_HEIGHT = 470

var MIN_Y = 0
var MAX_Y = 0 + Y_OFFSET

func _ready():
	$CardsArea/CardsContainer.position = Vector2(X_OFFSET, Y_OFFSET)
	N = global.cards_viewer_ids.size()
	MIN_Y = -int(N / columns + (1 if (N % columns != 0) else 0)) * card_size.y + Y_OFFSET + VIEWER_HEIGHT
	if MIN_Y > MAX_Y:
		MIN_Y = MAX_Y
	var counter = 0;
	for id in global.cards_viewer_ids:
		var card = Card.instance()
		card.position = Vector2((counter % columns) * card_size.x, int(counter / columns) * card_size.y)
		$CardsArea/CardsContainer.add_child(card)
		card.init(id, global.cards_viewer_cards[id])
		card.play_mode = false
		card.connect("clicked", self, "card_selected")
		counter += 1
	pass

func _input(event):
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		if pressed:
			$CardsArea/CardsContainer.position.y += (event.position - old_position).y
			if $CardsArea/CardsContainer.position.y > MAX_Y:
				$CardsArea/CardsContainer.position.y = MAX_Y
			elif $CardsArea/CardsContainer.position.y < MIN_Y:
				$CardsArea/CardsContainer.position.y = MIN_Y
			old_position = event.position
	elif event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.is_pressed():
			old_position = event.position
			pressed = true
		else:
			pressed = false


func _on_Back_pressed():
	global.return_to_previous()
