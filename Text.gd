extends Node2D

var SCREEN_WIDTH = 960#ProjectSettings.get_setting("display/window/width")
var SCREEN_HEIGHT = 540#ProjectSettings.get_setting("display/window/height")

var letters = ["吧","爸","八","百","北","不","田","由","甲","申","甴","电","甶","男","甸","甹","町","画","甼","甽","甾","甿","畀","畁","畂","畃","畄","畅","畆","畇","畈","畉","畊","畋","界","畍","畎","畏","畐","畑", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "S", "U", "P", "R", "E", "M", "E", "S", "E", "N", "S", "E"]
var font = DynamicFont.new()

var time = 0

func _ready():
	var data = DynamicFontData.new()
	data.font_path = "res://Zpix.ttf"
	font.font_data = data
	font.size = 22

func _draw():
	for i in range(SCREEN_WIDTH / 22 + 1):
		for j in range(SCREEN_HEIGHT / 22 + 1):
			if randf() > 0:#.999:
				draw_string(font, Vector2(i * 22, 22 + j * 22), letters[randi() % letters.size()], Color("FFFFFFFF"))

func _process(delta):
	time += delta
	if time > 0.1:
		update()
		time = 0

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
