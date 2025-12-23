extends Ability

var projectile = preload("res://Scenes/Combat/bullet.tscn")
@export var projectile_speed = 2000

func _ready() -> void:
	load_stats("res://Resources/Combat/knife_throw.tres")
	activate = activate_knife_throw

func get_mana_cost():
	return mana_cost

func activate_knife_throw(direction, start_position):
	var knife = projectile.instantiate()

	add_child(knife)
	remove_child(knife)

	knife.set_speed(projectile_speed)
	knife.set_direction(direction)
	knife.add_hurtbox_owners(["Player"])
	knife.change_sprite("knife")
	
	CombatSignalBus.emit_signal("bullet_shot", knife, start_position)
