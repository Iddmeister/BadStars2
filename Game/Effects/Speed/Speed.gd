extends Effect

func start(info:Dictionary, player:Character):
	
	player.moveSpeed += info.speed
	
	pass
	
func end(info:Dictionary, player:Character):
	
	player.moveSpeed -= info.speed
	queue_free()
	
	pass
