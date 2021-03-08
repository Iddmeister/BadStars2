extends Node2D

export var dashSpeed:float = 2000
export var damageReduction:float = 0.5

onready var player = get_parent().get_parent().get_parent()

func attack1():
	player.usingAttack1 = true
	rpc("slash", player.getAimDirection())
	yield($Slash/Animation, "animation_finished")
	player.usingAttack1 = false
	
remotesync func slash(dir:float):
	
	$Slash.global_rotation = dir
	$Slash/Animation.play("Slash")
	
	pass
	
func attack2():
	rpc("dash", player.getAimDirection())
	
remotesync func dash(dir:float):
	if is_network_master():
		$Slash/DamageReduction.start()
	player.rpc("knock", Vector2(dashSpeed, 0).rotated(dir))
	player.damageReduction += damageReduction
	$Shield.visible = true
	
remotesync func removeDamageReduction():
	player.damageReduction -= damageReduction
	$Shield.visible = false
	
func _on_DamageReduction_timeout():
	rpc("removeDamageReduction")
