extends Character

export var Bullet:PackedScene

func attack1():
	
	rpc("shoot", global_position, (get_global_mouse_position()-global_position).angle(), OS.get_system_time_msecs())
	
	pass
	
func ability1():
	
	print("bruh")
	
remotesync func shoot(pos:Vector2, dir:float, time:int):
	
	var timePassed = float(OS.get_system_time_msecs()-time)
	
	var b:Projectile = Bullet.instance()
	b.set_network_master(get_network_master())
	Manager.loose.add_child(b)
	b.fastForward(pos, dir, timePassed/1000)
	
	pass
	
var flipped:bool = false
	
func masterAnimations(delta:float):
	if moveVelocity.x < 0:
		if not flipped:
			$Graphics.scale.x *= -1
			flipped = true
	else:
		if flipped:
			$Graphics.scale.x *= -1
			flipped = false
	pass
	
func puppetAnimations(delta:float):
	
	if (masterPos.x-global_position.x) < 0:
		if not flipped:
			$Graphics.scale.x *= -1
			flipped = true
	else:
		if flipped:
			$Graphics.scale.x *= -1
			flipped = false
	
	pass
