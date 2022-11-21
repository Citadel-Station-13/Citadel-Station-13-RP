//holographic signs and barriers

/obj/structure/holosign
	name = "holo sign"
	icon = 'icons/effects/effects.dmi'
	anchored = TRUE
	max_integrity = 1
	var/obj/item/holosign_creator/projector
	var/use_vis_overlay = TRUE

/obj/structure/holosign/Initialize(mapload, source_projector)
	. = ..()
	if(use_vis_overlay)
		alpha = 0
		SSvis_overlays.add_vis_overlay(src, icon, icon_state, ABOVE_MOB_LAYER, GAME_PLANE_UPPER, dir, add_appearance_flags = RESET_ALPHA) //you see mobs under it, but you hit them like they are above it
	if(source_projector)
		projector = source_projector
		LAZYADD(projector.signs, src)

/obj/structure/holosign/Destroy()
	if(projector)
		LAZYREMOVE(projector.signs, src)
		projector = null
	return ..()

/obj/structure/holosign/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	user.do_attack_animation(src)
	take_damage(5, BRUTE, "melee", 1)
	playsound(loc, 'sound/weapons/egloves.ogg', 80, TRUE)

/obj/structure/holosign/wetsign
	name = "wet floor sign"
	desc = "The words flicker as if they mean nothing."
	icon = 'icons/effects/effects.dmi'
	icon_state = "holosign"

/obj/structure/holosign/barrier
	name = "holobarrier"
	desc = "A short holographic barrier which can only be passed by walking."
	icon_state = "holosign_sec"
	pass_flags_self = ATOM_PASS_TABLE | ATOM_PASS_GRILLE | ATOM_PASS_GLASS | ATOM_PASS_THROWN
	density = TRUE
	max_integrity = 20
	var/allow_walk = TRUE //can we pass through it on walk intent

/obj/structure/holosign/barrier/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(.)
		return
	if(iscarbon(mover))
		var/mob/living/carbon/C = mover
		if(C.stat) // Lets not prevent dragging unconscious/dead people.
			return TRUE
		if(allow_walk && C.m_intent == MOVE_INTENT_WALK)
			return TRUE

/obj/structure/holosign/barrier/wetsign
	name = "wet floor holobarrier"
	desc = "When it says walk it means walk."
	icon = 'icons/effects/effects.dmi'
	icon_state = "holosign"

/obj/structure/holosign/barrier/wetsign/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(iscarbon(mover))
		var/mob/living/carbon/C = mover
		if(C.stat) // Lets not prevent dragging unconscious/dead people.
			return TRUE
		if(allow_walk && C.m_intent != MOVE_INTENT_WALK)
			return FALSE

/obj/structure/holosign/barrier/combifan
	name = "holo combifan"
	desc = "A holographic barrier resembling a blue-accented tiny fan. Though it does not prevent solid objects from passing through, gas and temperature changes are kept out."
	icon_state = "holo_combifan"
	anchored = TRUE
	density = FALSE
	CanAtmosPass = ATMOS_PASS_AIR_BLOCKED
	layer = ABOVE_TURF_LAYER
	alpha = 150
