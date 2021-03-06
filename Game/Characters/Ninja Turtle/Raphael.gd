extends Node2D

export var Sai:PackedScene = preload("res://Game/Characters/Ninja Turtle/Sai.tscn")

onready var player = get_parent().get_parent().get_parent()

func attack1():
	player.usingAttack1 = true
	rpc("stab", player.getAimDirection())
	yield($Stab/Animation, "animation_finished")
	player.usingAttack1 = false
	
remotesync func stab(dir:float):
	
	$Stab.global_rotation = dir
	$Stab/Animation.play("Stab")
	
	pass
	
func attack2():
	rpc("throwSai", global_position, player.getAimDirection(), Network.clock)
	
remotesync func throwSai(pos:Vector2, dir:float, time:float):
	
	var s:Projectile = Sai.instance()
	Manager.loose.add_child(s)
	s.global_position = global_position
	s.initialize(player.get_network_master(), pos, dir, time)
	
	pass
