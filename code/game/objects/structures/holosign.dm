//holographic signs and barriers

/obj/structure/holosign
	name = "holo sign"
	icon = 'icons/effects/effects.dmi'
	anchored = TRUE
	var/obj/item/holosign_creator/projector
	var/health = 10
	explosion_resistance = 1

/obj/structure/holosign/Initialize(mapload, source_projector)
	. = ..()
	if(source_projector)
		projector = source_projector
		projector.signs += src
/*	if(overlays) // Fucking god damnit why do we have to have an entire different subsystem for this shit from other codebases.
		overlays.add_overlay(src, icon, icon_state, ABOVE_MOB_LAYER, plane, dir, alpha, RESET_ALPHA) //you see mobs under it, but you hit them like they are above it
		alpha = 0
*/

/obj/structure/holosign/Destroy()
	if(projector)
		projector.signs -= src
		projector = null
	return ..()

/obj/structure/holosign/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	user.do_attack_animation(src)
	take_damage(5, BRUTE, "melee", 1)
	playsound(loc, 'sound/weapons/egloves.ogg', 80, 1)

/obj/structure/holosign/wetsign
	name = "wet floor sign"
	desc = "The words flicker as if they mean nothing."
	icon = 'icons/effects/effects.dmi'
	icon_state = "holosign"

/obj/structure/holosign/barrier/combifan
	name = "holo combifan"
	desc = "A holographic barrier resembling a blue-accented tiny fan. Though it does not prevent solid objects from passing through, gas and temperature changes are kept out."
	icon_state = "holo_combifan"
	anchored = TRUE
	density = FALSE
	CanAtmosPass = ATMOS_PASS_AIR_BLOCKED
	layer = ABOVE_TURF_LAYER
	alpha = 150



