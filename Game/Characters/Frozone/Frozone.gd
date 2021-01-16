extends Character

export var Icicle:PackedScene
export var SlipperyIcicle:PackedScene

func attack1():
	rpc("shoot", get_network_master(), global_position, getAimDirection(), Network.clock, 0)
	pass
	
func attack2():
	rpc("shoot", get_network_master(), global_position, getAimDirection(), Network.clock, 1)
	pass
	
	
remotesync func shoot(id:int, pos:Vector2, dir:float, time:float, bulletType):
	
	var bullet:PackedScene
	
	match bulletType:
		
		0:
			bullet = Icicle
		1:
			bullet = SlipperyIcicle
	
	var b:Projectile = bullet.instance()
	Manager.loose.add_child(b)
	b.initialize(id, pos, dir, time)
		
	#$Shoot.play()
	
	pass
