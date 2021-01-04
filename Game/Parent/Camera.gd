extends Camera2D

var currentImportance:int = 0

var moving:bool = false
onready var followPlayer:bool = true

func _physics_process(delta):
	if followPlayer:
		global_position = get_parent().get_parent().global_position
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
