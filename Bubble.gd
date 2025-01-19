extends RigidBody2D

var screen_size = Vector2(750, 1624)
var direction = Vector2(0, 1)
var speed = 10
var score = 10
var in_fan_range = false
var bubble_strength = 1000
var is_merged = false
var scale_factor = 1
var color = ""
var blower_node :Node2D = null


var color_map = {
    "white": Color(1, 1, 1, 0.75),
    "red": Color(1, 0, 0, 0.75),
    "green": Color(0, 1, 0, 0.75),
    "blue": Color(0, 0, 1, 0.75)
   }

onready var sprite = $Sprite
onready var area2d = $Area2D
onready var coll2d = $CollisionShape2D
var bubble_sound = preload("res://assets/bubble-sound-43207.mp3")


signal bubble_gen(score)
signal bubble_die(score)

func _ready():
    play_bubble_sound()
    if color == "":
        color = get_random_color()
    sprite.modulate = color_map[color]
    var game = get_tree().get_root().get_node("GameControl/Game")
    connect("bubble_gen", game, "update_score")
    connect("bubble_die", game, "update_score")
    emit_signal("bubble_gen", score)
    add_to_group("bubble")
    load_blower_node()
    if scale_factor > 4:
        die()
    else:
        sprite.scale = Vector2(1, 1)*scale_factor
        area2d.scale = Vector2(1, 1)*scale_factor
        coll2d.scale = Vector2(1, 1)*scale_factor
        
func load_blower_node():
    if not blower_node:
        blower_node = get_tree().get_root().get_node("GameControl/Game/Character/Blower")
        if not blower_node:
            print("警告：未能找到 Blower 节点")
    
func _process(delta):
    var node_position = global_position  
    if position.x < 0 or position.x > screen_size.x or position.y < 0 or position.y > screen_size.y:
        die()

func get_random_color():
    var color_keys = color_map.keys()
    var random_index = randi() % color_keys.size()
    return color_keys[random_index]
    
func bubble_scale(factor):
    scale_factor = factor
    
func die():
    emit_signal("bubble_die", -score)
    queue_free()

func _physics_process(delta):
    # 判断风向
    var blower_node_position
    if blower_node:
        blower_node_position = blower_node.global_transform.get_rotation() + deg2rad(45)
    # else:
    #     blower_node_position = Vector2.ZERO
        
    if self.in_fan_range:
        speed = 20
        direction = Vector2(0, -1).rotated(blower_node_position)
    else:
        speed = 5
        direction = Vector2(0, 1)
        
    self.apply_central_impulse(direction * speed)

    # 泡泡的左右上下边缘横坐标
    var booble_left_position_x = global_position.x - scale_factor / 2
    var booble_right_position_x = global_position.x + scale_factor / 2
    var booble_top_position_y = global_position.y - scale_factor / 2
    var booble_bottom_position_y = global_position.y + scale_factor / 2
    # 检查是否超出屏幕边界
    if booble_left_position_x  < 0 or booble_right_position_x > screen_size.x:
        # 碰到左右边缘反弹
        direction.x *= -0.8

    if booble_top_position_y < 0:
        # 碰到顶部边缘反弹
        direction.y *= -0.8


    # 更新位置
    self.position += direction * speed
    
func _integrate_forces(state):
    # 检测和处理挤压效果
    for body in get_colliding_bodies():
        if body.is_in_group("bubbles"):
            var direction = (body.position - position).normalized()
            # 计算推力
            var force = direction * bubble_strength
            add_force(force, Vector2(0, -1))

func can_merge(other_bubble):
    return (other_bubble.is_in_group("bubble") 
        and not is_merged 
        and not other_bubble.is_merged 
        and scale_factor == other_bubble.scale_factor 
        and color == other_bubble.color
        )
    
func merge_with(other_bubble):
    is_merged = true
    other_bubble.is_merged = true
    var new_position = (position + other_bubble.position) / 2
    var merged_bubble = load("res://Bubble.tscn").instance()
    merged_bubble.position = new_position
    merged_bubble.bubble_scale(scale_factor*2)
    merged_bubble.color = color
    merged_bubble.score = score + other_bubble.score
    get_parent().add_child(merged_bubble)
    other_bubble.die()  # 销毁与其合并的气泡
    die()

func _on_Area2D_area_entered(area):
    var obj = area.get_parent()
    if can_merge(obj):
        merge_with(obj)

func play_bubble_sound():
    var audio_player = AudioStreamPlayer.new()
    add_child(audio_player)
    bubble_sound.loop = false
    audio_player.stream = bubble_sound 
    audio_player.play() 
    audio_player.connect("finished", audio_player, "queue_free")  # 播放结束后自动释放播放器
