tool
extends EditorPlugin

func _enter_tree():
	VisualScriptEditor.add_custom_node("VisualScriptNew", "New", preload("res://addons/VisualScriptNew/VisualScriptNew.gd"))

func _exit_tree():
	VisualScriptEditor.remove_custom_node("VisualScriptNew", "New")
