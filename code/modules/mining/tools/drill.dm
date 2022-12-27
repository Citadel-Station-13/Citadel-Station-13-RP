/**
 * mining drills
 *
 * click on rock, continuously drill until rock breaks or it stops working.
 */
/obj/item/drill
	name = "drill"
	desc = "A hand-held mining drill."
	#warn icon
	#warn sound/soundloop
	#warn w_clsas, force, throw force, etc

	/// currently drilling
	var/drilling = FALSE

	/// excavation depth per second
	var/excavation_speed = EXCAVATION_DEPTH_DEFAULT
	/// excavation hardness
	var/excavation_hardness = EXCAVATION_HARDNESS_DEFAULT
	/// excavation flags
	var/excavation_flags = EXCAVATION_OP_COURSE | EXCAVATION_OP_PULVERIZING

/obj/item/drill/examine(mob/user)
	. = ..()
	. += SPAN_NOTICE("Click on something able to be excavated in non-help to start drilling; You must remain still during the procedure, and can only drill one thing at a time.")

/obj/item/drill/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	. = ..()

/obj/item/drill/proc/drill(atom/target, mob/user)

/**
 * called to check if we can keep drilling
 *
 * @params
 * - target - what we're drilling
 * - user - driller
 * - interval - deciseconds of this operation
 */
/obj/item/drill/proc/can_drill(atom/target, mob/user, interval)


/obj/item/drill/proc/do_drill(atom/target, mob/user, depth)
	#warn impl

#warn some kind of default use power system??? we don't want to snowflake cells, but how?
