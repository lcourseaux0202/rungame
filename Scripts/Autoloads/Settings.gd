extends Node

var max_sections = 100
var level_length = 20000
var xp_gain_per_orb = 10

enum GAMEMODE{
	SOLO,
	MULTIPLAYER
}

var selected_skins = {
	1 : null,
	2 : null,
	3 : null,
	4 : null,
}
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
