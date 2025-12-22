extends Node2D

func _ready() -> void:
	CombatSignalBus.connect("bullet_shot", add_bullet_as_child)


func add_bullet_as_child(bullet, bullet_spawn_pos):
	add_child(bullet)
	bullet.set_bullet_position(bullet_spawn_pos)
