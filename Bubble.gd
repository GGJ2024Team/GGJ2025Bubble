extends RigidBody2D

var screen_size = Vector2(750, 1624)
var direction = Vector2(0, 1)
var speed = 10
var score = 10
var in_fan_range = false
var bubble_strength = 1000

signal bubble_gen(score)
signal bubble_die(score)


func _ready():
    var game = get_tree().get_root().get_node("Game")
    connect("bubble_gen", game, "update_score")
    connect("bubble_die", game, "update_score")
    emit_signal("bubble_gen", score)
    add_to_group("bubble")
    
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

func _integrate_forces(state):
    # 检测和处理挤压效果
    for body in get_colliding_bodies():
        if body.is_in_group("bubbles"):
            var direction = (body.position - position).normalized()
            # 计算推力
            var force = direction * bubble_strength
            add_force(force, Vector2(0, -1))
