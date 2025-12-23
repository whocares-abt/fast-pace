extends Node2D

const SPEED = 300

@onready var particle = $GPUParticles2D

@onready var animation_sprite = $AnimatedSprite2D
@onready var collision_body = $CollisionShape2D
@onready var hitbox = $Hitbox

func _physics_process(delta: float) -> void:
	pass

func _on_hitbox_hurtbox_entered(area: Variant) -> void:
	if ("Player" in area.hurtbox_owners):
		animation_sprite.play("dead")
		particle.emitting = true
		disable_enemy.call_deferred()

func disable_enemy():
	collision_body.disabled = true
	hitbox.monitorable = false
	hitbox.monitoring = false
	
