extends Node2D


var score = 0
onready var score_label = $UI/HUD/ColorRect/Score
onready var http_request = $HTTPRequest

func _ready():
    pass


func update_score(score_chg):
    score += score_chg
    score_label.text = "SCORE: " + str(score)
    on_game_end()

func on_game_end():
    print("on_game_end()")
    var url = "http://127.0.0.1:8080/scoreboard/info"
    var result = http_request.request(url)
    if result != OK:
        print("Failed to request URL:", url)
    http_request.connect("request_completed", self, "_on_request_completed")

func _on_request_completed(result, response_code, headers, body):
    if response_code == 200:
        print("Response:", body.get_string_from_utf8().substr(0, 100))
    else:
        print("Request failed with response code:", response_code)

    
