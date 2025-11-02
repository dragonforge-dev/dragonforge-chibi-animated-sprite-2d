@tool
class_name ChibiAnimatedSprite2D extends AnimatedSprite2D

const DEATH_ANIMATION = "dying"
const FALL_ANIMATION = "falling_down"
const HURT_ANIMATION = "hurt"
const IDLE_ANIMATION = "idle"
const IDLE_BLINKING_ANIMATION = "idle_blinking"
const JUMP_ANIMATION = "jump_loop"
const JUMP_START_ANIMATION = "jump_start"
const KICK_ANIMATION = "kicking"
const RUN_SLASH_ANIMATION = "run_slashing"
const RUN_THROW_ANIMATION = "run_throwing"
const RUN_ANIMATION = "running"
const ATTACK_ANIMATION = "slashing"
const JUMP_ATTACK_ANIMATION = "slashing_in_the_air"
const SHOOT_ANIMATION = "shooting"
const JUMP_SHOOT_ANIMATION = "shooting_in_the_air"
const SLIDE_ANIMATION = "sliding"
const THROW_ANIMATION = "throwing"
const JUMP_THROW_ANIMATION = "throwing_in_the_air"
const WALK_ANIMATION = "walking"

@export_dir var sprite_root_folder:
	set(value):
		sprite_root_folder = value
		if sprite_frames:
			sprite_frames = SpriteFrames.new()
			sprite_frames = null
		if value:
			if Engine.is_editor_hint():
				var scan_time: float = 0.0
				scan_time = _rename_directories()
				if scan_time > 0.0:
					print("SCAN TIME: %s" % [scan_time])
					await get_tree().create_timer(scan_time).timeout
					print("DIRECTORY SCAN COMPLETE")
				_remove_import_files()
				scan_time = _rename_files()
				if scan_time > 0.0:
					print("SCAN TIME: %s" % [scan_time])
					await get_tree().create_timer(scan_time).timeout
					print("FILE RELOAD COMPLETE")
			_load_sprite_frames()
			print_rich("[color=cornflower_blue][b]%s[/b][/color]: [b]SpriteFrames[/b] Loading Complete!" % [name])


func _reimporting(resources: PackedStringArray) -> void:
	print_rich("[color=green]Reimporting signal:[/green] %s" % [resources])

func _reimported(resources: PackedStringArray) -> void:
	print_rich("[color=green]Reimported signal:[/green] %s" % [resources])

func _reload(resources: PackedStringArray) -> void:
	print_rich("[color=green]Reload signal:[/green] %s" % [resources])

## Returns true or false if this sprite has this animation.
func has_animation(animation_name: StringName) -> bool:
	return sprite_frames.has_animation(animation_name)


func _rename_directories() -> float:
	var scan_time: float = 0.0 #Since I don't have a reliable signal for when the scan is done, I'm calculating it.
	var dir = DirAccess.open(sprite_root_folder)
	if not dir:
		return scan_time
	var editor_filesystem = EditorInterface.get_resource_filesystem()

	var animation_list = dir.get_directories()
	for animation_dir in animation_list:
		# Convert the directory name to snake case
		var new_animation_dir = animation_dir.to_snake_case()
		if new_animation_dir != animation_dir:
			scan_time += 0.5
			dir.rename(animation_dir, new_animation_dir)
			print("Old Directory: %s New Directory: %s" % [animation_dir, new_animation_dir])
	
	#Scan the files in with the new directory names
	editor_filesystem.scan()
	return scan_time


func _remove_import_files() -> void:
	var dir = DirAccess.open(sprite_root_folder)
	if not dir:
		return

	var animation_list = dir.get_directories()
	for animation_dir in animation_list:
		#change to the specific animation directory
		dir.change_dir(animation_dir)
		var file_list = dir.get_files()
		#rename each file
		for file in file_list:
			var new_filename = file.to_snake_case()
			if file.ends_with(".import") and new_filename != file:
				dir.remove(file)
				print("Deleted %s" % [file])
		#drop back down a directory for the next loop
		dir.change_dir("..")


func _rename_files() -> float:
	var scan_time: float = 0.0 #Since I don't have a reliable signal for when the scan is done, I'm calculating it.
	var dir = DirAccess.open(sprite_root_folder)
	if not dir:
		return scan_time
	var editor_filesystem = EditorInterface.get_resource_filesystem()

	var animation_list = dir.get_directories()
	for animation_dir in animation_list:
		#change to the specific animation directory
		dir.change_dir(animation_dir)
		var file_list = dir.get_files()
		#rename each file
		for file in file_list:
			var new_filename = file.to_snake_case()
			if file.ends_with(".png") and new_filename != file:
				scan_time += 0.041
				var id = ResourceUID.path_to_uid(file)
				if id is int:
					ResourceUID.remove_id(id)
				dir.rename(file, new_filename)
				print("Old Filename: %s New Filename: %s" % [file, new_filename])
				var new_uid = ResourceUID.create_id_for_path(new_filename)
				ResourceUID.add_id(new_uid, new_filename)
				print("New UID Created: %s for New Filename: %s" % [new_uid, new_filename])
				editor_filesystem.update_file(new_filename)
				print("Update %s" % [new_filename])
		#drop back down a directory for the next loop
		dir.change_dir("..")
	#Scan the files in with the new directory names
	editor_filesystem.scan()
	return scan_time


func _load_sprite_frames() ->void:
	#if sprite_frames is null, create a new instance
	if not sprite_frames:
		sprite_frames = SpriteFrames.new()
	#delete default if it exists
	sprite_frames.remove_animation(&"default")
	#iterate through folders
	var dir = DirAccess.open(sprite_root_folder)
	if not dir:
		return
	var animation_list = dir.get_directories()
	for animation_dir in animation_list:
		# Get the animation name
		var animation_name = animation_dir.get_file().to_snake_case()
		sprite_frames.add_animation(animation_name)
		#Set it to 24 frames a second
		sprite_frames.set_animation_speed(animation_name, 24.0)
		#Set looping for looping animations
		if animation_name.contains(IDLE_ANIMATION) or \
				animation_name.contains("falling") or \
				animation_name.contains("loop") or \
				animation_name.contains("running") or \
				animation_name.contains("sliding") or \
				animation_name.contains("walking"):
			sprite_frames.set_animation_loop(animation_name, true)
		else:
			sprite_frames.set_animation_loop(animation_name, false)
		#change to the specific animation directory
		dir.change_dir(animation_dir)
		var file_list = dir.get_files()
		var path = dir.get_current_dir() + "/"

		#skip over .import files and uids and add the animation frames
		for file in file_list:
			if file.ends_with(".png"):
				sprite_frames.add_frame(animation_name, load(path + file))
		#drop back down a directory for the next loop
		dir.change_dir("..")
	#set the default animations
	set_autoplay(IDLE_ANIMATION)
	animation = IDLE_ANIMATION
