extends CharacterBody2D

@export var SPEED = 300

@onready var particle = $GPUParticles2D
@onready var animation_sprite = $AnimatedSprite2D

@onready var collision_body = $CollisionShape2D
@onready var hitbox = $Hitbox

@onready var nav_comp = $NavComp

@export var player : Node2D
@export var patrol_path : Path2D
var patrol_start_point

# Defining state

enum EnemyState {
	PATROL, # Enemy patrols particular path
	AGGRO, # Enemy chases player
	RETURN_TO_PATROL # Enemy returns to patrol after deaggro
}

var current_state : EnemyState

func get_current_state():
	return current_state

func set_current_state(new_state):
	current_state = new_state

func _ready() -> void:
	if (patrol_path == null):
		printerr("No patrol path")
	else:
		patrol_start_point = patrol_path.get_start_node()
	
	switch_state(EnemyState.RETURN_TO_PATROL)

func _physics_process(_delta: float) -> void:	
	match current_state:
		EnemyState.AGGRO:
			aggro_behaviour()

		EnemyState.PATROL:
			patrol_behaviour()

		EnemyState.RETURN_TO_PATROL:
			return_patrol_behaviour()

	move_and_slide()

# Simulating state behaviour

func aggro_behaviour():
	if (not nav_comp.is_target_reachable()):
		switch_state(EnemyState.RETURN_TO_PATROL)
		
	if (not nav_comp.is_target_reached()):
		nav_to_goal() # Goal is player

func patrol_behaviour():
	pass

func return_patrol_behaviour():	
	if (not nav_comp.is_target_reachable()):
		printerr("Can't reach patrol point")
		
	if (not nav_comp.is_target_reached()):
		nav_to_goal() # Goal is patrol start point
	else:
		switch_state(EnemyState.PATROL)

# Switching states

func switch_state(new_state : EnemyState):
	match new_state:
		EnemyState.PATROL:
			switch_to_patrol()
			
		EnemyState.AGGRO:
			switch_to_aggro()
		
		EnemyState.RETURN_TO_PATROL:
			switch_to_return_patrol()

func switch_to_patrol():
	current_state = EnemyState.PATROL
	if (patrol_path == null):
		printerr("No patrol path for enemy ")
		return
	patrol_path.add_new_patroller(self, SPEED)

func switch_to_aggro():
	current_state = EnemyState.AGGRO
	update_nav_goal(player)
	
func switch_to_return_patrol():
	current_state = EnemyState.RETURN_TO_PATROL
	if (patrol_start_point == null):
		printerr("No patrol start point")
		return
	update_nav_goal(patrol_start_point)


# Navigation functions
func update_nav_goal(new_goal):
	nav_comp.set_goal(new_goal)

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
