extends Character

export var NormBullet:PackedScene
export var BigBullet:PackedScene
export var LifeSteal:PackedScene
export var attack1NumBullets:int = 3
export var shootDelay:float = 0.12

func attack1():
	usingAttack1 = true
	var dir = (get_global_mouse_position()-global_position).angle()
	for b in range(attack1NumBullets):
		rpc("shoot", get_network_master(), global_position, dir, OS.get_system_time_msecs(), 0)
		yield(get_tree().create_timer(shootDelay), "timeout")
	usingAttack1 = false
	pass
	
func attack2():
	rpc("shoot", get_network_master(), global_position, (get_global_mouse_position()-global_position).angle(), OS.get_system_time_msecs(), 1)
	
func ability1():
	
	rpc("shoot", get_network_master(), global_position, (get_global_mouse_position()-global_position).angle(), OS.get_system_time_msecs(), 2)
	
remotesync func shoot(id:int, pos:Vector2, dir:float, time:int, bulletType):
	
	Manager.draw.addDrawCall("draw_circle", [pos, 5, Color(0, 1 ,0, 1)], 1)
	
	var bullet:PackedScene
	
	match bulletType:
		
		0:
			bullet = NormBullet
		1:
			bullet = BigBullet
		2:
			bullet = LifeSteal
	
	var b:Projectile = bullet.instance()
	b.set_network_master(1)
	Manager.loose.add_child(b)
	b.initialize(id, pos, time, dir)
	if bulletType == 2 and is_network_master():
		b.connect("collided", self, "lifeSteal", [b.damage])
	
	pass
	
func lifeSteal(body, amount:int):
	if body.is_in_group("Player") and body.is_in_group("Enemy"):
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
