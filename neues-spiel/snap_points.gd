extends Marker2D

var occupied: bool = false
var occupant = null

func _ready() -> void:
	add_to_group("snap_points")

func release():
	occupied = false
	occupant = null
