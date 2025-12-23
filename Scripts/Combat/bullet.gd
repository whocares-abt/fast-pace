extends Node2D

@onready var hurtbox = $Hurtbox
@onready var environment_collider = $EnvironmentCollider
@onready var sprite = $Sprite2D
@onready var particles = $GPUParticles2D

@export var velocity : Vector2 = Vector2(700, 0)

@export var map_edge = 1500

var sprite_map = {
	"bullet" : "res://Assets/Art/Textures/Combat/bullet.png",
	"knife" : "res://Assets/Art/Textures/Combat/knife.png",
}

func add_hurtbox_owners(new_owners):
	hurtbox.add_hurtbox_owners(new_owners)

func _ready() -> void:
	await get_tree().create_timer(0.05).timeout
	enable_particles()

func _process(delta: float) -> void:
	position += (velocity*delta)
	if (abs(position.x) > map_edge || abs(position.y) > map_edge):
		queue_free()

func change_sprite(new_sprite):
	var sprite_file = sprite_map[new_sprite]
	sprite.texture = load(sprite_file)
	
	# Remove trail for knife
	if (new_sprite == "knife"):
		particles.amount_ratio = 0

# Changing velocity

func set_velocity(new_velocity):
	velocity = new_velocity

func set_direction(new_direction : Vector2):
	assert(new_direction.x != 0 or new_direction.y != 0)
	velocity = velocity.length() * (new_direction.normalized())
	rotation = new_direction.angle()

func set_speed(new_speed):
	velocity *= (new_speed)/velocity.length()

func set_bullet_position(new_position):
	set_position(new_position)

func _on_environment_collider_body_entered(_body: Node2D) -> void:
	queue_free()

func enable_particles():
	particles.emitting = true
