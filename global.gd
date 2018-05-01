extends Node

var current_scene = null
var Battle = preload("res://Battle.tscn")
var Map = preload("res://map/Map.tscn")
var mutex = Mutex.new()
var mutex_selection = Mutex.new()
var locked = false

var material_ = preload("res://material.tres")
var outlined_material = preload("res://outlined_material.tres")

enum Modifiers {DEXTERITY, STRENGTH, WEAKNESS, VULNERABILITY}
var decrease_every_turn = [WEAKNESS, VULNERABILITY]

func does_decrease(modifier):
	if modifier in decrease_every_turn:
		return true
	else:
		return false

func vulnerability_damage_to_enemies():
	return 1.5

func vulnerability_damage_to_player():
	return 1.5

func weakness_damage_to_enemies():
	return 0.75

func weakness_damage_to_player():
	return 0.75

func get_damage_to_enemy(base, modifiers, enemy_modifiers):
	var value = (base + modifiers.get(STRENGTH))
	if value <= 0:
		return 0
	if modifiers.has(WEAKNESS):
		value *= weakness_damage_to_enemies()
	if enemy_modifiers != null and enemy_modifiers.has(VULNERABILITY):
		value *= vulnerability_damage_to_enemies()
	return int(value)

func get_damage_to_player(base, modifiers, player_modifiers):
	var value = (base + modifiers.get(STRENGTH))
	if value <= 0:
		return 0
	if modifiers.has(WEAKNESS):
		value *= weakness_damage_to_player()
	if player_modifiers.has(VULNERABILITY):
		value *= vulnerability_damage_to_player()
	return int(value)

func get_block_player(base, modifiers):
	var value = (base + modifiers.get(DEXTERITY))
	if value <= 0:
		return 0
	return value

func get_block_enemy(base, modifiers):
	var value = (base + modifiers.get(DEXTERITY))
	if value <= 0:
		return 0
	return value

onready var modifier_textures = {
								 DEXTERITY: "res://modifiers/images/dexterity.png",
								 STRENGTH: "res://modifiers/images/strength.png",
								 WEAKNESS: "res://modifiers/images/weakness.png",
								 VULNERABILITY: "res://modifiers/images/vulnerability.png"
								}

var cards = {
			  0 : {
				   "name" : "Attack",
				   "cost" : 1,
				   "description" : "Deals #dmg damage",
				   "type" : "attack",
				   "image" : "res://card_placeholder.png",
				   "value" : 7,
				   "value2" : 0,
				   "effect" : "",
				   "modifiers": []
				  },
			  1 : {
				   "name" : "Defence",
				   "cost" : 1,
				   "description" : "Increases block by #block",
				   "type" : "skill",
				   "image" : "res://card_placeholder2.png",
				   "value" : 0,
				   "value2" : 7,
				   "effect" : "block",
				   "modifiers": []
				  },
			  2 : {
				   "name" : "Burst",
				   "cost" : 3,
				   "description" : "Deals #dmg damage",
				   "type" : "attack",
				   "image" : "res://card_placeholder2.png",
				   "value" : 25,
				   "value2" : 0,
				   "effect" : "",
				   "modifiers": []
				  },
			  3 : {
				   "name" : "Strength",
				   "cost" : 1,
				   "description" : "Gain 2 strength",
				   "type" : "skill",
				   "image" : "res://card_placeholder2.png",
				   "value" : 0,
				   "value2" : 0,
				   "effect" : "",
				   "modifiers": [STRENGTH, "self", -2]
				  },
			  4 : {
				   "name" : "Disabling attack",
				   "cost" : 2,
				   "description" : "Deals #dmg damage and applies 2 weakness",
				   "type" : "attack",
				   "image" : "res://card_placeholder2.png",
				   "value" : 10,
				   "value2" : 0,
				   "effect" : "",
				   "modifiers": [WEAKNESS, "target", 2]
				  },
			  5 : {
				   "name" : "Vulnerability",
				   "cost" : 2,
				   "description" : "Applies 1 vulnerability to all enemies",
				   "type" : "skill",
				   "image" : "res://card_placeholder2.png",
				   "value" : 0,
				   "value2" : 0,
				   "effect" : "",
				   "modifiers": [VULNERABILITY, "all", 1]
				  },
			  6 : {
				   "name" : "Break",
				   "cost" : 3,
				   "description" : "Enemy looses 5 strength",
				   "type" : "skill",
				   "image" : "res://card_placeholder2.png",
				   "value" : 0,
				   "value2" : 0,
				   "effect" : "target",
				   "modifiers": [STRENGTH, "target", -5]
				  },
			  7 : {
				   "name" : "Dexter",
				   "cost" : 0,
				   "description" : "Gain 3 dexterity",
				   "type" : "skill",
				   "image" : "res://card_placeholder2.png",
				   "value" : 0,
				   "value2" : 0,
				   "effect" : "",
				   "modifiers": [DEXTERITY, "self", 3]
				  }
			}

var default_draw_size = 5
var max_hand_size = 10
var max_mana = 9

var current_max_mana = 3

var deck = []

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
	deck.append(3)
	deck.append(4)
	deck.append(5)
	deck.append(6)
	deck.append(7)

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
