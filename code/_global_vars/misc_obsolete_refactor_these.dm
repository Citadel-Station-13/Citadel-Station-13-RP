GLOBAL_DATUM(data_core, /datum/datacore)
GLOBAL_DATUM_INIT(universe, /datum/universal_state, new)

GLOBAL_VAR_INIT(Debug2, FALSE)


GLOBAL_LIST_EMPTY(tagger_locations)

GLOBAL_DATUM_INIT(game_master, /datum/game_master, new)
GLOBAL_DATUM_INIT(metric, /datum/metric, new)

GLOBAL_LIST_EMPTY(awaydestinations)

GLOBAL_LIST_INIT(robot_module_types, list(
	"Standard",
	"Engineering",
	"Surgeon",
	"Crisis",
	"Miner",
	"Janitor",
	"Service",
	"Clerical",
	"Security",
	"Research"
))

// Some scary sounds.
GLOBAL_LIST_INIT(scarySounds, list(
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
))

// Announcer intercom, because too much stuff creates an intercom for one message then hard del()s it.
//THIS IS BAD AND YOU SHOULD FEEL BAD - KEVINZ000 - WHY DON'T THINGS JUST SPEAK THEMSELVES DAMNIT AAAAAAAAAAAAAAAAAAA OR AT LEAST ANCHOR THIS TO THE STATION OR SOMETHING!!
GLOBAL_DATUM_INIT(global_announcer, /obj/item/device/radio/intercom/omni, new)

GLOBAL_LIST_INIT(station_departments, list(
	"Command",
	"Medical",
	"Engineering",
	"Science",
	"Security",
	"Cargo",
	"Civilian"
))
