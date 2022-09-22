// Items that ask to be called every cycle.
var/global/datum/datacore/data_core = null
var/global/list/processing_machines      = list()	// TODO - Move into SSmachines
var/global/list/processing_power_items   = list()	// TODO - Move into SSmachines
var/global/list/hud_icon_reference       = list()


var/global/list/global_mutations  = list() // List of hidden mutation things.

var/global/datum/universal_state/universe = new

// Noises made when hit while typing.
var/list/hit_appends	= list("-OOF", "-ACK", "-UGH", "-HRNK", "-HURGH", "-GLORF")
// var/station_name		= "Northern Star"
// var/const/station_orig	= "Northern Star" //station_name can't be const due to event prefix/suffix
// var/const/station_short	= "Northern Star"
// var/const/dock_name		= "Vir Interstellar Spaceport"
// var/const/boss_name		= "Central Command"
// var/const/boss_short	= "CentCom"
// var/const/company_name	= "NanoTrasen"
// var/const/company_short	= "NT"
// var/const/star_name		= "Vir"
// var/const/starsys_name	= "Vir"
var/const/game_version	= "Citadel Station RP"
var/game_year			= (text2num(time2text(world.realtime, "YYYY")) + 544)

var/master_mode       = "extended" // "extended"
var/secret_force_mode = "secret"   // if this is anything but "secret", the secret rotation will forceably choose this mode.

var/host = null //only here until check @ code\modules\ghosttrap\trap.dm:112 is fixed

var/list/jobMax        = list()
var/list/bombers       = list()
var/list/admin_log     = list()
var/list/lastsignalers = list() // Keeps last 100 signals here in format: "[src] used \ref[src] @ location [src.loc]: [freq]/[code]"
var/list/lawchanges    = list() // Stores who uploaded laws to which silicon-based lifeform, and what the law was.
var/list/reg_dna       = list()

var/mouse_respawn_time = 5 // Amount of time that must pass between a player dying as a mouse and repawning as a mouse. In minutes.

var/list/monkeystart     = list()
var/list/wizardstart     = list()
var/list/newplayer_start = list()

var/list/prisonwarp         = list() // Prisoners go to these
var/list/holdingfacility    = list() // Captured people go here
var/list/xeno_spawn         = list() // Aliens spawn at at these.
var/list/tdome1             = list()
var/list/tdome2             = list()
var/list/tdomeobserve       = list()
var/list/tdomeadmin         = list()
var/list/prisonsecuritywarp = list() // Prison security goes to these.
var/list/prisonwarped       = list() // List of players already warped.
var/list/blobstart          = list()
var/list/ninjastart         = list()

var/datum/configuration_legacy/config_legacy      = null

var/list/combatlog = list()
var/list/IClog     = list()
var/list/OOClog    = list()
var/list/adminlog  = list()

var/list/powernets = list()	// TODO - Move into SSmachines

var/gravity_is_on = 1

var/join_motd = null

var/datum/metric/metric = new() // Metric datum, used to keep track of the round.

var/list/awaydestinations = list() // Away missions. A list of landmarks that the warpgate can take you to.

// For FTP requests. (i.e. downloading runtime logs.)
// However it'd be ok to use for accessing attack logs and such too, which are even laggier.
var/fileaccess_timer = 0
var/custom_event_msg = null

// Added for Xenoarchaeology, might be useful for other stuff.
var/global/list/alphabet_uppercase = list("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z")


// Used by robots and robot preferences.
var/list/robot_module_types = list(
	"Standard", "Engineering", "Medical",
	"Miner",    "Janitor",     "Service",
	"Clerical", "Security",    "Research"
)

// Some scary sounds.
var/static/list/scarySounds = list(
	'sound/weapons/thudswoosh.ogg',
	'sound/weapons/Taser.ogg',
	'sound/weapons/armbomb.ogg',
	'sound/voice/hiss1.ogg',
	'sound/voice/hiss2.ogg',
	'sound/voice/hiss3.ogg',
	'sound/voice/hiss4.ogg',
	'sound/voice/hiss5.ogg',
	'sound/voice/hiss6.ogg',
	'sound/effects/Glassbr1.ogg',
	'sound/effects/Glassbr2.ogg',
	'sound/effects/Glassbr3.ogg',
	'sound/items/Welder.ogg',
	'sound/items/Welder2.ogg',
	'sound/machines/airlock.ogg',
	'sound/effects/clownstep1.ogg',
	'sound/effects/clownstep2.ogg'
)

// Bomb cap!
var/max_explosion_range = 14

//Keyed list for caching icons so you don't need to make them for records, IDs, etc all separately.
//Could be useful for AI impersonation or something at some point?
var/static/list/cached_character_icons = list()

//! ## VR FILE MERGE ## !//

/hook/startup/proc/modules_vr()
	robot_module_types += "Medihound"
	robot_module_types += "K9"
	robot_module_types += "Janihound"
	robot_module_types += "Sci-Hound"
	robot_module_types += "Pupdozer"
	return 1

var/list/shell_module_types = list(
	"Standard", "Service", "Clerical"
)

var/list/eventdestinations = list() // List of scatter landmarks for event portals

var/global/list/acceptable_fruit_types = list(
	"ambrosia",
	"apple",
	"banana",
	"berries",
	"cabbage",
	"carrot",
	"celery",
	"cherry",
	"chili",
	"cocoa",
	"corn",
	"durian",
	"eggplant",
	"grapes",
	"greengrapes",
	"harebells",
	"jahtak",
	"lavender",
	"lemon",
	"lettuce",
	"lime",
	"onion",
	"orange",
	"peanut",
	"poppies",
	"potato",
	"pumpkin",
	"pyrrhlea",
	"rice",
	"rose",
	"rhubarb",
	"soybean",
	"spineapple",
	"sugarcane",
	"sunflowers",
	"tomato",
	"vanilla",
	"watermelon",
	"wheat",
	"whitebeet",
	)

var/global/list/acceptable_nectar_types= list(
	"waxcomb (honey)",
	)
