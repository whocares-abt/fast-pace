extends Node2D

const SPEED = 300

func _physics_process(delta: float) -> void:
	pass

func _on_hitbox_hurtbox_entered(area: Variant) -> void:
	if (area.hurtbox_owner == "Player"):
		self.queue_free()
