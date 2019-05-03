extends Node2D

var MapIcon = preload("res://ui/Button.tscn")
var IconTexture = preload("res://map/map_icons/chest.png")

var random_seed = 0
var floors_number = 15
var min_rooms = 2
var max_rooms = 5
var min_first_floor = 3

var floors = []
var icons = []

var pressed = false
var old_position = 0

var X = 960 / 2
var Y = 540

var MIN_Y = 0
var MAX_Y = 3000

func generate_floors():
	floors.resize(floors_number)
	var m = (max_rooms - min_rooms) + 1
	for i in range(floors_number):
		var rooms = randi() % m + min_rooms
		floors[i] = []
		for j in range(rooms):
			floors[i].append([])
	while floors[0].size() < min_first_floor:
		floors[0].append([])
	
	for i in range(floors_number - 1):
		var current = floors[i].size()
		var next = floors[i + 1].size()
		floors[i][0].append(0)
		var last_connected = 0
		for j in range(current):
			if last_connected == (next - 1):
				floors[i][j].append(last_connected)
				continue
			var connections = 1 + (randi() % (next - last_connected))
			
			if connections > 1:
				if (randi() % 2 == 0):
					connections -= 1
			if connections > 1:
				if (randi() % 2 == 0):
					connections -= 1
#			if connections > 1:
#				if (randi() % 2 == 0):
#					connections -= 1
#			if connections > 1:
#				if (randi() % 2 == 0):
#					connections -= 1
			
			if (j != 0) and ((connections == (next - last_connected)) or (randi() % 4 == 0)):
				floors[i][j].append(last_connected)
			if (j == (current - 1)) and (last_connected < (next - 1 - 1)):
				connections = floors[i][j].size() + (next - 1 - 1 - last_connected)
			while floors[i][j].size() < connections:
				last_connected += 1
				floors[i][j].append(last_connected)
		if not floors[i][current - 1].has(next - 1):
			floors[i][current - 1].append(next - 1)
	
	for f in floors:
		print(f)

func _ready():
	if random_seed == 0:
		randomize()
	else:
		seed(random_seed)
	
	generate_floors()
	generate_icons()
	draw_connections()

func _input(event):
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		if pressed:
			$ItemsContainer.position.y += (event.position - old_position).y
			if $ItemsContainer.position.y > MAX_Y:
				$ItemsContainer.position.y = MAX_Y
			elif $ItemsContainer.position.y < MIN_Y:
				$ItemsContainer.position.y = MIN_Y
			old_position = event.position
	elif event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.is_pressed():
			old_position = event.position
			pressed = true
		else:
			pressed = false

func generate_icons():
	var posY = Y - 100
	var i = 0
	for f in floors:
		var counter = 0
		icons.append([])
		for r in f:
			var icon = MapIcon.instance()
			icon.rect_scale.x = 1
			icon.rect_scale.y = 1
			icon.rect_position.x = (counter + 1) * (X / f.size()) + (rand_range(-10, 10))
			icon.rect_position.y = posY + (rand_range(-30, 30))
			icon.texture = IconTexture
			icon.texture_hover = IconTexture
			$ItemsContainer.add_child(icon)
			icons[i].append(icon)
			counter += 1
		posY -= 200
		i += 1

func draw_dotted_line(p1, p2):
	var scale = 4
	var ll = 15.0
	var ls = 5.0
	var delta = 3.0
	var v = p2 - p1
	var v_normalized = v.normalized()
	var n = v.length() / (ll + ls)
	var current = p1
	for i in range(n):
		var line = Line2D.new()
		line.add_point((current + Vector2(rand_range(-delta, delta), rand_range(-delta, delta))) / scale)
		current += (v_normalized * ll)
		line.add_point((current + Vector2(rand_range(-delta, delta), rand_range(-delta, delta))) / scale)
		current += (v_normalized * ls)
		line.width = 1
		line.scale = Vector2(scale, scale)
		line.z_index = -500
		line.default_color = Color(0, 0, 0)
		$ItemsContainer.add_child(line)
	pass

func draw_connections():
	for i in range(floors_number - 1):
		var current = floors[i].size()
		for j in range(current):
			for p in floors[i][j]:
				draw_dotted_line(icons[i][j].rect_position + icons[i][j].rect_size / 2, icons[i + 1][p].rect_position + icons[i + 1][p].rect_size / 2)
#				var line = Line2D.new()
#				line.add_point((icons[i][j].rect_position + icons[i][j].rect_size / 2) / 4)
#				line.add_point((icons[i + 1][p].rect_position + icons[i + 1][p].rect_size / 2) / 4)
#				line.width = 1
#				line.scale = Vector2(4, 4)
#				line.z_index = -500
#				line.default_color = Color(0, 0, 0)
#				$ItemsContainer.add_child(line)


