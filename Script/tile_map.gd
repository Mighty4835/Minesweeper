extends TileMap
var columns = 15
var rows = 15
var click = false
var background_layer = 0
var mine_layer = 1
var number_layer = 2
var ground_layer = 3
var flag_layer = 4
var Tileset_id = 1
var mine_list = []
var max_mines = 25
var cell_list  = {
	1: Vector2i(0,0),
	2: Vector2i(1,0),
	3: Vector2i(2,0),
	4: Vector2i(3,0),
	5: Vector2i(4,0),
	6: Vector2i(5,0),
	7: Vector2i(6,0),
	8: Vector2i(7,0),
	9: Vector2i(8,0),
	"black_bomb": Vector2i(1,1),
	"red_bomb" : Vector2i(0,1),
	"white_tile" : Vector2i(2,1),
	"black_tile": Vector2i(3,1),
	"flag" : Vector2i(4,1)
}


func _ready():
	generate_background()
	generate_mines()
	generate_numbers()
	generate_cover()

func generate_background():
	for y in range(rows):
		for x in range(columns):
#			print(x,y)
			set_cell(background_layer, Vector2i(x,y), Tileset_id, cell_list["white_tile"] )

func generate_mines():
	for y in range(max_mines):
		var mine_post = (Vector2i(randi_range(0,columns-1),randi_range(0,rows-1)))
		while mine_post in mine_list:
			mine_post = (Vector2i(randi_range(0,columns-1),randi_range(0,rows-1)))
		mine_list.append(mine_post)
		set_cell(mine_layer, mine_post, Tileset_id, cell_list["black_bomb"])


func generate_numbers():
	for current_tiles in mine_list:
		for x in [-1,0,1]:
			for y in [-1,0,1]:
				var current_post = (Vector2i(current_tiles.x+x,current_tiles.y+y))
				if mine_list.has(current_post):
					continue 
				var tile_number = get_cell_atlas_coords(number_layer,current_post).x+1
				set_cell(number_layer, current_post, Tileset_id, cell_list[tile_number+1])

func generate_cover():
	for y in range(rows):
		for x in range(columns):
#			print(x,y)
			set_cell(ground_layer, Vector2i(x,y), Tileset_id, cell_list["black_tile"] )



func _process(delta):
	var mouse_pos = local_to_map(get_local_mouse_position())
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		process_right_click(mouse_pos)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		process_left_click(mouse_pos)

func process_left_click(pos):
	click = true
	if !is_flag(pos):
		erase_cell(ground_layer,pos)
	if is_mine(pos):
		Mine_explode()
func Mine_explode():
	print("Mine_explode")

func process_right_click(pos):
	click = true
	if is_flag(pos):
		erase_cell(flag_layer,pos)
	else:
		set_cell(flag_layer, pos, Tileset_id, cell_list["flag"] )

func is_flag(pos):
	return get_cell_source_id(flag_layer, pos) == 1
func is_mine(pos):
	return get_cell_source_id(mine_layer, pos) == 1

func _input(event):
	if event is InputEventMouseButton and !event.pressed:
		click = false
