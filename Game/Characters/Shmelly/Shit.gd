extends Area2D

export var slowTime:float = 1
export var slowAmount:float = 100
export var healAmount:int = 50
var masterID:int

var shitSkin:Texture

var finalPos:Vector2
var speed:float = 0.5

func _ready():
	
	if shitSkin:
		$Sprite.texture = shitSkin

func _process(delta):
	
	global_position = global_position.linear_interpolate(finalPos, speed*60*delta)

func _on_Shit_body_entered(body):
	
	if is_network_master():
		if not body.is_in_group("Ally"+String(masterID)):
			body.rpc("addEffect", Manager.generateUniqueID(), "slow", slowTime, {"slow":slowAmount})
		elif body.name == String(masterID):
			body.rpc("heal", healAmount)
			rpc("destroy")

remotesync func destroy():
	queue_free()

func _on_Exist_timeout():
	queue_free()


func _on_Active_timeout():
	$CollisionShape2D.disabled = false
