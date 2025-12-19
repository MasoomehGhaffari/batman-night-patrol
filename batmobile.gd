extends CharacterBody3D

# تنظیمات سرعت طبق خواسته پروژه
@export var normal_speed = 15.0    # سرعت عادی
@export var boost_speed = 40.0     # سرعت بوست (با Shift)
@export var rotation_speed = 2.0   # سرعت چرخش

@onready var headlight = $Headlight # دسترسی به چراغ جلو

func _physics_process(delta):
	# --- مدیریت سرعت (Boost) ---
	var current_speed = normal_speed
	
	# اگر دکمه boost (Shift) نگه داشته شده باشد
	if Input.is_action_pressed("boost"):
		current_speed = boost_speed
		# وقتی سرعت بالاست، نور کمی پرنورتر شود
		if headlight: headlight.light_energy = 15.0 
	else:
		current_speed = normal_speed
		# برگشت نور به حالت عادی
		if headlight: headlight.light_energy = 10.0

	# --- چرخش (A/D) ---
	# اگر جهت‌های چپ/راست فشرده شوند
	var turn_direction = Input.get_axis("turn_right", "turn_left")
	rotation.y += turn_direction * rotation_speed * delta

	# --- حرکت جلو/عقب (W/S) ---
	# اگر جهت‌های جلو/عقب فشرده شوند
	var move_direction = Input.get_axis("move_backward", "move_forward")
	
	# محاسبه جهت حرکت بر اساس زاویه فعلی ماشین
	# transform.basis.z بردار "جلو"ی ماشین است
	velocity = transform.basis.z * move_direction * current_speed
	
	# اعمال حرکت
	move_and_slide()
