extends Area2D

class_name Projectile

var startPos:Vector2
export var maxDistance:float = 500

signal collided(body)

func _physics_process(delta):
	move(delta)

func fastForward(start:Vector2, dir:float, time:float):
	pass
	
func move(delta:float):
	
	if (global_position-startPos).length() >= maxDistance:
		destroy()
	
	pass
	
remotesync func destroy():
	queue_free()

func collided(body):
	emit_signal("collided", body)
	pass

func _on_Projectile_body_entered(body):
	collided(body)
