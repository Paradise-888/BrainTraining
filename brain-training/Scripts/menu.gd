extends Control # 👈 บรรทัดนี้สำคัญที่สุด ห้ามหายเด็ดขาดครับ!

func _on_button_pressed():
	# สั่งให้เปลี่ยนหน้าจอไปยังหน้าเลือกเกมที่คุณทำไว้
	get_tree().change_scene_to_file("res://Scenes/game_selection.tscn")
