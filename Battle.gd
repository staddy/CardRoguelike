extends Node2D

var turn = 0
var Card = preload("res://Card.tscn")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	draw_cards()
	pass

func draw_cards():
	for i in range(global.default_hand_size):
		var card = Card.instance()
		card.initial_position = Vector2(i * 50, 100)
		card.position = Vector2(0, 0)
		add_child(card)
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
