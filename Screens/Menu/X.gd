extends Control


func _on_Button_pressed():
	Manager.changeScene("res://Screens/Menu/Menu.tscn")
	pass # Replace with function body.


func _on_RichTextLabel_meta_clicked(meta):
	OS.shell_open(meta)
	pass # Replace with function body.
