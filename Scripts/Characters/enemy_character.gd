extends CharacterBody2D

@export var SPEED = 300

@onready var particle = $GPUParticles2D
@onready var animation_sprite = $AnimatedSprite2D

@onready var collision_body = $CollisionShape2D
@onready var hitbox = $Hitbox

@onready var nav_comp = $NavComp

@export var goal : Node2D

var current_state

enum EnemyState {
	PATROL, # Enemy patrols particular path
	AGGRO, # Enemy chases player
	RETURN_TO_PATROL
}


func _ready() -> void:
	current_state = EnemyState.PATROL
	update_nav_goal(goal)

func update_nav_goal(new_goal):
	nav_comp.set_goal(new_goal)

func _physics_process(_delta: float) -> void:	
	match current_state:
		EnemyState.AGGRO:
			if (not nav_comp.is_target_reachable()):
				current_state = EnemyState.PATROL
				
			if (not nav_comp.is_target_reached()):
				nav_to_goal()

		EnemyState.PATROL:
			pass

	move_and_slide()

func nav_to_goal():
	var nav_point_direction = to_local(nav_comp.get_next_path_position()).normalized()
	velocity = nav_point_direction*SPEED


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
