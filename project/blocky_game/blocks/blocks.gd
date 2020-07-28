extends Resource

const ROTATION_TYPE_NONE = 0
const ROTATION_TYPE_AXIAL = 1

const ROOT = "res://blocky_game/blocks"


class Block:
	var id := 0
	var name := ""
	var gui_model_path := ""
	var directory := ""
	var rotation_type := ROTATION_TYPE_NONE
	var sprite_texture : Texture
	var transparent := false
	var backface_culling := true
	var voxels := []


class RawMapping:
	var block_id := 0
	var variant_index := 0


var _voxel_library := preload("res://blocky_game/blocks/voxel_library.tres")
var _blocks = []
var _raw_mappings = []


func _init():
	_create_block({
		"name": "air",
		"directory": "",
		"gui_model": "",
		"rotation_type": ROTATION_TYPE_NONE,
		"voxels": ["air"],
		"transparent": true
	})
	_create_block({
		"name": "dirt",
		"gui_model": "dirt.obj",
		"rotation_type": ROTATION_TYPE_NONE,
		"voxels": ["dirt"],
		"transparent": false
	})
	_create_block({
		"name": "grass",
		"gui_model": "grass.obj",
		"rotation_type": ROTATION_TYPE_NONE,
		"voxels": ["grass"],
		"transparent": false
	})
	_create_block({
		"name": "log",
		"gui_model": "log_y.obj",
		"rotation_type": ROTATION_TYPE_AXIAL,
		"voxels": ["log_x", "log_y", "log_z"],
		"transparent": false
	})
	_create_block({
		"name": "planks",
		"gui_model": "planks.obj",
		"rotation_type": ROTATION_TYPE_NONE,
		"voxels": ["planks"],
		"transparent": false
	})
	_create_block({
		"name": "stairs",
		"gui_model": "stairs_nx.obj",
		"rotation_type": ROTATION_TYPE_NONE,
		"voxels": ["stairs_nx"],
		"transparent": false
	})
	_create_block({
		"name": "tall_grass",
		"gui_model": "tall_grass.obj",
		"rotation_type": ROTATION_TYPE_NONE,
		"voxels": ["tall_grass"],
		"transparent": true,
		"backface_culling": false
	})


func get_block(id: int) -> Block:
	assert(id >= 0)
	return _blocks[id]


func get_block_count() -> int:
	return len(_blocks)


func _create_block(params: Dictionary):
	_defaults(params, {
		"rotation_type": ROTATION_TYPE_NONE,
		"transparent": false,
		"backface_culling": true,
		"directory": params.name
	})
	
	for i in len(params.voxels):
		var vname = params.voxels[i]
		var id = _voxel_library.get_voxel_index_from_name(vname)
		if id == -1:
			push_error("Could not find voxel named {0}".format([vname]))
		assert(id != -1)
		params.voxels[i] = id

	var block = Block.new()
	block.id = len(_blocks)
	block.name = params.name
	block.directory = params.directory
	block.rotation_type = params.rotation_type
	block.voxels = params.voxels
	block.transparent = params.transparent
	block.backface_culling = params.backface_culling
	if block.directory != "":
		block.gui_model_path = str(ROOT, "/", params.directory, "/", params.gui_model)
		var sprite_path = str(ROOT, "/", params.directory, "/", params.name, "_sprite.png")
		block.sprite_texture = load(sprite_path)
	_blocks.append(block)


static func _defaults(d, defaults):
	for k in defaults:
		if not d.has(k):
			d[k] = defaults[k]
