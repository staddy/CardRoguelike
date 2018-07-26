extends Node2D

var Item = preload("res://battle/ItemButton.tscn")

func _ready():
	for item in global.current_reward:
		var newItem = Item.instance()
		newItem.connect("picked", self, "check_loot")
		$VBoxContainer.add_child(newItem)

func check_loot():
	if $VBoxContainer.get_child_count() == 0:
		finish()

func finish():
	if global.step >= global.current_loc.size:
		global.return_to_previous()
		global.step = 0
	else:
		global.goto_scene(global.Battle)