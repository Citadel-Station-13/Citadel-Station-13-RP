/*
** /datum/overmap_event - Descriptors of how/what to spawn during overmap event generation
*/

// These now are basically only used to spawn hazards. Will be useful when we need to spawn group of moving hazards
// Somethings weird with the numbers here that is causing NOTHING to spawn on our overmap and I am unsure if there's a second file we need to investigate to resolve this.
// I'm doing another slight number tweak to see if stuff spawns, but would like other eyes to check and see if there's something missing. - Enzo 9/8/2020
/datum/overmap_event
	var/name = "map event"
	var/radius = 2			// Radius of the spawn circle around chosen epicenter
	var/count = 6			// How many hazards to spawn
	var/hazards				// List (or single) typepath of hazard to spawn
	var/continuous = TRUE	// If it should form continous blob, or can have gaps

/datum/overmap_event/meteor
	name = "asteroid field"
	count = 15
	radius = 4
	continuous = FALSE
	hazards = /obj/effect/overmap/event/meteor

/datum/overmap_event/electric
	name = "electrical storm"
	count = 15
	radius = 4
	hazards = /obj/effect/overmap/event/electric

/datum/overmap_event/dust
	name = "dust cloud"
	count = 15
	radius = 3
	hazards = /obj/effect/overmap/event/dust

/datum/overmap_event/ion
	name = "ion cloud"
	count = 15
	radius = 3
	hazards = /obj/effect/overmap/event/ion

/datum/overmap_event/carp
	name = "carp shoal"
	count = 15
	radius = 4
	continuous = FALSE
	hazards = /obj/effect/overmap/event/carp

/datum/overmap_event/event/carp_heavy
	name = "carp school"
	count = 10
	radius = 3
	continuous = FALSE
	hazards = /obj/effect/overmap/event/carp_heavy

/datum/overmap_event/hostile_migration
	name = "hostile lifesigns"
	count = 10
	radius = 3
	continuous = FALSE
	hazards = /obj/effect/overmap/event/hostile_migration

/datum/overmap_event/communications_blackout
	name = "Ionspheric Bubble"
	count = 15
	radius = 4
	hazards = /obj/effect/overmap/event/communications_blackout

/datum/overmap_event/cult
	name = "Screaming Signal"
	count = 10
	radius = 3
	hazards = /obj/effect/overmap/event/cult