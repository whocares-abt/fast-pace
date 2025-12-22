extends Node2D

@onready var hurtbox = $Hurtbox
@onready var environment_collider = $EnvironmentCollider

@export var velocity : Vector2 = Vector2(700, 0)

@export var map_edge = 1500

func add_hurtbox_owner(new_owner):
	hurtbox.add_hurtbox_owner(new_owner)

func _process(delta: float) -> void:
	position += (velocity*delta)
	if (abs(position.x) > map_edge || abs(position.y) > map_edge):
		queue_free()

func set_velocity(new_velocity):
	velocity = new_velocity

func set_direction(new_direction : Vector2):
	assert(new_direction.x != 0 or new_direction.y != 0)
	velocity = velocity.length() * (new_direction.normalized())

func set_speed(new_speed):
	velocity *= (new_speed)/velocity.length()

func _on_environment_collider_body_entered(body: Node2D) -> void:
	queue_free()
