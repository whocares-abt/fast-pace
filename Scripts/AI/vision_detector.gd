extends Area2D

signal player_detected(player : Node2D)

# Detects if there are any walls to detect
@onready var vision_raycast = $RayCast2D

func _on_area_entered(area: Area2D) -> void:
	var vector_to_player = (area.global_position - global_position)
	vision_raycast.set_target_position(2*vector_to_player)
	vision_raycast.global_rotation = 0

	await get_tree().create_timer(0.01).timeout

	if (vision_raycast.get_collider()):
		var colliding_obj = vision_raycast.get_collider()
		if (colliding_obj.get_collision_layer_value(5)):
			player_detected.emit(colliding_obj)
	pass

func disable_vision():
	monitorable = false
	monitoring = false
