extends Character

export var BasicAttack:PackedScene
export var Silence:PackedScene
export var KnockUp:PackedScene
export var numOfBullets:int = 4
export var bulletSpacing:float = 100
export var knockUpTime:float = 2
export var eatHealth:int = 25

remotesync func shoot(id:int, pos:Vector2, dir:float, time:float, bulletType:int=0):
	
	var bullet:PackedScene
	var multiple:bool = true
	
	match bulletType:
		
		0:
			bullet = BasicAttack
		1:
			bullet = Silence
			multiple = false
			
	if multiple:
	
		for num in range(numOfBullets):

			var offset = float(num)/float(numOfBullets)

			offset = (offset-0.5)*2
			offset *= bulletSpacing

			var spawnPos = pos+Vector2(0, offset).rotated(getAimDirection())

			var b:Projectile = bullet.instance()
			Manager.loose.add_child(b)
			b.initialize(id, spawnPos, dir, time)
			
	else:
			var b:Projectile = bullet.instance()
			Manager.loose.add_child(b)
			b.initialize(id, pos, dir, time)

	pass
	
func attack1():
	
	rpc("shoot", get_network_master(), global_position, getAimDirection(), Network.clock, 0)
	
func attack2():
	
	rpc("eat")
	
	
func ability1():
	
	rpc("shoot", get_network_master(), global_position, getAimDirection(), Network.clock, 1)
	
	
func ability2():
	rpc("knockUpArea", getAimDirection())
	pass
	
remotesync func knockUpArea(dir:float):

	$KnockUpArea.global_rotation = dir
	if is_network_master():
		yield(get_tree(), "physics_frame")
		for body in $KnockUpArea.get_overlapping_bodies():
			if not body.is_in_group("Ally"+String(get_network_master())):
				body.rpc("knockUp", knockUpTime)
	pass
	
remotesync func eat():
	
	if is_network_master():
		for body in $EatArea.get_overlapping_bodies():
			if not body.is_in_group("Ally"+String(get_network_master())):
				if body.health <= eatHealth:
					body.rpc("hit", 100000, get_network_master())
	
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
