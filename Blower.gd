extends Node2D

# export(NodePath) var Fan: NodePath = "Fan"
onready var wind_force_area = get_node("Fan")

var wind_strength: float = 100.0
var target_rotation: float = 0.0
var rotation_speed: float = 5.0 # 控制旋转速度

func _ready():
    if not wind_force_area:
        print("Error: Could not find the wind force area node.")
    else:
        print("Wind force area node found:", wind_force_area.name)

func _process(delta):
    var mouse_pos = get_global_mouse_position()
    var local_mouse_pos = to_local(mouse_pos)
    
    # 使用 atan2 计算目标角度
    var target_angle = atan2(local_mouse_pos.y, local_mouse_pos.x)
    
    # 平滑旋转到目标角度
    target_rotation = lerp(rotation, target_angle, delta * rotation_speed)
    rotation = target_rotation
