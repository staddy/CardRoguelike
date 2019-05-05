extends Node2D

var Item = preload("res://battle/ItemButton.tscn")

func _ready():
	var y = 0
	for item in global.current_reward:
		var newItem = Item.instance()
		newItem.type = item["type"]
		newItem.ammount = null if not item.has("ammount") else item["ammount"]
		newItem.artifact_id = null if not item.has("artifact_id") else item["artifact_id"]
		newItem.connect("picked", self, "check_loot")
		newItem.rect_position.y = y
		$Container.add_child(newItem)
		y += (newItem.rect_size.y * newItem.rect_scale.y + 10)

func check_loot():
	if $Container.get_child_count() == 0:
		finish()
	else:
		var y = 0
		for child in $Container.get_children():
			child.rect_position.y = y
			y += (child.rect_size.y * child.rect_scale.y + 10)

func finish():
	global.return_to_previous()


func _on_Continue_pressed():
	finish()
