extends Node2D

const BLINK_FREQ = 0.5
var lastBlink: float
var isLoadingGame = false

func _ready():
	$stonk.menuMode = true
	$stonk2.menuMode = true
	$stonk3.menuMode = true



func _process(delta):
	
	if Input.is_action_just_pressed("shoot"):
		get_tree().change_scene("res://map.tscn")
	
	if !isLoadingGame:
		if lastBlink >= BLINK_FREQ: 
			$VBoxContainer/Label3.visible = !$VBoxContainer/Label3.visible
			lastBlink = 0.0
		else: lastBlink += delta
	
	
