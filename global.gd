extends Node

var current_scene = null
var Battle = preload("res://Battle.tscn")
var mutex = Mutex.new()
var mutex_selection = Mutex.new()
var locked = false

var cards = { 0 : {
				   "name" : "Attack",
				   "cost" : 1,
				   "description" : "Deals 10 damage",
				   "type" : "attack"
				  },
			  1 : {
				   "name" : "Defence",
				   "cost" : 1,
				   "description" : "Increases block by 10",
				   "type" : "skill"
				  }
			}

var default_hand_size = 5
var deck = []

func init_card(card, id):
	card.card_name = cards[id].name
	card.cost = cards[id].cost
	card.description = cards[id].description
	card.type = cards[id].type

func shuffle_list(list):
    var shuffledList = [] 
    var indexList = range(list.size())
    for i in range(list.size()):
        var x = randi()%indexList.size()
        shuffledList.append(list[indexList[x]])
        indexList.remove(x)
    return shuffledList

func init_deck():
	deck.clear()
	for i in range(5):
		deck.append(0)
	for i in range(5):
		deck.append(1)

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
