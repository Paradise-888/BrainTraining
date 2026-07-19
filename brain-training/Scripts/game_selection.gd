extends Control

# ปุ่มที่ 1: เข้าเกมทดสอบความไว (ไฟล์ชื่อ Game.tscn)
func _on_button_reaction_pressed():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

# ปุ่มที่ 2: เข้าเกมจับคู่ภาพ (ปรับเป็นตัวพิมพ์เล็กทั้งหมดตามไฟล์จริงของคุณ)
func _on_button_memory_pressed():
	get_tree().change_scene_to_file("res://Scenes/memory_game.tscn")

# ปุ่มที่ 3: ย้อนกลับหน้าเมนูหลัก (ไฟล์ของคุณชื่อ menu.tscn พิมพ์เล็กหมด)
func _on_button_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
