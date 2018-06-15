extends Node2D

# 

var width = 960
var height = 540

var map = []

var trees = [[],[],[]]
var branch = []

### icons type
### fight - 0, random - 1, elite - 2, chest - 3,
### camp - 4, marker - 5, boss - 6
var icons = [
	preload("res://map/objects/fight.tscn").instance(),
	preload("res://map/objects/random.tscn").instance(),
	preload("res://map/objects/elite.tscn").instance(),
	preload("res://map/objects/chest.tscn").instance(),
	preload("res://map/objects/camp.tscn").instance(),
	preload("res://map/objects/market.tscn").instance(),
	preload("res://map/objects/boss1.tscn").instance(),
	]

var zone = preload("res://map/objects/zone.tscn")
var line = preload("res://map/objects/line.tscn")

### Description ###
# 3 core trees
# Distance between icons from 96 to 128px
# 1-4 branches on tree long 1-5
# No branches on branches
# 1-3 connections between trees
# Min, max size trees ???
# Build trees #
# Create Boss icon
# Create core icons to boss and add in map massive
# Zero element of map - end icon, element number 1 - start 
# Map array look - [[obj1.1], [obj2.1, obj.2.2]]
# Create array "m" containing clean tree for build branches
# Create branches
# Create connections

func _ready():
	initing()

func initing():
	randomize(true)
	create_map()

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

func selective_rand(a, b):
	var r = bool_rand()
	if r:
		return a
	else:
		return b

func create_line(x1, y1, x2, y2):
	var l = line.instance()
	l.set_point_position(0, Vector2(x1, y1))
	l.set_point_position(1, Vector2(x2, y2))
	add_child(l)

func create_icon(i, j, active):
	if j == 0:
		# End icon
		var icn2 = icons[4].duplicate()
		icn2.set_scale(Vector2(0.8, 0.8))
		icn2.position = Vector2(active.position.x+10, -960+160)
		icn2.tree = i
		add_child(icn2)
		map.append([icn2])
		trees[i].append(icn2)
		# Start icon
		var icn = icons[0].duplicate()
		icn.set_scale(Vector2(0.8, 0.8))
		icn.position = Vector2(active.position.x, active.position.y)
		icn.tree = i
		add_child(icn)
		return icn
	# Generate type
	var spawn = gen_type(active)
	# Gen turn and step
	var data = gen_turn(active.turn)
	# Gen icon
	var icn = icons[spawn].duplicate()
	icn.tree = i
	icn.turn = data.turn
	icn.set_scale(Vector2(0.8, 0.8))
	icn.position = active.position + data.step
	add_child(icn)
	create_line(active.position.x, active.position.y, icn.position.x, icn.position.y)
	return icn

func gen_type(active):
	var spawn = 0
	var dice = round_rand(1, 100)
	if dice <= 50:
		spawn = 0
	elif dice > 50 and dice <= 60:
		spawn = 1
	elif dice > 60 and dice <= 70:
		spawn = 2
	elif dice > 70 and dice <= 80:
		spawn = 3
	elif dice > 80 and dice < 90:
		spawn = 4
	elif dice > 90 and dice < 100:
		spawn = 5
	return spawn

func gen_turn(oldTurn):
	var data = { turn = 0, step = Vector2(0, 0)}
	data.turn = int_rand(-1, 1)
	if oldTurn == 0:
		if data.turn == 0:
			data.step = Vector2(int_rand(-4, 4), int_rand(-128, -96))
		elif data.turn == 1:
			data.step = Vector2(int_rand(48, 96), int_rand(-128, -96))
		else:
			data.step = Vector2(int_rand(-96, -48), int_rand(-128, -96))
		return data
	elif oldTurn == 1:
		if data.turn == 1 or data.turn == 0:
			data.turn = 1
			data.step = Vector2(int_rand(-4, 4), int_rand(-128, -96))
			return data
		else:
			data.turn = 0
			data.step = Vector2(int_rand(-96, -48), int_rand(-128, -96))
			return data
	else:
		if data.turn == -1 or data.turn == 0:
			data.turn = -1
			data.step = Vector2(int_rand(-4, 4), int_rand(-128, -96))
			return data
		else:
			data.turn = 0
			data.step = Vector2(int_rand(48, 96), int_rand(-128, -96))
			return data

func _gen_turn(data):
	# Make icon oriented to top
	# Tratata generate turn
	var turn = selective_rand(-1, 1)
	var step = Vector2(0, 0)
	if turn == -1:
		data.turn = -2
		step = Vector2(int_rand(-96, -48), int_rand(-96, -64))
		if not check_area(data.active, step):
			data.turn = 2
			step = Vector2(int_rand(48, 96), int_rand(-96, -64))
	else:
		data.turn = 2
		step = Vector2(int_rand(48, 96), int_rand(-96, -64))
		if not check_area(data.active, step):
			data.turn = -2
			step = Vector2(int_rand(-96, -48), int_rand(-96, -64))
	data.step = step
	if not check_area(data.active, step):
		return null
	return data

func check_area(active, step):
	var z = zone.instance()
	z.position = active.position + step
	add_child(z)
	for i in map.size():
		for c in map[i]:
			var dist = z.position.distance_to(c.position)
			if dist < 48:
				z.queue_free()
				return false
	z.queue_free()
	return true

func create_branch(i, j, h, active): # For branches
	var k = h
	var data = { active = active, turn = 0, step = Vector2(0, 0) }
	data = _gen_turn(data)
	while k > 0:
		var spawn = gen_type(active)
		if data == null:
			# End build code
			break
		if k != h:
			data.step = Vector2(int_rand(-4, 4), int_rand(-96, -64))
		if check_area(data.active, data.step):
			var icn = icons[spawn].duplicate()
			icn.tree = i
			icn.turn = data.turn
			icn.set_scale(Vector2(0.8, 0.8))
			icn.position = active.position + data.step
			icn.get_node("Sprite").modulate.r8 = 55
			add_child(icn)
			create_line(active.position.x, active.position.y, icn.position.x, icn.position.y)
			active = icn
			data.active = active
			map[j].append(active)
			branch.append(active)
		k -= 1

func create_map():
	var dice = 0
	# Create boss
	var b = icons[6].duplicate()
	b.position = Vector2(480, -960)
	add_child(b)
	# Create core trees
	for i in trees.size():
		var j = 0
		var active = { position = {x = -64 + (i+1)*275, y = 400} }
		while active.position.y >= b.position.y + 360:
			active = create_icon(i, j, active)
			map.append([active])
			trees[i].append(active)
			j += 1
		create_line(active.position.x, active.position.y, trees[i][0].position.x, trees[i][0].position.y)
	# Create branches
	for i in trees.size():
		var mark = false
		var completed = false
		var h = int_rand(2, 4)
		var s = int_rand(2, 4)
		var j = 1
		branch = []
		var active = trees[i][j]
		while not completed:
			active = trees[i][j]
			#turn -2, 2
			dice = bool_rand()
			if dice or mark:
				create_branch(i, j, h, active)
				j += h
				s -= 1
			j += 1
			if s == 0:
				completed = true
				continue
			if j >= trees[i].size()-1 and not completed:
				j = 1
		#print(branch)






