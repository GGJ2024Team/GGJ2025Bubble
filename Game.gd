extends Node2D

var game_started = false
var score = 0
var wind_dir = Vector2.ZERO
var wind_speed = 0

onready var score_label = $UI/HUD/ColorRect/Score
onready var http_request = $HTTPRequest
onready var wind_timer = $WindTimer

signal return_to_main_menu
signal game_restart

func _ready():
    connect("return_to_main_menu", get_parent(), "load_main_menu")
    connect("game_restart", get_parent(), "load_game")
    start_random_timer()
    
func update_score(score_chg):
    score += score_chg
    score_label.text = "SCORE: " + str(score)
    if not game_started and score > 0:
        game_started = true
    if game_started and score <= 0:
        on_game_end()

func on_game_end():
    print("on_game_end()")
    var url = "http://127.0.0.1:8080/scoreboard/info"
    var result = http_request.request(url)
    if result != OK:
        print("Failed to request URL:", url)
    http_request.connect("request_completed", self, "_on_request_completed")
    get_node("Character").queue_free()
    var game_end = load("res://GameEnd.tscn").instance()
    var return_button = game_end.get_node("ColorRect/Return")
    var restart_button = game_end.get_node("ColorRect/Restart")
    get_node("UI").add_child(game_end)
    return_button.connect("pressed", self, "on_return")
    restart_button.connect("pressed", self, "on_restart")
    

func _on_request_completed(result, response_code, headers, body):
    if response_code == 200:
        print("Response:", body.get_string_from_utf8().substr(0, 100))
    else:
        print("Request failed with response code:", response_code)

func on_return():
    emit_signal("return_to_main_menu")
    queue_free()
    
func on_restart():
    emit_signal("game_restart")
    
func wind():
    var wind_gust = load("res://WindGust.tscn")
    add_child(wind_gust)
    
func start_random_timer():
    var random_time = randi()%3 + 1
    wind_timer.wait_time = random_time
    wind_timer.start()

func random_wind():
    print("random wind")
    if randi()%100 <= 100:
        wind_dir =  Vector2(rand_dir_num(), rand_dir_num())
        wind_speed = randi()%3
    print(wind_dir)
    
func rand_dir_num():
    return randi()%2 - 1
    
func _on_WindTimer_timeout():
    random_wind()
    start_random_timer()
