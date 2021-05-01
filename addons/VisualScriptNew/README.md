# VisualScriptNew

**A new VisualScriptNode**

For easy instancing of items other then scenes
Flexible and clear editing of instanced variables
Optional Sequenced flow
Is able to instnace.
- Built in Classes
- *.gd
- *.vs
- *.tscn
- *.tres

# Node Propertys Explained

- Sequenced = true: The instance gets created when sequence is called. And the object is accesible until the sequence is called again
- Sequenced = false: Every obj.get() creates a new object
- Class To Instance: When a class is able to instance the node name will change
- Script To Instance: When a script is able to instance the node name will change (overrules Class To Instance)
- Edit Property: If you type a valid property it wil be added to editing List
- Editing List: if valid property set input ports

# Known Issues
Godot/issues/48351

It is not possible to set the color value directly.

Work arround = Drag in Color from constant
