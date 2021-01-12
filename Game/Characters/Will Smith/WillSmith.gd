extends Character

export var Ball:PackedScene
export var numOfBalls:int = 3
export var angle:float = 30

func attack1():
	rpc("shoot", get_network_master(), global_position, getAimDirection(), Network.clock)
	pass
	
remotesync func shoot(id:int, startPos:Vector2, dir:float, time:float):
	
	for b in range(numOfBalls):
		
		var newAngle:float = dir+((((float(b)/numOfBalls)-0.5)*2)*(deg2rad(angle)/2))
		var ball:Projectile = Ball.instance()
		Manager.loose.add_child(ball)
		ball.initialize(id, startPos, newAngle, time)
	
	pass
	
remotesync func teleport(pos:Vector2):
	setPos(pos)
	pass
	
func attack2():
	rpc("teleport", get_global_mouse_position())
	pass
	camera.followType = camera.SMOOTH
	yield(camera, "caughtUp")
	camera.followType = camera.STATIC
	
func ability1():
	pass
	
func ability2():
	pass
