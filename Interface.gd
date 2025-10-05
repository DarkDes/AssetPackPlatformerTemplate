extends CanvasLayer

@onready var hud = $HUD
@onready var dev_menu = $DevMenu
@onready var starting_animation = $StartingAnimation

@onready var screenshot_button = $ScreenshotButton
@onready var restart_button = $RestartButton


func _ready():
	dev_menu.skip_intro.toggled.connect(
		func(_toggled):
			starting_animation.disabled = _toggled
	)
	
	dev_menu.asset_cycling.toggled.connect(
		func(_toggled):
			GD.asset_cycling = _toggled
	)
	
	restart_button.pressed.connect(func(): GD.level_restart())
	
	# Take Screen shot
	screenshot_button.pressed.connect(
		func():
			dev_menu.visible = false
			screenshot_button.visible = false
			restart_button.visible = false
			
			var _screenshot_hub = true
			var filename : String = "s.png"
			# Имя скриншота в общей папке 
			if _screenshot_hub == true:
				filename = OS.get_executable_path().get_base_dir().path_join("Screenshots")
				if DirAccess.dir_exists_absolute(filename) == false:
					DirAccess.make_dir_absolute(filename)
				var _time_date = Time.get_datetime_dict_from_system()
				filename = filename.path_join("Screenshot %s %04d-%02d-%02d T%02d-%02d-%02d.png" % \
						[APM.current.get_assetpack_name(),
						_time_date.year, _time_date.month, _time_date.day, 
						_time_date.hour, _time_date.minute, _time_date.second])
			else:
			# Скриншот в папке с ассетпаком
				filename = "screenshot_" + Time.get_date_string_from_system() + "_" + Time.get_time_string_from_system() + ".png"
				filename = filename.replace(":", "")
				filename = APM.current.path.path_join(filename)
			
			await RenderingServer.frame_post_draw
			var image = get_viewport().get_texture().get_image()
			# image.flip_y() # Flip the image if needed (some renderers might require it)
			var error = image.save_png(filename)
			if error != OK:
				printerr("Failure!")

			dev_menu.visible = true
			screenshot_button.visible = true
			restart_button.visible = true
			print("Screen shot saved " + filename)
	)

