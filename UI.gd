extends CanvasLayer

var score = 0
onready var score_label = $HUD/ColorRect/Score

func _ready():
    print('connect bubblegen')
    connect("bubble_gen", self, "update_score")

func update_score(score_chg):
    score += score_chg
    score_label.text = "SCORE: " + str(score)
