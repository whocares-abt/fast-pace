extends Ability

var projectile = preload("uid://bfqk0r7mpuyuo")
@export var projectile_speed = 2000

func _ready() -> void:
	load_stats("res://Resources/Combat/knife_throw.tres")
	activate = activate_knife_throw
	can_activate = true

func get_mana_cost():
	return mana_cost

func activate_knife_throw(direction, start_position):
	if (not can_activate):
		return
	
	can_activate = false
	var knife = projectile.instantiate()

	add_child(knife)
	remove_child(knife)

	knife.set_speed(projectile_speed)
	knife.set_direction(direction)
	knife.add_hurtbox_owners(["Player"])
	knife.change_bullet_type("knife")
	
	CombatSignalBus.emit_signal("bullet_shot", knife, start_position)
	
	await get_tree().create_timer(cooldown).timeout
	can_activate = true
