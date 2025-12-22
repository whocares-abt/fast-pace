extends Node2D

var ranged : bool
var weapon_name : String
var projectile = preload("res://Scenes/Combat/bullet.tscn")

# Both ranged and melee weapons
var firing_rate : float

# Ranged weapons
var projectile_speed : float

# Melee weapons
var attack_hold  : float

var stats : WeaponStats = load("res://Resources/Combat/pistol.tres")

@onready var melee_hurtbox = $AttackHurtbox
@onready var sprite = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ranged = stats.ranged
	weapon_name = stats.weapon_name
	firing_rate = stats.firing_rate
	projectile_speed = stats.projectile_speed
	attack_hold = stats.attack_hold
	
	melee_hurtbox.add_hurtbox_owner("Player")
	melee_hurtbox.disable_hurtbox()

func attack(attack_direction : Vector2):
	sprite.play("attack")

	# Rotate node to rotate sprite and hurtbox
	rotation = attack_direction.angle()

	if (ranged):
		var bullet = projectile.instantiate()
		add_child(bullet)
		bullet.set_speed(projectile_speed)
		bullet.set_direction(attack_direction)
		bullet.add_hurtbox_owner("Player")
		await get_tree().create_timer(attack_hold).timeout

	else:
		melee_hurtbox.enable_hurtbox()
		await get_tree().create_timer(attack_hold).timeout
		melee_hurtbox.disable_hurtbox()

	sprite.play("idle")

	await get_tree().create_timer(1/firing_rate).timeout

func add_hurtbox_owner():
	pass
