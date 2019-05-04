extends Node2D

var MapIcon = preload("res://ui/Button.tscn")
var IconTexture = preload("res://map/map_icons/chest.png")

var letters = ["吧","爸","八","百","北","不","田","由","甲","申","甴","电","甶","男","甸","甹","町","画","甼","甽","甾","甿","畀","畁","畂","畃","畄","畅","畆","畇","畈","畉","畊","畋","界","畍","畎","畏","畐","畑"]
var font = DynamicFont.new()

var random_seed = 0
var floors_number = 15
var min_rooms = 2
var max_rooms = 5
var min_first_floor = 3

var max_connections = 3

var floors = []
var icons = []
var symbols = []

var pressed = false
var old_position = 0

var X_OFFSET = 960 / 8
var X = 960
var Y = 540
var FLOOR_HEIGHT = 200
var FIRST_FLOOR_HEIGHT = 100

var MIN_Y = 0
var MAX_Y = 3000

var FONT_SIZE = 20
var FONT_SPACE = 15
var DELTA = 5.0

var TIME = 0.0
var UPDATE = 0.1

func init_font():
	var data = DynamicFontData.new()
	data.font_path = "res://Zpix.ttf"
	font.font_data = data
	font.size = FONT_SIZE

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
			var connections = 1
			var delta = next - last_connected
			if delta > max_connections:
				delta = max_connections
			connections += (randi() % delta)
			
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
			if (j == (current - 1)) and (last_connected < (next - 1)):
				connections = floors[i][j].size() + (next - 1 - last_connected)

			while floors[i][j].size() < connections:
				last_connected += 1
				floors[i][j].append(last_connected)
			
			connections = floors[i][j].size()
			if connections > max_connections:
				var to_remove = []
				var dc = connections - max_connections
				for k in range(dc):
					to_remove.append(floors[i][j][k])
				for tr in to_remove:
					if not floors[i][j - 1].has(tr):
						floors[i][j - 1].append(tr)
					floors[i][j].erase(tr)


func _ready():
	init_font()
	if random_seed == 0:
		randomize()
	else:
		seed(random_seed)
	generate()


func generate():
	floors = []
	icons = []
	symbols = []
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
	var posY = Y - FIRST_FLOOR_HEIGHT
	var i = 0
	var path_width = (X - X_OFFSET * 2)
	for f in floors:
		var counter = 0
		icons.append([])
		for r in f:
			var icon = MapIcon.instance()
			icon.rect_scale.x = 1
			icon.rect_scale.y = 1
			icon.rect_position.x = X_OFFSET + (counter + 1) * (path_width / (f.size() + 1)) + (rand_range(-10, 10)) - icon.rect_size.x / 2
			icon.rect_position.y = posY + (rand_range(-30, 30)) - icon.rect_size.y / 2
			icon.texture = IconTexture
			icon.texture_hover = IconTexture
			$ItemsContainer.add_child(icon)
			icons[i].append(icon)
			counter += 1
		posY -= FLOOR_HEIGHT
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
		line.z_index = -1
		line.default_color = Color(0, 0.2, 0)
		$ItemsContainer/LabelsContainer.add_child(line)

func draw_symbols_line(p1, p2):
	var v = p2 - p1
	var v_normalized = v.normalized()
	var n = ceil(v.length() / (FONT_SIZE + FONT_SPACE))
	var current = p1
	for i in range(n):
		var label = Label.new()
		label.add_font_override("font", font)
		label.add_color_override("font_color", Color(0, 0.3 + rand_range(0.0, 0.7), 0))
		label.rect_position = current - Vector2(FONT_SIZE, FONT_SIZE) / 2 + Vector2(0, rand_range(-DELTA, DELTA))
		label.rect_position.x = round(label.rect_position.x / (FONT_SIZE + FONT_SPACE)) * (FONT_SIZE + FONT_SPACE)
		#label.rect_position.y = round(label.rect_position.y / (FONT_SIZE + FONT_SPACE)) * (FONT_SIZE + FONT_SPACE)
		label.text = letters[randi() % letters.size()]
		$ItemsContainer/LabelsContainer.add_child(label)
		symbols.append(label)
		current += (v_normalized * (FONT_SIZE + FONT_SPACE))

func draw_connections():
	for i in range(floors_number - 1):
		var current = floors[i].size()
		#var r = randi()
		#var c = 1
		for j in range(current):
			for p in floors[i][j]:
				draw_symbols_line(icons[i][j].rect_position + icons[i][j].rect_size / 2, icons[i + 1][p].rect_position + icons[i + 1][p].rect_size / 2)#, 0.45 + (r % c) * 0.3)
				draw_dotted_line(icons[i][j].rect_position + icons[i][j].rect_size / 2, icons[i + 1][p].rect_position + icons[i + 1][p].rect_size / 2)
				#c += 1

func _process(delta):
	TIME += delta
	if TIME > UPDATE:
		TIME = 0.0
		for i in range(100):
			var s = symbols[randi() % symbols.size()]
			s.text = letters[randi() % letters.size()]
		for i in range(100):
			var s = symbols[randi() % symbols.size()]
			s.add_color_override("font_color", Color(0, 0.3 + rand_range(0.0, 0.7), 0))




func _on_Button_pressed():
	var tmp = $ItemsContainer
	var pos = tmp.position
	remove_child(tmp)
	tmp.queue_free()
	var node = Node2D.new()
	node.position = pos
	node.name = "ItemsContainer"
	add_child(node)
	var tmp2 = Node2D.new()
	tmp2.name = "LabelsContainer"
	node.add_child(tmp2)
	generate()
