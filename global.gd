extends Node

var current_scene = null
var Battle = preload("res://Battle.tscn")
var Map = preload("res://map/Map.tscn")
var mutex = Mutex.new()
var mutex_selection = Mutex.new()
var locked = false

var material_ = preload("res://material.tres")
var outlined_material = preload("res://outlined_material.tres")

var cards = { 0 : {
				   "name" : "Attack",
				   "cost" : 1,
				   "description" : "Deals 7 damage",
				   "type" : "attack",
				   "image" : "res://card_placeholder.png",
				   "value" : 7,
				   "effect" : ""
				  },
			  1 : {
				   "name" : "Defence",
				   "cost" : 1,
				   "description" : "Increases block by 7",
				   "type" : "skill",
				   "image" : "res://card_placeholder2.png",
				   "value" : 7,
				   "effect" : "block"
				  },
			  2 : {
				   "name" : "Burst",
				   "cost" : 3,
				   "description" : "Deals 25 damage",
				   "type" : "attack",
				   "image" : "res://card_placeholder2.png",
				   "value" : 25,
				   "effect" : ""
				  }
			}

var default_draw_size = 5
var max_hand_size = 10
var max_mana = 9

var current_max_mana = 3

var deck = []

func init_card(card, id):
	card.card_id = id
	card.card_name = cards[id].name
	card.cost = cards[id].cost
	card.description = cards[id].description
	card.type = cards[id].type
	card.image = cards[id].image
	card.value = cards[id].value
	card.effect = cards[id].effect

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
	deck.append(2)

signal unselect_all()

func _ready():
	randomize()
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
