extends VBoxContainer

func _on_coop_pressed():
	if IP.get_local_addresses().is_empty():
		$error.popup_centered()
		SoundEffect.press(false)
		return
	
	$HostOrJoin.popup_centered()

func _on_host_or_join_canceled():
	root.change_menu(NodePath("EnetHost"))

func _on_host_or_join_confirmed():
	root.change_menu(NodePath("EnetJoin"))

@onready var root := get_tree().current_scene

func _on_solo_pressed():
	Global.change_scene(global.lobby)
