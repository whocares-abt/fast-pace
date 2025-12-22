extends Node2D

var ranged : bool
var weapon_name : String
var projectile = preload("res://Scenes/Combat/bullet.tscn")

# Both ranged and melee weapons
var firing_rate : float
var can_attack : bool = true
var hurtbox_owners = []

# Ranged weapons
var projectile_speed : float

# Melee weapons
var attack_hold  : float

var stats : WeaponStats = load("res://Resources/Combat/katana.tres")

@onready var pivot = $WeaponPivot # For rotating hitboxes and sprites
@onready var melee_hurtbox = $WeaponPivot/AttackHurtbox
@onready var sprite = $WeaponPivot/AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ranged = stats.ranged
	weapon_name = stats.weapon_name
	firing_rate = stats.firing_rate
	projectile_speed = stats.projectile_speed
	attack_hold = stats.attack_hold
	
	melee_hurtbox.disable_hurtbox()

func attack(attack_direction : Vector2):
	if (not can_attack):
		return
	can_attack = false
	sprite.play("attack")
	rotate_pivot(attack_direction)

	if (ranged):
		ranged_attack(attack_direction)
	else:
		await melee_attack()

	sprite.play("idle")

	await get_tree().create_timer(1/firing_rate).timeout
	can_attack = true

func rotate_pivot(direction):
	pivot.rotation = direction.angle()

func ranged_attack(direction):
	var bullet = projectile.instantiate()
	add_child(bullet)
	bullet.set_speed(projectile_speed)
	bullet.set_direction(direction)
	bullet.add_hurtbox_owners(hurtbox_owners)

func melee_attack():
	melee_hurtbox.enable_hurtbox()
	await get_tree().create_timer(attack_hold).timeout
	melee_hurtbox.disable_hurtbox()

func add_hurtbox_owners(new_owners):
	for owner in new_owners:
		hurtbox_owners.append(owner)
	melee_hurtbox.add_hurtbox_owners(new_owners)
