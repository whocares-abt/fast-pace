extends Node2D

var ranged : bool
var weapon_name : String
var projectile = preload("res://Scenes/Combat/bullet.tscn")

# Stats for both ranged and melee weapons
var firing_rate : float

# Stats for ranged weapons
var projectile_speed : float

var stats : WeaponStats = load("res://Resources/Combat/pistol.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func attack():
	pass
