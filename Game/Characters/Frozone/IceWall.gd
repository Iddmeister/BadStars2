extends StaticBody2D

export var existTime:float = 4
var time:float = 0

func _ready():
	$Animation.play("Place")

func initialize(startTime:float):
	
	time = Network.clock-startTime
	
	pass
	
func _process(delta):
	
	time += delta
	
	if time >= existTime:
		destroy()
		
func destroy():
	queue_free()
