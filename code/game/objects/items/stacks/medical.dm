/obj/item/stack/medical
	name = "medical pack"
	singular_name = "medical pack"
	icon = 'icons/obj/stacks.dmi'
	amount = 10
	max_amount = 10
	w_class = ITEMSIZE_SMALL
	throw_speed = 4
	throw_range = 20

	var/heal_brute = 0
	var/heal_burn = 0
	var/animal_heal = 3
	var/apply_sounds

	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'

	/// The type path this stack can be upgraded to.
	var/upgrade_to

/obj/item/stack/medical/proc/check_limb_state(var/mob/user, var/obj/item/organ/external/limb)
	. = FALSE
	if(BP_IS_CRYSTAL(limb))
		to_chat(user, SPAN_WARNING("You cannot use \the [src] to treat a crystalline limb."))
	else if(BP_IS_ROBOTIC(limb))
		to_chat(user, SPAN_WARNING("You cannot use \the [src] to treat a robotic limb."))
	else
		. = TRUE

/obj/item/stack/medical/attack(var/mob/living/carbon/M, var/mob/user)
	if(!istype(M))
		to_chat(user, SPAN_WARNING("\The [src] cannot be applied to [M]!"))
		return TRUE

	if(!(istype(user, /mob/living/carbon/human) || \
			istype(user, /mob/living/silicon) ))
		to_chat(user, SPAN_WARNING("You don't have the dexterity to do this!"))
		return TRUE

	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(!affecting)
			to_chat(user, SPAN_WARNING("No body part there to work on!"))
			return TRUE

		if(affecting.organ_tag == BP_HEAD)
			if(H.head && istype(H.head,/obj/item/clothing/head/helmet/space))
				to_chat(user, SPAN_WARNING("You can't apply [src] through [H.head]!"))
				return TRUE
		else
			if(H.wear_suit && istype(H.wear_suit,/obj/item/clothing/suit/space))
				to_chat(user, SPAN_WARNING("You can't apply [src] through [H.wear_suit]!"))
				return TRUE

		if(affecting.robotic == ORGAN_ROBOT)
			to_chat(user, SPAN_WARNING("This isn't useful at all on a robotic limb."))
			return TRUE

		if(affecting.robotic >= ORGAN_LIFELIKE)
			to_chat(user, SPAN_WARNING("You apply the [src], but it seems to have no effect..."))
			use(1)
			return TRUE

		H.UpdateDamageIcon()

	else
		M.heal_organ_damage((src.heal_brute/2), (src.heal_burn/2))
		user.visible_message( \
			SPAN_NOTICE("[M] has been applied with [src] by [user]."), \
			SPAN_NOTICE("You apply \the [src] to [M].") )
		use(1)

	M.updatehealth()

/obj/item/stack/medical/proc/upgrade_stack(var/upgrade_amount)
	. = FALSE

	var/turf/T = get_turf(src)

	if(ispath(upgrade_to) && use(upgrade_amount))
		var/obj/item/stack/medical/M = new upgrade_to(T, upgrade_amount)
		return M
	return .

/obj/item/stack/medical/crude_pack
	name = "crude bandage"
	singular_name = "crude bandage length"
	desc = "Some bandages to wrap around bloody stumps."
	icon_state = "gauze"
	origin_tech = list(TECH_BIO = 1)
	no_variants = FALSE
	apply_sounds = list('sound/effects/rip1.ogg','sound/effects/rip2.ogg')
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'

	upgrade_to = /obj/item/stack/medical/bruise_pack

/obj/item/stack/medical/crude_pack/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return TRUE

	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(affecting.is_bandaged())
			to_chat(user, SPAN_WARNING("The wounds on [M]'s [affecting.name] have already been bandaged."))
			return TRUE
		else
			user.visible_message( \
				SPAN_NOTICE("\The [user] starts bandaging [M]'s [affecting.name]."), \
				SPAN_NOTICE("You start bandaging [M]'s [affecting.name]." ) )
			var/used = 0
			for (var/datum/wound/W in affecting.wounds)
				if(W.internal)
					continue
				if(W.bandaged)
					continue
				if(used == amount)
					break
				if(!do_mob(user, M, W.damage/3))
					to_chat(user, SPAN_NOTICE("You must stand still to bandage wounds."))
					break

				if(affecting.is_bandaged()) //? We do a second check after the delay, in case it was bandaged after the first check.
					to_chat(user, SPAN_WARNING("The wounds on [M]'s [affecting.name] have already been bandaged."))
					return TRUE

				if(W.current_stage <= W.max_bleeding_stage)
					user.visible_message( \
						SPAN_NOTICE("\The [user] bandages \a [W.desc] on [M]'s [affecting.name]."), \
						SPAN_NOTICE("You bandage \a [W.desc] on [M]'s [affecting.name].") )
				else
					user.visible_message( \
						SPAN_NOTICE("\The [user] places a bandage over \a [W.desc] on [M]'s [affecting.name]."), \
						SPAN_NOTICE("You place a bandage over \a [W.desc] on [M]'s [affecting.name].") )
				W.bandage()
				playsound(src, pick(apply_sounds), 25)
				used++

			affecting.update_damages()
			if(used == amount)
				if(affecting.is_bandaged())
					to_chat(user, SPAN_WARNING("\The [src] is used up."))
				else
					to_chat(user, SPAN_WARNING("\The [src] is used up, but there are more wounds to treat on \the [affecting.name]."))
			use(used)

/obj/item/stack/medical/bruise_pack
	name = "roll of gauze"
	singular_name = "gauze length"
	desc = "Some sterile gauze to wrap around bloody stumps."
	icon_state = "brutepack"
	origin_tech = list(TECH_BIO = 1)
	animal_heal = 5
	no_variants = FALSE
	apply_sounds = list('sound/effects/rip1.ogg','sound/effects/rip2.ogg')
	amount = 10

	upgrade_to = /obj/item/stack/medical/advanced/bruise_pack

/obj/item/stack/medical/bruise_pack/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return TRUE

	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(affecting.is_bandaged())
			to_chat(user, SPAN_WARNING("The wounds on [M]'s [affecting.name] have already been bandaged."))
			return TRUE
		else
			user.visible_message( \
				SPAN_NOTICE("\The [user] starts treating [M]'s [affecting.name]."), \
				SPAN_NOTICE("You start treating [M]'s [affecting.name].") )
			var/used = 0
			for(var/datum/wound/W in affecting.wounds)
				if(W.internal)
					continue
				if(W.bandaged)
					continue
				if(used == amount)
					break
				if(!do_mob(user, M, W.damage/5))
					to_chat(user, SPAN_NOTICE("You must stand still to bandage wounds."))
					break
				if(affecting.is_bandaged()) //? We do a second check after the delay, in case it was bandaged after the first check.
					to_chat(user, SPAN_WARNING("The wounds on [M]'s [affecting.name] have already been bandaged."))
					return TRUE
				if(W.current_stage <= W.max_bleeding_stage)
					user.visible_message( \
						SPAN_WARNING("\The [user] bandages \a [W.desc] on [M]'s [affecting.name]."), \
						SPAN_NOTICE("You bandage \a [W.desc] on [M]'s [affecting.name].") )
				else if(W.damage_type == BRUISE)
					user.visible_message( \
						SPAN_NOTICE("\The [user] places a bruise patch over \a [W.desc] on [M]'s [affecting.name]."), \
						SPAN_NOTICE("You place a bruise patch over \a [W.desc] on [M]'s [affecting.name].") )
				else
					user.visible_message( \
						SPAN_NOTICE("\The [user] places a bandaid over \a [W.desc] on [M]'s [affecting.name]."), \
						SPAN_NOTICE("You place a bandaid over \a [W.desc] on [M]'s [affecting.name].") )
				W.bandage()
				if(M.stat == UNCONSCIOUS && prob(25))
					to_chat(M, SPAN_BOLDNOTICE("... [pick("feels a little better", "hurts a little less")] ..."))
				playsound(src, pick(apply_sounds), 25)
				used++
				M.bitten = FALSE

			affecting.update_damages()
			if(used == amount)
				if(affecting.is_bandaged())
					to_chat(user, SPAN_WARNING("\The [src] is used up."))
				else
					to_chat(user, SPAN_WARNING("\The [src] is used up, but there are more wounds to treat on \the [affecting.name]."))
			use(used)
			H.update_bandages(1)

/obj/item/stack/medical/ointment
	name = "ointment"
	desc = "Used to treat those nasty burns."
	gender = PLURAL
	singular_name = "ointment"
	icon_state = "ointment"
	heal_burn = 1
	origin_tech = list(TECH_BIO = 1)
	animal_heal = 4
	no_variants = FALSE
	apply_sounds = list('sound/effects/ointment.ogg')

	drop_sound = 'sound/items/drop/herb.ogg'
	pickup_sound = 'sound/items/pickup/herb.ogg'

/obj/item/stack/medical/ointment/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return TRUE

	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(affecting.is_salved())
			to_chat(user, SPAN_WARNING("The wounds on [M]'s [affecting.name] have already been salved."))
			return TRUE
		else
			user.visible_message( \
				SPAN_NOTICE("\The [user] starts salving wounds on [M]'s [affecting.name]."), \
				SPAN_NOTICE("You start salving the wounds on [M]'s [affecting.name].") )
			playsound(src, pick(apply_sounds), 25)
			if(!do_after(user, 1 SECOND, M))
				return TRUE
			user.visible_message( \
				SPAN_NOTICE("[user] salved wounds on [M]'s [affecting.name]."), \
				SPAN_NOTICE("You salved wounds on [M]'s [affecting.name].") )
			use(1)
			affecting.salve()
			affecting.disinfect()

/obj/item/stack/medical/advanced/bruise_pack
	name = "advanced trauma kit"
	singular_name = "advanced trauma kit"
	desc = "A packet filled antibacterial bio-adhesive, used to quickly seal and disinfect cuts, bruises, and other physical trauma. Can be used to treat both limbs and internal organs."
	icon_state = "traumakit"
	//!This is 0 for a REASON.  Refer to Baystation12/Baystation12/pull/11204, heal_brute will multiply inside the loop to stupid high numbers.
	heal_brute = 0
	origin_tech = list(TECH_BIO = 1)
	animal_heal = 12
	apply_sounds = list('sound/effects/rip1.ogg','sound/effects/rip2.ogg','sound/effects/tape.ogg')
	amount = 10

/obj/item/stack/medical/advanced/bruise_pack/attack(var/mob/living/carbon/M, var/mob/user)
	if(..())
		return TRUE

	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting) //nullchecked by ..()
		if(affecting.is_bandaged() && affecting.is_disinfected())
			to_chat(user, SPAN_WARNING("The wounds on [M]'s [affecting.name] have already been treated."))
			return TRUE
		else
			user.visible_message( \
				SPAN_NOTICE("\The [user] starts treating [M]'s [affecting.name]."), \
				SPAN_NOTICE("You start treating [M]'s [affecting.name].") )
			var/used = 0
			for(var/datum/wound/W in affecting.wounds)
				if(W.bandaged && W.disinfected)
					continue
				if(used == amount)
					break
				if(!do_mob(user, M, W.damage/5))
					to_chat(user, SPAN_NOTICE("You must stand still to bandage wounds."))
					break
				if(affecting.is_bandaged() && affecting.is_disinfected()) // We do a second check after the delay, in case it was bandaged after the first check.
					to_chat(user, SPAN_WARNING("The wounds on [M]'s [affecting.name] have already been bandaged."))
					return TRUE
				if(W.current_stage <= W.max_bleeding_stage)
					user.visible_message( \
						SPAN_NOTICE("\The [user] cleans \a [W.desc] on [M]'s [affecting.name] and seals the edges with bioglue."), \
						SPAN_NOTICE("You clean and seal \a [W.desc] on [M]'s [affecting.name].") )
				else if(W.damage_type == BRUISE)
					user.visible_message( \
						SPAN_NOTICE("\The [user] places a medical patch over \a [W.desc] on [M]'s [affecting.name]."), \
						SPAN_NOTICE("You place a medical patch over \a [W.desc] on [M]'s [affecting.name].") )
				else
					user.visible_message(
						SPAN_NOTICE("\The [user] smears some bioglue over \a [W.desc] on [M]'s [affecting.name]."), \
						SPAN_NOTICE("You smear some bioglue over \a [W.desc] on [M]'s [affecting.name].") )
				playsound(src, pick(apply_sounds), 25)
				W.bandage()
				W.disinfect()
				W.heal_damage(heal_brute)
				used++
				update_icon()
				if(M.stat == UNCONSCIOUS && prob(25))
					to_chat(M, SPAN_BOLDNOTICE("... [pick("feels better", "hurts less")] ..."))
			affecting.update_damages()
			if(used == amount)
				if(affecting.is_bandaged())
					to_chat(user, SPAN_WARNING("\The [src] is used up."))
				else
					to_chat(user, SPAN_WARNING("\The [src] is used up, but there are more wounds to treat on \the [affecting.name]."))
			use(used)
			H.update_bandages(1)

/obj/item/stack/medical/advanced/ointment
	name = "advanced burn kit"
	singular_name = "advanced burn kit"
	desc = "An advanced treatment kit for severe burns."
	icon_state = "burnkit"
	heal_burn = 5
	origin_tech = list(TECH_BIO = 1)
	animal_heal = 7
	apply_sounds = list('sound/effects/ointment.ogg')

/obj/item/stack/medical/advanced/ointment/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return TRUE

	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting) //nullchecked by ..()

		if(affecting.is_salved())
			to_chat(user, SPAN_WARNING("The wounds on [M]'s [affecting.name] have already been salved."))
			return TRUE
		else
			user.visible_message( \
				SPAN_NOTICE("\The [user] starts salving wounds on [M]'s [affecting.name]."), \
				SPAN_NOTICE("You start salving the wounds on [M]'s [affecting.name].") )
			playsound(src, pick(apply_sounds), 25)
			if(!do_after(user, 1 SECOND, M))
				return TRUE
			if(affecting.is_salved()) // We do a second check after the delay, in case it was bandaged after the first check.
				to_chat(user, SPAN_WARNING("The wounds on [M]'s [affecting.name] have already been salved."))
				return TRUE
			user.visible_message( \
				SPAN_NOTICE("[user] covers wounds on [M]'s [affecting.name] with regenerative membrane."), \
				SPAN_NOTICE("You cover wounds on [M]'s [affecting.name] with regenerative membrane.") )
			affecting.heal_damage(0,heal_burn)
			use(1)
			affecting.salve()
			affecting.disinfect()
			if(M.stat == UNCONSCIOUS && prob(25))
				to_chat(M, SPAN_BOLDNOTICE("... [pick("feels better", "hurts less")] ..."))
			update_icon()

/obj/item/stack/medical/splint
	name = "medical splints"
	singular_name = "medical splint"
	desc = "Modular splints capable of supporting and immobilizing bones in all areas of the body."
	icon_state = "splint"
	amount = 5
	max_amount = 5
	animal_heal = 0
	drop_sound = 'sound/items/drop/hat.ogg'
	pickup_sound = 'sound/items/pickup/hat.ogg'

	var/list/splintable_organs = list(BP_HEAD, BP_L_HAND, BP_R_HAND, BP_L_ARM, BP_R_ARM, BP_L_FOOT, BP_R_FOOT, BP_L_LEG, BP_R_LEG, BP_GROIN, BP_TORSO)	//List of organs you can splint, natch.

/obj/item/stack/medical/splint/attack(mob/living/carbon/M as mob, mob/living/user as mob)
	if(..())
		return TRUE

	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting) //nullchecked by ..()
		var/limb = affecting.name
		if(!(affecting.organ_tag in splintable_organs))
			to_chat(user, SPAN_DANGER("You can't use \the [src] to apply a splint there!"))
			return
		if(affecting.splinted)
			to_chat(user, SPAN_DANGER("[M]'s [limb] is already splinted!"))
			return
		if(M != user)
			user.visible_message( \
				SPAN_DANGER("[user] starts to apply \the [src] to [M]'s [limb]."), \
				SPAN_DANGER("You start to apply \the [src] to [M]'s [limb]."), \
				SPAN_DANGER("You hear something being wrapped.") )
		else
			if(( !user.hand && (affecting.organ_tag in list(BP_R_ARM, BP_R_HAND)) || \
				user.hand && (affecting.organ_tag in list(BP_L_ARM, BP_L_HAND)) ))
				to_chat(user, SPAN_DANGER("You can't apply a splint to the arm you're using!"))
				return
			user.visible_message( \
				SPAN_DANGER("[user] starts to apply \the [src] to their [limb]."), \
				SPAN_DANGER("You start to apply \the [src] to your [limb]."), \
				SPAN_DANGER("You hear something being wrapped.") )
		if(do_after(user, 5 SECONDS, M))
			if(affecting.splinted)
				to_chat(user, SPAN_DANGER("[M]'s [limb] is already splinted!"))
				return
			if(M == user && prob(75))
				user.visible_message( \
					SPAN_DANGER("\The [user] fumbles [src]."),\
					SPAN_DANGER("You fumble [src]."), \
					SPAN_DANGER("You hear something being wrapped.") )
				return
			if(ishuman(user))
				var/obj/item/stack/medical/splint/S = split(1)
				if(S)
					if(affecting.apply_splint(S))
						S.forceMove(affecting)
						if(M != user)
							user.visible_message( \
								SPAN_DANGER("\The [user] finishes applying [src] to [M]'s [limb]."), \
								SPAN_DANGER("You finish applying \the [src] to [M]'s [limb]."), \
								SPAN_DANGER("You hear something being wrapped.") )
						else
							user.visible_message( \
								SPAN_DANGER("\The [user] successfully applies [src] to \his [limb]."), \
								SPAN_DANGER("You successfully apply \the [src] to your [limb]."), \
								SPAN_DANGER("You hear something being wrapped.") )
						return
					S.dropInto(src.loc) //didn't get applied, so just drop it
			if(isrobot(user))
				var/obj/item/stack/medical/splint/B = src
				if(B)
					if(affecting.apply_splint(B))
						B.forceMove(affecting)
						user.visible_message( \
							SPAN_DANGER("\The [user] finishes applying [src] to [M]'s [limb]."), \
							SPAN_DANGER("You finish applying \the [src] to [M]'s [limb]."), \
							SPAN_DANGER("You hear something being wrapped.") )
						B.use(1)
						return
			user.visible_message( \
				SPAN_DANGER("\The [user] fails to apply [src]."), \
				SPAN_DANGER("You fail to apply [src]."), \
				SPAN_DANGER("You hear something being wrapped."))
		return

/obj/item/stack/medical/splint/ghetto
	name = "makeshift splints"
	singular_name = "makeshift splint"
	desc = "For holding your limbs in place with duct tape and scrap metal."
	icon_state = "tape-splint"
	amount = 1
	splintable_organs = list(BP_L_ARM, BP_R_ARM, BP_L_LEG, BP_R_LEG)

/obj/item/stack/medical/advanced/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/stack/medical/advanced/update_icon()
	switch(amount)
		if(1 to 2)
			icon_state = initial(icon_state)
		if(3 to 4)
			icon_state = "[initial(icon_state)]_4"
		if(5 to 6)
			icon_state = "[initial(icon_state)]_6"
		if(7 to 8)
			icon_state = "[initial(icon_state)]_8"
		if(9)
			icon_state = "[initial(icon_state)]_9"
		else
			icon_state = "[initial(icon_state)]_10"
