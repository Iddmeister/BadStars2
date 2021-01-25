extends Node2D

func start(info:Dictionary, player:Character):
	
	player.moveSpeed -= info.slow
	
	pass
	
func end(info:Dictionary, player:Character):
	
	player.moveSpeed += info.slow
	queue_free()
	
	pass

