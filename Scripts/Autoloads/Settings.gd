extends Node

var max_sections = 100
var level_length = 50000
var xp_gain_per_orb = 10

enum GAMEMODE{
	SOLO,
	MULTIPLAYER
}

var gamemode : GAMEMODE = GAMEMODE.SOLO
var number_of_players = 2

const CHARACTER_COLOR : Color = Color.WHITE
const AURA_COLOR : Color = Color.AQUA
const WORLD_COLOR : Color = Color.WHITE
const RAIL_COLOR : Color = Color.AQUA

var character_color : Color = CHARACTER_COLOR
var aura_color : Color = AURA_COLOR
var world_color : Color = WORLD_COLOR
var rail_color : Color = RAIL_COLOR


var resolutions = {
	"1920x1080" : Vector2(1920, 1080),
	"1600x900" : Vector2(1600, 900),
	"1360x768" : Vector2(1360, 768),
	"1280x720" : Vector2(1280, 720),
}
