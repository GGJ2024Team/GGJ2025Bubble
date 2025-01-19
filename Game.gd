extends Node2D

var game_started = false
var score = 0
var max_score = 0
var wind_dir = Vector2.ZERO
var wind_speed = 0
var username = "unknow_user"

var PASSWORD = "98954740257108"
var URL_BASE = "http://146.190.117.12:8080"

onready var score_label = $UI/HUD/ColorRect/Score
onready var http_request = $HTTPRequest
onready var wind_timer = $WindTimer
onready var line_edit = $UI/GetNameRect/Label/LineEdit
onready var character = $Character
onready var get_name_rect = $UI/GetNameRect

signal return_to_main_menu
signal game_restart

func _ready():
    connect("return_to_main_menu", get_parent(), "load_main_menu")
    connect("game_restart", get_parent(), "load_game")
    start_random_timer()

func update_score(score_chg):
    score += score_chg
    score_label.text = "SCORE: " + str(score) + " " + "| MAX SCORE: " + str(max_score)
    max_score = max(max_score, score)
    if not game_started and score > 0:
        game_started = true
    if game_started and score <= 0:
        on_game_end()

func on_game_end():
    print("on_game_end()")
    var url = URL_BASE + "/scoreboard/update"
    var params = "?password=" + PASSWORD + "&username=" + username + "&score=" + str(max_score)
    http_request.timeout = 3.0  # 秒
    var result = http_request.request(url + params)
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
        print("Response:", body.get_string_from_utf8().substr(0, 1000))
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
    if randi()%100 <= 100:
        wind_dir = get_random_direction()
        wind_speed = randi()%3 + 3

func get_random_direction() -> Vector2:
    var angle = randf()*3.1415926*2
    return Vector2(cos(angle), sin(angle)).normalized()

func _on_WindTimer_timeout():
    wind_dir = Vector2.ZERO
    wind_speed = 0
    random_wind()
    start_random_timer()

func _on_OKButton_pressed():
    if line_edit.text != "":
        character.enable_gen_bubble = true
        username = line_edit.text
        get_name_rect.queue_free()
