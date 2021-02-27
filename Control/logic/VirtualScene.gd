extends Control

# Variables
var effect
var recording

# Called when the node enters the scene tree for the first time.
func _ready():
	# We get the index of the "Record" bus.
	var idx = AudioServer.get_bus_index("Record")
	# And use it to retrieve its first effect, which has been defined
	# as an "AudioEffectRecord" resource.
	effect = AudioServer.get_bus_effect(idx, 0)
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
	$Control/TextContainer/TextEdit.text = "Penguin: Talk to me!"
	var animated = $Control/Character/Penguin/Animation
	animated.play("default")
	pass # Replace with function body.


func _on_Play_pressed():
	print(recording)
	print(recording.format)
	print(recording.mix_rate)
	print(recording.stereo)
	var data = recording.get_data()
	print(data)
	print(data.size())
	$AudioStreamPlayer.stream = recording
	$AudioStreamPlayer.play()
	$Control/TextContainer/TextEdit.text = "Penguin: Am blushing~"
	var animated = $Control/Character/Penguin/Animation
	animated.play("blushing")
	pass # Replace with function body.
