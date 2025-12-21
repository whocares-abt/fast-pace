extends Area2D

@export var hurtbox_owners : Array[String]

func add_hurtbox_owner(new_owner):
	hurtbox_owners.append(new_owner)

func enable_hurtbox():
	pass

func disable_hurtbox():
	pass
