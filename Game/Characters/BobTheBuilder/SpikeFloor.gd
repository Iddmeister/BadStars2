extends Area2D

export var damage:int = 12

var masterID:int

var bodies = []

func _ready():
	if is_network_master():
		$Damage.start()
	pass

func _on_SpikeFloor_body_entered(body):
	if not body.is_in_group("Ally"+String(masterID)):
		bodies.append(body)
		if is_network_master():
			$Exist.start()


func _on_SpikeFloor_body_exited(body):
	bodies.erase(body)


func _on_Damage_timeout():
	for body in bodies:
		body.rpc("hit", damage, masterID)


func _on_Exist_timeout():
	rpc("destroy")
	
remotesync func destroy():
	queue_free()
