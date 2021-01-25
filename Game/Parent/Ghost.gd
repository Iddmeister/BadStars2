extends Sprite

export var speed:float = 600

var masterPos:Vector2

var syncing:bool = false

func initialze(id:int):
	set_network_master(id)
	
	name = "Ghost"+String(id)
	
	if is_network_master():
		$Camera.current = true
		yield(get_tree().create_timer(1), "timeout")
		syncing = true
	else:
		modulate.a = 0.5

func getMoveDirection() -> Vector2:
	
	var dir = Vector2(0, 0)
	
	if Input.is_action_pressed("left"):
		dir.x -= 1
	if Input.is_action_pressed("right"):
		dir.x += 1
	if Input.is_action_pressed("up"):
		dir.y -= 1
	if Input.is_action_pressed("down"):
		dir.y += 1
		
	return dir.normalized()

func _physics_process(delta):
	
	if is_network_master():
	
		global_position += getMoveDirection()*speed*delta
		
		if syncing:
			rpc_unreliable("updatePos", global_position)
		
	else:
		
		global_position = global_position.linear_interpolate(masterPos, 0.5)
		
	pass
	
puppet func setPos(pos:Vector2):
	masterPos = pos
	global_position = pos
	
puppet func updatePos(pos:Vector2):
	masterPos = pos

