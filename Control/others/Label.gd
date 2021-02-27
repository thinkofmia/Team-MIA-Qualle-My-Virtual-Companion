extends Button

export(String) var scene_to_load


func _on_Settings_pressed():
	pass # Replace with function body.


func _on_Back_pressed():
	get_tree().change_scene("res://View/Scenes/MainScreen.tscn")
	pass # Replace with function body.
