extends Ability

func _ready() -> void:
	load_stats("res://Resources/Combat/knife_throw.tres")
	activate = activate_knife_throw

func get_mana_cost():
	return mana_cost

func activate_knife_throw():
	pass
