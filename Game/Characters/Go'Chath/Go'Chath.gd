extends Character

export var BasicAttack:PackedScene
export var Silence:PackedScene
export var KnockUp:PackedScene
export var numOfBullets:int = 4
export var bulletSpacing:float = 100
export var knockUpTime:float = 2
export var growAmount:float = 0.5
export var healthIncrease:int = 50
export var knockUpParticles:PackedScene
export var GrowParticles:PackedScene

var knockUpBodies = []

remotesync func shoot(id:int, pos:Vector2, dir:float, time:float, bulletType:int=0):
	
	$Attack.play()
	
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

			var spawnPos = pos+Vector2(0, offset).rotated(dir)

			var b:Projectile = bullet.instance()
			Manager.loose.add_child(b)
			b.initialize(id, spawnPos, dir, time)
			b.global_position = global_position+Vector2(0, offset).rotated(dir)
			
	else:
			var b:Projectile = bullet.instance()
			Manager.loose.add_child(b)
			b.initialize(id, pos, dir, time)
			b.global_position = global_position

	pass
	
func attack1():
	
	rpc("shoot", get_network_master(), global_position, getAimDirection(), Network.clock, 0)
	
func attack2():
	
	rpc("shoot", get_network_master(), global_position, getAimDirection(), Network.clock, 1)
	
	
func ability1():
	
	rpc("grow")
	
	
	
remotesync func grow():
	
	var g = GrowParticles.instance()
	Manager.loose.add_child(g)
	g.global_position = global_position
	g.scale = scale
	g.start()
	
	canMove += 1
	$Grow.play()
	yield(get_tree().create_timer(1), "timeout")
	scale += Vector2(growAmount, growAmount)
	moveSpeed = max(moveSpeed-20, 100)
	var increase = float(health)/maxHealth
	maxHealth += healthIncrease
	health = int(maxHealth*increase)
	updateHealth()
	canMove -= 1
	
	pass
	
func ability2():

	rpc("knockUpArea", getAimDirection())
	
remotesync func knockUpArea(dir:float):

	$KnockUpArea.global_rotation = dir
	
	$KnockUpArea/Tell.visible = true
	
	yield(get_tree().create_timer(1), "timeout")
	
	$KnockUpArea/Tell.visible = false
	
	var p = knockUpParticles.instance()
	Manager.loose.add_child(p)
	p.global_position = $KnockUpArea/CollisionShape2D.global_position
	p.start()
	
	if is_network_master():
		for body in knockUpBodies:
			if not body.is_in_group("Ally"+String(get_network_master())):
				body.rpc("knockUp", knockUpTime)
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


func _on_KnockUpArea_body_entered(body):
	knockUpBodies.append(body)


func _on_KnockUpArea_body_exited(body):
	knockUpBodies.erase(body)
