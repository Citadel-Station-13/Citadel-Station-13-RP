//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/orbital_deployment_transit
	var/turf/target_lower_left
	var/target_orientation

	var/datum/map_reservation/reservation

	var/c_impact_obj_dmg_base
	var/c_impact_obj_dmg_sides
	var/c_impact_obj_dmg_cnt
	var/c_impact_mob_dmg_base
	var/c_impact_mob_dmg_sides
	var/c_impact_mob_dmg_cnt
	var/c_impact_mob_dmg_sides_for_those_without_plot_armor
	var/c_landing_obj_dmg_base
	var/c_landing_obj_dmg_sides
	var/c_landing_obj_dmg_cnt
	var/c_landing_mob_dmg_base
	var/c_landing_mob_dmg_sides
	var/c_landing_mob_dmg_cnt

/datum/orbital_deployment_transit/New(datum/orbital_deployment_zone/zone)
	src.c_impact_obj_dmg_base = zone.c_impact_obj_dmg_base
	src.c_impact_obj_dmg_sides = zone.c_impact_obj_dmg_sides
	src.c_impact_obj_dmg_cnt = zone.c_impact_obj_dmg_cnt
	src.c_impact_mob_dmg_base = zone.c_impact_mob_dmg_base
	src.c_impact_mob_dmg_sides = zone.c_impact_mob_dmg_sides
	src.c_impact_mob_dmg_cnt = zone.c_impact_mob_dmg_cnt
	src.c_landing_obj_dmg_base = zone.c_landing_obj_dmg_base
	src.c_landing_obj_dmg_sides = zone.c_landing_obj_dmg_sides
	src.c_landing_obj_dmg_cnt = zone.c_landing_obj_dmg_cnt
	src.c_landing_mob_dmg_base = zone.c_landing_mob_dmg_base
	src.c_landing_mob_dmg_sides = zone.c_landing_mob_dmg_sides
	src.c_landing_mob_dmg_cnt = zone.c_landing_mob_dmg_cnt

/datum/orbital_deployment_transit/proc/allocate_and_package(turf/lower_left, turf/upper_right)

/datum/orbital_deployment_transit/proc/land()

/datum/orbital_deployment_transit/proc/

#warn impl
