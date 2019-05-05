
extends 'BaseType.gd'


func _init():
	_name = 'Float'
	_t = TYPE_REAL


func get(v):  # float
	if _rematch and _rematch is RegExMatch:
		return float(_rematch.get_string().replace(',', '.'))

	return 0.0
