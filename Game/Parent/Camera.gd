extends Camera2D

var currentImportance:int = 0

var moving:bool = false
var followPlayer:bool = true
enum {STATIC, SMOOTH}
onready var followType:int = STATIC
export var smoothSpeed:float = 3000
signal caughtUp()

func _physics_process(delta):
	if followPlayer:
		match followType:
			
			STATIC:
				global_position = get_parent().get_parent().global_position
			SMOOTH:
				if (get_parent().get_parent().global_position-global_position).length() <= smoothSpeed*delta:
					emit_signal("caughtUp")
					global_position = get_parent().get_parent().global_position
				else:
					global_position += (get_parent().get_parent().global_position-global_position).normalized()*smoothSpeed*delta
	pass

func move_camera(move:Vector2):
	if not moving:
		offset = Vector2(rand_range(-move.x, move.x), rand_range(-move.y, move.y))
	pass
	
func shake(power:float, time:float, importance:int=0):
	
	if importance >= currentImportance:
		currentImportance = importance
	else:
		return
	
	$Tween.interpolate_method(self, "move_camera", Vector2(power, power), Vector2(0, 0), time, Tween.TRANS_SINE, Tween.EASE_OUT, 0)
	$Tween.start()
	
	pass


func _on_Tween_tween_completed(object, key):
	currentImportance = 0
