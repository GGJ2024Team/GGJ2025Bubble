extends Node

var game_scene
func _ready():
    load_main_menu()
    
func load_main_menu():
    var main_menu = load("res://MainMenu.tscn").instance()
    add_child(main_menu)
    var new_game = get_node("MainMenu/MarginContainer/VBoxContainer/Newgame")
    var quit = get_node("MainMenu/MarginContainer/VBoxContainer/Quit")
    new_game.connect("pressed", self, "on_new_game_pressed")
    quit.connect("pressed", self, "on_quit_pressed")

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
