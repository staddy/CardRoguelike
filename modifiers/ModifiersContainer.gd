extends Node2D

var Modifier = preload("Modifier.tscn")

var modifiers_instances = {}

func add(m, v):
	modifiers_instances[m].value += v

func _ready():
	for m in global.Modifiers:
		var modifier = Modifier.instance()
		$HBoxContainer.add_child(modifier)
		modifier.type = global[m]
		modifier.value = 0
		modifiers_instances[global[m]] = modifier
	add(global.DEXTERITY, 10)
	add(global.VULNERABILITY, -10)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
