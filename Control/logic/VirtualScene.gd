extends Control

# Variables
var effect
var recording
var speech
var animated

# Called when the node enters the scene tree for the first time.
func _ready():
	# We get the index of the "Record" bus.
	var idx = AudioServer.get_bus_index("Record")
	# And use it to retrieve its first effect, which has been defined
	# as an "AudioEffectRecord" resource.
	effect = AudioServer.get_bus_effect(idx, 0)
	speech  = $Control/TextContainer/TextEdit
	animated = $Control/Character/Penguin/Animation
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Button_pressed():
	get_tree().change_scene("res://View/Scenes/MainScreen.tscn")
	pass # Replace with function body.


func _on_Penguin_mouse_entered():
	speech.text = "Pongoon: Am blushing~"
	animated.play("default")
	pass # Replace with function body.


func _on_Penguin_mouse_exited():
	animated.stop()
	pass # Replace with function body.


func _on_Listen_pressed():
	speech.text = "Pongoon: Am blushing~"
	animated.play("blushing")
	#For recording sounds
	if effect.is_recording_active():
		recording = effect.get_recording()
		effect.set_recording_active(false)
		$MarginContainer/VBoxContainer/TopButtons/Listen/Label.text = "Record"
	else:
		effect.set_recording_active(true)
		$MarginContainer/VBoxContainer/TopButtons/Listen/Label.text = "Stop"
	pass # Replace with function body.


func _on_Animation_animation_finished():
	speech.text = "Pongoon: Talk to me!"
	var animated = $Control/Character/Penguin/Animation
	animated.play("default")
	pass # Replace with function body.
