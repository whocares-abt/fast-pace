extends Area2D

signal player_detected(player : Node2D)

# Detects if there are any walls to detect
@onready var vision_raycast = $RayCast2D

func _on_area_entered(area: Area2D) -> void:
	#vision_raycast.set_target_position(area.position)
	#print(vision_raycast.is_colliding())
	#if (vision_raycast.get_collider()):
		#var colliding_obj = vision_raycast.get_collider()
		#player_detected.emit()
	pass
