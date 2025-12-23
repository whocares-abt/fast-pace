extends Ability

@export var slowdown = 0.3

func _ready() -> void:
	load_stats("res://Resources/Combat/bullet_time.tres")
	activate = activate_bullet_time

func get_mana_cost():
	return mana_cost

func activate_bullet_time():
	Engine.time_scale = slowdown
