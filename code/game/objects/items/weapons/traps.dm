// todo: rewrite this shitcode
/obj/item/beartrap
	name = "mechanical trap"
	throw_speed = 2
	throw_range = 1
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "beartrap0"
	desc = "A mechanically activated leg trap. Low-tech, but reliable. Looks like it could really hurt if you set it off."
	throw_force = 0
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_MATERIAL = 1)
	matter = list(MAT_STEEL = 18750)
	buckle_restrained_resist_time = 15 SECONDS
	var/deployed = 0
	var/camo_net = FALSE
	var/stun_length = 0.25 SECONDS
	var/trap_damage = 30
	slot_flags = SLOT_MASK
	item_icons = list(
		SLOT_ID_MASK = 'icons/mob/clothing/mask.dmi'
		)

/obj/item/beartrap/equipped(mob/user, slot, flags)
	if(ishuman(src.loc))
		var/mob/living/carbon/human/H = src.loc
		if(H.wear_mask == src)
			add_verb(H, /mob/living/proc/shred_limb_temp)
		else
			remove_verb(H, /mob/living/proc/shred_limb_temp)
	..()

/obj/item/beartrap/dropped(mob/user, flags, atom/newLoc)
	remove_verb(user, /mob/living/proc/shred_limb_temp)
	..()

/obj/item/beartrap/suicide_act(mob/user)
	var/datum/gender/T = GLOB.gender_datums[user.get_visible_gender()]
	user.visible_message("<span class='danger'>[user] is putting the [src.name] on [T.his] head! It looks like [T.hes] trying to commit suicide.</span>")
	return (BRUTELOSS)

/obj/item/beartrap/attack_self(mob/user as mob)
	..()
	if(!deployed)
		user.visible_message(
			"<span class='danger'>[user] starts to deploy \the [src].</span>",
			"<span class='danger'>You begin deploying \the [src]!</span>",
			"You hear the slow creaking of a spring."
			)

		if (do_after(user, 60))
			if(!user.drop_item_to_ground(src))
				return
			user.visible_message(
				"<span class='danger'>[user] has deployed \the [src].</span>",
				"<span class='danger'>You have deployed \the [src]!</span>",
				"You hear a latch click loudly."
				)
			playsound(src.loc, 'sound/machines/click.ogg',70, 1)
			activate()

/obj/item/beartrap/proc/activate()
	deployed = TRUE
	anchored = TRUE
	update_icon()

/obj/item/beartrap/user_unbuckle_mob(mob/M, flags, mob/user, semantic)
	if(user == M)
		user.visible_message(SPAN_WARNING("[user] begins carefully pulling themselves free of [src]!"))
	else
		user.visible_message(SPAN_WARNING("[user] begins freeing [M] from [src]!"))
	if(!do_after(user, 5 SECONDS, src))
		return
	if(user == M)
		user.visible_message(SPAN_WARNING("[user] pulls themselves free of [src]!"))
	else
		user.visible_message(SPAN_WARNING("[user] frees [M] from [src]!"))
	return ..()

/obj/item/beartrap/mob_unbuckled(mob/M, flags, mob/user, semantic)
	. = ..()
	if(!has_buckled_mobs())
		anchored = FALSE

/obj/item/beartrap/attack_hand(mob/user)
	// check unbuckle first
	if(click_unbuckle_interaction(user))
		return CLICKCHAIN_DO_NOT_PROPAGATE
	if(deployed)
		user.visible_message(
			"<span class='danger'>[user] starts to disarm \the [src].</span>",
			"<span class='notice'>You begin disarming \the [src]!</span>",
			"You hear a latch click followed by the slow creaking of a spring."
			)
		playsound(src, 'sound/machines/click.ogg', 50, 1)

		if(do_after(user, 60))
			user.visible_message(
				"<span class='danger'>[user] has disarmed \the [src].</span>",
				"<span class='notice'>You have disarmed \the [src]!</span>"
				)
			deployed = FALSE
			anchored = FALSE
			// reset buckle allowed
			buckle_allowed = FALSE
			update_icon()
	else
		return ..()

/obj/item/beartrap/proc/trap_mob(mob/living/L)

	var/target_zone
	if(L.lying)
		target_zone = ran_zone()
	else
		target_zone = pick("l_foot", "r_foot", "l_leg", "r_leg")

	//armour
	var/blocked = L.run_armor_check(target_zone, "melee")
	var/soaked = L.get_armor_soak(target_zone, "melee")

	if(blocked >= 100)
		return

	if(soaked >= 30)
		return

	if(!L.apply_damage(trap_damage, BRUTE, target_zone, blocked, soaked, used_weapon=src))
		return 0

	//trap the victim in place
	setDir(L.dir)
	// allow it so they can do buckle interactions at all
	buckle_allowed = TRUE
	buckle_mob(L, BUCKLE_OP_FORCE)
	L.Stun(stun_length)
	to_chat(L, "<span class='danger'>The steel jaws of \the [src] bite into you, trapping you in place!</span>")
	deployed = FALSE

/obj/item/beartrap/Crossed(atom/movable/AM as mob|obj)
	if(AM.is_incorporeal())
		return
	if(deployed && isliving(AM))
		var/mob/living/L = AM
		if(L.m_intent == "run")
			L.visible_message(
				"<span class='danger'>[L] steps on \the [src].</span>",
				"<span class='danger'>You step on \the [src]!</span>",
				"<b>You hear a loud metallic snap!</b>"
				)
			trap_mob(L)
			if(!has_buckled_mobs())
				anchored = 0
			deployed = 0
			update_icon()
	..()

/obj/item/beartrap/update_icon()
	..()

	if(!deployed)
		if(camo_net)
			alpha = 255

		icon_state = "beartrap0"
	else
		if(camo_net)
			alpha = 50

		icon_state = "beartrap1"

/obj/item/beartrap/hunting
	name = "hunting trap"
	desc = "A mechanically activated leg trap. High-tech and reliable. Looks like it could really hurt if you set it off."
	stun_length = 1 SECOND
	trap_damage = 45
	camo_net = TRUE
	color = "#C9DCE1"

	origin_tech = list(TECH_MATERIAL = 4, TECH_BLUESPACE = 3, TECH_MAGNET = 4, TECH_PHORON = 2, TECH_ARCANE = 1)

/obj/item/beartrap/hunting/emp
	name = "stealth disruptor trap"
	desc = "A mechanically activated leg trap. High tech and reliable. Looks like it could really be a problem for unshielded electronics."

/obj/item/beartrap/hunting/emp/trap_mob(mob/living/L)
	. = ..()
	empulse(L.loc, 0, 0, 0, 0)	// very localized, apparently
