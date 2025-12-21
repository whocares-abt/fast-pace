extends CharacterBody2D

const SPEED = 300.0

func _physics_process(_delta: float) -> void:

	var direction_x = Input.get_axis("move_left", "move_right")
	var direction_y = Input.get_axis("move_up", "move_down")

	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if direction_y:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

func _on_hitbox_hurtbox_entered(area: Variant) -> void:
	if (area.hurtbox_owner == "Enemy"):
		self.queue_free()
