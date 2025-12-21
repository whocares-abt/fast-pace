class_name WeaponStats
extends Resource

@export var ranged : bool
@export var projectile : ProjectileStats
@export var texture : Texture2D

# Stats for both ranged and melee weapons
@export var firing_rate : float
@export var damage : float

# Stats for melee weapons
# var attack_hitbox : Area2D

# Stats for ranged weapons
@export var spread : float

# Number of bullets shot in one shot and the interval range
@export var pellet_count : int
@export var pellet_rate : float # Time between each pellet
