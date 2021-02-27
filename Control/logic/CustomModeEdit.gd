extends Node

#Variables
var totalQn = 1 #Total No of Qn
onready var newQnSet = load("res://View/util/customQuestionSet.tscn") #Sets Merged scene as custom Qn Set
onready var qnList = $PlayBoard/Container/QnList #Get qn list node
var id = "" #Var to store quiz id

#Firebase var
var getQuiz = false
var existQuiz = false
var getQns = false
var saveQuiz = false
var newQuiz = false
var quizDatabase = "Custom"
var qns
var qns_display
var qns_info
var numLoadedQns=0
var q

onready var http : HTTPRequest = $HTTPRequest
onready var quizName : LineEdit = $PlayBoard/TitleRow/LineEdit2
onready var Id : LineEdit = $PlayBoard/IDRow/LineEdit2

var Question := {
	"QuestionText":{},
	"Option1":{},
	"Option2":{},
	"Option3":{},
	"Option4":{},
	"Ans":{}
}
onready var Quiz := {
	"Creator": {},
	"Date": {},
	"Id":{},
	"NumQns":{},
	"QuizName":{},
	"World":{}
}setget set_Quiz

# Called when the node enters the scene tree for the first time.
func _ready():
	hideButtons()
	#Performance Test
	if (testPerformance.performanceCheck):
		testPerformance.startTime()
	$PlayBoard.hide() #Hide on startup
	totalQn = 0 #Get total number of qns here
	$ConfirmButton/Label.set_text("Save") #Replace Edit Button with Confirm Button
	newQnSet 
	
	getQuiz = true
	quizName.text=global.customTitle
	#check if the user is creating a new quiz or editing an existing quiz
	if global.customTitle != "":
		#http request to get quiz
		Firebase.get_document("CustomQuiz/%s"%global.customTitle, http)
		yield(get_tree().create_timer(2), "timeout")
	if existQuiz == true:
		quizDatabase+global.customTitle
		getQns = true
		#http request to get questions
		Firebase.get_document("Custom%s"%global.customTitle, http)
		yield(get_tree().create_timer(2), "timeout")
		#get values from questions array and put into question_info
		qns_info = (qns.values())
		numLoadedQns = qns_info[0].size()
		#for each questions in the array
		for i in range(0,qns_info[0].size()):
			#Add new instance
			var addQn = newQnSet.instance()
			#Change Question Name with its number
			addQn.get_child(0).get_child(0).set_text("Qn #"+str(i+1)+": ")
			addQn.get_child(7).hide() #Hide difficulty row
			#Add qn to the list
			qnList.add_child(addQn)
			var qnSet = qnList.get_child(i)
			#extract question attribute based on i
			qns_display= (qns_info[0][i]['fields'])
			qnSet.get_child(0).get_child(1).set_text(str(qns_display['QuestionText'].values()[0])) #Qn Title
			qnSet.get_child(1).get_child(1).set_text(str(qns_display['Option1'].values()[0])) #Option 1
			qnSet.get_child(2).get_child(1).set_text(str(qns_display['Option2'].values()[0])) #Option 2
			qnSet.get_child(3).get_child(1).set_text(str(qns_display['Option3'].values()[0])) #Option 3
			qnSet.get_child(4).get_child(1).set_text(str(qns_display['Option4'].values()[0])) #Option 4
			qnSet.get_child(5).get_child(1).set_text(str(qns_display['Ans'].values()[0])) #Ans
			#Check if explanation exists
			var includeExplanation = false
			for key in qns_display:
				if (key=="Explanation"):
					includeExplanation = true
				
			if (!includeExplanation):
				qnSet.get_child(6).get_child(1).set_text("") #Explanation
			else:
				qnSet.get_child(6).get_child(1).set_text(str(qns_display['Explanation'].values()[0])) #Explanation
			
		totalQn = qns_info[0].size()
	else: #If Quiz is new
		_on_AddButton_pressed()
	$PlayBoard.show() #Show after loading
	
	#Performance Test
	if (testPerformance.performanceCheck):
		print("Performance Test: Custom Mode Edit Display")
		testPerformance.getTimeTaken()
	showButtons()

func _on_BackButton_pressed(): #Exit Scene
	get_tree().change_scene("res://View/gameModes/CustomModeMyQuizzes.tscn")

func _on_AddButton_pressed(): #Add new Qn 
	totalQn +=1
	#Add new instance
	var addQn = newQnSet.instance()
	#Change Question Name with its number
	addQn.get_child(0).get_child(0).set_text("Qn #"+str(totalQn)+": ")
	addQn.get_child(7).hide() #Hide difficulty section
	#Add qn to the list
	qnList.add_child(addQn)

#Hide all buttons
func hideButtons():
	$BackButton.hide()
	$AddButton.hide()
	$ConfirmButton.hide()

#Show all buttons
func showButtons():
	$BackButton.show()
	$AddButton.show()
	$ConfirmButton.show()

func _on_ConfirmButton_pressed(): #Save Quiz
	#Performance Test
	if (testPerformance.performanceCheck):
		testPerformance.startTime()
	#Show Pop up, hide buttons
	$PopUpControl.show()#Display confirmation msg
	hideButtons()
	#
	var name = $PlayBoard/TitleRow/LineEdit2.get_text() #Quiz Title
	print("Quiz Name: "+str(name)+" Total Qn: "+str(totalQn)) #Quiz Name and Total Qns
	var date = str(OS.get_date().day)+"/"+str(OS.get_date().month)+"/"+str(OS.get_date().year) #Date of Creation/Update - Hard code for now
	var worlds = "Custom" #Worlds involved - Hard code for now (Probably might be removed)
	id = $PlayBoard/IDRow/LineEdit2.get_text() #Get quiz id
	var username = global.username #Creator's name
	var qnNum=totalQn
	var format_string
	var actual_string 
	var start
	#check if the user is creating a new quiz or editing an existing quiz
	if existQuiz==false:
		#if false
		#set Quiz attributes
		Quiz.Creator={"stringValue":username}
		Quiz.Date={"stringValue":str(date)}
		Quiz.Id={"stringValue":str(id)}
		Quiz.NumQns={"stringValue":str(totalQn+1)}
		Quiz.QuizName={"stringValue":name}
		Quiz.World={"stringValue":worlds}
		#http request to save Quiz
		Firebase.save_document("CustomQuiz?documentId=%s"%str(name),Quiz, http)
		yield(get_tree().create_timer(2.0), "timeout")
		start=1
	else:
		#if true
		for i in range(1,numLoadedQns+1): #Loop For Number of Qn Loaded
			var qnSet = qnList.get_child(i-1) #Save as qn set
			var qnTitle = qnSet.get_child(0).get_child(1).get_text() #Qn Title
			var option1 = qnSet.get_child(1).get_child(1).get_text() #Option 1
			var option2 = qnSet.get_child(2).get_child(1).get_text() #Option 2
			var option3 = qnSet.get_child(3).get_child(1).get_text() #Option 3
			var option4 = qnSet.get_child(4).get_child(1).get_text() #Option 4
			var ans = qnSet.get_child(5).get_child(1).get_text() #Ans
			var explanation = qnSet.get_child(6).get_child(1).get_text() #Explanation
			#Set Question attributes
			Question.QuestionText={"stringValue": qnTitle}
			Question.Option1={"stringValue": option1}
			Question.Option2={"stringValue": option2}
			Question.Option3={"stringValue": option3}
			Question.Option4={"stringValue": option4}
			Question.Ans={"integerValue": int(ans)}
			Question.Explanation={"stringValue": explanation}
			format_string = "%s?documentId=%s"
			actual_string = format_string % ["Custom"+str(id),str(qnNum)]
			#http request to update the questions
			Firebase.update_document(actual_string, Question, http)
			yield(get_tree().create_timer(2.0), "timeout")
			qnNum+=1
			start=numLoadedQns+1
	
	#print("Quiz ID: "+str(id)+" Created By: "+str(username)) #Print quiz ID
	#print(" ")
	q=totalQn
	for i in range(start,totalQn+1): #Loop For Total Number of Qn Or Remaining Qn
		var qnSet = qnList.get_child(i-1) #Save as qn set
		var qnTitle = qnSet.get_child(0).get_child(1).get_text() #Qn Title
		#skip if question title is empty 
		if qnTitle == "":
			q-=1
			continue
		var option1 = qnSet.get_child(1).get_child(1).get_text() #Option 1
		var option2 = qnSet.get_child(2).get_child(1).get_text() #Option 2
		var option3 = qnSet.get_child(3).get_child(1).get_text() #Option 3
		var option4 = qnSet.get_child(4).get_child(1).get_text() #Option 4
		var ans = qnSet.get_child(5).get_child(1).get_text() #Ans
		var explanation = qnSet.get_child(6).get_child(1).get_text() #Option 1
		#Set Question attributes
		Question.QuestionText={"stringValue": qnTitle}
		Question.Option1={"stringValue": option1}
		Question.Option2={"stringValue": option2}
		Question.Option3={"stringValue": option3}
		Question.Option4={"stringValue": option4}
		Question.Ans={"stringValue": ans}
		Question.Explanation={"stringValue": explanation}
		#format http request string
		format_string = "%s?documentId=%s"
		actual_string = format_string % ["Custom"+str(name),str(qnNum)]
		#http request to save the question
		Firebase.save_document(actual_string, Question, http)
		yield(get_tree().create_timer(2.0), "timeout")
		qnNum+=1
		
		#For Debugging and getting each vars
		#print("Q"+str(i)+": "+str(qnTitle)) #Print Qn No and Text
		#print(">Options: ["+str(option1)+", "+str(option2)+", "+str(option3)+", "+str(option4)+"]") #Print options 
		#print(">Ans: "+str(ans)) #Print correct ans
		#print(">Explanation: "+str(explanation)) #Print correct ans
		#print(" ")
	#Performance Test
	if (testPerformance.performanceCheck):
		print("Performance Test: Custom Mode Edit Quiz Saved")
		testPerformance.getTimeTaken()

		Quiz.NumQns={"stringValue":str(q)}
		Firebase.update_document("CustomQuiz/%s"%str(name),Quiz, http)
	
	#Returns to my list
	yield(get_tree().create_timer(2.0), "timeout")
	_on_BackButton_pressed()

#Set quiz values	
func set_Quiz(value: Dictionary) -> void:
	Quiz=value
	Id.text = str(Quiz.Id.stringValue)

#HTTP Request
func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	print(result_body)
	print(response_code)
	match response_code:
		#error
		404:
			return
		#success
		200:
			if getQuiz==true:
				self.Quiz = result_body.fields
				getQuiz=false
				existQuiz=true
			if getQns == true:
				qns=result_body
