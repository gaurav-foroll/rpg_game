extends KinematicBody2D

const Death = preload("res://Effects/Deffect.tscn")
const heart  = preload("res://UI/pickable_Heart.tscn")


export var ACC = 300
export var max_speed = 50
export var fric = 200
export var wander_target_range = 3

enum{
	idle,
	wander,
	chase
}


onready var velocity = Vector2.ZERO
onready var normivel =Vector2.ZERO
onready var knockback = Vector2.ZERO
onready var sprite = $AnimatedSprite
onready var stats = $stats
onready var player_detection = $player_detection
onready var hurtbox = $hurt
onready var softcollision = $softcollision 
onready var wandercontroller = $wandercontroller 
onready var health_bar =$HealthBar
onready var animationplayer = $AnimationPlayer
onready var animationtree = $AnimationTree
onready var animationstate = animationtree.get("parameters/playback")

var state = chase

func _ready():
	randomize()
	animationtree.active = true
	state = pick_random_state([idle,wander])

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO , 200*delta)
	knockback = move_and_slide(knockback)
	
	match state:
		idle:
			animationstate.travel('Idle')
			velocity = velocity.move_toward(Vector2.ZERO, fric * delta)
			seek()
			if wandercontroller.get_time_left() ==0:
				update_wander()
				
		wander:
			seek()
			if wandercontroller.get_time_left() == 0:
				update_wander()
			animationtree.set("parameters/Walking/blend_position",normivel)
			animationstate.travel('Walking')
			acc_towards(wandercontroller.target_position, delta)
			
			if global_position.distance_to(wandercontroller.target_position) <= wander_target_range :
				update_wander()
		
		chase:
			var player = player_detection.isplayer
			if player != null :
				animationstate.travel('Walking')
				acc_towards(player.global_position , delta)
			else:
				state = idle
		
	
	if softcollision.is_colliding():
		velocity += softcollision.get_push_vector() * delta * 400
	velocity =  move_and_slide(velocity)

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()


func update_wander():
	state= pick_random_state([idle,wander])
	wandercontroller.start_wander_timer(rand_range(1,3))


func acc_towards(point, delta):
	var direction = global_position.direction_to(point)
	velocity =  velocity.move_toward(direction * max_speed, ACC *delta)
	normivel = velocity.normalized()
	print(normivel)
	animationtree.set("parameters/Walking/blend_position",normivel)
	animationstate.travel('Walking')
	#sprite.flip_h = velocity.x < 0


func seek():
	if player_detection.can_see_player():
		state = chase


func _on_hurt_area_entered(area):
	stats.health -= 10
	health_bar.no_effect(stats.health)
	print(stats.health)
	knockback = area.knockback_vector * 120
	hurtbox.create_hit_effect()


func _on_stats_no_health():
	queue_free()
	var enemy = Death.instance()
	get_parent().add_child(enemy)
	enemy.global_position = global_position
	var des = randi()%3
	print(des)
	if not des:
		var heart_instance = heart.instance()
		heart_instance.position = global_position
		get_parent().add_child(heart_instance)


