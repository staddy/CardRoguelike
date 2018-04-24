extends 'town.gd'

var windows = {"a" : {}, "b" : {}, "c" : {}}

func _ready():
	_init()

func _init():
	var k = 0
	for i in get_children().size():
		if get_child(i).is_in_group("window"):
			if k == 0:
				windows.a["src"] = null
				windows.a["connect"] = false
			elif k == 1:
				windows.b["src"] = null
				windows.b["connect"] = false
			elif k == 2:
				windows.c["src"] = null
				windows.c["connect"] = false
			k += 1

func _on_window1_pressed():
	windows.a.src.action()

func _on_window2_pressed():
	windows.b.src.action()

func _on_window3_pressed():
	windows.c.src.action()
