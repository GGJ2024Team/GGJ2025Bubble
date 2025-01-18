extends Node2D

var screen_size = Vector2(750, 1624)
var direction = Vector2(0, 1)
var speed = 10
var score = 10
var in_fan_range = false

signal bubble_gen(score)
signal bubble_die(score)


func _ready():
    var ui = get_tree().get_root().get_node("Game/UI")
    connect("bubble_gen", ui, "update_score")
    connect("bubble_die", ui, "update_score")
    emit_signal("bubble_gen", score)
    
func _process(delta):
    var node_position = global_position  
    if position.x < 0 or position.x > screen_size.x or position.y < 0 or position.y > screen_size.y:
        emit_signal("bubble_die", -score)
        queue_free()
        
func _physics_process(delta):
    if self.in_fan_range:
        speed = 20
        direction = Vector2(0, -1)
    else:
        speed = 5
        direction = Vector2(0, 1)
    self.position += direction*speed

