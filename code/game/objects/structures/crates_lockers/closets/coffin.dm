/obj/structure/closet/coffin
	name = "coffin"
	desc = "It's a burial receptacle for the dearly departed."
	icon_state = "coffin"
	icon_closed = "coffin"
	icon_opened = "coffin_open"
	seal_tool = /obj/item/tool/screwdriver
	breakout_sound = 'sound/weapons/tablehit1.ogg'

/obj/structure/closet/coffin/comfy
	name = "extra comfortable coffin"
	desc = "It's a burial receptacle for the dearly departed. This one has been modified with new upholstery to make it more comfortable to lay in."

/obj/structure/closet/coffin/update_icon()
	if(!opened)
		icon_state = icon_closed
	else
		icon_state = icon_opened

/* Graves */
/obj/structure/closet/grave
	name = "grave"
	desc = "Dirt."
	icon_state = "grave"
	icon_closed = "grave"
	icon_opened = "grave_open"
	seal_tool = null
	breakout_sound = 'sound/weapons/thudswoosh.ogg'
	anchored = 1
	max_closets = 1
	opened = 1

/obj/structure/closet/grave/attack_hand(mob/user as mob)
	if(opened)
		visible_message(SPAN_NOTICE("[user] starts to climb into \the [src.name]."), \
						SPAN_NOTICE("You start to lower yourself into \the [src.name]."))
		if(do_after(user, 50))
			user.forceMove(src.loc)
			visible_message(SPAN_NOTICE("[user] climbs into \the [src.name]."), \
							SPAN_NOTICE("You climb into \the [src.name]."))
		else
			visible_message(SPAN_NOTICE("[user] decides not to climb into \the [src.name]."), \
							SPAN_NOTICE("You stop climbing into \the [src.name]."))
	return

/obj/structure/closet/grave/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(opened && ismob(mover))
		var/mob/M = mover
		add_fingerprint(M)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H.m_intent == "walk")
				to_chat(H, SPAN_WARNING("You stop at the edge of \the [src.name]."))
				return FALSE
			else
				to_chat(H, SPAN_WARNING("You fall into \the [src.name]!"))
				fall_in(H)
				return TRUE
		if(isrobot(M))
			var/mob/living/silicon/robot/R = M
			if(R.a_intent == INTENT_HELP)
				to_chat(R, SPAN_WARNING("You stop at the edge of \the [src.name]."))
				return FALSE
			else
				to_chat(R, SPAN_WARNING("You enter \the [src.name]."))
				return TRUE
	return TRUE	//Everything else can move over the graves

/obj/structure/closet/grave/proc/fall_in(mob/living/L)	//Only called on humans for now, but still
	L.Weaken(5)
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		var/limb_damage = rand(5,25)
		H.adjustBruteLoss(limb_damage)

/obj/structure/closet/grave/attackby(obj/item/W as obj, mob/user as mob)
	if(src.opened)
		if(istype(W, /obj/item/shovel))
			user.visible_message(SPAN_NOTICE("[user] piles dirt into \the [src.name]."), \
								 SPAN_NOTICE("You start to pile dirt into \the [src.name]."), \
								 SPAN_NOTICE("You hear dirt being moved."))
			if(do_after(user, 40 * W.tool_speed))
				user.visible_message(SPAN_NOTICE("[user] pats down the dirt on top of \the [src.name]."), \
								 SPAN_NOTICE("You finish filling in \the [src.name]."))
				close()
				return
			else
				user.visible_message(SPAN_NOTICE("[user] stops filling in \the [src.name]."), \
								 SPAN_NOTICE("You change your mind and stop filling in \the [src.name]."))
				return
		if(istype(W, /obj/item/grab))
			var/obj/item/grab/G = W
			src.MouseDroppedOn(G.affecting, user)      //act like they were dragged onto the closet
			return 0
		if(istype(W,/obj/item/tk_grab))
			return 0
		if(istype(W, /obj/item/storage/laundry_basket) && W.contents.len)
			var/obj/item/storage/laundry_basket/LB = W
			var/turf/T = get_turf(src)
			for(var/obj/item/I in LB.contents)
				LB.remove_from_storage(I, T)
			user.visible_message(SPAN_NOTICE("[user] empties \the [LB] into \the [src]."), \
								 SPAN_NOTICE("You empty \the [LB] into \the [src]."), \
								 SPAN_NOTICE("You hear rustling of clothes."))
			return
		if(isrobot(user))
			return
		if(W.loc != user) // This should stop mounted modules ending up outside the module.
			return
		user.transfer_item_to_loc(W, src, 			user.transfer_item_to_loc(W, src, INV_OP_FORCE)
)
	else
		if(istype(W, /obj/item/shovel))
			if(user.a_intent == INTENT_HARM)	// Hurt intent means you're trying to kill someone, or just get rid of the grave
				user.visible_message(SPAN_NOTICE("[user] begins to smoothe out the dirt of \the [src.name]."), \
									 SPAN_NOTICE("You start to smoothe out the dirt of \the [src.name]."), \
									 SPAN_NOTICE("You hear dirt being moved."))
				if(do_after(user, 40 * W.tool_speed))
					user.visible_message(SPAN_NOTICE("[user] finishes smoothing out \the [src.name]."), \
										 SPAN_NOTICE("You finish smoothing out \the [src.name]."))
					if(LAZYLEN(contents))
						alpha = 40	// If we've got stuff inside, like maybe a person, just make it hard to see us
					else
						qdel(src)	// Else, go away
					return
				else
					user.visible_message(SPAN_NOTICE("[user] stops concealing \the [src.name]."), \
										 SPAN_NOTICE("You stop concealing \the [src.name]."))
					return
			else
				user.visible_message(SPAN_NOTICE("[user] begins to unearth \the [src.name]."), \
									 SPAN_NOTICE("You start to unearth \the [src.name]."), \
									 SPAN_NOTICE("You hear dirt being moved."))
				if(do_after(user, 40 * W.tool_speed))
					user.visible_message(SPAN_NOTICE("[user] reaches the bottom of \the [src.name]."), \
										 SPAN_NOTICE("You finish digging out \the [src.name]."))
					break_open()
					return
				else
					user.visible_message(SPAN_NOTICE("[user] stops digging out \the [src.name]."), \
										 SPAN_NOTICE("You stop digging out \the [src.name]."))
					return
	return

/obj/structure/closet/grave/close()
	..()
	if(!opened)
		sealed = TRUE

/obj/structure/closet/grave/open()
	.=..()
	alpha = 255	// Needed because of grave hiding

/obj/structure/closet/grave/bullet_act(var/obj/item/projectile/P)
	return PROJECTILE_CONTINUE	// It's a hole in the ground, doesn't usually stop or even care about bullets

/obj/structure/closet/grave/return_air_for_internal_lifeform(var/mob/living/L)
	var/gasid = /datum/gas/carbon_dioxide
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(H.species && H.species.exhale_type)
			gasid = H.species.exhale_type
	var/datum/gas_mixture/grave_breath = new()
	var/datum/gas_mixture/above_air = return_air()
	grave_breath.adjust_gas(gasid, BREATH_MOLES)
	grave_breath.temperature = (above_air.temperature) - 30	//Underground
	return grave_breath
