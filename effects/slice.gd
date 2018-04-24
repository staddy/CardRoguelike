extends Sprite

var slide_x = Vector2(10, -2)

func _ready():
	$Animation.play("attack")
	$sound.set_volume_db(-10) 

func _process(delta):
	if visible == false and $Animation.stop():
		queue_free()

func _on_Timer_timeout():
	position += slide_x
	slide_x -= Vector2(10, -2)*2
	$Timer.start()