extends Sprite

var slide_x = Vector2(10, -2)

func _ready():
	$sound.set_volume_db(-20) 
	$Animation.play("attack")

func _process(delta):
	if visible == false and $Animation.stop():
		queue_free()
		#self.get_parent().remove_child(self)

func _on_Timer_timeout():
	position += slide_x
	slide_x -= Vector2(10, -2)*2
	$Timer.start()