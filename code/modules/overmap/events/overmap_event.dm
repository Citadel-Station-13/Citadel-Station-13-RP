/*
** /obj/effect/overmap/event - Actual instances of event hazards on the overmap map
*/
// TO-DO: We need to find a way to get BSAs ported or something to make weaknesses work so crew have a chance to *fight* tiles later - Enzo 9/9/2020
// We don't subtype /obj/effect/overmap/visitable because that'll create sections one can travel to
//	 and with them "existing" on the overmap Z-level things quickly get odd.
/obj/effect/overmap/event
	name = "event"
	icon = 'icons/obj/overmap.dmi'
	icon_state = "event"
	opacity = 1
	var/list/events							// List of event datum paths
	var/list/event_icon_states				// Randomly picked from
	var/difficulty = EVENT_LEVEL_MODERATE
	var/weaknesses		// If the BSA can destroy them and with what
	var/list/victims	// Basically cached events on which Z level
	color = COLOR_WHITE

/obj/effect/overmap/event/Initialize()
	. = ..()
	icon_state = pick(event_icon_states)
	GLOB.overmap_event_handler.update_hazards(loc)

/obj/effect/overmap/event/Move()
	var/turf/old_loc = loc
	. = ..()
	if(.)
		GLOB.overmap_event_handler.update_hazards(old_loc)
		GLOB.overmap_event_handler.update_hazards(loc)

/obj/effect/overmap/event/forceMove(atom/destination)
	var/old_loc = loc
	. = ..()
	if(.)
		GLOB.overmap_event_handler.update_hazards(old_loc)
		GLOB.overmap_event_handler.update_hazards(loc)

/obj/effect/overmap/event/Destroy()	// Takes a look at this one as well, make sure everything is A-OK
	var/turf/T = loc
	. = ..()
	GLOB.overmap_event_handler.update_hazards(T)

//
// Definitions for specific types!
//

/obj/effect/overmap/event/meteor
	name = "asteroid field"
	events = list(/datum/event/meteor_wave/overmap)
	event_icon_states = list("meteor1", "meteor2", "meteor3", "meteor4")
	color = "#DD4444"
	difficulty = EVENT_LEVEL_MAJOR
	weaknesses = OVERMAP_WEAKNESS_MINING | OVERMAP_WEAKNESS_EXPLOSIVE

/obj/effect/overmap/event/electric
	name = "electrical storm"
	events = list(/datum/event/electrical_storm/overmap)
	color = "#EEEEEE"
	opacity = 0
	event_icon_states = list("electrical1", "electrical2", "electrical3", "electrical4")
	difficulty = EVENT_LEVEL_MAJOR
	weaknesses = OVERMAP_WEAKNESS_EMP

/obj/effect/overmap/event/dust
	name = "dust cloud"
	events = list(/datum/event/dust/overmap)
	event_icon_states = list("dust1", "dust2", "dust3", "dust4")
	color = "#EEEEEE"
	weaknesses = OVERMAP_WEAKNESS_MINING | OVERMAP_WEAKNESS_EXPLOSIVE | OVERMAP_WEAKNESS_FIRE

/obj/effect/overmap/event/ion
	name = "ion cloud"
	events = list(/datum/event/ionstorm/overmap)
	opacity = 0
	event_icon_states = list("ion1", "ion2", "ion3", "ion4")
	color = "#EEEEEE"
	difficulty = EVENT_LEVEL_MAJOR
	weaknesses = OVERMAP_WEAKNESS_EMP

/obj/effect/overmap/event/carp
	name = "carp shoal"
	events = list(/datum/event/carp_migration/overmap)
	opacity = 0
	event_icon_states = list("carp1", "carp2")
	color = "#EEEEEE"
	difficulty = EVENT_LEVEL_MODERATE
	weaknesses = OVERMAP_WEAKNESS_EXPLOSIVE | OVERMAP_WEAKNESS_FIRE

/obj/effect/overmap/event/carp_heavy
	name = "carp school"
	events = list(/datum/event/carp_migration/overmap)
	opacity = 0
	event_icon_states = list("carp3", "carp4")
	color = "#DD4444"
	difficulty = EVENT_LEVEL_MAJOR
	weaknesses = OVERMAP_WEAKNESS_EXPLOSIVE | OVERMAP_WEAKNESS_FIRE

/obj/effect/overmap/event/hostile_migration
	name = "unknown lifesigns"
	events = list(/datum/event/hostile_migration/overmap)
	opacity = 0
	event_icon_states = list("rats1", "rats2")
	color = "#DD4444"
	difficulty = EVENT_LEVEL_MODERATE
	weaknesses = OVERMAP_WEAKNESS_EXPLOSIVE | OVERMAP_WEAKNESS_FIRE

/obj/effect/overmap/event/communications_blackout
	name = "Ionspheric Bubble"
	events = list(/datum/event/communications_blackout/overmap)
	opacity = 1
	event_icon_states = list("comout1")
	color = "#EEEEEE"
	difficulty = EVENT_LEVEL_MODERATE
	weaknesses = OVERMAP_WEAKNESS_EMP

/obj/effect/overmap/event/cult
	name = "eerie signals"
	events = list(/datum/event/cult/overmap)
	opacity = 0
	event_icon_states = list("cultist","cultist2")
	color = "#DD4444"
	difficulty = EVENT_LEVEL_MAJOR
	weaknesses = OVERMAP_WEAKNESS_FIRE
