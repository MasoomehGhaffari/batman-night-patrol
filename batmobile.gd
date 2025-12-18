extends CharacterBody3D

# --- متغیرهای تنظیمات ---
# سرعت حرکت عادی ماشین
@export var speed: float = 20.0
# سرعت چرخش ماشین
@export var turn_speed: float = 2.0

func _physics_process(delta):
	# فراخوانی تابع حرکت در هر فریم فیزیکی
	handle_movement(delta)

# تابع مدیریت ورودی‌ها و اعمال حرکت
func handle_movement(delta):
	var direction = Vector3.ZERO
	
	# مدیریت چرخش
	# اگر دکمه چپ یا راست فشرده شود، ماشین حول محور Y می‌چرخد
	if Input.is_action_pressed("turn_left"):
		rotation.y += turn_speed * delta
	if Input.is_action_pressed("turn_right"):
		rotation.y -= turn_speed * delta
	
	# مدیریت حرکت به جلو و عقب
	# استفاده از basis.z برای حرکت در جهت "رو به جلوی" خود ماشین (نه جهت جهانی)
	if Input.is_action_pressed("move_forward"):
		direction = -transform.basis.z # منفی Z یعنی جلو 
	elif Input.is_action_pressed("move_backward"):
		direction = transform.basis.z
	
	# اعمال حرکت
	if direction != Vector3.ZERO:
		velocity = direction * speed
	else:
		# توقف نرم وقتی دکمه‌ای زده نمی‌شود
		velocity = velocity.move_toward(Vector3.ZERO, speed)

	# تابع داخلی گودوت برای اعمال velocity و مدیریت برخوردها
	move_and_slide()
