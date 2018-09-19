extends Label

func _ready():
	set_process(true)

func _process(delta):
	set_text('FPS: ' + str(OS.get_frames_per_second()))
