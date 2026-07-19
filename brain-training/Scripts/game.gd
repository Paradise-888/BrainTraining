extends Control

# ดึง Node ต่างๆ มาเตรียมใช้งานในโค้ด
@onready var background = $Background
@onready var status_label = $VBoxContainer/StatusLabel
@onready var best_time_label = $VBoxContainer/BestTimeLabel
@onready var delay_timer = $DelayTimer

# ตัวแปรควบคุมสถานะเกม
enum GameState { START, WAITING, READY, RESULT }
var current_state = GameState.START

var start_time = 0
var best_time = 999999.0

func _ready():
	# สุ่มค่า seed ของระบบสุ่ม เพื่อไม่ให้สุ่มได้เวลาซ้ำๆ
	randomize() 
	# ซ่อนข้อความสถิติไว้ก่อนในครั้งแรกสุด
	best_time_label.text = "" 
	reset_game()

func _process(_delta):
	# ตรวจจับการกดปุ่ม Spacebar
	if Input.is_action_just_pressed("ui_accept"):
		match current_state:
			GameState.START:
				start_waiting_phase()
			GameState.WAITING:
				trigger_foul()
			GameState.READY:
				calculate_reaction_time()
			GameState.RESULT:
				reset_game()

# 1. หน้าจอเริ่มต้น
func reset_game():
	current_state = GameState.START
	background.color = Color("1f2335") # สีน้ำเงินเข้มสบายตา
	status_label.text = "กด SPACEBAR เพื่อเริ่มทดสอบ"

# 2. เริ่มช่วงรอ (หน้าจอสีแดง และสุ่มเวลา)
func start_waiting_phase():
	current_state = GameState.WAITING
	background.color = Color("ff2a2a") # สีแดง เตือนให้รอ
	status_label.text = "รอจนกว่าจอจะเปลี่ยนเป็นสีเขียว...\n(ห้ามกดเด็ดขาด!)"
	
	var random_delay = randf_range(2.0, 5.0)
	delay_timer.wait_time = random_delay
	delay_timer.one_shot = true
	delay_timer.start()

# 3. ฟังก์ชันเมื่อสุ่มเวลารอเสร็จสิ้น (ผูกจาก Signal timeout ของ DelayTimer)
func _on_delay_timer_timeout():
	if current_state == GameState.WAITING:
		current_state = GameState.READY
		background.color = Color("00e676") # สีเขียว ให้รีบกด!
		status_label.text = "กดเลย!!!"
		start_time = Time.get_ticks_msec()

# 4. คำนวณเวลาเมื่อกดได้ถูกต้อง
func calculate_reaction_time():
	current_state = GameState.RESULT
	var end_time = Time.get_ticks_msec()
	var reaction_time = end_time - start_time
	var reaction_in_seconds = reaction_time / 1000.0
	
	background.color = Color("24283b")
	status_label.text = "ความไวของคุณ: " + String.num(reaction_in_seconds, 3) + " วินาที\n\n(กด SPACEBAR เพื่อทดสอบใหม่)"
	
	if reaction_time < best_time:
		best_time = reaction_time
		var best_in_seconds = best_time / 1000.0
		best_time_label.text = "เวลาที่ดีที่สุด: " + String.num(best_in_seconds, 3) + " วินาที"

# 5. กรณีผู้เล่นใจร้อน กดก่อนจอสีเขียว
func trigger_foul():
	delay_timer.stop()
	current_state = GameState.RESULT
	background.color = Color("bb9af7") # สีม่วงเตือนว่าทำฟาวล์
	status_label.text = "ใจร้อนไปนิด! กดก่อนสีเขียวขึ้นครับ (ฟาวล์)\n\n(กด SPACEBAR เพื่อเริ่มใหม่)"

# 6. ฟังก์ชันปุ่มย้อนกลับ (ใช้ตัวพิมพ์เล็กตรงตามไฟล์จริงแล้ว)
func _on_button_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/game_selection.tscn")
