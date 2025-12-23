class_name Ability
extends Node2D

var stats : AbilityStats

var ability_name
var mana_cost
var cooldown

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func update_stats(stats : AbilityStats):
	ability_name = stats.ability_name
	mana_cost = stats.mana_cost
	cooldown = stats.cooldown

func load_stats(file_name):
	stats = load(file_name)
	update_stats(stats)

var activate : Callable = func():
	pass
