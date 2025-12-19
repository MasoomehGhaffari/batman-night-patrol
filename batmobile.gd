extends CharacterBody3D

# --- تعریف حالت‌های بازی (Enum) ---
enum Mode { NORMAL, STEALTH, ALERT }
var current_mode = Mode.NORMAL

# --- تنظیمات سرعت برای هر حالت ---
@export var speed_stealth: float = 10.0
@export var speed_normal: float = 25.0
@export var speed_alert: float = 50.0

# سرعت فعلی (که تغییر می‌کند)
var current_speed: float = 0.0
@export var turn_speed: float = 2.0

# --- دسترسی به نودها ---
# نود چراغ جلو را اینجا فراخوانی می‌کنیم
# دقت کنید که نام نود در صحنه دقیقاً "Headlight" باشد
@onready var headlight = $Headlight 

func _ready():
	# شروع بازی با حالت نرمال
	change_mode(Mode.NORMAL)

func _physics_process(delta):
	handle_input()
	handle_movement(delta)

# تابع مدیریت ورودی‌های تغییر حالت
func handle_input():
	if Input.is_action_just_pressed("mode_normal"):
		change_mode(Mode.NORMAL)
	elif Input.is_action_just_pressed("mode_stealth"):
		change_mode(Mode.STEALTH)
	elif Input.is_action_just_pressed("mode_alert"):
		change_mode(Mode.ALERT)

# تابع تغییر حالت (مغز متفکر سیستم)
func change_mode(new_mode):
	current_mode = new_mode
	
	match current_mode:
		Mode.NORMAL:
			current_speed = speed_normal
			headlight.visible = true # چراغ روشن
			print("Mode: NORMAL")
			
		Mode.STEALTH:
			current_speed = speed_stealth
			headlight.visible = false # چراغ خاموش
			print("Mode: STEALTH")
			
		Mode.ALERT:
			current_speed = speed_alert
			headlight.visible = true # چراغ روشن
			print("Mode: ALERT")

# تابع حرکت (همان تابع قبلی با کمی تغییر برای سرعت)
func handle_movement(delta):
	var direction = Vector3.ZERO
	
	# چرخش
	if Input.is_action_pressed("turn_left"):
		rotation.y += turn_speed * delta
	if Input.is_action_pressed("turn_right"):
		rotation.y -= turn_speed * delta
	
	# حرکت جلو/عقب
	if Input.is_action_pressed("move_forward"):
		direction = -transform.basis.z 
	elif Input.is_action_pressed("move_backward"):
		direction = transform.basis.z
	
	# اعمال حرکت با سرعتِ متغیرِ فعلی
	if direction != Vector3.ZERO:
		velocity = direction * current_speed
	else:
		velocity = velocity.move_toward(Vector3.ZERO, current_speed)

	move_and_slide()
