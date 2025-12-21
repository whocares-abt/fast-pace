extends Node2D

var ranged : bool
var weapon_name : String
var projectile = preload("res://Scenes/Combat/bullet.tscn")

# Both ranged and melee weapons
var firing_rate : float

# Ranged weapons
var projectile_speed : float

# Melee weapons
@onready var meele_hurtbox = $AttackHurtbox
var melee_attack_hold  : float

var stats : WeaponStats = load("res://Resources/Combat/pistol.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ranged = stats.ranged
	weapon_name = stats.weapon_name
	firing_rate = stats.firing_rate
	projectile_speed = stats.projectile_speed
	melee_attack_hold = stats.melee_attack_hold

func attack(attack_direction : Vector2):
	if (ranged):
		projectile.instantiate()
		projectile.set_speed(projectile_speed)
		projectile.set_direction(attack_direction)
	else:
		meele_hurtbox.enable_hurtbox()
		await get_tree().create_timer(melee_attack_hold).timeout
		meele_hurtbox.disable_hurtbox()

	await  get_tree().create_timer(1/firing_rate).timeout
