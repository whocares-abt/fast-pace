extends Ability

func _ready() -> void:
	load_stats("res://Resources/Combat/sword_dash.tres")
	activate = activate_sword_dash
	can_activate = true

func get_mana_cost():
	return mana_cost

func activate_sword_dash(direction, start_position):
	can_activate = false

	await get_tree().create_timer(cooldown).timeout
	can_activate = true
