/obj/item/beartrap
	name = "mechanical trap"
	throw_speed = 2
	throw_range = 1
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "beartrap0"
	desc = "A mechanically activated leg trap. Low-tech, but reliable. Looks like it could really hurt if you set it off."
	throwforce = 0
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_MATERIAL = 1)
	matter = list(MAT_STEEL = 18750)
	var/deployed = 0
	var/camo_net = FALSE
	var/stun_length = 0.25 SECONDS
	var/trap_damage = 30
	slot_flags = SLOT_MASK
	item_icons = list(
		/datum/inventory_slot_meta/inventory/mask = 'icons/mob/clothing/mask.dmi'
		)

/obj/item/beartrap/equipped(mob/user, slot)
	if(ishuman(src.loc))
		var/mob/living/carbon/human/H = src.loc
		if(H.wear_mask == src)
			H.verbs |= /mob/living/proc/shred_limb_temp
		else
			H.verbs -= /mob/living/proc/shred_limb_temp
	..()

/obj/item/beartrap/dropped(var/mob/user)
	user.verbs -= /mob/living/proc/shred_limb_temp
	..()

/obj/item/beartrap/suicide_act(mob/user)
	var/datum/gender/T = gender_datums[user.get_visible_gender()]
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
			user.visible_message(
				"<span class='danger'>[user] has deployed \the [src].</span>",
				"<span class='danger'>You have deployed \the [src]!</span>",
				"You hear a latch click loudly."
				)
			playsound(src.loc, 'sound/machines/click.ogg',70, 1)

			user.drop_from_inventory(src)
			activate()

/obj/item/beartrap/proc/activate()
	deployed = 1
	anchored = 1
	update_icon()

/obj/item/beartrap/user_unbuckle_mob(mob/living/buckled_mob, mob/user)
	if(user == buckled_mob)
		user.visible_message(SPAN_WARNING("[user] begins carefully pulling themselves free of [src]!"))
	else
		user.visible_message(SPAN_WARNING("[user] begins freeing [buckled_mob] from [src]!"))
	if(!do_after(user, 5 SECONDS, src))
		return
	if(user == buckled_mob)
		user.visible_message(SPAN_WARNING("[user] pulls themselves free of [src]!"))
	else
		user.visible_message(SPAN_WARNING("[user] frees [buckled_mob] from [src]!"))
	return ..()
	
/obj/item/beartrap/unbuckle_mob()
	. = ..()
	if(!LAZYLEN(buckled_mobs))
		anchored = FALSE

/obj/item/beartrap/attack_hand(mob/user as mob)
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
			deployed = 0
			anchored = 0
			update_icon()
	else
		return ..()

/obj/item/beartrap/proc/attack_mob(mob/living/L)

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
	can_buckle = 1
	buckle_mob(L)
	L.Stun(stun_length)
	to_chat(L, "<span class='danger'>The steel jaws of \the [src] bite into you, trapping you in place!</span>")
	deployed = 0
	can_buckle = initial(can_buckle)

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
			attack_mob(L)
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

/obj/item/beartrap/hunting/emp/attack_mob(mob/living/L)
	. = ..()
	empulse(L.loc, 0, 0, 0, 0)	// very localized, apparently
