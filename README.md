# Aseprite Anim Setter #
## Table of Contents ##
1. [Introduction](#introduction)
2. [Tutorial](#tutorial)
## Introduction ##
This tool originated from the repetive work of updating loads of Animations
in Godot when I changed the Spritesheets with Aseprite. It started as a scipt,
and turned into a "full fledged" addon.
## Tutorial ##
### 1. Export from Aseprite ###
Export as a Spritesheet (File -> Export Spritesheet or just Ctrl+E), check JSON Data
and Frame Tags under meta are ticked. It's easier when both files have the same name 
and are in the same folder.
### 2. Setup in Godot ###
When You select a Sprite or a Sprite2D, a Dock will be added to the bottom right,
entitled "AnimSetter". It makes sense to first apply the texture, then go to the
AnimSetter Dock. If the Json-file is in the same folder and has the same name as 
the texture the Json-file will automatically be selected for you. If not, you can
also manually selected it. You also have to apply the framesize, as this is needed
to set up the region, hframes and vframes parameters of the texture. With the a 
click on the "Update"-button, an AnimationPlayer Node will be created for you and all
Animations are automatically set up. With the "Delete Animations"-button, all
Animations will be deleted. The duration of a frame corresponds to the duration set
in the frame properties in Aseprite. Also a default-offset of (0|0) will be set at 
the beginning of each frame. You can change this by changing the defaultOffset 
variable in the "ImportJsonAnim.gd"-Script. A better solution will be added later.
There is also the import mode. This should be set to Hash or Array, depending on
the Setting during the export in Aseprite. By default is this Hash, like the default
in Aseprite.
