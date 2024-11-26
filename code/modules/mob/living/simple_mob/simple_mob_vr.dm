/mob/living/simple_mob
	base_attack_cooldown = 15

	var/temperature_range = 40			// How close will they get to environmental temperature before their body stops changing its heat

	var/life_disabled = 0				// For performance reasons

	var/obj/item/radio/headset/mob_headset/mob_radio		//Adminbus headset for simplemob shenanigans.

// Release belly contents before being gc'd!
/mob/living/simple_mob/Destroy()
	release_vore_contents()
	return ..()

//For all those ID-having mobs
/mob/living/simple_mob/GetIdCard()
	if(access_card)
		return access_card

/mob/living/simple_mob/death()
	release_vore_contents()
	return ..()

// Make sure you don't call ..() on this one, otherwise you duplicate work.
/mob/living/simple_mob/init_vore()
	. = ..()

	if(!IsAdvancedToolUser())
		add_verb(src, /mob/living/simple_mob/proc/animal_nom)
		add_verb(src, /mob/living/proc/shred_limb)

	if(LAZYLEN(vore_organs))
		return

// Checks to see if mob doesn't like this kind of turf
/mob/living/simple_mob/IMove(turf/newloc, safety = TRUE)
	if(istype(newloc,/turf/simulated/sky))
		return MOVEMENT_FAILED //Mobs aren't that stupid, probably
	return ..() // Procede as normal.

// todo: shitcode, rewrite on say rewrite
/mob/living/simple_mob/handle_message_mode(message_mode, message, verb, speaking, used_radios, alt_name)
	switch(message_mode)
		if("intercom")
			for(var/obj/item/radio/intercom/I in view(1, null))
				I.talk_into(src, message, verb, speaking)
				used_radios += I
		if("headset", "right ear", "left ear")
			if(mob_radio)
				mob_radio.talk_into(src,message,null,verb,speaking)
				used_radios += mob_radio
		if("department", "Command", "Science", "Medical", "Engineering", "Security", "Mercenary", "Raider", "Supply", "Service", "AI Private", "Explorer", "Trader", "Common")
			if(mob_radio)
				mob_radio.talk_into(src,message,message_mode,verb,speaking)
				used_radios += mob_radio
		else
			..()

/mob/living/simple_mob/proc/leap()
	set name = "Pounce Target"
	set category = "Abilities"
	set desc = "Select a target to pounce at."

	if(last_special > world.time)
		to_chat(src, "Your legs need some more rest.")
		return

	if(incapacitated(INCAPACITATION_DISABLED))
		to_chat(src, "You cannot leap in your current state.")
		return

	var/list/choices = list()
	for(var/mob/living/M in view(3,src))
		choices += M
	choices -= src

	var/mob/living/T = input(src,"Who do you wish to leap at?") as null|anything in choices

	if(!T || !src || src.stat) return

	if(get_dist(get_turf(T), get_turf(src)) > 3) return

	if(last_special > world.time)
		return

	if(usr.incapacitated(INCAPACITATION_DISABLED))
		to_chat(src, "You cannot leap in your current state.")
		return

	last_special = world.time + 10
	status_flags |= STATUS_LEAPING
	pixel_y = pixel_y + 10

	src.visible_message("<span class='danger'>\The [src] leaps at [T]!</span>")
	src.throw_at_old(get_step(get_turf(T),get_turf(src)), 4, 1, src)
	playsound(src.loc, 'sound/effects/bodyfall1.ogg', 50, 1)
	pixel_y = base_pixel_y

	sleep(5)

	if(status_flags & STATUS_LEAPING) status_flags &= ~STATUS_LEAPING

	if(!src.Adjacent(T))
		to_chat(src, "<span class='warning'>You miss!</span>")
		return

	if(ishuman(T))
		var/mob/living/carbon/human/H = T
		if(H.species.lightweight == 1)
			H.afflict_paralyze(20 * 3)
			return
	var/armor_block = run_armor_check(T, "melee")
	var/armor_soak = get_armor_soak(T, "melee")
	T.apply_damage(20, DAMAGE_TYPE_HALLOSS,, armor_block, armor_soak)
	if(prob(33))
		T.apply_effect(3, WEAKEN, armor_block)

/mob/living/simple_mob/verb/access_mob_radio_legacy()
	set name = "Access Mob Radio"
	set category = VERB_CATEGORY_IC

	if(isnull(mob_radio))
		to_chat(usr, SPAN_WARNING("You don't have a radio."))
		return

	mob_radio.ui_interact(usr)
