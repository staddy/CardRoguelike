extends Node2D

var map_icons = preload("res://map/objects/map_icons.tscn")
var parts_town = preload("res://map/objects/town.tscn")

var width = 960
var height = 540

var iconsMas = []
var townMas = []
var MAP = []
var spawn = 0
var sequence = { value1 = 0, value2 = 0, value3 = 0 }

var town = { h = 0 }
var trees = [[],[],[]]

var player = { townLvl = -1 }

func _ready():
	initing()

func initing():
	randomize(true)
	add_classes()
	town_create()

func add_classes():
	var m = map_icons.instance()
	for i in m.get_children().size():
		if m.get_child(i).is_in_group("icon"):
			iconsMas.append(m.get_child(i))
	var t = parts_town.instance()
	for i in t.get_children().size():
		if t.get_child(i).is_in_group("town"):
			townMas.append(t.get_child(i))

func icon_gen(line, h):
	#проверка на повторение
	spawn = round(rand_range(1, 10))
	if spawn < 6:
		spawn = 0
	elif spawn == 6:
		spawn = 1
	elif spawn == 7:
		spawn = 2
	elif spawn == 8:
		spawn = 3
	elif spawn == 9:
		spawn = 4
	elif spawn == 10:
		spawn = 5
	if h > 0 and h < town.h-1:
		if spawn != 0 and trees[line][h-1] == spawn:
			while spawn == trees[line][h-1]:
				spawn = round(rand_range(0, 5))
		else:
			if trees[line][h-1] == trees[line][h-2]:
				spawn = round(rand_range(1, 5))
			else:
				spawn == 0
	elif h+1 == town.h:
		spawn = 2

func town_create():
	town.h = round(rand_range(3, 10))
	var offset = Vector2(0, 32)
	var this = { x = width/2, y = height, size = null, lvl = 1 }
	var step = Vector2(this.x, this.y)
	var k = 0
	#create entrance
	var e = townMas[3].duplicate()
	offset.x = 10
	e.position = Vector2(this.x-offset.x, this.y-offset.y)
	add_child(e)
	offset.y += 64
	#create bottom part
	var b = townMas[0].duplicate()  # ↓↓↓ incorrect offset 
	b.position = Vector2(this.x, this.y-offset.y)
	add_child(b)
	this.size = b.get_node("Sprite").get_texture().get_size()
	offset = Vector2(2, -28)
	step -= Vector2(offset.x, (this.size.y - offset.y))
	#create middle part
	for i in range(town.h):
		var m = townMas[1].duplicate()
		m.position = Vector2(step.x, step.y)
		add_child(m)
		this.size = m.get_node("Sprite").get_texture().get_size()
		step.y -= this.size.y
		#create icons for windows
		for j in range(3):
			icon_gen(j, i)
			var n = iconsMas[spawn].duplicate()
			n.position = m.position - this.size/2 + Vector2(160+(j*50), 70)#+50
			add_child(n)
			trees[j].append(spawn)
			MAP.append(n)
			n.type = spawn
			n.level = this.lvl
			n.tree = j
			k += 1
		this.lvl += 1
	#create top part
	var t = townMas[2].duplicate()
	this.size = t.get_node("Sprite").get_texture().get_size()
	t.position = Vector2(step.x, step.y - this.size.y/4)
	add_child(t)
