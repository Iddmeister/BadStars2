extends Node2D

export var smackDamage:int = 60
export var smackKnock:float = 2000
export var smackStunTime:float = 0.7
onready var player = get_parent().get_parent().get_parent()

func attack1():
	player.usingAttack1 = true
	rpc("swipe", player.getAimDirection())
	yield($Swipe/Animation, "animation_finished")
	player.usingAttack1 = false
	
func attack2():
	player.usingAttack2 = true
	rpc("smack", player.getAimDirection())
	yield($Smack/Animation, "animation_finished")
	player.usingAttack2 = false
	
	
remotesync func swipe(dir:float):
	
	$Swipe.global_rotation = dir
	$Swipe/Animation.play("Swipe")

	
remotesync func smack(dir:float):
	$Smack.global_rotation = dir
	$Smack/Animation.play("Smack")
	
	
func smackBodies():
	
	if is_network_master():
		for body in $Smack.get_overlapping_bodies():
			if not body.is_in_group("Ally"+String(player.get_network_master())):
				body.rpc("knock", Vector2(smackKnock, 0).rotated((body.global_position-global_position).angle()))
				body.rpc("addEffect", "donatelloStun", "stun", smackStunTime)
	pass
