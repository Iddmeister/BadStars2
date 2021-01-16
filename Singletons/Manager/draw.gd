extends Node2D

## drawCall is a dictionary in the form {method:String, args:[], time:milliseconds, start:milliseconds}

var drawBuffer = {}


func _process(delta):
	update()

func _draw():
	
	for call in drawBuffer.keys():
		
		if drawBuffer[call].start+drawBuffer[call].delay > OS.get_ticks_msec():
			continue
		
		if drawBuffer[call].start+drawBuffer[call].delay+drawBuffer[call].time >= OS.get_ticks_msec():
			
			callv(drawBuffer[call].method, drawBuffer[call].args)
			
		else:
			
			drawBuffer.erase(call)
		
		pass
	
	pass
	
func addDrawCall(method:String, args:Array, time:int=0, delay:int=0):
	
	drawBuffer[drawBuffer.keys().size()] = {"method":method, "args":args, "time":time, "start":OS.get_ticks_msec(), "delay":delay}
	
	pass
	
func shake(power:float, time:float, importance:int=0):
	
	for c in get_tree().get_nodes_in_group("playerCamera"):
		c.shake(power, time, importance)
		
remotesync func effect():
	pass
