extends CharacterBody3D

# --- تنظیمات اسم دکمه‌های حرکت ---
var action_forward = "move_forward"
var action_back =    "move_backward"
var action_left =    "turn_left"
var action_right =   "turn_right"
var action_boost =   "boost"

#--- تعریف حالت‌ها (State System) ---
enum BatmanState { NORMAL, STEALTH, ALERT }
var current_state = BatmanState.NORMAL

# --- تنظیمات سرعت ---
@export var stealth_speed = 8.0   # سرعت در حالت مخفی
@export var normal_speed = 15.0   # سرعت عادی
@export var boost_speed = 40.0    # سرعت بوست
@export var rotation_speed = 2.0

# --- نودها ---
@onready var headlight = $Headlight
@onready var siren_sound = $SirenSound # نود صدای آژیر

func _physics_process(delta):
	# -----------------------------------------------
	# 1. بررسی تغییر حالت (State Switching)
	# -----------------------------------------------
	if Input.is_action_just_pressed("mode_stealth"): # دکمه C
		current_state = BatmanState.STEALTH
		print("Mode: STEALTH")
		# تنظیمات مخفی: نور کم، صدا قطع
		if headlight: 
			headlight.light_energy = 0.5
			headlight.light_color = Color(0.5, 0.5, 1.0) # آبی کم‌رنگ
		if siren_sound: siren_sound.stop()

	elif Input.is_action_just_pressed("mode_alert"): # دکمه Space
		current_state = BatmanState.ALERT
		print("Mode: ALERT")
		# تنظیمات هشدار: نور قرمز و زیاد، پخش آژیر
		if headlight: 
			headlight.light_energy = 20.0
			headlight.light_color = Color(1.0, 0.0, 0.0) # قرمز
		if siren_sound and not siren_sound.playing: 
			siren_sound.play()

	elif Input.is_action_just_pressed("mode_normal"): # دکمه N
		current_state = BatmanState.NORMAL
		print("Mode: NORMAL")
		# تنظیمات عادی: نور سفید استاندارد، صدا قطع
		if headlight: 
			headlight.light_energy = 10.0
			headlight.light_color = Color(1.0, 1.0, 1.0) # سفید
		if siren_sound: siren_sound.stop()

	# -----------------------------------------------
	# 2. محاسبه سرعت بر اساس حالت فعلی
	# -----------------------------------------------
	var target_speed = 0.0
	
	if current_state == BatmanState.STEALTH:
		target_speed = stealth_speed # در حالت مخفی بوست نداریم
		
	else: 
		# در حالت نرمال و هشدار، بوست کار میکند
		if Input.is_action_pressed(action_boost):
			target_speed = boost_speed
		else:
			target_speed = normal_speed

	# -----------------------------------------------
	# 3. حرکت و چرخش (مثل قبل)
	# -----------------------------------------------
	var turn_dir = Input.get_axis(action_right, action_left)
	rotation.y += turn_dir * rotation_speed * delta

	var move_dir = Input.get_axis(action_back, action_forward)
	velocity = -transform.basis.z * move_dir * target_speed
	
	move_and_slide()
