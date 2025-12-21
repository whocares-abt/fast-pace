extends Area2D

@export var hurtbox_owners : Array[String]

func add_hurtbox_owner(new_owner):
	hurtbox_owners.append(new_owner)

func enable_hurtbox():
	monitorable = true
	monitoring = true

func disable_hurtbox():
	monitorable = false
	monitoring = false
