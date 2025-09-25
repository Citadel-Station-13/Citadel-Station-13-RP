
/obj/item/robot_builtin/dog_tongue
	name = "synthetic tongue"
	desc = "Useful for slurping mess off the floor before affectionally licking the crew members in the face."
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "synthtongue"
	attack_sound = 'sound/effects/attackblob.ogg'
	item_flags = ITEM_NO_BLUDGEON | ITEM_ENCUMBERS_WHILE_HELD
	var/emagged = 0
	var/datum/matter_synth/water = null

/obj/item/robot_builtin/dog_tongue/examine(user)
	. = ..()
	if(item_mount.get_reagent(/datum/reagent/water::id) < 5)
		. += "<span class='notice'>[src] is wet.</span>"
	else
		. += "<span class='notice'>[src] is dry.</span>"

/obj/item/robot_builtin/dog_tongue/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	var/mob/living/silicon/robot/R = user
	if(R.emagged || R.emag_items)
		emagged = !emagged
		if(emagged)
			name = "hacked tongue of doom"
			desc = "Your tongue has been upgraded successfully. Congratulations."
			icon = 'icons/mob/dogborg_vr.dmi'
			icon_state = "syndietongue"
		else
			name = "synthetic tongue"
			desc = "Useful for slurping mess off the floor before affectionally licking the crew members in the face."
			icon = 'icons/mob/dogborg_vr.dmi'
			icon_state = "synthtongue"
		update_icon()

/obj/item/robot_builtin/dog_tongue/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(!(clickchain_flags & CLICKCHAIN_HAS_PROXIMITY))
		return

	user.setClickCooldownLegacy(DEFAULT_ATTACK_COOLDOWN)
	if(user.client && (target in user.client.screen))
		to_chat(user, "<span class='warning'>You need to take [target] off before cleaning it!</span>")
	if(istype(target, /obj/structure/sink) || istype(target, /obj/structure/toilet)) //Dog vibes.
		user.visible_message("[user] begins to lap up water from [target].", "<span class='notice'>You begin to lap up water from [target].</span>")
		if(do_after(user, 50, target = target))
			item_mount?.push_reagent(/datum/reagent/water, 50)
	else if(item_mount?.get_reagent(/datum/reagent/water) < 1)
		to_chat(user, "<span class='notice'>Your mouth feels dry. You should drink some water.</span>") //fixed annoying grammar and needless space
		return
	else if(istype(target,/obj/effect/debris/cleanable))
		user.visible_message("[user] begins to lick off [target].", "<span class='notice'>You begin to lick off [target]...</span>")
		if(do_after(user, 50, target = target))
			to_chat(user, "<span class='notice'>You finish licking off [target].</span>")
			item_mount?.pull_reagent(/datum/reagent/water, 1)
			qdel(target)
			var/mob/living/silicon/robot/R = user
			R.cell.charge += 50
	else if(istype(target,/obj/item))
		if(istype(target,/obj/item/trash))
			user.visible_message("[user] nibbles away at [target].", "<span class='notice'>You begin to nibble away at [target]...</span>")
			if(do_after(user, 50, target = target))
				user.visible_message("[user] finishes eating [target].", "<span class='notice'>You finish eating [target].</span>")
				to_chat(user, "<span class='notice'>You finish off [target].</span>")
				qdel(target)
				var/mob/living/silicon/robot/R = user
				if(istype(target,/obj/item/trash/rkibble))
					R.cell.charge += 1000
				else
					R.cell.charge += 250
				item_mount?.pull_reagent(/datum/reagent/water, 1)
			return
		if(istype(target,/obj/item/cell))
			user.visible_message("[user] begins cramming [target] down its throat.", "<span class='notice'>You begin cramming \the [target.name] down your throat...</span>")
			if(do_after(user, 50, target = target))
				user.visible_message("[user] finishes gulping down [target].", "<span class='notice'>You finish swallowing [target].</span>")
				to_chat(user, "<span class='notice'>You finish off [target], and gain some charge!</span>")
				var/mob/living/silicon/robot/R = user
				var/obj/item/cell/C = target
				R.cell.charge += C.maxcharge / 3
				item_mount?.pull_reagent(/datum/reagent/water, 1)
				qdel(target)
			return
		user.visible_message("[user] begins to lick [target] clean...", "<span class='notice'>You begin to lick [target] clean...</span>")
		if(do_after(user, 50, target = target))
			to_chat(user, "<span class='notice'>You clean [target].</span>")
			item_mount?.pull_reagent(/datum/reagent/water, 1)
			var/obj/effect/debris/cleanable/C = locate() in target
			qdel(C)
			target.clean_blood()
	else if(ishuman(target))
		if(src.emagged)
			var/mob/living/silicon/robot/R = user
			var/mob/living/L = target
			if(R.cell.charge <= 666)
				return
			L.afflict_stun(20 * 1)
			L.afflict_paralyze(20 * 1)
			L.apply_effect(STUTTER, 1)
			L.visible_message("<span class='danger'>[user] has shocked [L] with its tongue!</span>", \
								"<span class='userdanger'>[user] has shocked you with its tongue! You can feel the betrayal.</span>")
			playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)
			R.cell.charge -= 666
		else
			user.visible_message("<span class='notice'>\The [user] affectionally licks all over [target]'s face!</span>", "<span class='notice'>You affectionally lick all over [target]'s face!</span>")
			playsound(src.loc, 'sound/effects/attackblob.ogg', 50, 1)
			item_mount?.pull_reagent(/datum/reagent/water, 1)
			var/mob/living/carbon/human/H = target
			if(H.species.lightweight == 1)
				H.afflict_paralyze(20 * 3)
	else
		user.visible_message("[user] begins to lick [target] clean...", "<span class='notice'>You begin to lick [target] clean...</span>")
		if(do_after(user, 50, target = target))
			to_chat(user, "<span class='notice'>You clean [target].</span>")
			var/obj/effect/debris/cleanable/C = locate() in target
			qdel(C)
			target.clean_blood()
			item_mount?.pull_reagent(/datum/reagent/water, 1)
			if(istype(target, /turf/simulated))
				var/turf/simulated/T = target
				T.dirt = 0
