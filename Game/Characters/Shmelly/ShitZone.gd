extends Area2D

var masterID:int
export var diarrheaBuildUp:float = 3
var skin:Texture

func _ready():
	if skin:
		$Sprite.texture = skin
	

func _on_ShitZone_body_entered(body):
	if not is_network_master():
		return
	if not body.is_in_group("Ally"+String(masterID)):
		randomize()
		body.rpc("addEffect", Manager.generateUniqueID(), "diarrhea", diarrheaBuildUp, {"s":int(rand_range(0, 100)), "masterID":masterID})

func _on_Exist_timeout():
	queue_free()
	
