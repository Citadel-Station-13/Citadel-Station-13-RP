/turf/unsimulated
	name = "command"

	//air_status = AIR_STATUS_IMMUTABLE

	initial_gas_mix = GAS_STRING_STP

/turf/unsimulated/Initialize(mapload)
	flags |= INITIALIZED
	return INITIALIZE_HINT_NORMAL

//VOREStation Add
/turf/unsimulated/fake_space
	name = "\proper space"
	icon = 'icons/turf/space.dmi'
	icon_state = "0"
	dynamic_lighting = FALSE

/turf/unsimulated/fake_space/New()
	..()
	icon_state = "[((x + y) ^ ~(x * y) + z) % 25]"

//VOREStation Add End

// Better nip this just in case.
/turf/unsimulated/rcd_values(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	return FALSE

/turf/unsimulated/rcd_act(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	return FALSE
