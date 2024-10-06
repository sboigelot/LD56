extends Area2D 

@export var custom_gravity:float = 200.0
@export var speed:float = 350.0

var screen_size:Vector2

func _ready():
	screen_size = get_viewport_rect().size
	
func _physics_process(delta: float) -> void:
	var velocity = Vector2.ZERO # The player's movement vector.
	#if Input.is_action_pressed("move_right"):
		#velocity.x += 1
	#if Input.is_action_pressed("move_left"):
		#velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		#$AnimatedSprite2D.play()
	else:
		#$AnimatedSprite2D.stop()
		pass
	velocity += Vector2(0.0, custom_gravity)
	
	#$AnimatedSprite2D.flip_h = velocity.x < 0
	if velocity.y <= 0:
		rotation_degrees = -20.0
	else:
		rotation_degrees = 0.0
	
	position += velocity * delta
	position = position.clamp(-screen_size/2.0, screen_size/2.0)
