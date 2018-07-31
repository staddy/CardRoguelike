extends Node2D

var level1_nodes = null
var level2_nodes = null
var level3_nodes = null
var level4_nodes = null
var level5_nodes = null
var nodes = null

var connections = {}
var visited = []
var current_node = null

func set_max_hp():
	$MaxHp.text = str(global.max_hp)

func set_current_hp():
	$CurrentHp.text = str(global.current_hp)

func set_max_energy():
	$MaxEnergy.text = str(global.max_energy)

func set_strength():
	$Strength.text = str(global.strength)

func set_dexterity():
	$Dexterity.text = str(global.dexterity)

func set_money():
	$Money.text = str(global.money)

func _ready():
	nodes = [$L1_1, $L2_1, $L2_2, $L2_3, $L3_1, $L3_2, $L3_3, $L4_1, $L4_2, $L5_1]
	for node in nodes:
		node.connect("start_battle", self, "start_battle")
	
	current_node = $L1_1.name
	visited.append($L1_1.name)
	
	set_max_hp()
	set_current_hp()
	set_max_energy()
	set_strength()
	set_dexterity()
	set_money()
	global.connect("max_hp_changed", self, "set_max_hp")
	global.connect("current_hp_changed", self, "set_current_hp")
	global.connect("max_energy_changed", self, "set_max_energy")
	global.connect("strength_changed", self, "set_strength")
	global.connect("dexterity_changed", self, "set_dexterity")
	global.connect("money_changed", self, "set_money")
	draw_connections()
	pass

func draw_connections():
	for node in nodes:
		for node2 in nodes:
			if node.level == node2.level:
				connect_nodes(node, node2)
	pass

func connect_nodes(node1, node2):
	if not connections.has(node1.name):
		connections[node1.name] = []
	if not connections.has(node2.name):
		connections[node2.name] = []
	connections[node1.name].append(node2.name)
	connections[node2.name].append(node1.name)
	var line = Line2D.new()
	line.add_point(node1.rect_position + node1.get_offset())
	line.add_point(node2.rect_position + node2.get_offset())
	line.z_index = -500
	line.default_color = Color(0, 0, 0)
	add_child(line)

func start_battle(level):
	global.goto_subscene(global.Battle)

