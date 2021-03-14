extends Character

export var straightDamage:int = 15
export var hookDamageIncrease:float = 10
export var baseHookKnock:float = 1000
export var hookKnockIncrease:float = 300
export var straightHeal:int = 15
export var bodySlamForce:float = 5000
export var slowAmount:float = 100
export var slowTime:float = 2

var straights:int = 0
var hooked:bool = false

var justHooked:bool = false

var bodySlamming:bool = false

var knockedBodies = []

func hitBody(body):
	if justHooked:
		hooked = true
	else:
		straights += 1

func attack1():
	
	if hooked:
		rpc("heal", straightHeal)
	
	usingAttack1 = true
	rpc("straight", getAimDirection())
	yield($Graphics/Fist/Animation, "animation_finished")
	usingAttack1 = false
	$Combo.start()
	
	
func attack2():
	usingAttack2 = true
	justHooked = true
	rpc("hook", getAimDirection(), straights)
	straights = 0
	yield($Graphics/Fist/Animation, "animation_finished")
	usingAttack2 = false
	$Combo.start()
	
	
remotesync func straight(dir:float):
	$Graphics/Fist.global_rotation = dir
	$Graphics/Fist.knockBack = 0
	$Graphics/Fist.damage = straightDamage
	$Graphics/Fist/Animation.play("Straight")

	pass
	
remotesync func hook(dir:float, numStraights:int):
	$Graphics/Fist.global_rotation = dir
	$Graphics/Fist.damage = straightDamage+int(hookDamageIncrease*numStraights)
	$Graphics/Fist.knockBack = baseHookKnock+int(hookKnockIncrease*numStraights)
	$Graphics/Fist/Animation.play("Hook")



func _on_Combo_timeout():
	straights = 0
	hooked = false
	
func ability1():
	knock(Vector2(bodySlamForce, 0).rotated(getAimDirection()))
	rpc("bodySlam", true)
	usingAbility1 = true
	reloadAmmo(maxAmmo-ammo)
	yield(get_tree().create_timer(1), "timeout")
	rpc("bodySlam", false)
	usingAbility1 = false
	pass
	
remotesync func bodySlam(do:bool):
	knockedBodies.clear()
	bodySlamming = do
	$BodySlam/CollisionShape2D.disabled = not do
	$Trail.emitting = do
	pass

func _on_BodySlam_body_entered(body):
	if is_network_master():
		if not body.is_in_group("Ally"+String(get_network_master())) and not body in knockedBodies:
			body.rpc("knock", knockVelocity.normalized()*bodySlamForce)
			body.rpc("addEffect", "BodySlam"+String(get_network_master()), "stun", 0.5, {})
			knockedBodies.append(body)

func ability2():
	rpc("scream")
	pass
	
	
remotesync func scream():
	$Scream/Animation.play("Scream")
	if is_network_master():
		for body in $Scream.get_overlapping_bodies():
			if not body.is_in_group("Ally"+String(get_network_master())):
				body.rpc("addEffect", "Scream"+String(get_network_master()), "slow", slowTime, {"slow":slowAmount})
