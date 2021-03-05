extends Area2D

var masterID:int

func _ready():
	$Animation.play("Drop")

func _on_SmokeBomb_body_entered(body):
	if not is_network_master():
		return
	if body.is_in_group("Turtle") and body.is_in_group("Ally"+String(masterID)):
		body.rpc("camouflage", true)


func _on_SmokeBomb_body_exited(body):
	if not is_network_master():
		return
	if body.is_in_group("Turtle") and body.is_in_group("Ally"+String(masterID)):
		body.rpc("camouflage", false)


func _on_Time_timeout():
	$Animation.play("Remove")
	yield($Animation, "animation_finished")
	queue_free()
