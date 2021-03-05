extends Character

export var damage:int = 20
export var speedIncrease:float = 300
export var speedDecrease:float = 300
export var speedTime:float = 3
export var slowTime:float = 3
export var dashSpeed:float = 8000

var speedBodies = []

var speeding:bool = false

func setupSkin():
	
	match skin:
		
		"Udyr":
			
			$Graphics/Sprite.texture = load("res://Game/Characters/Barrel/Udyr.png")
			$Graphics/Sprite.scale = Vector2(0.15, 0.15)
			$Hit.pitch_scale = 3
			$Death.pitch_scale = 3



func _draw():
	
	if speeding:
		if is_in_group("Ally"+String(get_tree().get_network_unique_id())):
			draw_circle(Vector2(0, 0), $Speed/CollisionShape2D.shape.radius, Color(0, 0.2, 1, 0.5))
		else:
			draw_circle(Vector2(0, 0), $Speed/CollisionShape2D.shape.radius, Color(1, 0.2, 0, 0.5))

func updates(delta:float):
	update()

func ability1():
	
	knock(Vector2(dashSpeed, 0).rotated(getAimDirection()))
	
	pass
	
func ability2():
	
	rpc("speedArea")
	
remotesync func speedArea():
	
	speeding = true
	
	if is_network_master():
	
		for body in speedBodies:
			
			if body.is_in_group("Ally"+String(get_network_master())):
				body.rpc("addEffect", "barrelSpeed", "speed", speedTime, {"speed":speedIncrease})
			else:
				body.rpc("addEffect", "barrelSlow", "slow", slowTime, {"slow":speedDecrease})
				
	yield(get_tree().create_timer(0.2), "timeout")
	
	speeding = false
	
func _on_Damage_body_entered(body):
	if get_tree().is_network_server():
		if not body.is_in_group("Ally"+String(get_network_master())):
			body.rpc("hit", damage, get_network_master())
			rpc("hitPlayer")
			rpc("setAbility1Cooldown", 0)
			

remotesync func hitPlayer():
	$Hit.play()
	pass


func _on_Speed_body_entered(body):
	speedBodies.append(body)


func _on_Speed_body_exited(body):
	speedBodies.erase(body)
