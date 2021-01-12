extends Projectile

export var speed:float = 300
export var syncSpeed:float = 0.3


func collided(body):
	.collided(body)
	if is_network_master():
		body.rpc("setAddedVelocity", Vector2(speed, 0).rotated(global_rotation))
	if body.is_network_master():
		$Blowing.play()

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
	
	global_position = global_position.linear_interpolate(masterPos, syncSpeed*delta*60)
	
	if (masterPos-global_position).length() <= 2:
		synced = true
		
	.puppetMove(delta)
	
	pass



func _on_MagicCarpet_body_exited(body):
	if is_network_master():
		body.rpc("setAddedVelocity", Vector2(0, 0))
	if body.is_network_master():
		$Blowing.stop()
