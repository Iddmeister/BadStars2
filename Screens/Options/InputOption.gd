extends Button

var waitingForInput:bool = false
signal assignedInput(input)

func _input(event):
	
	if not waitingForInput:
		return
		
	if event.is_pressed():
		if event is InputEventMouseButton:
			if event.is_action("leftClick"):
				text = "Mouse Left"
			elif event.is_action("rightClick"):
				text = "Mouse Right"
			elif event.is_action("middleMouse"):
				text = "Mouse Middle"
		else:
			text = event.as_text()
		emit_signal("assignedInput", event)
		pressed = false
		waitingForInput = false
		disabled = true
		yield(get_tree().create_timer(0.1), "timeout")
		disabled = false
	
	pass
	



func _on_InputOption_button_up():
	waitingForInput = true
	text = "-"
