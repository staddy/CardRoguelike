extends Node2D

var Modifier = preload("Modifier.tscn")

var modifiers_instances = {}

func add(m, v):
	modifiers_instances[m].value += v

func set(m, v):
	modifiers_instances[m].value = v

func reset():
	for m in global.Modifiers:
		set(global[m], 0)

func has(m):
	if get(m) > 0:
		return true
	else:
		return false

func get(m):
	return modifiers_instances[m].value

func _ready():
	for m in global.Modifiers:
		var modifier = Modifier.instance()
		$HBoxContainer.add_child(modifier)
		modifier.type = global[m]
		modifier.value = 0
		modifiers_instances[global[m]] = modifier

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
