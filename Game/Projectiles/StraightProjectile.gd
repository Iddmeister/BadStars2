extends Projectile

class_name StraightProjectile

export var speed:float = 300


func fastForward(start:Vector2, dir:float, time:float):
	startPos = start
	var pos = start+Vector2(speed*time, 0).rotated(dir)
	global_position = pos
	global_rotation = dir
	
func move(delta:float):
	
	global_position += Vector2(speed*delta, 0).rotated(global_rotation)
	
	.move(delta)
