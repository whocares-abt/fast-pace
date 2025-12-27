extends Area2D

@export var hurtbox_owners : Array[String]

signal deflect

func add_hurtbox_owners(new_owners):
	for new_owner in new_owners:
		hurtbox_owners.append(new_owner)

func enable_hurtbox():
	monitorable = true
	monitoring = true

func disable_hurtbox():
	monitorable = false
	monitoring = false

func deflection(deflection_hitbox_owners):
	add_hurtbox_owners(deflection_hitbox_owners)
	deflect.emit()
