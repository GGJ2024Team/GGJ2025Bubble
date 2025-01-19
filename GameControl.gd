extends Node

var game_scene
func _ready():
    load_main_menu()
    
func load_main_menu():
    var main_menu = load("res://MainMenu.tscn").instance()
    add_child(main_menu)
    var new_game = get_node("MainMenu/MarginContainer/VBoxContainer/Newgame")
    var quit = get_node("MainMenu/MarginContainer/VBoxContainer/Quit")
    var scoreboard = get_node("MainMenu/MarginContainer/VBoxContainer/Scoreboard")
    
    new_game.connect("pressed", self, "on_new_game_pressed")
    quit.connect("pressed", self, "on_quit_pressed")
    scoreboard.connect("pressed", self, "on_scoreboard_pressed")

func load_game():
    if is_instance_valid(game_scene):
        game_scene.name = "GameRemoved"
        game_scene.queue_free()
    game_scene = load("res://Game.tscn").instance()
    add_child(game_scene)
   
func on_new_game_pressed():
    get_node("MainMenu").queue_free()
    load_game()
    
func on_quit_pressed():
    get_tree().quit()

func on_scoreboard_pressed():
    var scoreboard = load("res://GameEnd.tscn").instance()
    var color_ret = scoreboard.get_node("ColorRect")
    var label = scoreboard.get_node("ColorRect/Label")
    var restart = scoreboard.get_node("ColorRect/Restart")
    var return_button = scoreboard.get_node("ColorRect/Return")
    color_ret.remove_child(label)
    color_ret.remove_child(restart)
    add_child(scoreboard)
    return_button.connect("pressed", self, "on_return")
    
func on_return():
    get_node("GameEnd").queue_free()
