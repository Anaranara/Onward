extends CharacterBody3D

@export var SPEED = 5.0
@export var JUMP_VELOCITY = 4.5
@export var MOTION_SPEED = 160 # Pixels/second
@export var FALL_HEIGHT: float = -10


@onready var sfx: AudioStreamPlayer3D = $SFX
# Vector để lưu hướng di chuyển cuối cùng
@onready var last_direction = Vector3(1, 0, 0)
@onready var start_pos: Vector3 = position

# Dictionary chứa các animation states
var anim_directions = {
	"idle": [ # list of [animation name, horizontal flip]
		["idle/right_idle", false],
		["idle/front_right_idle", false], 
		["idle/front_idle", false],
		["idle/front_left_idle", false],
		["idle/left_idle", false],
		["idle/back_left_idle", false],
		["idle/back_idle", false],
		["idle/back_right_idle", false],
	],
	"walk": [
		["walk/right_walk", false],
		["walk/front_right_walk", false],
		["walk/front_walk", false],
		["walk/front_left_walk", false],
		["walk/left_walk", false],
		["walk/back_left_walk", false],
		["walk/back_walk", false],
		["walk/back_right_walk", false],
	],
	"jump": [
		["jump/right_jump", false],
		["jump/front_right_jump", false],
		["jump/front_jump", false],
		["jump/front_left_jump", false],
		["jump/left_jump", false],
		["jump/back_left_jump", false],
		["jump/back_jump", false],
		["jump/back_right_jump", false],
	],
}


func _physics_process(delta: float) -> void:
	# Xử lý gravity
	check_fall()
	if not is_on_floor():
		if velocity.y < 0:
			velocity += get_gravity() * delta * 3
		else:
			velocity += get_gravity() * delta
	var input_dir = Vector3(0,0,0)
	if GlobalVar.can_interact and !GlobalVar.interact_wait:
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			sfx.play()

		# Lấy input direction và xử lý movement
		input_dir = Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	## Cập nhật velocity dựa trên input
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		last_direction = direction
		if not is_on_floor():
			update_animation("jump")
		else:
			update_animation("walk")
	else:
		velocity.x = 0
		velocity.z = 0
		if not is_on_floor():
			update_animation("jump")
		else:
			update_animation("idle")
	move_and_slide()

func update_animation(anim_set: String) -> void:
	# Chuyển đổi vector3 thành vector2 để tính góc (bỏ qua trục y)
	var dir_2d = Vector2(0, 0)
	
	dir_2d = Vector2(last_direction.x, last_direction.z)
	# Tính góc và slice direction
	var angle = rad_to_deg(dir_2d.angle()) + 22.5
	var slice_dir = int(fmod(floor(angle / 45), 8))  # Đảm bảo giá trị từ 0-7
	
	# Lấy reference đến AnimationPlayer hoặc AnimatedSprite3D
	$AnimationPlayer.play(anim_directions[anim_set][slice_dir][0])
func check_fall() -> void:
	if position.y < FALL_HEIGHT:
		restart()
	
func restart() -> void:
	position = start_pos
	velocity = Vector3.ZERO
#func _input(event: InputEvent) -> void:
	#pass
	## Kiểm tra nếu nhấn phím 'Q' để xoay ngược chiều kim đồng hồ
	#if event.is_action_pressed("rotate_left"):
		#rotate_object_left()
#
	## Kiểm tra nếu nhấn phím 'E' để xoay xuôi chiều kim đồng hồ
	#if event.is_action_pressed("rotate_right"):
		#rotate_object_right()

#rotate pov
#func rotate_object_left() -> void:
	## Xoay 90 độ quanh trục Y (ngược chiều kim đồng hồ)
	#if GlobalVariable.player.rotation_degrees.y == 180 || GlobalVariable.player.rotation_degrees.y == -180:
		#GlobalVariable.player.rotation_degrees.y = 90
	#else:
		#GlobalVariable.player.rotation_degrees.y -= 90
#
#func rotate_object_right() -> void:
	## Xoay 90 độ quanh trục Y (xuôi chiều kim đồng hồ)
	#if GlobalVariable.player.rotation_degrees.y == 180 || GlobalVariable.player.rotation_degrees.y == -180:
		#GlobalVariable.player.rotation_degrees.y = -90
	#else:
		#GlobalVariable.player.rotation_degrees.y += 90
#


#rotation check
	#if GlobalVariable.player.rotation_degrees.y == 90:
		#dir_2d = Vector2(-last_direction.z, last_direction.x)
	#if GlobalVariable.player.rotation_degrees.y == -90:
		#dir_2d = Vector2(last_direction.z, -last_direction.x)
	#if abs(GlobalVariable.player.rotation_degrees.y) == 180:
		#dir_2d = Vector2(-last_direction.x, -last_direction.z)
	#if GlobalVariable.player.rotation_degrees.y == 0:
	#
