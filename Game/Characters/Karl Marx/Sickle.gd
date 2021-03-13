extends Area2D

export var speed:float = 600
export var damage:int = 50
export var maxDistance:float = 400
export var minFinishDistance:float = 10
export var spinSpeed:float = 10
var direction:float
var startPos:Vector2
var karl:Character

var returning:bool = false
var inAir:bool = false

signal returned()


func _physics_process(delta):
	
	if not inAir:
		global_position = karl.global_position
		return
		
	global_rotation += spinSpeed*delta
	
	if not returning:
		global_position += Vector2(speed, 0).rotated(direction)*delta
		
		if (global_position-startPos).length() >= maxDistance:
			returning = true
		
	else:
		global_position += (karl.global_position-global_position).normalized()*speed*delta

		if (karl.global_position-global_position).length() <= minFinishDistance:
			finish()
		
remotesync func throw(dir:float):
	
	inAir = true
	visible = true
	direction = dir
	startPos = global_position
	returning = false
	
	pass
		
remotesync func finish():
	inAir = false
	visible = false
	emit_signal("returned")
	
remotesync func bounce():
	if returning:
		return
	returning = true
	pass

func _on_Sickle_body_entered(body):
	if not body.is_in_group("Player"):
		bounce()
		if is_network_master():
			rpc("bounce")
	elif is_network_master():
		if not body.is_in_group("Ally"+String(karl.get_network_master())):
			body.rpc("hit", damage, karl.get_network_master())
