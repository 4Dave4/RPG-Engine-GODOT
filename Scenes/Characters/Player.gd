extends KinematicBody2D

var _speed = 30
var _velocity = Vector2()
var _MaxHP = 10
var _currentHP = 1

enum States{
	Idle
	Run 
	Attack
	Die
	Staggered
}

var _state = States.Idle

func _ready():
	_currentHP = _currentHP

func _physics_process(delta):
	
	match (_state):
		States.Idle:
			$AnimatedSprite.play("Idle")
		States.Run:
			$AnimatedSprite.play("Run")
		States.Attack:
			$AnimatedSprite.play("Attack")
			$AttackArea/CollisionShape2D.disabled = false
			return
		States.Die:
			pass
		States.Staggered:
			pass
	
	if _state != States.Attack:
		move()
		$AttackArea/CollisionShape2D.disabled = true
	
	if Input.is_action_just_pressed("ui_attack"):
		_state = States.Attack
	
	move_and_slide(_velocity)

func move():
	var _horizontal_direction = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
	var _vertical_direction = (Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"))
	
	_velocity.x = _horizontal_direction * _speed
	_velocity.y = _vertical_direction * _speed
	
	
	if _velocity.x || _velocity.y != 0:
		_state = States.Run
	elif _velocity.x || _velocity.y == 0:
		_state = States.Idle
	
	if _velocity.x < 0:
		$AnimatedSprite.flip_h = true
		$AttackArea.position.x = - 26
	elif _velocity.x > 0:
		$AnimatedSprite.flip_h = false
		$AttackArea.position.x = 0
	

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "Attack":
		_state = States.Idle
