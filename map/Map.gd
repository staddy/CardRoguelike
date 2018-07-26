extends Node2D

func set_max_hp():
	$MaxHp.text = str(global.max_hp)

func set_current_hp():
	$CurrentHp.text = str(global.current_hp)

func set_max_energy():
	$MaxEnergy.text = str(global.max_energy)

func set_strength():
	$Strength.text = str(global.strength)

func set_dexterity():
	$Dexterity.text = str(global.dexterity)

func _ready():
	set_max_hp()
	set_current_hp()
	set_max_energy()
	set_strength()
	set_dexterity()
	global.connect("max_hp_changed", self, "set_max_hp")
	global.connect("current_hp_changed", self, "set_current_hp")
	global.connect("max_energy_changed", self, "set_max_energy")
	global.connect("strength_changed", self, "set_strength")
	global.connect("dexterity_changed", self, "set_dexterity")
	pass

func _on_Button_pressed():
	#global.init_deck()
	global.current_loc = global.set_location(0)
	global.goto_subscene(global.Battle)
