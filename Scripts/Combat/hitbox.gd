extends Area2D

signal hurtbox_entered(area)

func _on_area_entered(area: Area2D) -> void:
	# When a hurtbox enters this area
	hurtbox_entered.emit(area)

func disable_hitbox():
	monitorable = false
	monitoring = false

func enable_hitbox():
	monitorable = true
	monitoring = true
