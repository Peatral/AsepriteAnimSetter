tool
extends EditorPlugin

var edi
var interface
var control_added = false

func _enter_tree():
	var plugin = EditorPlugin.new()
	edi = plugin.get_editor_interface()
	plugin.queue_free()
	interface = preload("res://addons/AsepriteAnimSetter/Interface.tscn").instance()

func _exit_tree():
	if control_added:
		remove_control_from_docks(interface)
		#remove_control_from_bottom_panel(interface)

func _process(delta):
	var nodes = edi.get_selection().get_selected_nodes()
	
	if nodes != null && nodes.size() > 0:
		var node = nodes[0]
		if node is Sprite3D || node is Sprite:
			if !control_added:
				add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_BL, interface)
				#add_control_to_bottom_panel(interface, "AnimSetter")
				interface.selectSprite(node)
				control_added = true
		else:
			if control_added:
				remove_control_from_docks(interface)
				#remove_control_from_bottom_panel(interface)
				control_added = false