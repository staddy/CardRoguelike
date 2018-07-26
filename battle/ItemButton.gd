extends "res://ui/Button.gd"

var type
var ammount

signal picked()

func _ready():
	if type == "card":
		$Sprite.texture = load("res://battle/items/card.png")
	elif type == "money":
		$Sprite.texture = load("res://battle/items/coin.png")
		$Label.text = str(ammount)

func _on_ItemButton_pressed():
	if type == "card":
		global.current_card_item = self
		global.goto_subscene(global.CardSelection)
	elif type == "money":
		global.money += ammount
		remove()

func remove():
	get_parent().remove_child(self)
	emit_signal("picked")
	queue_free()