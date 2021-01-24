extends PanelContainer

export var unreadyColour:Color
export var readyColour:Color

var ready:bool = false
var showCharacter:bool = false

signal kick(p)
signal leave(p)

var team:int = 0

func _ready():
	$VBoxContainer/Name.add_color_override("font_color", unreadyColour)
	if is_network_master():
		$VBoxContainer/Kick.show()
	if showCharacter:
		$VBoxContainer/Character.show()
		
	pass
	
func setName(n:String):
	$VBoxContainer/Name.text = n
	
func setCharacter(c:String):
	$VBoxContainer/Character.text = c
	
func setTeams(d:bool):
	if d:
		$VBoxContainer/Team.show()
		if not int(name) == get_tree().get_network_unique_id():
			$VBoxContainer/Team.disabled = true
			
	else:
		$VBoxContainer/Team.hide()
		
func setHost(d:bool):
	
	if d:
		$VBoxContainer/Ping.text = "Host"
		$VBoxContainer/Ping.visible = true
	else:
		$VBoxContainer/Ping.visible = false
		
func setPing(ping:float):
	$VBoxContainer/Ping.text = String(ping)+"ms"
	$VBoxContainer/Ping.visible = true

func setReady(r:bool):
	ready = r
	
	if ready:
		$VBoxContainer/Name.add_color_override("font_color", readyColour)
	else:
		$VBoxContainer/Name.add_color_override("font_color", unreadyColour)

remotesync func setTeam(t:int):
	team = t
	$VBoxContainer/Team.selected = t
	pass
	
func updateTeam():
	
	rpc("setTeam", team)
	
	pass

func _on_Kick_pressed():
	emit_signal("kick", self)


func _on_Team_item_selected(index):
	rpc("setTeam", index)
