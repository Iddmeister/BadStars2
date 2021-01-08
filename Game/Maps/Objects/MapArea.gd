extends Area2D


func _ready():
	pass


func _on_MapArea_body_exited(body):
	if body.is_network_master():
		body.rpc("hit", 10000, Globals.deathCodes.OUT_OF_MAP)
