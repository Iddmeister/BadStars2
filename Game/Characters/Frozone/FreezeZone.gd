extends Area2D

export var freezeTime:float = 1.5
var masterID:int

func initialize(id:int):
	masterID = id
	pass
	
func _ready():
	$Animation.play("Place")

func _on_FreezeZone_body_entered(body):
	if is_network_master():
		if not body.is_in_group("Ally"+String(masterID)):
			body.rpc("addEffect", "freezeZone", "freeze", freezeTime)


func _on_Time_timeout():
	queue_free()
