extends Control

# กำหนดคู่ภาพ (สุ่มตัวเลขคู่ 1-4)
var card_values = [1, 1, 2, 2, 3, 3, 4, 4] 
var buttons = []
var first_card = null
var second_card = null
var is_processing = false

var matches_found = 0 # ตัวนับว่าจับคู่สำเร็จไปกี่คู่แล้ว
@onready var grid = $VBoxContainer/GridContainer
@onready var score_label = $VBoxContainer/Label_Score # Node แสดงสถานะ/คะแนน

func _ready():
	randomize()
	card_values.shuffle()
	
	buttons = grid.get_children()
	score_label.text = "จับคู่ภาพที่เหมือนกัน!"
	
	for i in range(buttons.size()):
		var btn = buttons[i]
		btn.text = "?"
		# ปรับขนาดฟอนต์ของปุ่มในโค้ดให้ใหญ่ขึ้นเพื่อผู้สูงอายุ (หากไม่ได้ปรับใน Editor)
		btn.add_theme_font_size_override("font_size", 32)
		btn.pressed.connect(_on_card_pressed.bind(btn, card_values[i]))

func _on_card_pressed(btn, value):
	if is_processing or btn.text != "?":
		return
	
	btn.text = str(value)
	# 🟢 บรรทัดที่เพิ่มใหม่: สั่งให้ปุ่มที่ถูกกดเปลี่ยนเป็นสีเขียวสดค้างไว้ทันที
	btn.modulate = Color("00e676")
	
	if first_card == null:
		first_card = {"btn": btn, "val": value}
	else:
		second_card = {"btn": btn, "val": value}
		is_processing = true
		
		await get_tree().create_timer(1.0).timeout
		
		if first_card.val == second_card.val:
			first_card.btn.disabled = true
			second_card.btn.disabled = true
			matches_found += 1
			
			# ตรวจสอบว่าจับคู่ครบทุกคู่หรือยัง (มี 8 ใบ = 4 คู่)
			if matches_found == 4:
				score_label.text = "ยอดเยี่ยมมาก! คุณจับคู่ครบทั้งหมดแล้ว"
		else:
			first_card.btn.text = "?"
			second_card.btn.text = "?"
			# ⚪ บรรทัดที่เพิ่มใหม่: ล้างสีเขียวกลับมาเป็นสีปกติ (ขาว) หากจับคู่ผิด
			first_card.btn.modulate = Color.WHITE
			second_card.btn.modulate = Color.WHITE
		
		first_card = null
		second_card = null
		is_processing = false

# 🔙 ฟังก์ชันสำหรับปุ่มย้อนกลับ (เชื่อมต่อจาก Signal ของ Button_Back)
func _on_button_back_pressed():
	# สั่งให้เอนจินเปลี่ยนหน้าจอกลับไปที่หน้าเลือกเกม
	get_tree().change_scene_to_file("res://Scenes/game_selection.tscn")
