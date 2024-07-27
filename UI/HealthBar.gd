extends Node2D

onready var under = $under
onready var over = $Over
onready var tween = $under/Tween

export (float , 0 , 100, 0.05) var Caution_zone = 50.0
export (float , 0 , 100, 0.05) var danger_zone = 20.0

var enemy
var player

func _ready():
	enemy = "bat" in get_parent().name 
	player = "player" in get_parent().name
	if enemy:
		over.tint_progress = Color.purple
	if not enemy and not player:
		over.tint_progress = Color.red

func set_health(value):
	over.value = value
	_assign_color(value)
	tween.interpolate_property(under,'value',under.value,value,0.4,Tween.TRANS_SINE)
	tween.start()


func _assign_color(value):
	if value < danger_zone:
		over.tint_progress = Color.red
	elif value < Caution_zone:
		over.tint_progress = Color.yellow
	else:
		over.tint_progress = Color.yellowgreen

func no_effect(value):
	over.value = value
	if not enemy:
		_assign_color(value)
	under.value = value
	
