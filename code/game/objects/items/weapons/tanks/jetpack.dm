//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/tank/jetpack
	name = "jetpack (empty)"
	desc = "A tank of compressed gas for use as propulsion in zero-gravity areas. Use with caution."
	icon_state = "jetpack"
	gauge_icon = null
	w_class = ITEMSIZE_LARGE
	item_icons = list(
			SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_storage.dmi',
			SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_storage.dmi',
			)
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "jetpack", SLOT_ID_LEFT_HAND = "jetpack")
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	var/datum/effect_system/ion_trail_follow/ion_trail
	var/on = 0.0
	var/stabilization_on = 0
	var/volume_rate = 500              //Needed for borg jetpack transfer
	action_button_name = "Toggle Jetpack"

/obj/item/tank/jetpack/Initialize(mapload)
	. = ..()
	ion_trail = new /datum/effect_system/ion_trail_follow()
	ion_trail.set_up(src)

/obj/item/tank/jetpack/Destroy()
	QDEL_NULL(ion_trail)
	return ..()

/obj/item/tank/jetpack/examine(mob/user)
	. = ..()
	if(air_contents.total_moles < 5)
		. += "<span class='danger'>The meter on \the [src] indicates you are almost out of gas!</span>"
		playsound(user, 'sound/effects/alert.ogg', 50, 1)

/obj/item/tank/jetpack/verb/toggle_rockets()
	set name = "Toggle Jetpack Stabilization"
	set category = "Object"
	stabilization_on = !( stabilization_on )
	to_chat(usr, "You toggle the stabilization [stabilization_on? "on":"off"].")

/obj/item/tank/jetpack/verb/toggle()
	set name = "Toggle Jetpack"
	set category = "Object"

	on = !on
	if(on)
		icon_state = "[icon_state]-on"
		ion_trail.start()
	else
		icon_state = initial(icon_state)
		ion_trail.stop()

	if (ismob(usr))
		var/mob/M = usr
		M.update_inv_back()
		M.update_action_buttons()

	to_chat(usr, "You toggle the thrusters [on? "on":"off"].")

/obj/item/tank/jetpack/proc/allow_thrust(num, mob/living/user as mob)
	if(!on)
		return 0
	if((num < 0.005 || air_contents.total_moles < num))
		ion_trail.stop()
		return 0

	var/datum/gas_mixture/G = air_contents.remove(num)

	var/allgases = G.gas[/datum/gas/carbon_dioxide] + G.gas[/datum/gas/nitrogen] + G.gas[/datum/gas/oxygen] + G.gas[/datum/gas/phoron]
	if(allgases >= 0.005)
		return 1

	qdel(G)
	return

/obj/item/tank/jetpack/ui_action_click()
	toggle()

/obj/item/tank/jetpack/void
	name = "void jetpack (oxygen)"
	desc = "It works well in a void."
	icon_state = "jetpack-void"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "jetpack-void", SLOT_ID_LEFT_HAND = "jetpack-void")

/obj/item/tank/jetpack/void/Initialize(mapload)
	. = ..()
	air_contents.adjust_gas(/datum/gas/oxygen, (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/tank/jetpack/oxygen
	name = "jetpack (oxygen)"
	desc = "A tank of compressed oxygen for use as propulsion in zero-gravity areas. Use with caution."
	icon_state = "jetpack"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "jetpack", SLOT_ID_LEFT_HAND = "jetpack")

/obj/item/tank/jetpack/oxygen/Initialize(mapload)
	. = ..()
	air_contents.adjust_gas(/datum/gas/oxygen, (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/tank/jetpack/carbondioxide
	name = "jetpack (carbon dioxide)"
	desc = "A tank of compressed carbon dioxide for use as propulsion in zero-gravity areas. Painted black to indicate that it should not be used as a source for internals."
	distribute_pressure = 0
	icon_state = "jetpack-black"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "jetpack-black", SLOT_ID_LEFT_HAND = "jetpack-black")

/obj/item/tank/jetpack/carbondioxide/Initialize(mapload)
	. = ..()
	air_contents.adjust_gas(/datum/gas/carbon_dioxide, (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/tank/jetpack/rig
	name = "jetpack"
	desc = "It's a jetpack. This description should not see the light of day (well, space-day.). If you can see this, report it on the bug tracker."
	var/obj/item/rig/holder

/obj/item/tank/jetpack/rig/allow_thrust(num, mob/living/user as mob)

	if(!(src.on))
		return 0

	if(!istype(holder) || !holder.air_supply)
		return 0

	var/obj/item/tank/pressure_vessel = holder.air_supply

	if((num < 0.005 || pressure_vessel.air_contents.total_moles < num))
		src.ion_trail.stop()
		return 0

	var/datum/gas_mixture/G = pressure_vessel.air_contents.remove(num)

	var/allgases = G.gas[/datum/gas/carbon_dioxide] + G.gas[/datum/gas/nitrogen] + G.gas[/datum/gas/oxygen] + G.gas[/datum/gas/phoron]
	if(allgases >= 0.005)
		return 1
	qdel(G)
	return

/obj/item/tank/jetpack/improvised
	name = "improvised jetpack"
	desc = "A jetpack made from two air tanks, a fire extinguisher and some atmospherics equipment. It doesn't look like it can hold much."
	icon_state = "jetpack-improvised"
	volume_rate = 5000
