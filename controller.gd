extends Node2D

@export var big_speed: float = 0.05
@export var big_speed2: float = 0.05
@export var big_trans_offset: float = 0.2
@export var big_pixelation: float = 1000
@export var big_noise_scale: float = 0.3
@export var big_dither_scale: Vector2 = Vector2(4, 4)
@export var big_base_scale: Vector2 = Vector2(3, 3)
@export var big_dir: Vector2 = Vector2(0.5, 0.5)
@export var big_dir2: Vector2 = Vector2(0.25, 0.5)
@export var big_true_alpha: float = 1
@export var big_rot_speed: float = -0.1
@export var big_texture_size: Vector2 = Vector2(100, 100)
@export var big_zoom_factor: float = 1
@export var big_min_zoom_offset: float = -0.1
@export var big_max_zoom_offset: float = -0.04
@export var big_pulse_frequency: float = 0.15

@export var small_speed: float = 0.2
@export var small_speed2: float = 0.001
@export var small_trans_offset: float = 0.3
@export var small_pixelation: float = 10000
@export var small_noise_scale: float = 0.3
@export var small_dither_scale: Vector2 = Vector2(4, 4)
@export var small_base_scale: Vector2 = Vector2(8, 8)
@export var small_dir: Vector2 = Vector2(-0.25, -0.5)
@export var small_dir2: Vector2 = Vector2(0.25, 0)
@export var small_true_alpha: bool = false
@export var small_rot_speed: float = 0.25
@export var small_texture_size: Vector2 = Vector2(94, 93)
@export var small_zoom_factor: float = 1
@export var small_min_zoom_offset: float = -0.3
@export var small_max_zoom_offset: float = -0.1
@export var small_pulse_frequency: float = 0.15

func _ready():
	set_process(true)

func _process(delta):
	return
	# todo: need to reference the shaders, not the nodes- 
	$big.speed = big_speed
	$bigShadow.speed = big_speed
	$big.speed2 = big_speed2
	$bigShadow.speed2 = big_speed2
	update_big_properties()
	update_small_properties()
	snap_to_pixel_grid($big)
	snap_to_pixel_grid($bigShadow)
	snap_to_pixel_grid($small)
	snap_to_pixel_grid($smallShadow)

func update_big_properties():
	$big.trans_offset = big_trans_offset
	$bigShadow.trans_offset = big_trans_offset
	$big.pixelation = big_pixelation
	$bigShadow.pixelation = big_pixelation
	$big.noise_scale = big_noise_scale
	$bigShadow.noise_scale = big_noise_scale
	$big.dither_scale = big_dither_scale
	$bigShadow.dither_scale = big_dither_scale
	$big.base_scale = big_base_scale
	$bigShadow.base_scale = big_base_scale
	$big.dir = big_dir
	$bigShadow.dir = big_dir
	$big.dir2 = big_dir2
	$bigShadow.dir2 = big_dir2
	$big.true_alpha = big_true_alpha
	$bigShadow.true_alpha = big_true_alpha
	$big.rot_speed = big_rot_speed
	$bigShadow.rot_speed = big_rot_speed
	$big.texture_size = big_texture_size
	$bigShadow.texture_size = big_texture_size
	$big.zoom_factor = big_zoom_factor
	$bigShadow.zoom_factor = big_zoom_factor
	$big.min_zoom_offset = big_min_zoom_offset
	$bigShadow.min_zoom_offset = big_min_zoom_offset
	$big.max_zoom_offset = big_max_zoom_offset
	$bigShadow.max_zoom_offset = big_max_zoom_offset
	$big.pulse_frequency = big_pulse_frequency
	$bigShadow.pulse_frequency = big_pulse_frequency

func update_small_properties():
	$small.trans_offset = small_trans_offset
	$smallShadow.trans_offset = small_trans_offset
	$small.pixelation = small_pixelation
	$smallShadow.pixelation = small_pixelation
	$small.noise_scale = small_noise_scale
	$smallShadow.noise_scale = small_noise_scale
	$small.dither_scale = small_dither_scale
	$smallShadow.dither_scale = small_dither_scale
	$small.base_scale = small_base_scale
	$smallShadow.base_scale = small_base_scale
	$small.dir = small_dir
	$smallShadow.dir = small_dir
	$small.dir2 = small_dir2
	$smallShadow.dir2 = small_dir2
	$small.true_alpha = small_true_alpha
	$smallShadow.true_alpha = small_true_alpha
	$small.rot_speed = small_rot_speed
	$smallShadow.rot_speed = small_rot_speed
	$small.texture_size = small_texture_size
	$smallShadow.texture_size = small_texture_size
	$small.zoom_factor = small_zoom_factor
	$smallShadow.zoom_factor = small_zoom_factor
	$small.min_zoom_offset = small_min_zoom_offset
	$smallShadow.min_zoom_offset = small_min_zoom_offset
	$small.max_zoom_offset = small_max_zoom_offset
	$smallShadow.max_zoom_offset = small_max_zoom_offset
	$small.pulse_frequency = small_pulse_frequency
	$smallShadow.pulse_frequency = small_pulse_frequency

func snap_to_pixel_grid(sprite):
	var gridSize = $bkg.texture.get_size()
	sprite.position.x = round(sprite.position.x / gridSize.x) * gridSize.x
	sprite.position.y = round(sprite.position.y / gridSize.y) * gridSize.y
