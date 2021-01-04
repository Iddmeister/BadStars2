extends Area2D

class_name Projectile

var startPos:Vector2
export var maxDistance:float = 500

func _physics_process(delta):
	move(delta)

func fastForward(start:Vector2, dir:float, time:float):
	pass
	
func move(delta:float):
	
	if (global_position-startPos).length() >= maxDistance:
		destroy()
	
	pass
	
func destroy():
	queue_free()

func collided(body):
	pass

func _on_Projectile_body_entered(body):
	if is_network_master():
		collided(body)
