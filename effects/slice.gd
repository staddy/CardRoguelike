extends Node2D

func _ready():
	$sound.set_volume_db(-20) 
	$Animation.play("attack")

func _process(delta):
	if !$Animation.is_playing():
		queue_free()
		#self.get_parent().remove_child(self)
