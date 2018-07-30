extends "res://ui/Button.gd"

var type
var ammount
var artifact_id

signal picked()

func _ready():
	if type == "card":
		$Icon.texture = load("res://battle/items/card.png")
	elif type == "money":
		$Icon.texture = load("res://battle/items/coin.png")
		$Label.text = str(ammount)
	elif type == "artifact":
		$Icon.texture = load(global.artifacts[artifact_id].small_image)
		$Label.text = global.artifacts[artifact_id].name

func _on_ItemButton_pressed():
	if type == "card":
		global.current_card_item = self
		global.goto_subscene(global.CardSelection)
	elif type == "money":
		global.money += ammount
		remove()
	elif type == "artifact":
		global.add_artifact(artifact_id)
		remove()

func remove():
	get_parent().remove_child(self)
	emit_signal("picked")
	queue_free()