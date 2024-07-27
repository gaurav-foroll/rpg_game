extends Position2D

var velocity :Vector2=Vector2()
var direction : Vector2=Vector2()
signal relay()


func _ready():
	set_physics_process(false)

func read_input(delta):
	if Input.is_action_pressed("ui_up"):
		position.y-=1
		direction=Vector2(0,-1)
	if Input.is_action_pressed("ui_down"):
		position.y+=1
		direction=Vector2(0,1)
	if Input.is_action_pressed("ui_left"):
		position.x-=1
		direction=Vector2(-1,0)
	if Input.is_action_pressed("ui_right"):
		position.x+=1
		direction=Vector2(1,0)
	if Input.is_action_just_pressed("place_Clone"):
		set_physics_process(false)
		emit_signal("relay")
		#emit_signal("create_clone",$Position2D.global_position)
	
func _physics_process(delta):
	read_input(delta)
