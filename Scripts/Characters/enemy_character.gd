extends CharacterBody2D

# Child nodes
@onready var weapon = $Weapon
@onready var particle = $GPUParticles2D
@onready var sprite = $AnimatedSprite2D

@onready var collision_body = $CollisionShape2D
@onready var hitbox = $Hitbox

@onready var nav_comp = $NavComp
@onready var patrol_comp = $PatrolComponent
@onready var vision_cone = $VisionCone

# Interacting with map
@export var SPEED = 300
@export var player : Node2D
@export var weapon_name = "pistol"
var patrol_start_point

# Defining state

enum EnemyState {
	PATROL, # Enemy patrols particular path
	AGGRO, # Enemy chases player
	RETURN_PATROL, # Enemy returns to patrol after deaggro
	DEAD
}

var current_state : EnemyState

func get_current_state():
	return current_state

# Ready and update funcion

func _ready() -> void:
	weapon.equip_weapon(weapon_name)
	weapon.reduce_melee_hurtbox()
	weapon.remove_deflection()
	weapon.add_hurtbox_owners(["Enemy"])
	patrol_start_point = patrol_comp.get_patrol_start()

func _physics_process(_delta: float) -> void:	
	match current_state:
		EnemyState.AGGRO:
			aggro_behaviour()

		EnemyState.PATROL:
			patrol_behaviour()

		EnemyState.RETURN_PATROL:
			return_patrol_behaviour()

		EnemyState.DEAD:
			dead_behaviour()
	
	sprite.rotation = velocity.angle()
	move_and_slide()

# Simulating state behaviour

func aggro_behaviour():
	if (player == null):
		switch_state(EnemyState.RETURN_PATROL)
		return
	#
	if (not nav_comp.is_target_reachable()):
		switch_state(EnemyState.RETURN_PATROL)
		pass
		
	if (not nav_comp.is_target_reached()):
		nav_to_goal() # Goal is player
	
	weapon.attack(player.global_position - global_position)

func patrol_behaviour():
	velocity = Vector2.ZERO # Depend on patrol path for movement

func return_patrol_behaviour():	
	if (not nav_comp.is_target_reachable()):
		printerr("Can't reach patrol point")
		
	if (not nav_comp.is_target_reached()):
		nav_to_goal() # Goal is patrol start point
	else:
		switch_state(EnemyState.PATROL)

func dead_behaviour():
	velocity = Vector2.ZERO # Depend on patrol path for movement

# Switching states

func switch_state(new_state : EnemyState):
	match current_state:
		EnemyState.PATROL:
			switch_from_patrol()
		
		EnemyState.AGGRO:
			switch_from_aggro()
			
		EnemyState.RETURN_PATROL:
			switch_from_return_patrol()
			
		EnemyState.DEAD:
			pass
	
	match new_state:
		EnemyState.PATROL:
			switch_to_patrol()
			
		EnemyState.AGGRO:
			switch_to_aggro()
		
		EnemyState.RETURN_PATROL:
			switch_to_return_patrol()
			
		EnemyState.DEAD:
			current_state = EnemyState.DEAD

# Exiting current state

func switch_from_patrol():
	pass

func switch_from_aggro():
	update_nav_goal(null)

func switch_from_return_patrol():
	update_nav_goal(null)

# Entering new states

func switch_to_patrol():
	current_state = EnemyState.PATROL

func switch_to_aggro():
	current_state = EnemyState.AGGRO
	update_nav_goal(player)
	
func switch_to_return_patrol():
	current_state = EnemyState.RETURN_PATROL
	if (patrol_start_point == null):
		printerr("No patrol start point")
		return
	update_nav_goal(patrol_start_point)

# Navigation functions
func update_nav_goal(new_goal):
	nav_comp.set_goal(new_goal)

func nav_to_goal():
	var nav_point_direction = to_local(nav_comp.get_next_path_position()).normalized().rotated(rotation)
	velocity = nav_point_direction*SPEED

# Func for enemy death

func _on_hitbox_hurtbox_entered(area: Variant) -> void:
	if ("Player" in area.hurtbox_owners):
		disable_enemy.call_deferred()

func disable_enemy():
	sprite.play("dead")
	collision_body.disabled = true
	
	hitbox.disable_hitbox()
	
	for vision_comp in vision_cone.get_children():
		vision_comp.disable_vision()
	
	CombatSignalBus.emit_signal("enemy_died")
	
	# To prevent blood splashes from disappearing
	particle.emitting = true
	await get_tree().create_timer(particle.lifetime).timeout
	switch_state(EnemyState.DEAD)
	pause_particle_process()

func pause_particle_process():
	# To prevent particles from despawning - blood splatters stay
	particle.process_mode = Node.PROCESS_MODE_DISABLED

# On detecting player

func _on_vision_detector_player_detected(_player: Node2D) -> void:
	switch_state(EnemyState.AGGRO)
	pass
