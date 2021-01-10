extends SimpleProjectile

class_name StraightProjectile

export var speed:float = 300
export var syncSpeed:float = 0.3


func calcMasterPos() -> Vector2:
	
	var dif = Network.clock-startTime
	var pos = startPos+Vector2(speed*dif, 0).rotated(global_rotation)
	
	return pos
	
	pass
	
func move(delta:float):
	
	global_position += Vector2(speed*delta, 0).rotated(global_rotation)
	
	.move(delta)
	
	pass
	
func puppetMove(delta:float):

	masterPos = calcMasterPos()
	
	Manager.draw.addDrawCall("draw_circle", [masterPos, 5, Color(1, 0, 0, 1)], 1000)
	
	global_position = global_position.linear_interpolate(masterPos, syncSpeed*delta*60)
	
	if (masterPos-global_position).length() <= 2:
		synced = true
		
	.puppetMove(delta)
	
	pass
