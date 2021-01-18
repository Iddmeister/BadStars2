extends Node2D

class_name Effect

func _ready():
	pass
	
func start(info:Dictionary, player:Character):
	pass
	
func end(info:Dictionary, player:Character):
	queue_free()
	pass

