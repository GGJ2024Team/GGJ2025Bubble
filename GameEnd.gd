extends Control


var PASSWORD = "98954740257108"
var URL_BASE = "http://146.190.117.12:8080"

onready var http_request = $HTTPRequest
onready var score_board_label = $ColorRect/Scoreboard

func _ready():
    get_scoreboard()

func get_scoreboard():
    var url = URL_BASE + "/scoreboard/info"
    var params = "?password=" + PASSWORD
    http_request.timeout = 3.0  # 秒
    var result = http_request.request(url + params)
    if result != OK:
        print("Failed to request URL:", url)
    http_request.connect("request_completed", self, "_on_request_completed")


func parse(json_string):
    var scoreboard = JSON.parse(json_string)
    scoreboard = scoreboard.get_result()
    var scoreboard_text = "==========\nScoreBOARD\n"
    var rank = 1
    for item in scoreboard:
        scoreboard_text += "(" + str(rank) + ")" + " " + item[0].substr(0, 5) + " : " + str(item[1]) + "\n"
        rank += 1
    score_board_label.text = scoreboard_text
    return scoreboard
    
func _on_request_completed(result, response_code, headers, body):
    if response_code == 200:
        print("Response:", body.get_string_from_utf8().substr(0, 1000))
        parse(body.get_string_from_utf8())
    else:
        print("Request failed with response code:", response_code)
