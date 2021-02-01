extends Character

export var Block:PackedScene = preload("res://Game/Characters/BobTheBuilder/Block.tscn")
export var SpikeFloor:PackedScene = preload("res://Game/Characters/BobTheBuilder/SpikeFloor.tscn")

export var hammerDamage:int = 35

var flipped = false

var bodies = []

func attack1():
	
	rpc("placeBlock", get_global_mouse_position())
	
	pass
	
func attack2():
	
	rpc("hammer", getAimDirection())
	
	pass
	
func ability1():
	rpc("placeSpike", get_global_mouse_position())
	
remotesync func hammer(dir:float):
	
	$Hammer.global_rotation = dir
	$Hammer/Animation.play("Swing")
	
	if is_network_master():
	
		yield(get_tree(), "physics_frame")
	
		for body in bodies:
			
			if body.has_method("remove"):
				body.rpc("remove")
				return
			if body.has_method("hit"):
				if not body.is_in_group("Ally"+String(get_network_master())):
					body.rpc("hit", hammerDamage, get_network_master())
					return
	
	pass
	
	
remotesync func placeSpike(pos:Vector2):
	
	var b = SpikeFloor.instance()
	b.masterID = get_network_master()
	Manager.loose.add_child(b)
	b.global_position = Vector2(round(pos.x/80)*80,round(pos.y/80)*80)
	
remotesync func placeBlock(pos:Vector2):
	
	var b = Block.instance()
	Manager.loose.add_child(b)
	b.global_position = Vector2(round(pos.x/80)*80,round(pos.y/80)*80)
	
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


func _on_Hammer_body_entered(body):
	bodies.append(body)


func _on_Hammer_body_exited(body):
	bodies.erase(body)
