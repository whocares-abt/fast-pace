extends Node2D

@onready var hurtbox = $Hurtbox

@export var velocity : Vector2 = Vector2(700, 0)

func set_hurtbox_owner(new_owner):
	hurtbox.set_hurtbox_owner(new_owner)

func _physics_process(delta: float) -> void:
	position += (velocity*delta)

func set_velocity(new_velocity):
	velocity = new_velocity

func set_direction(new_direction : Vector2):
	assert(new_direction.x != 0 or new_direction.y != 0)
	velocity = velocity.length() * (new_direction.normalized())

func set_speed(new_speed):
	velocity *= (new_speed)/velocity.length()
