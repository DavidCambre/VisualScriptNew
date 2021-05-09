tool
extends VisualScriptCustomNode

export var sequenced := false setget set_sequenced
func set_sequenced(value):
	sequenced = value
	ports_changed_notify()
func _has_input_sequence_port():
	return sequenced
func _get_output_sequence_port_count():
	return 0 + int(sequenced)

const INSTANTIATE_NONE = 0
const INSTANTIATE_INSTANCE = 1
const INSTANTIATE_NEW = 2
const INSTANTIATE_BASE_ATTACH = 3
var _instanceable_resource := 0
var _instanceable_class := 0

export var class_to_instance := "" setget _set_class_to_instance
export (String, FILE, "*.gd, *.vs, *.tscn, *.tres") var resource_to_instance := "" setget _set_resource_to_instance
var _resource_to_instance : Script

export var edit_property := "some_property" setget _update_edit_prop
export (Array, String) var editing_list := [] setget _set_editing_list
var editable_list := []

func _get_caption():
	if _instanceable_resource == INSTANTIATE_NEW:
		return resource_to_instance.get_file().get_basename() + ".new()"
	elif _instanceable_resource == INSTANTIATE_INSTANCE:
		return resource_to_instance.get_file().get_basename() + ".instance()"
	elif _instanceable_class == INSTANTIATE_NEW:
		return class_to_instance + ".new()"
	return "New()"
func _get_category():
	return "New"

func _get_input_value_port_count():
	var count := 0
	editable_list = []
	for name in editing_list:
		if _is_editable_property(name):
			count +=1
			editable_list.append(name)
	return count
func _get_input_value_port_name(idx):
	if _is_editable_property(editable_list[idx]):
		return editable_list[idx]
func _get_input_value_port_type(idx):
	return _is_editable_property(editable_list[idx])

func _get_output_value_port_count():
	return 1
func _get_output_value_port_type(idx):
	return TYPE_OBJECT

func _step(inputs, outputs, _start_mode, _working_mem):
	outputs[0] = _get_new_instance()
	for idx in editable_list.size():
		outputs[0].set(editable_list[idx], inputs[idx])
	return 0

func _get_new_instance():
	if _instanceable_resource == INSTANTIATE_NEW:
		return load(resource_to_instance).new()
	elif _instanceable_resource == INSTANTIATE_INSTANCE:
		return load(resource_to_instance).instance()
	elif _instanceable_resource == INSTANTIATE_BASE_ATTACH:
		var script = load("res://new_script.vs")
		var obj = ClassDB.instance(script.get_instance_base_type())
		obj.set_script(script)
		return obj
	elif _instanceable_class == INSTANTIATE_NEW:
		return ClassDB.instance(class_to_instance)

func _is_editable_property(prop_name):
	var instance = _get_new_instance()
	if instance:
		for prop in instance.get_property_list():
			if prop.name == prop_name:
				return prop.type
	return false

func _get_property_value(prop_name):
	var instance = _get_new_instance()
	if instance:
		if prop_name in instance:
			return instance.get_property_default_value(prop_name)
	return false

func _set_resource_to_instance(value):
	_instanceable_resource = INSTANTIATE_NONE
	resource_to_instance = value
	if ResourceLoader.exists(value):
		var resource = load(value)
		if resource is PackedScene:
			_instanceable_resource = INSTANTIATE_INSTANCE
		elif resource is GDScript:
			if resource.new():
				_instanceable_resource = INSTANTIATE_NEW
		elif resource is VisualScript:
			if resource.can_instance():
				_instanceable_resource = INSTANTIATE_BASE_ATTACH
	ports_changed_notify()

func _set_class_to_instance(value):
	_instanceable_class = INSTANTIATE_NONE
	class_to_instance = value
	if ClassDB.class_exists(value):
		if ClassDB.can_instance(value):
			_instanceable_class = INSTANTIATE_NEW
	ports_changed_notify()

func _update_edit_prop(value):
	edit_property = value
	if not editing_list.has(edit_property):
		if _is_editable_property(edit_property):
			editing_list.append(edit_property)
			call_deferred("property_list_changed_notify")
			ports_changed_notify()
			var v = _get_property_value(edit_property)
			var i = _get_property_input_port(edit_property)
			set_default_input_value(i, v)

func _get_property_input_port(prop_name):
	for i in _get_input_value_port_count():
		if _get_input_value_port_name(i) == prop_name:
			return i
			
func _set_editing_list(value):
	editing_list = value
	ports_changed_notify()
