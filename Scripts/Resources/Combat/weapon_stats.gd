class_name WeaponStats
extends Resource

@export var ranged : bool
@export var weapon_name : String
var projectile : Node2D # Projectile being shot by gun

# Stats for both ranged and melee weapons
@export var firing_rate : float
#@export var damage : float

# Stats for melee weapons
# TO DO : Differentiate between attack hold and animation hold
# var attack_hitbox : Area2D
@export var attack_hold : float
# For range weapons attack hold is simply for animation
# For melee weapons attack hold shows length of time hitbox remains


# Stats for ranged weapons
#@export var spread : float
@export var projectile_speed : float

# Number of bullets shot in one shot and the interval range
#@export var pellet_count : int
#@export var pellet_rate : float # Time between each pellet
