extends Node

const LAST_LEVEL_LENGTH := 500000
var max_sections := 100
var xp_gain_per_orb := 5
var number_of_levels := 30

enum GAMEMODE{
	SOLO,
	MULTIPLAYER
}

signal skin_changed(player_id : int, skin : SkinData)
var selected_skins = [null, null]

var default_skin := "res://Resources/Skins/Glacier.tres"

var gamemode : GAMEMODE = GAMEMODE.SOLO
var number_of_players = 2

const DEFAULT_WORLD_COLOR : Color = Color.WHITE
const DEFAULT_RAIL_COLOR : Color = Color.AQUA

var world_color : Color = DEFAULT_WORLD_COLOR
var rail_color : Color = DEFAULT_RAIL_COLOR

var resolutions = {
	"1920x1080" : Vector2(1920, 1080),
	"1600x900" : Vector2(1600, 900),
	"1360x768" : Vector2(1360, 768),
	"1280x720" : Vector2(1280, 720),
}

func set_selected_skin(player_id: int, skin: SkinData) -> void:
	selected_skins[player_id] = skin
	skin_changed.emit(player_id, skin)

func is_gamemode_solo():
	return gamemode == GAMEMODE.SOLO
	
func is_gamemode_multi():
	return gamemode == GAMEMODE.MULTIPLAYER
	
