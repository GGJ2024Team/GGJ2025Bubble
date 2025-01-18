extends Node2D

var BUBBLE_CD = 10 # second
var last_gen_bubble = 0
func _ready():
    pass # Replace with function body.

func gen_bubble():
    var bubble = load("res://Bubble.tscn").instance()
    bubble.position = self.position - Vector2(0, 200)
    self.get_parent().add_child(bubble, true)
    
func _process(delta):
    if Input.is_action_just_pressed("gen_bubble"):
        gen_bubble()
        
func _physics_process(delta):
    var direction = Vector2.ZERO
    if Input.is_action_pressed("move_right"):
        direction.x += 1
    if Input.is_action_pressed("move_left"):
        direction.x -= 1
    self.position += direction*10
