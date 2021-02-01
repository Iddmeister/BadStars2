extends StaticBody2D

export var maxHealth:int = 100
onready var health:int = maxHealth

remotesync func hit(damage:int, id:int):
	
	health = int(max(0, health-damage))
	
	$Sprite.modulate = Color(1, float(health)/maxHealth,float(health)/maxHealth, 1) 
	
	if health <= 0:
		destroy()
	
	pass
	
remotesync func remove():
	destroy()
	pass
	
func destroy():
	
	queue_free()
	
	pass
