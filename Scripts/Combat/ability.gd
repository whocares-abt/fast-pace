class_name Ability
extends Node2D

var ability_stats : AbilityStats

var ability_name
var mana_cost
var cooldown
var can_activate : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func update_stats(stats : AbilityStats):
	ability_name = ability_stats.ability_name
	mana_cost = ability_stats.mana_cost
	cooldown = ability_stats.cooldown

func load_stats(file_name):
	ability_stats = load(file_name)
	update_stats(ability_stats)

var activate : Callable = func():
	pass
