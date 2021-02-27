extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	get_tree().change_scene("res://View/Scenes/MainScreen.tscn")
	pass # Replace with function body.


func _on_Penguin_mouse_entered():
	$Control/TextContainer/TextEdit.text = "Penguin: Am blushing~"
	var animated = $Control/Character/Penguin/Animation
	$Control/Character/Penguin/Animation.play("default")
	pass # Replace with function body.


func _on_Penguin_mouse_exited():
	var animated = $Control/Character/Penguin/Animation
	animated.stop()
	pass # Replace with function body.


func _on_Listen_pressed():
	$Control/TextContainer/TextEdit.text = "Penguin: Am blushing~"
	var animated = $Control/Character/Penguin/Animation
	animated.play("blushing")
	pass # Replace with function body.


func _on_Animation_animation_finished():
	$Control/TextContainer/TextEdit.text = "Penguin: Talk to me!"
	var animated = $Control/Character/Penguin/Animation
	animated.play("default")
	pass # Replace with function body.
