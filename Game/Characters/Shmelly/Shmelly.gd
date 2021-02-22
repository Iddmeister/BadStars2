extends Character

export var NormBullet:PackedScene
export var PoisonBullet:PackedScene
export var ShitZone:PackedScene
export var numOfBullets:int = 5
export var angle:float = 30
export var maxShitZoneRange:float = 400
export var reloadDamage:int = 30

func attack1():
	$Graphics/Pivot.global_rotation = getAimDirection()
	rpc("shoot", get_network_master(), $Graphics/Pivot.global_position, getAimDirection(), Network.clock, 0)
	
func attack2():
	$Graphics/Pivot.global_rotation = getAimDirection()
	rpc("shoot", get_network_master(), $Graphics/Pivot.global_position, getAimDirection(), Network.clock, 1)

func ability1():
	
	reloadAmmo(maxAmmo-ammo)
	rpc("hit", reloadDamage, get_network_master())

func ability2():
	
	rpc("placeShitZone", global_position+(get_global_mouse_position()-global_position).clamped(maxShitZoneRange))
	
	pass
	
remotesync func placeShitZone(pos:Vector2):
	
	var s = ShitZone.instance()
	s.masterID = get_network_master()
	s.global_position = pos
	Manager.loose.add_child(s)

remotesync func shoot(id:int, pos:Vector2, dir:float, time:float, bulletType):
	
	$Graphics/Pivot.global_rotation = dir
	
	var bullet:PackedScene
	
	
	match bulletType:
		
		0:
			bullet = NormBullet
			for i in range(numOfBullets):
				
				var newAngle:float = dir+((((float(i)/numOfBullets)-0.5)*2)*(deg2rad(angle)/2))
				
				var b:Projectile = bullet.instance()
				Manager.loose.add_child(b)
				b.global_position = $Graphics/Pivot/Gun/Muzzle.global_position
				b.initialize(id, pos, newAngle, time)
		1:
			bullet = PoisonBullet
			var b:Projectile = bullet.instance()
			Manager.loose.add_child(b)
			b.global_position = $Graphics/Pivot/Gun/Muzzle.global_position
			b.initialize(id, pos, dir, time)
			

		
	#$Shoot.play()
	
	pass
