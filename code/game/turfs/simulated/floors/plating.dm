
/turf/simulated/floor/plating
	name = "plating"
	icon_state = "plating"
	base_icon_state = "plating"
	overfloor_placed = FALSE
	underfloor_accessibility = UNDERFLOOR_INTERACTABLE
	baseturfs = /turf/baseturf_bottom
	footstep = FOOTSTEP_PLATING
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

	var/attachment_holes = TRUE

	/// If true, will allow tiles to replace us if the tile [wants to] [/obj/item/stack/tile/var/replace_plating].
	/// And if our baseturfs are compatible.
	/// See [/obj/item/stack/tile/proc/place_tile].
	var/allow_replacement = TRUE

/turf/simulated/floor/plating/external
	outdoors = TRUE
/*
/turf/simulated/floor/plating/setup_broken_states()
	return list("platingdmg1", "platingdmg2", "platingdmg3")

/turf/simulated/floor/plating/setup_burnt_states()
	return list("panelscorched")
*/

/turf/simulated/floor/plating/examine(mob/user)
	. = ..()
	if(broken || burnt)
		. += SPAN_NOTICE("It looks like the dents could be <i>welded</i> smooth.")
		return
	if(attachment_holes)
		. += SPAN_NOTICE("There are a few attachment holes for a new <i>tile</i> or reinforcement <i>rods</i>.")
	else
		. += SPAN_NOTICE("You might be able to build ontop of it with some <i>tiles</i>...")

/turf/simulated/floor/plating/make_plating(force = FALSE)
	return

/turf/simulated/floor/plating/foam
	name = "metal foam plating"
	desc = "Thin, fragile flooring created with metal foam."
	icon_state = "foam_plating"

/turf/simulated/floor/plating/foam/burn_tile()
	return //jetfuel can't melt steel foam

/turf/simulated/floor/plating/foam/break_tile()
	return //jetfuel can't break steel foam...
