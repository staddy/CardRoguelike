extends Node2D

# 

var width = 960
var height = 540

var map = []

var player_place = null

var trees = [[],[],[]]
var branch = []
var apexes = []

var spawned = [[],[],[],[]]

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
	return a if bool_rand() else b

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
		icn.start = true
		add_child(icn)
		return icn
	# Generate type
	var spawn = gen_type(active, j)
	# Gen turn and step
	var data = gen_turn(active.turn)
	# Gen icon
	var icn = icons[spawn].duplicate()
	icn.tree = i
	icn.turn = data.turn
	icn.set_scale(Vector2(0.8, 0.8))
	icn.position = active.position + data.step
	add_child(icn)
	icn.connect = active
	create_line(active.position.x, active.position.y, icn.position.x, icn.position.y)
	return icn

func gen_type(active, j):
	return 0
  # very bad code /^\
### icons type
### fight - 0, random - 1, elite - 2, chest - 3,
### camp - 4, marker - 5, boss - 6
func change_type(zone):
	var dice
	var spawn
	if zone == 0:
		spawn = 0
	elif zone == 1:
		if bool_rand():
			spawn = 0
		else:
			spawn = 1
	elif zone == 2:
		dice = int_rand(1, 10)
		if dice == 1:
			spawn = 4
		elif dice > 1 and dice <= 5:
			spawn = 0
		elif dice > 5 and dice <= 7:
			spawn = 1
		elif dice > 7 and dice <= 9:
			spawn = 2
		elif dice == 10:
			spawn = 3
	elif zone == 3:
		dice = int_rand(1, 10)
		if dice == 1:
			spawn = 4
		elif dice > 1 and dice <= 5:
			spawn = 0
		elif dice > 5 and dice <= 7:
			spawn = 1
		elif dice > 7:
			spawn = 2
	return spawn

func apply_change_icn(icn, type):
	var n = icons[type].duplicate()
	n.set_scale(Vector2(0.8, 0.8))
	n.position = Vector2(icn.position.x, icn.position.y)
	n.tree = icn.tree
	n.other = icn.other 
	n.type = type
	n.turn = icn.turn
	n.use = icn.use
	n.start = icn.start
	n.connect = icn.connect
	add_child(n)
	icn.queue_free()

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

func _gen_turn(data, core):
	# Make icon oriented to top
	# Tratata generate turn
	var turn = selective_rand(-1, 1)
	var step = Vector2(0, 0)
	if turn == -1:
		data.turn = -2
		step = Vector2(int_rand(-96, -48), int_rand(-96, -64))
		if not check_area(data.active, step) or core.use.l:
			data.turn = 2
			step = Vector2(int_rand(48, 96), int_rand(-96, -64))
	else:
		data.turn = 2
		step = Vector2(int_rand(48, 96), int_rand(-96, -64))
		if not check_area(data.active, step) or core.use.r:
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
			if dist < 64:
				z.queue_free()
				return false
	z.queue_free()
	return true

func check_line(active, target, i, j):
	var distY = 0
	if active.position.y >= 0:
		distY = active.position.y - target.position.y
	else:
		distY = abs(target.position.y - active.position.y) 
	if distY > 142:
		var t = trees[i][j-1]
		return check_line(active, t, i, j-1)
	return j

func create_branch(i, j, h, active): # For branches
	var k = h
	if j >= trees[i].size()-2 and k > 3:
		h = 3
		k = 3
	var data = { active = active, turn = 0, step = Vector2(0, 0) }
	data = _gen_turn(data, trees[i][j])
	if data == null:
		return
	if active.position.x + data.step.x > 900 or active.position.x + data.step.x < 60 :
		return
	while k > 0:
		var spawn = gen_type(active, j)
		if data == null:
			j = check_line(active, trees[i][j], i, j)
			active.connect = trees[i][j]
			create_line(active.position.x, active.position.y, trees[i][j].position.x, trees[i][j].position.y)
			break
		if j <= trees[i].size()-1:
			if data.turn == 2 and trees[i][j].use.r:
				active.connect = trees[i][j]
				create_line(active.position.x, active.position.y, trees[i][j].position.x, trees[i][j].position.y)
				break
			elif data.turn == -2 and trees[i][j].use.l:
				active.connect = trees[i][j]
				create_line(active.position.x, active.position.y, trees[i][j].position.x, trees[i][j].position.y)
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
			if j <= trees[i].size()-1:
				if icn.position.x < trees[i][j].position.x and trees[i][j].turn == 1 and icn.turn == 2:
					icn.position.x += 48
				elif icn.position.x > trees[i][j].position.x and trees[i][j].turn == -1 and icn.turn == -2:
					icn.position.x -= 48
			active.connect = icn
			create_line(active.position.x, active.position.y, icn.position.x, icn.position.y)
			active = icn
			data.active = active
			var p = 0
			for _i in i:
				p += trees[i].size()
			map[p+j][0].get_node("Sprite").modulate.g8 = 55
			map[p+j].append(active)
			branch.append(active)
			if j <= trees[i].size()-1:
				if data.turn == 2:
					trees[i][j].use.r = true
				else:
					trees[i][j].use.l = true
		j += 1
		if k == 1:
			if j <= trees[i].size()-1:
				j = check_line(active, trees[i][j], i, j)
				if active.turn == 2:
					trees[i][j].use.r = true
				else:
					trees[i][j].use.l = true
				active.connect = trees[i][j]
				create_line(active.position.x, active.position.y, trees[i][j].position.x, trees[i][j].position.y)
			else:
				var e = null
				for c in trees[i]:
					var dist = active.position.distance_to(c.position)
					if dist < 200 and c.position.y < active.position.y:
						e = c
					if e != null:
						continue
				if e != null:
					active.connect = e
					create_line(active.position.x, active.position.y, e.position.x, e.position.y)
				else:
					apexes.append(active)
				break
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
		active.connect = trees[i][0]
		trees[i][0].connect = b
		create_line(active.position.x, active.position.y, trees[i][0].position.x, trees[i][0].position.y)
		create_line(trees[i][0].position.x, trees[i][0].position.y, b.position.x, b.position.y)
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
			if j >= trees[i].size()-2 and not completed:
				j = 1
	for c in apexes:
		c.connect = b
		create_line(c.position.x, c.position.y, b.position.x, b.position.y)
	var k = 0
	var spawn = 0
	for i in map.size():
		for c in map[i]:
			if c.start:
				k = 0
			if k <= 3:
				spawn = change_type(0)
				spawned[0].append(spawn)
				apply_change_icn(c, spawn)
			if k > 3 and k <= 7:
				spawn = change_type(1)
				spawned[1].append(spawn)
				apply_change_icn(c, spawn)
			if k > 7 and k <= 12:
				spawn = change_type(2)
				spawned[2].append(spawn)
				apply_change_icn(c, spawn)
			if k > 12:
				spawn = change_type(3)
				spawned[3].append(spawn)
				apply_change_icn(c, spawn)
			k+=1


