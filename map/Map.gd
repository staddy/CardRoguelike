extends Node2D

var nodes = []
var current_node = null setget set_current_node

func set_current_node(value):
	current_node = value
	for node in nodes:
		if node in current_node.connections:
			node.enabled = true
		else:
			node.enabled = false

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
	#nodes = [$L1_1, $L2_1, $L2_2, $L2_3, $L3_1, $L3_2, $L3_3, $L4_1, $L4_2, $L5_1]
	for node in nodes:
		node.connect("node_clicked", self, "node_clicked")
	
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
	
	self.current_node = $L1_1
	pass

func draw_connections():
	for node in nodes:
		for node2 in nodes:
			if node.level == node2.level:
				connect_nodes(node, node2)
	connect_nodes($L1_1, $L2_1)
	pass

func connect_nodes(node1, node2):
	node1.connections.append(node2)
	node2.connections.append(node1)
	var line = Line2D.new()
	line.add_point(node1.rect_position + node1.get_offset())
	line.add_point(node2.rect_position + node2.get_offset())
	line.z_index = -500
	line.default_color = Color(0, 0, 0)
	add_child(line)

func node_clicked(node):
	self.current_node = node
	global.goto_subscene(scenes.Battle)

