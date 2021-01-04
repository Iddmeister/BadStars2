extends Control

var CharacterButton = preload("res://Screens/CharacterSelect/CharacterButton.tscn")

signal characterSelected(character)

export var characters:NodePath

func _ready():
	
	for character in CharacterInfo.characters.keys():
		
		var c = CharacterButton.instance()
		get_node(characters).add_child(c)
		c.setup(character)
		c.connect("selected", self, "selected")
	
	
	pass
	
func selected(character:String):
	emit_signal("characterSelected", character)
	pass
