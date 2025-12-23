extends CharacterBody2D

@export var SPEED = 300.0
@export var max_health = 12
var health = 1

@onready var weapon = $CombatAbilities/Weapon
@onready var knife_throw = $CombatAbilities/KnifeThrow
@onready var bullet_time = $CombatAbilities/BulletTime

@onready var sprite = $AnimatedSprite2D

@onready var collider = $CollisionShape2D
@onready var hitbox = $Hitbox

@onready var particle = $GPUParticles2D
@onready var health_timer = $HealthTimer

var input_disabled = false
var input_disabled_cause = ""

func _ready() -> void:
	weapon.add_hurtbox_owners(["Player"])
	weapon.equip_weapon("katana")
	
	health = max_health
	
	CombatSignalBus.connect("enemy_died", on_enemy_death)

func _input(event: InputEvent) -> void:
	if (input_disabled):
		return
	
	var mouse_pos = get_global_mouse_position()
	var attack_direction = mouse_pos - position

	if (event.is_action_pressed("attack")):
		weapon.attack(attack_direction.normalized())
		
	if (event.is_action_pressed("ability")):
		var mana_cost = knife_throw.get_mana_cost()
		knife_throw.activate.call(attack_direction, weapon.get_hurtbox_location())
		update_health(-mana_cost)
		
	if (event.is_action_pressed("bullet_time")):
		var mana_cost = bullet_time.get_mana_cost()
		bullet_time.activate.call()
		update_health(-mana_cost)

func _physics_process(_delta: float) -> void:
	if (input_disabled):
		return

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
	if ("Enemy" in area.hurtbox_owners):
		self.queue_free()

func _on_health_timer_timeout() -> void:
	update_health(-1)

func on_enemy_death():
	update_health(3)

func update_health(delta):
	health = min(health + delta, max_health)
	CombatSignalBus.emit_signal("player_health_updated", health, max_health)
	if (health <= 0):
		disable_player.call_deferred()
		
func disable_player():
	input_disabled = true
	input_disabled_cause = "death"
	
	sprite.play("death")
	collider.disabled = true
	hitbox.monitoring = false
	hitbox.monitorable = false
	
	particle.emitting = true
	
	CombatSignalBus.emit_signal("player_died")
	
	# To prevent blood splashes from disappearing
	await get_tree().create_timer(particle.lifetime).timeout
	pause_particle_process()

func pause_particle_process():
	# To prevent particles from despawning - blood splatters stay
	particle.process_mode = Node.PROCESS_MODE_DISABLED
