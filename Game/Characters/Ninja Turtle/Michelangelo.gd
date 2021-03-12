extends Node2D

onready var player = get_parent().get_parent().get_parent()
export var pullStrength:float = 1000

func attack1():
	player.usingAttack1 = true
	rpc("whip", player.getAimDirection())
	yield($Whip/Animation, "animation_finished")
	player.usingAttack1 = false
	
func attack2():
	player.usingAttack2 = true
	rpc("pull", player.getAimDirection())
	yield($Pull/Animation, "animation_finished")
	player.usingAttack2 = false
	
remotesync func pull(dir:float):
	$Pull.global_rotation = dir
	$Pull/Animation.play("Pull")
	pass
	
func pullBodies():
	if is_network_master():
		for body in $Pull.get_overlapping_bodies():
			if not body.is_in_group("Ally"+String(player.get_network_master())):
				body.rpc("knock", Vector2(pullStrength, 0).rotated((global_position-body.global_position).angle()))
	pass
	
remotesync func whip(dir:float):
	
	$Whip.global_rotation = dir
	$Whip/Animation.play("Whip")
	
	pass
