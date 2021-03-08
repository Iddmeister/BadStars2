extends Character

export var skateSpeed:float = 200
export var healAmount:float = 5
export var healTick:float = 0.5
export var smokeBombRange:float = 100
export var SmokeBomb:PackedScene
var healTime:float = 0

var skateBodies:Array = []

var skinParams ={
	
	"Leonardo":{"scale":Vector2(0.08, 0.08), "offset":Vector2(-12.4, -1.126), "path":"res://Game/Characters/Ninja Turtle/Leonardo.png"},
	"Raphael":{"scale":Vector2(0.07, 0.07), "offset":Vector2(0, -4.46), "path":"res://Game/Characters/Ninja Turtle/Raphael.png"},
	"Michelangelo":{"scale":Vector2(0.4, 0.4), "offset":Vector2(-0.43, 2.27), "path":"res://Game/Characters/Ninja Turtle/Michelangelo.png"},
	"Donatello":{"scale":Vector2(0.28, 0.28), "offset":Vector2(-1.37, -2.97), "path":"res://Game/Characters/Ninja Turtle/Donatello.png"},
	
}

var skating:bool = false

func setupSkin():
	
	var sprite:Sprite = $Graphics/Sprite
	
	sprite.texture = load(skinParams[skin].path)
	sprite.position = skinParams[skin].offset
	sprite.scale = skinParams[skin].scale
	
	pass
	
func updates(delta:float):
	if not is_network_master():
		return
	if skating and not skateBodies.empty():
		for body in skateBodies:
			if body.skating:
				healTime += delta
				if healTime >= healTick:
					rpc("heal", healAmount)
					healTime = 0
		

func attack1():
	get_node("Graphics/Attacks/%s" % skin).attack1()
	
func attack2():
	get_node("Graphics/Attacks/%s" % skin).attack2()

	
func ability1():
	
	rpc("skate", true)
	$SkateTime.start()
	healTime = 0
	
	pass
	
remotesync func skate(do:bool):
	
	skating = do
	$Graphics/Skateboard.visible = do
	if do:
		addEffect("skate", "speed", $SkateTime.wait_time, {"speed":skateSpeed})
	
	pass
	
func ability2():
	
	rpc("dropSmokeBomb", global_position+(get_global_mouse_position()-global_position).clamped(smokeBombRange))
	
	pass
	
remotesync func dropSmokeBomb(pos:Vector2):
	var b = SmokeBomb.instance()
	b.masterID = get_network_master()
	Manager.loose.add_child(b)
	b.global_position = pos

remotesync func camouflage(do:bool):
	
	if do:
		invisible += 1
	else:
		invisible -= 1
			


func _on_SkateTime_timeout():
	rpc("skate", false)


func _on_SkateArea_body_entered(body):
	if body == self:
		return
	if body.is_in_group("Turtle") and body.is_in_group("Ally"+String(get_network_master())):
		skateBodies.append(body)


func _on_SkateArea_body_exited(body):
	if body == self:
		return
	if body.is_in_group("Turtle") and body.is_in_group("Ally"+String(get_network_master())):
		skateBodies.erase(body)
