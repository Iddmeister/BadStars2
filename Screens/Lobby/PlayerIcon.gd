extends PanelContainer

export var unreadyColour:Color
export var readyColour:Color

var ready:bool = false
var showCharacter:bool = false

signal kick(p)

func _ready():
	$VBoxContainer/Name.add_color_override("font_color", unreadyColour)
	if is_network_master():
		$VBoxContainer/Kick.show()
	if showCharacter:
		$VBoxContainer/Character.show()
		
	pass
	
func setCharacter(c:String):
	$VBoxContainer/Character.text = c

func setReady(r:bool):
	ready = r
	
	if ready:
		$VBoxContainer/Name.add_color_override("font_color", readyColour)
	else:
		$VBoxContainer/Name.add_color_override("font_color", unreadyColour)


func _on_Kick_pressed():
	emit_signal("kick", self)
