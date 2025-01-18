extends Node

var game_scene
func _ready():
    var new_game = get_node("MainMenu/MarginContainer/VBoxContainer/Newgame")
    var quit = get_node("MainMenu/MarginContainer/VBoxContainer/Quit")
    new_game.connect("pressed", self, "on_new_game_pressed")
    quit.connect("pressed", self, "on_quit_pressed")

func on_new_game_pressed():
    get_node("MainMenu").queue_free()
    game_scene = load("res://Game.tscn").instance()
#    game_scene.connect("game_finished", self, "unload_game")
#    game_scene.connect("game_restart", self, "restart_game")
    add_child(game_scene)
    
func on_quit_pressed():
    get_tree().quit()
