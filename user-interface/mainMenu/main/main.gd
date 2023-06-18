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

var root := get_tree().current_scene
