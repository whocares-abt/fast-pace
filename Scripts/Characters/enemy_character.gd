extends CharacterBody2D

@export var SPEED = 300

@onready var particle = $GPUParticles2D
@onready var animation_sprite = $AnimatedSprite2D

@onready var collision_body = $CollisionShape2D
@onready var hitbox = $Hitbox

@onready var nav_comp = $NavComp

@export var goal : Node2D

func _ready() -> void:
	update_goal(goal)

func update_goal(new_goal):
	nav_comp.set_goal(new_goal)

func _physics_process(_delta: float) -> void:	
	if (not nav_comp.is_target_reached()):
		var nav_point_direction = to_local(nav_comp.get_next_path_position()).normalized()
		velocity = nav_point_direction*SPEED
		move_and_slide()

# Func for enemy death

func _on_hitbox_hurtbox_entered(area: Variant) -> void:
	if ("Player" in area.hurtbox_owners):
		animation_sprite.play("dead")
		particle.emitting = true
		disable_enemy.call_deferred()

func disable_enemy():
	collision_body.disabled = true
	hitbox.monitorable = false
	hitbox.monitoring = false
	nav_comp.set_goal(null)
	CombatSignalBus.emit_signal("enemy_died")
	
	# To prevent blood splashes from disappearing
	await get_tree().create_timer(particle.lifetime).timeout
	pause_particle_process()

func pause_particle_process():
	# To prevent particles from despawning - blood splatters stay
	particle.process_mode = Node.PROCESS_MODE_DISABLED
