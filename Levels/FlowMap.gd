extends TileMap

export var AgentControl : NodePath

var field = []
var cols : int
var rows : int
export var resolution : int

var noise = OpenSimplexNoise.new()

func _ready():
	noise.seed = randi()
	noise.octaves = 2
	noise.period = 20.0
	noise.persistence = 0.8
	
	cols = get_node(AgentControl).boundsX/resolution
	rows = get_node(AgentControl).boundsY/resolution
	
	var xoff := 0.0
	for i in cols:
		field.append([])
		var yoff := 0.0
		for j in rows:
			field[i].append(0)
			var theta = remap_range(noise.get_noise_2d(xoff,yoff),0,1,0,PI*2)
			field[i][j] = Vector2((cos(theta)),(sin(theta)))
			set_cellv(field[i][j] * Vector2(cols,rows), 0)
			yoff += 0.1
		xoff += 0.1
	#print(get_used_cells_by_id(0))

#func lookup(lookup:Vector2):
#	var column = int(snap)


func remap_range(value, InputA, InputB, OutputA, OutputB):
	return(value - InputA) / (InputB - InputA) * (OutputB - OutputA) + OutputA
