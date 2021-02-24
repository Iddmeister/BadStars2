extends Character

export var NormBullet:PackedScene
export var BigBullet:PackedScene
export var LifeSteal:PackedScene
export var attack1NumBullets:int = 3
export var shootDelay:float = 0.12
export var laserWindup:float = 0.8
export var laserDamage:int = 65


func setupSkin():
	
	match skin:
		
		"Blood Clot":
			
			$Graphics/Sprite.texture = load("res://Game/Characters/Clot/RedBloodCell.png")
			$Graphics/Sprite.scale = Vector2(0.15, 0.15)
			$Graphics/BloodTrail.visible = true
			$Graphics/BloodTrail.emitting = true
			var squelch = preload("res://Game/Characters/Clot/Squelch.wav")
			$Shoot.stream = squelch
			$Shoot.pitch_scale = 1.5
			$Death.stream = squelch
			$Spawn.stream = squelch
			$Win.stream = squelch
			killLines = PoolStringArray(["res://Game/Characters/Clot/Squelch.wav"])
	pass

func attack1():
	usingAttack1 = true
	var dir = getAimDirection()
	for b in range(attack1NumBullets):
		rpc("shoot", get_network_master(), global_position, dir, Network.clock, 0)
		yield(get_tree().create_timer(shootDelay), "timeout")
	usingAttack1 = false
	pass
	
func attack2():
	rpc("shoot", get_network_master(), global_position, getAimDirection(), Network.clock, 1)
	
func ability1():
	
	rpc("shoot", get_network_master(), global_position, getAimDirection(), Network.clock, 2)
	
func ability2():
	rpc("shootLaser", getAimDirection())
	pass
	
remotesync func shootLaser(dir:float):
	$LaserShoot.play()
	$Laser.visible = true
	$Laser.global_rotation = dir
	$Laser/Tell.visible = true
	canMove += 1
	yield(get_tree().create_timer(laserWindup), "timeout")
	$Laser/Tell.visible = false
	$Laser/Line.visible = true
	if is_network_master():
		for body in $Laser.get_overlapping_bodies():
			if not body.has_method("hit"):
				continue
			if not body.is_in_group("Ally"+String(get_network_master())):
				body.rpc("hit", laserDamage, get_network_master())
	yield(get_tree().create_timer(0.3), "timeout")
	canMove -= 1
	$Laser.visible = false
	pass
	
remotesync func shoot(id:int, pos:Vector2, dir:float, time:float, bulletType):
	
	var bullet:PackedScene
	
	match bulletType:
		
		0:
			bullet = NormBullet
		1:
			bullet = BigBullet
		2:
			bullet = LifeSteal
	
	var b:Projectile = bullet.instance()
	Manager.loose.add_child(b)
	b.global_position = global_position
	b.initialize(id, pos, dir, time)
	if bulletType == 2 and get_tree().is_network_server():
		b.connect("collided", self, "lifeSteal", [b.damage])
		
	$Shoot.play()
	
	pass
	
func lifeSteal(body, amount:int):
	if body.is_in_group("Player") and not body.is_in_group("Ally"+String(get_network_master())):
		rpc("heal", amount)
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
