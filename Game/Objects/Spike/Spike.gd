extends Area2D

export var damage:int = 20

func _on_Spike_body_entered(body):
	if is_network_master():
		body.rpc("hit", damage, Globals.deathCodes.SPIKES)
