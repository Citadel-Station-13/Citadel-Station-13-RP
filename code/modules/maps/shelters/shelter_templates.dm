/datum/map_template/shelter
	id = "shelter_"
	var/blacklisted_turfs
	var/whitelisted_turfs
	var/banned_areas
	var/banned_objects
	var/check_anchored_objects = TRUE
	var/roof

/datum/map_template/shelter/New()
	. = ..()
	blacklisted_turfs = typecacheof(/turf/unsimulated)
	whitelisted_turfs = list()
	banned_areas = typecacheof(/area/shuttle)
	banned_objects = list()

/datum/map_template/shelter/proc/check_deploy(turf/deploy_location)
	var/affected = get_affected_turfs(deploy_location, centered=TRUE)
	for(var/turf/T in affected)
		var/area/A = get_area(T)
		if(is_type_in_typecache(A, banned_areas))
			return SHELTER_DEPLOY_BAD_AREA

		var/banned = is_type_in_typecache(T, blacklisted_turfs)
		var/permitted = !length(whitelisted_turfs) || is_type_in_typecache(T, whitelisted_turfs)
		if(banned && !permitted)
			return SHELTER_DEPLOY_BAD_TURFS

		if(check_anchored_objects)
			for(var/obj/O in T)
				if((O.density && O.anchored) || is_type_in_typecache(O, banned_objects))
					return SHELTER_DEPLOY_ANCHORED_OBJECTS
	return SHELTER_DEPLOY_ALLOWED

/datum/map_template/shelter/alpha
	name = "Shelter Alpha"
	id = "shelter_alpha"
	desc = "A cosy self-contained pressurized shelter, with \
		built-in navigation, entertainment, medical facilities and a \
		sleeping area! Order now, and we'll throw in a TINY FAN, \
		absolutely free!"
	mappath = "_maps/shelter_templates/shelter_1.dmm"
	roof = "shelter_alpha_roof"

/datum/map_template/shelter/alpha_roof
	id = "shelter_alpha_roof"
	mappath = "_maps/shelter_templates/shelter_1_roof.dmm"

/datum/map_template/shelter/alpha/New()
	. = ..()
	whitelisted_turfs = typecacheof(/turf/simulated/mineral)
	banned_objects = list()

/datum/map_template/shelter/beta
	name = "Shelter Beta"
	id = "shelter_beta"
	desc = "An extremely luxurious shelter, containing all \
		the amenities of home, including carpeted floors, hot and cold \
		running water, a gourmet three course meal, cooking facilities, \
		and a deluxe companion to keep you from getting lonely during \
		an ash storm."
	mappath = "_maps/shelter_templates/shelter_2.dmm"
	roof = "shelter_beta_roof"

/datum/map_template/shelter/beta_roof
	id = "shelter_beta_roof"
	mappath = "_maps/shelter_templates/shelter_2_roof.dmm"

/datum/map_template/shelter/beta/New()
	. = ..()
	whitelisted_turfs = typecacheof(/turf/simulated/mineral)
	banned_objects = list()
