extends Character

export var BasicAttack:PackedScene
export var Silence:PackedScene
export var KnockUp:PackedScene
export var Eat:PackedScene
export var numOfBullets:int = 4
export var Bullet:PackedScene
export var bulletSpacing:float = 5

remotesync func shootsilencebullet(id:int, pos:Vector2, dir:float, time:float):


	for num in range(numOfBullets):

		var offset = float(num)/float(numOfBullets)

		offset = (offset-0.5)*2
		offset *= bulletSpacing

		var spawnPos = pos+Vector2(0, offset).rotated(getAimDirection())

		var b:Projectile = Silence.instance()
		Manager.loose.add_child(b)
		b.initialize(id, spawnPos, dir, time)

	pass
	
	
func ability1():
	
	rpc("shoot", get_network_master(), global_position, getAimDirection(), Network.clock)
	
func ability2():
	rpc("shootLaser", getAimDirection())
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
