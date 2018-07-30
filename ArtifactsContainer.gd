extends Node2D

var Artifact = preload("res://artifacts/Artifact.tscn")

func _ready():
	global.connect("artifacts_changed", self, "update_artifacts")
	update_artifacts()

func update_artifacts():
	var x = 0
	for artifact in global.inventory:
		var newArtifact = Artifact.instance()
		newArtifact.image = global.artifacts[artifact].image
		newArtifact.rect_position.x = x
		add_child(newArtifact)
		x += (newArtifact.rect_size.x * newArtifact.rect_scale.x + 10)