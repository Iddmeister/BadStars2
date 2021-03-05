extends KinematicBody2D

class_name Drake

export var maxHealth:int = 100
onready var health = maxHealth

var dead:bool = false

remotesync func hit(damage:int, id:int):
	
	if dead:
		return
	
	health = max(health-damage, 0)
	
	if health <= 0 and not dead:
		die(id)
		
	updateHealth()
	
	pass
	
func updateHealth():
	pass
	
func die(killer:int):
	pass
