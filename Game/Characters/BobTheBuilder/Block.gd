extends StaticBody2D

export var maxHealth:int = 50
onready var health:int = maxHealth

signal destroyed(pos)

master func hit(damage:int, id:int):
	
	health = int(max(0, health-damage))
	
	$Sprite.modulate = Color(1, float(health)/maxHealth,float(health)/maxHealth, 1) 
	
	if health <= 0:
		rpc("destroy")
	
	pass
	
remotesync func remove():
	destroy()
	pass
	
remotesync func destroy():
	
	emit_signal("destroyed", global_position)
	queue_free()
	
	pass
