extends Node2D

var BUBBLE_CD = 10 # second
var last_gen_bubble = 0
var character_width = 100 # 角色宽度

var screen_rect: Rect2
onready var sprite = $Sprite

func _ready():
    # 初始化屏幕尺寸，假设你希望基于窗口大小来限制
    screen_rect = Rect2(Vector2.ZERO, get_viewport().get_visible_rect().size)
    

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
    # 计算新的位置
    var new_position = self.position + direction * 10
    
    # 检查并修正新位置以确保其不超出屏幕边界
    new_position.x = clamp(new_position.x, screen_rect.position.x + character_width, screen_rect.end.x - character_width)
    
    # 更新角色位置
    self.position = new_position
