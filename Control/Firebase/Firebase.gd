extends Node

const API_KEY := "AIzaSyDihYrRQIy73nyicONA-FoIthHV0888d08"
const PROJECT_ID := "methstack-b68fa"

const REGISTER_URL := "https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=%s" % API_KEY
const LOGIN_URL := "https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=%s" % API_KEY
const FIRESTORE_URL := "https://firestore.googleapis.com/v1/projects/%s/databases/(default)/documents/" % PROJECT_ID
const PASSWORD_RESET_URL := "https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=AIzaSyDihYrRQIy73nyicONA-FoIthHV0888d08" 

var user_info := {}
#var save := {}

func _get_user_info(result: Array) -> Dictionary:
	var result_body := JSON.parse(result[3].get_string_from_ascii()).result as Dictionary
	return {
		"token": result_body.idToken,
		"id": result_body.localId,
		"email": result_body.email
	}
	
func _get_save_info(result: Array) -> Dictionary:
	var result_body := JSON.parse(result[3].get_string_from_ascii()).result as Dictionary
	return {
		"World1": result_body.fields.World1,
		"World2": result_body.fields.World2,
		"World3": result_body.fields.World3,
		"World4": result_body.fields.World4,
		"World5": result_body.fields.World5,
		"World6": result_body.fields.World6,
		"World7": result_body.fields.World7,
		"World8": result_body.fields.World8,
		"World9": result_body.fields.World9,
		"World10": result_body.fields.World10
	}


func _get_request_headers() -> PoolStringArray:
	return PoolStringArray([
		"Content-Type: application/json",
		"Authorization: Bearer %s" % user_info.token
		#"Authorization: Bearer zfCt7yOk8TQ1f7QcPegfnEpDnJf2" 
	])


func register(email: String, password: String, http: HTTPRequest) -> void:
	var body := {
		"email": email,
		"password": password,
	}
	http.request(REGISTER_URL, [], false, HTTPClient.METHOD_POST, to_json(body))
	var result := yield(http, "request_completed") as Array
	if result[1] == 200:
		user_info = _get_user_info(result)


func login(email: String, password: String, http: HTTPRequest) -> void:
	var body := {
		"email": email,
		"password": password,
		"returnSecureToken": true
	}
	http.request(LOGIN_URL, [], false, HTTPClient.METHOD_POST, to_json(body))
	var result := yield(http, "request_completed") as Array
	if result[1] == 200:
		user_info = _get_user_info(result)
	
func reset_pw(email: String, http: HTTPRequest) -> void:
	var body := {
		"requestType":"PASSWORD_RESET",
		"email":email
	}
	http.request(PASSWORD_RESET_URL, [], false, HTTPClient.METHOD_POST, to_json(body))
	var result := yield(http, "request_completed") as Array
	if result[1] == 200:
		print(result)
	else:
		print(result)

func get_save(path: String, http: HTTPRequest) -> void:
	var url := FIRESTORE_URL + path
	http.request(url, _get_request_headers(), false, HTTPClient.METHOD_GET)
	var result := yield(http, "request_completed") as Array
	if result[1] == 200:
		global.save = _get_save_info(result)

func save_document(path: String, fields: Dictionary, http: HTTPRequest) -> void:
	var document := { "fields": fields }
	var body := to_json(document)
	var url := FIRESTORE_URL + path
	http.request(url, _get_request_headers(), false, HTTPClient.METHOD_POST, body)

func get_document(path: String, http: HTTPRequest) -> void:
	var url := FIRESTORE_URL + path
	http.request(url, _get_request_headers(), false, HTTPClient.METHOD_GET)


func update_document(path: String, fields: Dictionary, http: HTTPRequest) -> void:
	var document := { "fields": fields }
	var body := to_json(document)
	var url := FIRESTORE_URL + path
	http.request(url, _get_request_headers(), false, HTTPClient.METHOD_PATCH, body)


func delete_document(path: String, http: HTTPRequest) -> void:
	var url := FIRESTORE_URL + path
	http.request(url, _get_request_headers(), false, HTTPClient.METHOD_DELETE)
	
	#https://firestore.googleapis.com/v1beta1/projects/methstack-b68fa/databases/(default)/documents/users?orderBy=dexterity
