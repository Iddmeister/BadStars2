extends MarginContainer

export var maxMessages:int = 10

var chatting:bool = false


onready var messageBox = $VBoxContainer/Message
onready var chatHistory = $VBoxContainer/History

func _process(delta):
	
	if Input.is_action_just_pressed("chat") and not chatting and not Globals.inputBusy:
		
		Globals.inputBusy = true
		chatting = true
		messageBox.show()
		messageBox.grab_focus()
		
	elif Input.is_action_just_pressed("chat") and chatting:
		
		if not messageBox.text.empty():
			
			if messageBox.text.begins_with("/team"):
				
				for player in Globals.currentGameInfo.players.keys():
					
					if get_tree().get_network_unique_id() in Globals.currentGameInfo.players[player].allies:
						rpc_id(player, "addMessage", get_tree().get_network_unique_id(), messageBox.text)
				
			else:
			
				rpc("addMessage", get_tree().get_network_unique_id(), messageBox.text)
			
		messageBox.text = ""
		messageBox.hide()
		Globals.inputBusy = false
		chatting = false
		

remotesync func addMessage(id:int, message:String, colour:Color=Color(1, 1, 1 ,1)):
	
	var l = Label.new()
	l.autowrap = true
	l.add_color_override("font_color", colour)
	
	if message.begins_with("/team"):
		message = message.replace("/team", "[team]")
	
	if not id == -1:
		l.text = "[%s] %s" % [Network.players[id].name, message]
	else:
		l.text = message
		
	if chatHistory.get_child_count() >= maxMessages:
		chatHistory.get_child(maxMessages-1).queue_free()
		
	chatHistory.add_child(l)
	
	pass
	



func _on_Message_text_entered(new_text):
	pass # Replace with function body.
