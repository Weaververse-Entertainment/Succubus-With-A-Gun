extends KinematicBody2D

var velocity = Vector2(0,0)
var dir = 1
var wj_dir = -1
var dj = false
var SPEED = 250
var JUMPFORCE = -750
const GRAVITY = 25

func get_dir():
	if dir > 0:
		return "r"
	if dir < 0:
		return "l"

func _physics_process(_delta):
	if Input.is_action_pressed("run"):
		SPEED = 500
		JUMPFORCE = -1000
	else:
		SPEED = 250
		JUMPFORCE = -750
	
	if Input.is_action_pressed("right"):
		velocity.x = SPEED
		dir = 1
		$Sprite.play(get_dir() + "run")
	elif Input.is_action_pressed("left"):
		velocity.x = -SPEED
		dir = -1
		$Sprite.play(get_dir() + "run")
	else: $Sprite.play(get_dir() + "idle")
		
	if not is_on_floor():
		if velocity.y < 0:
			if dj:
				$Sprite.play(get_dir() + "dj")
			else:
				$Sprite.play(get_dir() + "jump")
		if velocity.y >= 0: $Sprite.play(get_dir() + "fall")
	
	if Input.is_action_pressed("duck"): pass  # not implemented yet
	
	velocity.y += GRAVITY
	
	if Input.is_action_just_pressed("jump"):
		if not is_on_floor() and not dj and not is_on_wall():
			dj = true
			velocity.y = JUMPFORCE
		elif is_on_floor():
			velocity.y = JUMPFORCE
	
	if is_on_floor():
		dj = false
		wj_dir = -dir
	
	if is_on_wall():
		if Input.is_action_just_pressed("jump") and dir != wj_dir:
			velocity.y = JUMPFORCE/1.5
			wj_dir = dir
		if velocity.y > 0:
			velocity.y = 100
			$Sprite.play(get_dir() + "wj")
		dj = false
	
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity.x = lerp(velocity.x, 0, 0.2)
