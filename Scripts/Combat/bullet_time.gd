extends Ability

@export var slowdown = 0.1
@export var bullet_time_duration = 3

func _ready() -> void:
	load_stats("res://Resources/Combat/bullet_time.tres")
	activate = activate_bullet_time
	can_activate = true

func get_mana_cost():
	return mana_cost

func activate_bullet_time():
	if (not can_activate):
		return
	
	can_activate = false
	Engine.time_scale = slowdown
	
	await get_tree().create_timer(bullet_time_duration).timeout
	Engine.time_scale = 1
	
	await  get_tree().create_timer(cooldown - bullet_time_duration).timeout
	
	can_activate = true
