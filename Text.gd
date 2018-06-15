extends Node2D

var SCREEN_WIDTH = 960#ProjectSettings.get_setting("display/window/width")
var SCREEN_HEIGHT = 540#ProjectSettings.get_setting("display/window/height")

var letters = ["吧","爸","八","百","北","不","田","由","甲","申","甴","电","甶","男","甸","甹","町","画","甼","甽","甾","甿","畀","畁","畂","畃","畄","畅","畆","畇","畈","畉","畊","畋","界","畍","畎","畏","畐","畑"]
var font = DynamicFont.new()

var time = 0

func _ready():
	var data = DynamicFontData.new()
	data.font_path = "res://Zpix.ttf"
	font.font_data = data
	font.size = 11

func _draw():
	pass
	for i in range(SCREEN_WIDTH / 11):
		for j in range(SCREEN_HEIGHT / 11):
			if randf() > 0:#.999:
				draw_string(font, Vector2(i * 11, 11 + j * 11), letters[randi() % letters.size()], Color("FF00FFFF"))

func _process(delta):
	pass
	time += delta
	if time > 0.1:
		update()
		time = 0

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
