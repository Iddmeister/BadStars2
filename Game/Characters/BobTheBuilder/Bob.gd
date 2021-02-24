extends Character

export var Block:PackedScene = preload("res://Game/Characters/BobTheBuilder/Block.tscn")
export var SpikeFloor:PackedScene = preload("res://Game/Characters/BobTheBuilder/SpikeFloor.tscn")
export var Hammer = preload("res://Game/Characters/BobTheBuilder/Hammer.tscn")

var flipped = false

var blocks = {}


func attack1():
	
	rpc("placeBlock", get_global_mouse_position())
	
	pass
	
func attack2():
	rpc("removeBlock", get_global_mouse_position())
	pass
	
func ability1():
	rpc("placeSpike", get_global_mouse_position())
	
func ability2():
	rpc("throwHammer", get_network_master(), global_position, getAimDirection(), Network.clock)
	
remotesync func throwHammer(id:int, pos:Vector2, dir:float, time:float):
	
	
	var h:Projectile = Hammer.instance()
	Manager.loose.add_child(h)
	h.global_position = global_position
	h.initialize(id, pos, dir, time)
		
	$Throw.play()
	
	pass
	
remotesync func placeSpike(pos:Vector2):
	
	var b = SpikeFloor.instance()
	b.masterID = get_network_master()
	Manager.loose.add_child(b)
	b.global_position = Vector2(round(pos.x/80)*80,round(pos.y/80)*80)
	$Build.play()
	
remotesync func placeBlock(pos:Vector2):
	
	if blocks.has(Vector2(round(pos.x/80)*80,round(pos.y/80)*80)):
		return
	
	var b = Block.instance()
	Manager.loose.add_child(b)
	b.global_position = Vector2(round(pos.x/80)*80,round(pos.y/80)*80)
	b.add_to_group("Ally"+String(get_network_master()))
	blocks[Vector2(round(pos.x/80)*80,round(pos.y/80)*80)] = b
	
	$Build.play()
	
	pass
	
remotesync func removeBlock(pos:Vector2):
	
	if not blocks.has(Vector2(round(pos.x/80)*80,round(pos.y/80)*80)):
		return
	var b = blocks[Vector2(round(pos.x/80)*80,round(pos.y/80)*80)]
	b.queue_free()
	blocks.erase(Vector2(round(pos.x/80)*80,round(pos.y/80)*80))
	
	$Build.play()
	
	pass

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


