extends Area2D

export var damage:int = 20

func _on_Spike_body_entered(body):
	body.rpc("hit", damage, Globals.deathCodes.SPIKES)
