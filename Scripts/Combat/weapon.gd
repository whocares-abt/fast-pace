extends Node2D

var ranged : bool
var weapon_name : String
var projectile = preload("res://Scenes/Combat/bullet.tscn")

# Both ranged and melee weapons
var firing_rate : float

# Ranged weapons
var projectile_speed : float

# Melee weapons
var melee_attack_hold  : float

var stats : WeaponStats = load("res://Resources/Combat/katana.tres")

@onready var melee_hurtbox = $AttackHurtbox
@onready var sprite = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ranged = stats.ranged
	weapon_name = stats.weapon_name
	firing_rate = stats.firing_rate
	projectile_speed = stats.projectile_speed
	melee_attack_hold = stats.melee_attack_hold
	
	melee_hurtbox.add_hurtbox_owner("Player")
	melee_hurtbox.disable_hurtbox()
	sprite.visible = false

func attack(attack_direction : Vector2):
	if (ranged):
		projectile.instantiate()
		projectile.set_speed(projectile_speed)
		projectile.set_direction(attack_direction)
	else:
		sprite.visible = true
		melee_hurtbox.enable_hurtbox()
		await get_tree().create_timer(melee_attack_hold).timeout
		melee_hurtbox.disable_hurtbox()
		sprite.visible = false

	await  get_tree().create_timer(1/firing_rate).timeout
