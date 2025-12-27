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

var stats : WeaponStats

var weapon_stat_map = {
	"pistol" : "res://Resources/Combat/pistol.tres",
	"katana" : "res://Resources/Combat/katana.tres",
}

var sprite_frame_map = {
	"pistol" : "res://Resources/Spriteframes/pistol.tres",
	"katana" : "res://Resources/Spriteframes/katana.tres",
}

@onready var pivot = $WeaponPivot # For rotating hitboxes and sprites
@onready var melee_hurtbox = $WeaponPivot/AttackHurtbox
@onready var sprite = $WeaponPivot/AnimatedSprite2D
@onready var deflection_hitbox = $WeaponPivot/DeflectionHitbox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	equip_weapon("katana")
	melee_hurtbox.disable_hurtbox()
	deflection_hitbox.disable_hitbox()

func update_stats():
	ranged = stats.ranged
	weapon_name = stats.weapon_name
	firing_rate = stats.firing_rate
	projectile_speed = stats.projectile_speed
	attack_hold = stats.attack_hold

func equip_weapon(new_weapon_name):
	# Loads weapon stats from filename
	
	var stat_file_name = weapon_stat_map[new_weapon_name]
	stats = load(stat_file_name)
	
	var sprite_file_name = sprite_frame_map[new_weapon_name]
	sprite.sprite_frames = load(sprite_file_name)
	
	update_stats()

func attack(attack_direction : Vector2):
	if (not can_attack):
		return
	can_attack = false
	sprite.play("attack")
	rotate_pivot(attack_direction)

	if (ranged):
		await ranged_attack(attack_direction)
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
	remove_child(bullet)

	bullet.set_speed(projectile_speed)
	bullet.set_direction(direction)
	bullet.add_hurtbox_owners(hurtbox_owners)
	
	CombatSignalBus.emit_signal("bullet_shot", bullet, melee_hurtbox.global_position)

	await get_tree().create_timer(attack_hold).timeout

func melee_attack():
	melee_hurtbox.enable_hurtbox()
	deflection_hitbox.enable_hitbox()
	await get_tree().create_timer(attack_hold).timeout
	melee_hurtbox.disable_hurtbox()
	deflection_hitbox.disable_hitbox()

func get_hurtbox_location():
	return melee_hurtbox.global_position

func add_hurtbox_owners(new_owners):
	for new_owner in new_owners:
		hurtbox_owners.append(new_owner)
	melee_hurtbox.add_hurtbox_owners(new_owners)

func reduce_melee_hurtbox():
	$WeaponPivot/AttackHurtbox/CollisionShape2D.scale = Vector2(0.7, 0.7)

func remove_deflection():
	deflection_hitbox.queue_free()

func _on_deflection_hitbox_hurtbox_entered(area: Variant) -> void:
	area.deflection(hurtbox_owners)
