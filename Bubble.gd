extends RigidBody2D

var screen_size = Vector2(750, 1624)
var direction = Vector2(0, 1)
var speed = 10
var score = 10
var in_fan_range = false
var bubble_strength = 1000
var is_merged = false
var scale_factor = 1

onready var sprite = $AnimatedSprite
onready var area2d = $Area2D
onready var coll2d = $CollisionShape2D

signal bubble_gen(score)
signal bubble_die(score)

func _ready():
    var game = get_tree().get_root().get_node("Game")
    connect("bubble_gen", game, "update_score")
    connect("bubble_die", game, "update_score")
    emit_signal("bubble_gen", score)
    add_to_group("bubble")
    sprite.scale = Vector2(1, 1)*scale_factor
    if scale_factor > 4:
        die()
    
func _process(delta):
    var node_position = global_position  
    if position.x < 0 or position.x > screen_size.x or position.y < 0 or position.y > screen_size.y:
        die()

func bubble_scale(factor):
    scale_factor = factor
    
func die():
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

func can_merge(other_bubble):
    return other_bubble.is_in_group("bubble") and not is_merged and not other_bubble.is_merged and scale_factor == other_bubble.scale_factor
    
func merge_with(other_bubble):
    is_merged = true
    other_bubble.is_merged = true
    var new_position = (position + other_bubble.position) / 2
    var merged_bubble = load("res://Bubble.tscn").instance()
    merged_bubble.position = new_position
    merged_bubble.bubble_scale(scale_factor*2)
    get_parent().add_child(merged_bubble)
    other_bubble.die()  # 销毁与其合并的气泡
    die()

func _on_Area2D_area_entered(area):
    var obj = area.get_parent()
    if can_merge(obj):
        merge_with(obj)
