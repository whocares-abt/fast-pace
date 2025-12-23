extends NavigationRegion2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	NavigationSignalBus.connect("polygon_added", cut_polygon_from_mesh)

func cut_polygon_from_mesh(polygon : Polygon2D, polygon_transform):	
	# Removing node from the parent
	if polygon.get_parent():
		polygon.get_parent().remove_child(polygon)

	# Setting the polygon in same place
	polygon.transform = polygon_transform
	add_child(polygon)

	# Recreating the mesh with polygons cut out
	
	if (get_child_count() == 6):
		bake_navigation_polygon()

	print(get_child_count())
