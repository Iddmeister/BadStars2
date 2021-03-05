extends KinematicBody2D

export var kickPower:float = 1000
export var deceleration:float = 0.1
var velocity:Vector2
var masterPos:Vector2
var syncSpeed:float = 0.6
var spawnPos:Vector2

func _ready():
	masterPos = global_position
	spawnPos = global_position

func _physics_process(delta):
	
	if is_network_master():
	
		velocity = velocity.linear_interpolate(Vector2(0, 0), deceleration*delta*60)
		
		var collision = move_and_collide(velocity*delta)
		
		if collision:
			
			if collision.collider.is_in_group("Player"):
				rpc("kick", (global_position-collision.collider.global_position).angle())
			else:
				velocity = move_and_slide(velocity)
				
		rpc("updateState", global_position)
		
	else:
		syncState(delta)

puppet func updateState(pos:Vector2):
	masterPos = pos
	
func syncState(delta:float):
	global_position = global_position.linear_interpolate(masterPos, syncSpeed*delta*60)

master func kick(dir:float):
	
	velocity += Vector2(kickPower, 0).rotated(dir)

remotesync func setState(pos:Vector2):
	masterPos = pos
	global_position = pos
	velocity = Vector2(0, 0)
	
	
remotesync func reset():
	global_position = spawnPos
