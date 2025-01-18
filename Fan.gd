extends Node2D

onready var animation = $AnimationPlayer

func _ready():
    animation.play("wind")

func _on_Area2D_area_entered(area):
    if is_instance_valid(area):
        var bubble = area.get_parent()
        if not bubble.in_fan_range:
            bubble.in_fan_range = true


func _on_Area2D_area_exited(area):
    if is_instance_valid(area):
        var bubble = area.get_parent()
        if bubble.in_fan_range:
            bubble.in_fan_range = false
