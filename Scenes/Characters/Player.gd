extends KinematicBody2D

var _speed = 30
var _velocity = Vector2()
var _MaxHP = 10
var _currentHP = 1

enum {
	Idle
	Run 
	Attack
	Die
	Staggered
}

var _state = Idle

func _ready():
	_currentHP = _currentHP

func _physics_process(delta):
	
	if _state != Attack && Staggered:
		move()
		$AttackArea/CollisionShape2D.disabled = true
	
	if Input.is_action_just_pressed("ui_attack"):
		_state = Attack
		
	
	match (_state):
		Idle:
			$AnimatedSprite.play("Idle")
		Run:
			$AnimatedSprite.play("Run")
		Attack:
			$AnimatedSprite.play("Attack")
			$AttackArea/CollisionShape2D.disabled = false
		Die:
			pass
	
	
	move_and_slide(_velocity)


func move():
	var _horizontal_direction = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
	var _vertical_direction = (Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"))
	
	_velocity.x = _horizontal_direction * _speed
	_velocity.y = _vertical_direction * _speed
	
	if _velocity.x || _velocity.y != 0:
		_state = Run
	elif _velocity.x || _velocity.y == 0:
		_state = Idle
	
	if _velocity.x < 0:
		$AnimatedSprite.flip_h = true
		$AttackArea.position.x = - 26
	elif _velocity.x > 0:
		$AnimatedSprite.flip_h = false
		$AttackArea.position.x = 0
	


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "Attack":
		_state = Idle
