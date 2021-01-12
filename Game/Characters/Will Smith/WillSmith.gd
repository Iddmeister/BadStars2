extends Character

export var Ball:PackedScene
export var numOfBalls:int = 3
export var angle:float = 30
export var MagicCarpet:PackedScene
export var lampSpeed:float = 10000
export var lampDamage:int = 50
export var Dust:PackedScene

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
	
remotesync func teleport(pos:Vector2, lastPos:Vector2):
	
	var d = Dust.instance()
	Manager.loose.add_child(d)
	d.global_position = lastPos
	d.start()
	setPos(pos)
	$Teleport.play()

	var d2 = Dust.instance()
	Manager.loose.add_child(d2)
	d2.global_position = pos
	d2.start()
	pass
	
func attack2():
	rpc("teleport", get_global_mouse_position(), global_position)
	pass
	camera.followType = camera.SMOOTH
	yield(camera, "caughtUp")
	camera.followType = camera.STATIC
	
func ability1():
	rpc("throwCarpet", global_position+Vector2(200, 0).rotated(getAimDirection()), getAimDirection(), Network.clock)
	pass
	
remotesync func throwCarpet(startPos:Vector2, dir:float, time:float):
	
	$CarpetNoise.play()
	var m:Projectile = MagicCarpet.instance()
	Manager.loose.add_child(m)
	m.initialize(get_network_master(), startPos, dir, time)
	
	pass
	
func ability2():
	rpc("lampMode", true, getAimDirection())
	knock(Vector2(10000, 0).rotated(getAimDirection()))
	yield(get_tree().create_timer(1), "timeout")
	rpc("lampMode", false, 0)
	pass
	
remotesync func lampMode(d:bool, dir:float):
	
	enableAbilities(not d)
	enableAttacks(not d)
	
	if d:
		$LampNoise.play()
	
	if d:
		invincible += 1
	else:
		invincible -= 1
	global_rotation = dir
	$LampCollision.disabled = not d
	$Graphics/Lamp.visible = d
	$Graphics/Sprite.visible = not d
	$LampDamage/CollisionShape2D.disabled = not d
	


func _on_LampDamage_body_entered(body):
	if get_tree().is_network_server():
		body.rpc("hit", lampDamage, get_network_master())
	pass
