extends CharacterBody2D

const SPEED = 300.0

var is_attacking = false
var character = 1

@onready var chibi_animated_sprite_2d: ChibiAnimatedSprite2D = $Valkyrie1
@onready var valkyrie_1: ChibiAnimatedSprite2D = $Valkyrie1
@onready var valkyrie_2: ChibiAnimatedSprite2D = $Valkyrie2


func _ready() -> void:
	chibi_animated_sprite_2d.animation_finished.connect(_animation_finished)

func _physics_process(_delta: float) -> void:
	if is_attacking:
		return
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		velocity = direction * SPEED
		chibi_animated_sprite_2d.play("walking")
		chibi_animated_sprite_2d.flip_h = direction.x < 0
	else:
		velocity = Vector2.ZERO
		chibi_animated_sprite_2d.play("idle")
	
	if Input.is_action_just_pressed("attack"):
		is_attacking = true
		chibi_animated_sprite_2d.play("slashing")
	if Input.is_action_just_pressed("switch_character"):
		if character == 1:
			_switch_character(valkyrie_2)
			character = 2
		else:
			_switch_character(valkyrie_1)
			character = 1
		print(chibi_animated_sprite_2d.name)

		

	move_and_slide()


func _animation_finished() -> void:
	is_attacking = false


func _switch_character(character_skin: ChibiAnimatedSprite2D) -> void:
	var flip = chibi_animated_sprite_2d.flip_h
	chibi_animated_sprite_2d.hide()
	chibi_animated_sprite_2d.animation_finished.disconnect(_animation_finished)
	chibi_animated_sprite_2d = character_skin
	chibi_animated_sprite_2d.animation_finished.connect(_animation_finished)
	chibi_animated_sprite_2d.flip_h = flip
	chibi_animated_sprite_2d.show()
	
