extends "res://enemies/Enemy.gd"

func set_intents():
	if current_turn % 2 == 0:
		self.intent = "cast"
		self.intent_value = 0
	else:
		self.intent = "attack"
		self.intent_value = 6

func init():
	set_intents()
	self.block = 0
	self.max_hp = 15 + randi()%2
	self.hp = self.max_hp

func cast(value):
	modifiers.add(global.STRENGTH, 3)