class_name WeaponStats
extends Resource

@export var ranged : bool
var projectile : Node2D # Projectile being shot by gun
@export var texture : Texture2D

# Stats for both ranged and melee weapons
@export var firing_rate : float
@export var damage : float

# Stats for melee weapons
# var attack_hitbox : Area2D

# Stats for ranged weapons
@export var spread : float
@export var projectile_speed : float

# Number of bullets shot in one shot and the interval range
@export var pellet_count : int
@export var pellet_rate : float # Time between each pellet
