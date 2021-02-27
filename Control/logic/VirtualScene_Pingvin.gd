extends Control

#Variables
var speech
var animated

# Called when the node enters the scene tree for the first time.
func _ready():
	animated = $Control/Character/Pingvin/Animation
	speech = $Control/TextContainer/TextEdit
	pass # Replace with function body.


func _on_Back_pressed():
	get_tree().change_scene("res://View/Scenes/FriendsScene.tscn")
	pass # Replace with function body.


func _on_Greet_pressed():
	speech.text = "Pingvin: Good afternoon~"
	animated.play("blush")
	pass # Replace with function body.


func _on_Animation_animation_finished():
	speech.text = "Pingvin was fed an hour ago."
	animated.play("default")
	pass # Replace with function body.
