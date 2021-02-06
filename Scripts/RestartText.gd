extends Label

var timer: Timer
const interval = 0.1

func blink():
	visible = !visible

func _start():
	visible = true
	if !timer:
		timer = Timer.new()
		timer.connect("timeout", self, "blink")
		add_child(timer)
		timer.start(interval)