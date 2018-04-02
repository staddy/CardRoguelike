extends Node

var current_scene = null
var Battle = preload("res://Battle.tscn")
var mutex = Mutex.new()
var mutex_selection = Mutex.new()
var locked = false

var default_hand_size = 5
var deck = []

signal unselect_all()

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func goto_scene(scene):
    call_deferred("_deferred_goto_scene", scene)


func _deferred_goto_scene(scene):
    # Immediately free the current scene,
    # there is no risk here.
    current_scene.free()

    # Load new scene
    #var scene = ResourceLoader.load(path)

    # Instance the new scene
    current_scene = scene.instance()

    # Add it to the active scene, as child of root
    get_tree().get_root().add_child(current_scene)

    # optional, to make it compatible with the SceneTree.change_scene() API
    get_tree().set_current_scene(current_scene)

func lock():
	mutex.lock()
	if locked:
		mutex.unlock()
		return false
	else:
		locked = true
		mutex.unlock()
		return true

func unlock():
	mutex.lock()
	locked = false
	mutex.unlock()
