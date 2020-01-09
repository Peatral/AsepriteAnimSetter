tool
extends Node

var defaultOffset = Vector2(0,0)

var animScr = "" setget setAnimScr
var animPlayerName = "AnimationPlayer"
var framesize = Vector2(64,64)
var sprite
var mode = 0

var lastTexture = null

func setAnimScr(val):
	animScr = val
	var t = animScr.split("/")
	$MarginContainer/VBoxContainer/OptionsPanel/ScrollContainer/MarginContainer/Grid/Select.text = t[t.size()-1].replace(".json", "")

func selectSprite(sprite):
	self.sprite = sprite
	if sprite.texture != null:
		$MarginContainer/VBoxContainer/Buttons/Update.disabled = false
		var path = sprite.texture.resource_path.split(".")
		path[path.size()-1] = "json"
		path = path.join(".")
		if File.new().file_exists(path):
			self.animScr = path
	else:
		$MarginContainer/VBoxContainer/Buttons/Update.disabled = true

func updateanims():
	deleteallanims()
	var animPlayer : AnimationPlayer = animPlayerCheck()
	var file = File.new()
	if not file.file_exists(animScr):
		print("No file saved!")
		return
	if file.open(animScr, File.READ) != 0:
		print("Error opening file")
		return
	var data_text = file.get_as_text()
	file.close()
	var data_parse = JSON.parse(data_text)
	if data_parse.error != OK:
		return
	var spriteanim = data_parse.result
	
	sprite.vframes = sprite.texture.get_height()/framesize.y
	sprite.hframes = sprite.texture.get_width()/framesize.x
	sprite.region_enabled = true
	sprite.region_rect = Rect2(0, 0, framesize.x * sprite.hframes, framesize.y * sprite.vframes)
	
	for tag in spriteanim["meta"]["frameTags"]:
		var startFrame = tag["from"]
		var endFrame = tag["to"]
		var animName = tag["name"]
		
		var anim = Animation.new()
		animPlayer.add_animation(animName, anim)
		anim.loop = true
		anim.add_track(Animation.TYPE_VALUE)
		anim.add_track(Animation.TYPE_VALUE)
		anim.track_set_interpolation_type(0, Animation.INTERPOLATION_NEAREST)
		anim.track_set_interpolation_type(1, Animation.INTERPOLATION_NEAREST)
		anim.track_set_path(0, sprite.name + ":frame")
		anim.track_set_path(1, sprite.name + ":offset")
		anim.track_insert_key(1, 0, defaultOffset)
		
		var lastFrameLength = 0.0
		var time = lastFrameLength
		
		var frames = spriteanim["frames"]
		var frontKey = ""
		var backKey = ""
		if mode == 0:
			var key = frames.keys()[0].split(".")
			var end = key[key.size()-1]
			key.remove(key.size()-1)
			var front = key.join(".")
			front = front.split(" ")
			front.remove(front.size()-1)
			front = PoolStringArray(front).join(" ")
			frontKey = front + " "
			backKey = "." + end
		
		for frameIdx in range(startFrame, endFrame+1):
			var frameData
			
			if mode == 0:
				frameData = frames[frontKey + str(frameIdx) + backKey]
			elif mode == 1:
				frameData = frames[frameIdx]
			
			anim.track_insert_key(0, time, frameIdx)
			lastFrameLength = frameData["duration"]/1000.0
			time += lastFrameLength
		
		anim.length = time

func deleteallanims():
	var animPlayer : AnimationPlayer = animPlayerCheck()
	print(animPlayer.get_animation_list())
	for i in animPlayer.get_animation_list():
		animPlayer.remove_animation(i)

func on_FramesizeX_value_changed(value):
	framesize.x = value

func on_FramesizeY_value_changed(value):
	framesize.y = value

func on_Select_pressed():
	$MarginContainer/VBoxContainer/OptionsPanel/ScrollContainer/MarginContainer/Grid/Select/FileDialog.show()

func on_FileDialog_file_selected(path):
	self.animScr = path

func on_AnimPlayerName_text_changed(new_text):
	animPlayerName = new_text

func on_JsonFile_text_changed(new_text):
	animScr = new_text

func animPlayerCheck():
	if sprite.get_parent().has_node(animPlayerName):
		if sprite.get_parent().get_node(animPlayerName) is AnimationPlayer:
			return sprite.get_parent().get_node(animPlayerName)
	var p = AnimationPlayer.new()
	p.name = animPlayerName
	sprite.get_parent().add_child(p)
	p.set_owner(sprite.get_parent().get_tree().get_edited_scene_root())
	return p

func on_Mode_item_selected(ID):
	mode = ID

func _process(delta):
	if lastTexture != sprite.texture:
		selectSprite(sprite)