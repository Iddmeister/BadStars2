extends Character

export var Bullet:PackedScene
export var attack1NumBullets:int = 3
export var shootDelay:float = 0.12

func attack1():
	usingAttack1 = true
	var dir = getAimDirection()
	for b in range(attack1NumBullets):
		rpc("shoot", get_network_master(), global_position, dir, Network.clock)
		yield(get_tree().create_timer(shootDelay), "timeout")
	usingAttack1 = false
	pass
	
func attack2():
	rpc("boom")
	pass
	
remotesync func boom():
	
	$Explosion/Animation.play("Boom")
	$ExplosionSound.play()
	
	canMove += 1
	
	if is_network_master():
		for body in $Explosion.get_overlapping_bodies():
			if not body.is_in_group("Ally"+String(get_network_master())):
				body.rpc("hit", 100000, get_network_master())
		yield(get_tree().create_timer(0.5), "timeout")
		rpc("hit", 100000, get_network_master())
				
	
	pass
	
	
remotesync func shoot(id:int, pos:Vector2, dir:float, time:float):
	
	var b:Projectile = Bullet.instance()
	Manager.loose.add_child(b)
	b.initialize(id, pos, dir, time)
		
	#$Shoot.play()
	
	pass
	
func ability1():
	rpc("ascension")

remotesync func ascension():
	$Animation.play("Ascension")
	moveSpeed += 100
	pass
	
func ability2():
	rpc("questionMark")
	
remotesync func questionMark():
	maxHealth += 1000
	health += 1000
	$Graphics/FUN.emitting = true
	updateHealth()
	yield(get_tree().create_timer(1), "timeout")
	maxHealth -= 1000
	health -= 1000
	$Graphics/FUN.emitting = false
	updateHealth()
	pass
	
func lifeSteal(body, amount:int):
	if body.is_in_group("Player") and not body.is_in_group("Ally"+String(get_network_master())):
		yield(get_tree().create_timer(0.1), "timeout")
		rpc("hit", 100000, get_network_master())
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



