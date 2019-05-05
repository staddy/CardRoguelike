extends Node2D

var Modifier = preload("Modifier.tscn")

var modifiers_instances = {}

func update_parent():
	if get_parent().is_in_group("enemy"):
		get_parent().update_intent_value()
	elif get_parent().is_in_group("battle"):
		get_parent().update_cards()
		pass
	pass

func add(m, v):
	modifiers_instances[m].value += v
	update_parent()

func set(m, v):
	modifiers_instances[m].value = v
	update_parent()

func reset():
	for m in global.Modifiers:
		set(global[m], 0)
	update_parent()

func has(m):
	if get(m) > 0:
		return true
	else:
		return false

func process():
	for m in modifiers_instances.keys():
		if has(m) and global.does_decrease(m):
			add(m, -1)

func get(m):
	return modifiers_instances[m].value
	

func _ready():
	for m in global.Modifiers:
		var modifier = Modifier.instance()
		$HBoxContainer.add_child(modifier)
		modifier.type = global.Modifiers[m]
		modifier.value = 0
		modifiers_instances[global.Modifiers[m]] = modifier

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
