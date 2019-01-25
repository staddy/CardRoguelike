extends Node2D

var Icon = preload("res://map/Icon.tscn")
var Boss = preload("res://map/Boss_icon.tscn")
var map_size = Vector2(1728, OS.window_size.y)
var can_drag = false
var current_icon = null
var start_icons = []

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
	line.add_to_group("line")
	add_child(line)

func node_clicked(node):
	self.current_node = node
	for c in get_tree().get_nodes_in_group("city"):
		c.visible = false
	for c in get_tree().get_nodes_in_group("line"):
		c.visible = false
	can_drag = true
	gen_tree()
	#global.goto_subscene(global.Battle)

func end_level():
	for c in get_tree().get_nodes_in_group("icon"):
		c.queue_free()
		remove_child(c)
	for c in get_tree().get_nodes_in_group("icon_line"):
		c.queue_free()
		remove_child(c)
	for c in get_tree().get_nodes_in_group("city"):
		c.visible = true
	for c in get_tree().get_nodes_in_group("line"):
		c.visible = true
	can_drag = false
	current_icon = null
	start_icons = []
	$Camera2D.position = Vector2(0, 0)

func gen_tree():
	var step = Vector2(0, 0)
	var count = 0
	var turn = 0
	var old_turn = 0
	var trees_count = 3
	var trees = []
	#add boss # pos, groups, color = Color(0, 0, 0, 1), flag = false, r_size = icon_size
	var boss_icon = add_icon(Vector2(map_size.x+160, (1440/2) - 128), ["boss"], true, Boss)
	for i in trees_count:
		var tree = []
		step = Vector2(round_rand(16, 32), 192 + round_rand(64, 80) + i*380 + (i-1)*96)
		while step.x < map_size.x:
			var groups = ["icon", "tree", str("tree_"+str(i)), get_turn_group(turn, old_turn)]
			tree.append(add_icon(step, groups, true))
			old_turn = define_rotation(old_turn, turn, true)
			turn = define_rotation(turn, get_turn(turn))
			if turn == old_turn:
				turn *= -1
			step += Vector2(round_rand(96, 128), get_turn_step(turn))
			if step.distance_to(boss_icon.rect_position) < 1080:
				step.x += 64
				if step.y < boss_icon.rect_position.y - 80:
					step.y += 64
				elif step.y > boss_icon.rect_position.y + 80:
					step.y -= 64
			count += 1
		trees.append(tree)
	for t in trees.size():
		var dist = trees[t].back().rect_position.distance_to(boss_icon.rect_position)
		if dist > 256:
			for i in round(dist/128):
				step = trees[t].back().rect_position + Vector2(128, 0)
				if step.y > boss_icon.rect_position.y + 64:
					step.y -= 64
				elif step.y > boss_icon.rect_position.y + 64:
					step.y += 64
				var groups = ["icon", "tree", str("tree_"+str(t)), "middle"]
				if step.x < boss_icon.rect_position.x - 64:
					trees[t].append(add_icon(step, groups, true))
		if trees.size() > 1:
			for i in trees[1].size():
				if trees[1].size() - i < 4:
					trees[1][i].rect_position.y = boss_icon.rect_position.y + 40 + round_rand(-16, 16)
	for t in trees.size():
		for i in trees[t].size()-1:
			connect_icons(trees[t][i], trees[t][i+1])
			if i == trees[t].size()-2:
				connect_icons(trees[t][i+1], boss_icon)
		gen_branchs(trees[t], t, trees)
	connect_trees(trees)
	start_icons = [trees[0][0], trees[1][0], trees[2][0]]

func gen_branchs(tree, tree_num, trees):
	var min_b = round((tree.size()-1)/5)
	var max_b = min_b*2
	var size = {_min = 2, _max = 3}
	var creating = false
	var branch = { size = 0, side = 0, mas = [] }
	var turn = 0
	var turn_name = "middle"
	var skip = 0
	var step = Vector2(0, 0)
	var dice
	for side in range(2):
		if side == 0:
			branch.side = 1
			turn_name = "down"
		else:
			branch.side = -1
			turn_name = "up"
		for i in min_b:
			var mas = []
			dice = int_rand(1, 3)
			dice += 5*i
			var global_turn = get_global_turn(tree, branch.side, dice)
			branch.size = round_rand(size._min, size._max)
			step = tree[dice].rect_position + Vector2(round_rand(48, 80), round_rand(64, 80)*branch.side)
			if abs(step.y -  tree[dice+1].rect_position.y) < 64:
				step.y += 32*branch.side
			var groups = ["icon", str("tree_"+str(tree_num)), "branch", turn_name, str("side_"+str(branch.side))]
			mas.append(add_icon(step, groups, true))
			tree[dice].add_to_group(str("blocked_"+str(branch.side)))
			for j in branch.size - 1:
				step = tree[dice+j+1].rect_position + Vector2(round_rand(48, 80), round_rand(64, 80)*branch.side)
				if abs(step.y - tree[dice+j+2].rect_position.y) < 64:
					step.y = tree[dice+j+2].rect_position.y + round_rand(48, 80)*branch.side
				for e in get_tree().get_nodes_in_group("branch"):
					if step.distance_to(e.rect_position) < 64:
						continue
				groups = ["icon", str("tree_"+str(tree_num)), "branch", turn_name, str("side_"+str(branch.side))]
				mas.append(add_icon(step, groups, true))
				tree[dice+j+1].add_to_group(str("blocked_"+str(branch.side)))
				#step.y -= tree[dice+j+1].rect_position.y
			for n in mas:
				if tree_num == 1:
					for t in trees[0]:
						if abs(n.rect_position.y - t.rect_position.y) < 64 && abs(n.rect_position.x - t.rect_position.x) < 80:
							t.modulate = Color(1, 0.5, 0.5)
							n.modulate = Color(0.5, 0.5, 1)
							print("del")
				elif tree_num == 2:
					for t in trees[1]:
						if abs(n.rect_position.y - t.rect_position.y) < 64 && abs(n.rect_position.x - t.rect_position.x) < 80:
							t.modulate = Color(1, 0.5, 0.5)
							n.modulate = Color(0.5, 0.5, 1)
							print("del")
			for j in mas.size():
				if j == 0:
					connect_icons(tree[dice], mas[0])
				if j < mas.size()-1:
					connect_icons(mas[j], mas[j+1])
				else:
					if tree[dice+j].rect_position.x < mas[j].rect_position.x:
						connect_icons(mas[j], tree[dice+j+1])
						#tree[dice+j+1].add_to_group(str("blocked_"+str(branch.side)))
					else: connect_icons(mas[j], tree[dice+j])

func connect_trees(trees):
	var sides = [[], [], [], []]
	for icon in get_tree().get_nodes_in_group("tree_0"):
		if !icon.get_groups().has("blocked_1") && !icon.get_groups().has("side_-1"):
			sides[0].append(icon)
	for icon in get_tree().get_nodes_in_group("tree_1"):
		if !icon.get_groups().has("blocked_-1") && !icon.get_groups().has("side_1"):
			sides[1].append(icon)
		if !icon.get_groups().has("blocked_1") && !icon.get_groups().has("side_-1"):
			sides[2].append(icon)
	for icon in get_tree().get_nodes_in_group("tree_2"):
		if !icon.get_groups().has("blocked_-1") && !icon.get_groups().has("side_1"):
			sides[3].append(icon)
	for side in sides:
		for i in side.size():
			for j in side.size():
				if side[i].rect_position.x > side[j].rect_position.x:
					swap(side, i, j)
		side.invert()
	for bridge in 2:
		var size = int_rand(1, 2)
		var dice = int_rand(0, 1)
		var currently = []
		var modificator
		if bridge*2+dice == 0:
			modificator = 1
		elif bridge*2+dice == 1:
			modificator = 0
		elif bridge*2+dice == 2:
			modificator = 3
		else:
			modificator = 2
		for k in range(1, sides[bridge*2+dice].size()-2):
			for icon in sides[modificator]:
				if sides[bridge*2+dice][k].rect_position.distance_to(icon.rect_position) < 512 && icon.rect_position.x > sides[bridge*2+dice][k].rect_position.x + 64:
					currently.append([sides[bridge*2+dice][k], icon])
		var currents = []
		var current = []
		if size == 1:
			var point = trees[1][trees[1].size()/2]
			current = currently[0]
			for c in currently:
				if c[0].rect_position.distance_to(point.rect_position) < current[0].rect_position.distance_to(point.rect_position):
					current = c
			currents.append(current)
		else:
			var points = [trees[1][trees[1].size()/3], trees[1][trees[1].size()/1.5]]
			for j in points.size():
				current = currently[0]
				for c in currently:
					if c[0].rect_position.distance_to(points[j].rect_position) < current[0].rect_position.distance_to(points[j].rect_position):
						current = c
				currents.append(current)
		for c in currents:
			var mas = []
			var dist = c[0].rect_position.distance_to(c[1].rect_position) - 24
			for i in range(1, round(dist/128)):
				var groups = ["icon", "bridge"]
				var step = c[0].rect_position + (c[1].rect_position - c[0].rect_position)/round(dist/128)*i
				if step.distance_to(c[1].rect_position) < 64:
					continue
				mas.append(add_icon(step, groups, true))
			if mas.empty():
				connect_icons(c[0], c[1])
			else:
				connect_icons(c[0], mas.front())
				connect_icons(mas.back(), c[1])
				for i in mas.size()-1:
					connect_icons(mas[i], mas[i+1])

func get_global_turn(tree, turn, dice):
	if tree[dice].get_groups().has("up"):
		if turn == 1:
			return "middle"
		else:
			return "up"
	elif tree[dice].get_groups().has("down"):
		if turn == 1:
			return "down"
		else:
			return "middle"
	else:
		if turn == 1:
			return "down"
		else:
			return "up"

func define_rotation(turn, new_turn, flag = false):
	if flag == false:
		if new_turn != turn:
			return new_turn
		return 0
	else:
		if turn == 1:
			if new_turn == 1:
				return 1
			elif new_turn == -1:
				return 0
			else:
				return 1
		elif turn == -1:
			if new_turn == 1:
				return 0
			elif new_turn == -1:
				return -1
			else:
				return -1
		else:
			if new_turn == 1:
				return 1
			elif new_turn == -1:
				return -1
			else:
				return 0

func get_turn_group(new_turn, turn):
	if turn == 1:
		if new_turn == 1:
			return "up"
		elif new_turn == -1:
			return "middle"
		else:
			return "up"
	elif turn == -1:
		if new_turn == 1:
			return "middle"
		elif new_turn == -1:
			return "down"
		else:
			return "down"
	else:
		if new_turn == 1:
			return "up"
		elif new_turn == -1:
			return "down"
		else:
			return "middle"

func get_turn(old_turn):
	var turn = 0
	if old_turn == 1:
		turn = round_rand(-1, 0)
	elif old_turn == -1:
		turn = round_rand(0, 1)
	else:
		turn = round_rand(-1, 1)
	return turn

func get_turn_step(turn):
	var step
	if turn == 1:
		step = round_rand(-64, -32)
	elif turn == -1:
		step = round_rand(32, 64)
	else:
		step = 0
	return step

func convert_turn_group(turn):
	if turn == "up":
		return 1
	elif turn == "down":
		return -1
	else:
		return 0

func add_icon(pos, groups, flag = false, type = Icon):
	var icon = type.instance()
	icon.rect_position = pos
	for g in groups:
		icon.add_to_group(g)
	add_child(icon)
	if flag:
		return icon

func add_line(pos1, pos2):
	var line = Line2D.new()
	line.add_point(pos1)
	line.add_point(pos2)
	line.set_width(6)
	line.default_color = Color(0, 0, 0)
	line.z_index = -1
	line.add_to_group("icon_line")
	add_child(line)
	pass

func connect_icons(icon1, icon2):
	icon1.can_move_to.append(icon2)
	add_line(icon1.rect_position+icon1.get_size()/2, icon2.rect_position+icon2.get_size()/2)
	pass

func swap(mas, el1, el2):
	var tmp = mas[el1]
	mas[el1] = mas[el2]
	mas[el2] = tmp

func round_rand(a, b):
	return round(rand_range(a, b))

func int_rand(a, b):
	return int(round(rand_range(a, b)))

func bool_rand():
	var r = round(rand_range(0, 1))
	if r == 0:
		return false
	else:
		return true




func _on_Generate_pressed():
	end_level()
	for c in get_tree().get_nodes_in_group("city"):
		c.visible = false
	for c in get_tree().get_nodes_in_group("line"):
		c.visible = false
	can_drag = true
	for c in get_tree().get_nodes_in_group("rect"):
		c.queue_free()
		remove_child(c)
	gen_tree()
	for c in get_tree().get_nodes_in_group("icon"):
		var cr = ColorRect.new()
		cr.rect_size = Vector2(16, 16)
		cr.rect_position = c.rect_position
		cr.add_to_group("rect")
		add_child(cr)