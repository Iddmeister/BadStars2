extends Particles2D

class_name TempParticles
	
func start():
	emitting = true
	$Time.start((lifetime/speed_scale)+1)


func _on_Time_timeout():
	queue_free()
