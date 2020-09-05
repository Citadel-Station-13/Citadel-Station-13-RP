/*
** /datum/overmap_event - Descriptors of how/what to spawn during overmap event generation
*/

// These now are basically only used to spawn hazards. Will be useful when we need to spawn group of moving hazards
/datum/overmap_event
	var/name = "map event"
	var/radius = 2			// Radius of the spawn circle around chosen epicenter
	var/count = 6			// How many hazards to spawn
	var/hazards				// List (or single) typepath of hazard to spawn
	var/continuous = TRUE	// If it should form continous blob, or can have gaps

/datum/overmap_event/meteor
	name = "asteroid field"
	count = 10
	radius = 4
	continuous = FALSE
	hazards = /obj/effect/overmap/event/meteor

/datum/overmap_event/electric
	name = "electrical storm"
	count = 20
	radius = 3
	hazards = /obj/effect/overmap/event/electric

/datum/overmap_event/dust
	name = "dust cloud"
	count = 40
	radius = 4
	hazards = /obj/effect/overmap/event/dust

/datum/overmap_event/ion
	name = "ion cloud"
	count = 20
	radius = 3
	hazards = /obj/effect/overmap/event/ion

/datum/overmap_event/carp
	name = "carp shoal"
	count = 20
	radius = 3
	continuous = FALSE
	hazards = /obj/effect/overmap/event/carp

/datum/overmap_event/event/carp_heavy
	name = "carp school"
	count = 20
	radius = 4
	continuous = FALSE
	hazards = /obj/effect/overmap/event/carp_heavy

/datum/overmap_event/hostile_migration
	name = "hostile lifesigns"
	count = 12
	radius = 2
	continuous = FALSE
	hazards = /obj/effect/overmap/event/hostile_migration

/datum/overmap_event/communications_blackout
	name = "Ionspheric Bubble"
	count = 12
	radius = 2
	hazards = /obj/effect/overmap/event/communications_blackout