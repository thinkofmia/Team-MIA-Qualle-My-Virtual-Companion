extends Node

# Firebase var
onready var http : HTTPRequest = $HTTPRequest
onready var teachers= []
var teacher_info = []
var teacher_display
var getTeachers=false

onready var teacherList = $PlayBoard/ScrollContainer/ListOfTeachers #Set teacher list node
var newButton = load("res://Model/buttons/interface/userButtons.tscn") #Set new button instance

# Called when the node enters the scene tree for the first time.
func _ready():
	global.targetType = "Teacher"#Set Target type as Teacher
	#Firebase func
	getTeachers=true
	#http request get all user profiles
	Firebase.get_document("users", http)
	yield(get_tree().create_timer(5.0), "timeout")
	#get values from user array and put into teacher_info
	teacher_info = (teachers.values())
	#Total Number of Teachers
	var totalNoUsers = teacher_info[0].size()
	#Loop based on No of teachers
	for i in range (0,totalNoUsers):
		#extract users based on i
		teacher_display= (teacher_info[0][i]['fields'])
		#print(str(teacher_display['account'].values()[0]))
		#check if user is a teacher
		if teacher_display['account'].values()[0] == "Teacher":
				#Add new instance
				var addButton = newButton.instance()
				#Change button name to teacher name
				addButton.set_text(str(teacher_display['nickname'].values()[0]))
				#Add quiz button to the list
				teacherList.add_child(addButton)

#Go to select user type scene
func _on_BackButton_pressed():
	get_tree().change_scene("res://View/admin/SelectUserType.tscn")

#Firebase request
func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var response_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	if response_code != 200:
		print(response_body)
		#print("error!")
	elif response_code == 200:
		if getTeachers==true:
			#put dictionary into an array
			self.teachers = response_body
