extends Character

export var Icicle:PackedScene
export var SlipperyIcicle:PackedScene
export var FreezeZone:PackedScene
export var speedTime:float = 3
export var speedIncrease:float = 300
export var IceWall:PackedScene
var timePassed:float = 0

func setupSkin():
	
	match skin:
		
		"Pool Party Frozone":
			
			$Graphics/Sprite.texture = load("res://Game/Characters/Frozone/FrozonePool.png")

func attack1():
	rpc("shoot", get_network_master(), global_position, getAimDirection(), Network.clock, 0)
	pass
	
func attack2():
	rpc("shoot", get_network_master(), global_position, getAimDirection(), Network.clock, 1)
	pass
	
func ability1():
	$FreezeZoneInterval.start()
	timePassed = 0
	moveSpeed += speedIncrease
	pass
	
func ability2():
	var offset = Vector2(100, 0).rotated(getAimDirection())
	rpc("placeWall", global_position+offset, getAimDirection(), Network.clock)
	
remotesync func placeWall(pos:Vector2, rot:float, startTime:float):
	
	var i = IceWall.instance()
	i.initialize(startTime)
	Manager.loose.add_child(i)
	i.global_position = pos
	i.global_rotation = rot
	
	pass
	
remotesync func placeFreezeZone(pos:Vector2):
	
	var zone = FreezeZone.instance()
	zone.initialize(get_network_master())
	Manager.loose.add_child(zone)
	zone.global_position = pos
	
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
	b.global_position = global_position
		
	#$Shoot.play()
	
	pass


func _on_FreezeZoneInterval_timeout():
	rpc("placeFreezeZone", global_position)
	timePassed += $FreezeZoneInterval.wait_time
	if timePassed >= speedTime:
		$FreezeZoneInterval.stop()
		moveSpeed -= speedIncrease
		
