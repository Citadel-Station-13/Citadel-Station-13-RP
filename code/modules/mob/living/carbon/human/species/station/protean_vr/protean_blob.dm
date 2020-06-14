// Simple animal nanogoopeyness
/mob/living/simple_mob/protean_blob
	name = "protean blob"
	desc = "Some sort of big viscous pool of jelly."
	tt_desc = "Animated nanogoop"
	icon = 'icons/mob/species/protean/protean.dmi'
	icon_state = "to_puddle"
	icon_living = "puddle2"
	icon_rest = "rest"
	icon_dead = "puddle"

	faction = "neutral"
	maxHealth = 200
	health = 200
	say_list_type = /datum/say_list/protean_blob

	// ai_inactive = TRUE //Always off //VORESTATION AI TEMPORARY REMOVAL
	show_stat_health = FALSE //We will do it ourselves
	has_langs = list(LANGUAGE_GALCOM, LANGUAGE_EAL)
	response_help = "pats the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"

	harm_intent_damage = 2
	melee_damage_lower = 10
	melee_damage_upper = 10
	attacktext = list("slashed")

	aquatic_movement = 1
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	maxbodytemp = 900
	movement_cooldown = 0

	var/mob/living/carbon/human/humanform
	var/obj/item/organ/internal/nano/refactory/refactory
	var/datum/modifier/healing

	var/obj/prev_left_hand
	var/obj/prev_right_hand

	player_msg = "In this form, you can move a little faster, your health will regenerate as long as you have metal in you, and you can ventcrawl!"
	holder_type = /obj/item/holder/protoblob
	can_buckle = TRUE //Blobsurfing

/datum/say_list/protean_blob
	speak = list("Blrb?","Sqrsh.","Glrsh!")
	emote_hear = list("squishes softly","spluts quietly","makes wet noises")
	emote_see = list("shifts wetly","undulates placidly")

//Constructor allows passing the human to sync damages
/mob/living/simple_mob/protean_blob/New(var/newloc, var/mob/living/carbon/human/H)
	..()
	mob_radio = new(src)
	myid = new(src)
	if(H)
		humanform = H
		updatehealth()
		refactory = locate() in humanform.internal_organs
		verbs |= /mob/living/proc/ventcrawl
		verbs |= /mob/living/proc/hide
		verbs |= /mob/living/simple_mob/protean_blob/proc/useradio
		verbs |= /mob/living/simple_mob/protean_blob/proc/appearanceswitch

	else
		update_icon()

/mob/living/simple_mob/protean_blob/Destroy()
	humanform = null
	refactory = null
	vore_organs = null
	vore_selected = null
	if(healing)
		healing.expire()
	return ..()

/mob/living/simple_mob/protean_blob/init_vore()
	return //Don't make a random belly, don't waste your time

/mob/living/simple_mob/protean_blob/Stat()
	..()
	if(humanform)
		humanform.species.Stat(humanform)


/mob/living/simple_mob/protean_blob/updatehealth()
	if(humanform)
		//Set the max
		maxHealth = humanform.getMaxHealth()*2 //HUMANS, and their 'double health', bleh.
		//Set us to their health, but, human health ignores robolimbs so we do it 'the hard way'
		health = maxHealth - humanform.getOxyLoss() - humanform.getToxLoss() - humanform.getCloneLoss() - humanform.getActualFireLoss() - humanform.getActualBruteLoss()

		//Alive, becoming dead
		if((stat < DEAD) && (health <= 0))
			death()

		//Overhealth
		if(health > getMaxHealth())
			health = getMaxHealth()

		//Update our hud if we have one
		if(healths)
			if(stat != DEAD)
				var/heal_per = (health / getMaxHealth()) * 100
				switch(heal_per)
					if(100 to INFINITY)
						healths.icon_state = "health0"
					if(80 to 100)
						healths.icon_state = "health1"
					if(60 to 80)
						healths.icon_state = "health2"
					if(40 to 60)
						healths.icon_state = "health3"
					if(20 to 40)
						healths.icon_state = "health4"
					if(0 to 20)
						healths.icon_state = "health5"
					else
						healths.icon_state = "health6"
			else
				healths.icon_state = "health7"
	else
		..()

/mob/living/simple_mob/protean_blob/stun_effect_act()
	return FALSE //ok so tasers hurt protean blobs what the fuck

/mob/living/simple_mob/protean_blob/adjustBruteLoss(var/amount)
	if(humanform)
		humanform.adjustBruteLoss(amount)
	else
		..()

/mob/living/simple_mob/protean_blob/ventcrawl_carry()
	return TRUE //proteans can have literally any small inside them and should still be able to ventcrawl regardless.

/mob/living/simple_mob/protean_blob/adjustFireLoss(var/amount)
	if(humanform)
		humanform.adjustFireLoss(amount)
	else
		..()

/mob/living/simple_mob/protean_blob/death(gibbed, deathmessage = "dissolves away, leaving only a few spare parts!")
	if(humanform)
		humanform.death(gibbed = gibbed)
		for(var/organ in humanform.internal_organs)
			var/obj/item/organ/internal/O = organ
			O.removed()
			O.forceMove(drop_location())
		var/list/items = humanform.get_equipped_items()
		if(prev_left_hand) items += prev_left_hand
		if(prev_right_hand) items += prev_right_hand
		for(var/obj/object in items)
			object.forceMove(drop_location())
		QDEL_NULL(humanform) //Don't leave it just sitting in nullspace

	animate(src,alpha = 0,time = 2 SECONDS)
	sleep(2 SECONDS)
	qdel(src)

	..()

/mob/living/simple_mob/protean_blob/Life()
	. = ..()
	if(. && istype(refactory) && humanform)
		if(!healing && health < maxHealth && refactory.get_stored_material(DEFAULT_WALL_MATERIAL) >= 100)
			healing = humanform.add_modifier(/datum/modifier/protean/steel, origin = refactory)
		else if(healing && health == maxHealth)
			healing.expire()
			healing = null

/mob/living/simple_mob/protean_blob/lay_down()
	..()
	if(resting)
		animate(src,alpha = 40,time = 1 SECOND)
		mouse_opacity = 0
	else
		mouse_opacity = 1
		icon_state = "wake"
		animate(src,alpha = 255,time = 1 SECOND)
		sleep(7)
		update_icon()
		//Potential glob noms
		if(can_be_drop_pred) //Toggleable in vore panel
			var/list/potentials = living_mobs(0)
			if(potentials.len)
				var/mob/living/target = pick(potentials)
				if(istype(target) && vore_selected)
					if(target.buckled)
						target.buckled.unbuckle_mob(target, force = TRUE)
					target.forceMove(vore_selected)
					to_chat(target,"<span class='warning'>\The [src] quickly engulfs you, [vore_selected.vore_verb]ing you into their [vore_selected.name]!</span>")

/mob/living/simple_mob/protean_blob/attack_target(var/atom/A)
	if(refactory && istype(A,/obj/item/stack/material))
		var/obj/item/stack/material/S = A
		var/substance = S.material.name
		var/list/edible_materials = list("steel", "plasteel", "diamond", "mhydrogen") //Can't eat all materials, just useful ones.
		var allowed = FALSE
		for(var/material in edible_materials)
			if(material == substance) allowed = TRUE
		if(!allowed)
			return
		if(refactory.add_stored_material(S.material.name,1*S.perunit) && S.use(1))
			visible_message("<b>[name]</b> gloms over some of \the [S], absorbing it.")
	else
		return ..()

/mob/living/simple_mob/protean_blob/attackby(var/obj/item/O, var/mob/user)
	if(refactory && istype(O,/obj/item/stack/material))
		var/obj/item/stack/material/S = O
		var/substance = S.material.name
		var/list/edible_materials = list("steel", "plasteel", "diamond", "mhydrogen") //Can't eat all materials, just useful ones.
		var allowed = FALSE
		for(var/material in edible_materials)
			if(material == substance) allowed = TRUE
		if(!allowed)
			return
		if(refactory.add_stored_material(S.material.name,1*S.perunit) && S.use(1))
			visible_message("<b>[name]</b> gloms over some of \the [S], absorbing it.")
	else
		return ..()

/mob/living/simple_mob/protean_blob/attack_hand(mob/living/L)
	if(src.get_effective_size() <= 0.5)
		src.get_scooped(L) //AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
	else
		..()
/mob/living/simple_mob/protean_blob/MouseEntered(location,control,params)
	if(resting)
		return
	..()

// Helpers - Unsafe, WILL perform change.
/mob/living/carbon/human/proc/nano_intoblob()
	handle_grasp() //It's possible to blob out before some key parts of the life loop. This results in things getting dropped at null. TODO: Fix the code so this can be done better.
	remove_micros(src, src) //Living things don't fare well in roblobs.
	if(buckled)
		buckled.unbuckle_mob()
	if(LAZYLEN(buckled_mobs))
		for(var/buckledmob in buckled_mobs)
			riding_datum.force_dismount(buckledmob)
	if(pulledby)
		pulledby.stop_pulling()
	stop_pulling()

	//Record where they should go
	var/atom/creation_spot = drop_location()

	//Create our new blob
	var/mob/living/simple_mob/protean_blob/blob = new(creation_spot,src)

	//Drop all our things
	var/list/things_to_drop = contents.Copy()
	var/list/things_to_not_drop = list(w_uniform,nif,l_store,r_store,wear_id,l_ear,r_ear,gloves,glasses,shoes) //And whatever else we decide for balancing.
	//you can instaflash or pepperspray on unblob with pockets anyways
	if(l_hand && l_hand.w_class <= ITEMSIZE_SMALL) //Hands but only if small or smaller
		things_to_not_drop += l_hand
	if(r_hand && r_hand.w_class <= ITEMSIZE_SMALL)
		things_to_not_drop += r_hand
	things_to_drop -= things_to_not_drop //Crunch the lists
	things_to_drop -= organs //Mah armbs
	things_to_drop -= internal_organs //Mah sqeedily spooch

	for(var/obj/item/I in things_to_drop) //rip hoarders
		drop_from_inventory(I)


	if(istype(slot_gloves, /obj/item/clothing/gloves/gauntlets/rig)) //drop RIGsuit gauntlets to avoid fucky wucky-ness.
		drop_from_inventory(slot_gloves)

	if(istype(slot_shoes, /obj/item/clothing/shoes/magboots)) //drop magboots because they're super heavy. also drops RIGsuit boots because they're magboot subtypes.
		drop_from_inventory(slot_shoes)

	for(var/obj/item/radio/headset/H in things_to_not_drop)
		blob.mob_radio.keyslot1 = H.keyslot1
		blob.mob_radio.keyslot2 = H.keyslot2
		if(H.adhoc_fallback)
			blob.mob_radio.adhoc_fallback = TRUE
		blob.mob_radio.recalculateChannels()

	for(var/obj/item/pda/P in things_to_not_drop)
		if(P.id)
			var/obj/item/card/id/PID = P.id
			blob.myid.access += PID.access

	for(var/obj/item/card/id/I in things_to_not_drop)
		blob.myid.access += I.access

	if(w_uniform && istype(w_uniform,/obj/item/clothing)) //No webbings tho. We do this after in case a suit was in the way
		var/obj/item/clothing/uniform = w_uniform
		if(LAZYLEN(uniform.accessories))
			for(var/obj/item/clothing/accessory/A in uniform.accessories)
				if(istype(A, /obj/item/clothing/accessory/holster) || istype(A, /obj/item/clothing/accessory/storage)) //only drop webbings/holsters so you don't drop your PAN or vanity/fluff accessories(the life notifier necklace, etc).
					uniform.remove_accessory(null,A) //First param is user, but adds fingerprints and messages

	//Size update
	blob.transform = matrix()*size_multiplier
	blob.size_multiplier = size_multiplier

	if(l_hand) blob.prev_left_hand = l_hand //Won't save them if dropped above, but necessary if handdrop is disabled.
	if(r_hand) blob.prev_right_hand = r_hand
	//languages!!
	for(var/datum/language/L in languages)
		blob.add_language(L.name)
	//Put our owner in it (don't transfer var/mind)
	blob.ckey = ckey
	temporary_form = blob

	//Mail them to nullspace
	moveToNullspace()

	//Message
	blob.visible_message("<b>[src.name]</b> collapses into a gooey blob!")

	//Duration of the to_puddle iconstate that the blob starts with
	sleep(13)
	blob.update_icon() //Will remove the collapse anim

	//Transfer vore organs
	blob.vore_organs = vore_organs
	blob.vore_selected = vore_selected
	for(var/belly in vore_organs)
		var/obj/belly/B = belly
		B.forceMove(blob)
		B.owner = blob

	//Return our blob in case someone wants it
	return blob

//For some reason, there's no way to force drop all the mobs grabbed. This ought to fix that. And be moved elsewhere. Call with caution, doesn't handle cycles.
/proc/remove_micros(var/src, var/mob/root)
	for(var/obj/item/I in src)
		remove_micros(I, root) //Recursion. I'm honestly depending on there being no containment loop, but at the cost of performance that can be fixed too.
		if(istype(I, /obj/item/holder))
			root.remove_from_mob(I)

/mob/living/simple_mob/protean_blob/proc/useradio()
	set name = "Utilize Radio"
	set desc = "Allows a protean blob to interact with its internal radio."
	set category = "Abilities"

	if(mob_radio)
		mob_radio.ui_interact(src, state = interactive_state)

/mob/living/carbon/human/proc/nano_outofblob(var/mob/living/simple_mob/protean_blob/blob)
	if(!istype(blob))
		return
	if(buckled)
		buckled.unbuckle_mob()
	if(LAZYLEN(buckled_mobs))
		for(var/buckledmob in buckled_mobs)
			riding_datum.force_dismount(buckledmob)
	if(pulledby)
		pulledby.stop_pulling()
	stop_pulling()

	//Stop healing if we are
	if(blob.healing)
		blob.healing.expire()

	//Play the animation
	blob.icon_state = "from_puddle"

	//Message
	blob.visible_message("<b>[src.name]</b> reshapes into a humanoid appearance!")

	//Duration of above animation
	sleep(8)

	//Record where they should go
	var/atom/reform_spot = blob.drop_location()

	//Size update
	resize(blob.size_multiplier, FALSE)

	//Move them back where the blob was
	forceMove(reform_spot)

	//Put our owner in it (don't transfer var/mind)
	ckey = blob.ckey
	temporary_form = null

	//Transfer vore organs
	vore_selected = blob.vore_selected
	for(var/belly in blob.vore_organs)
		var/obj/belly/B = belly
		B.forceMove(src)
		B.owner = src

	if(blob.prev_left_hand) put_in_l_hand(blob.prev_left_hand) //The restore for when reforming.
	if(blob.prev_right_hand) put_in_r_hand(blob.prev_right_hand)

	for(var/obj/item/radio/headset/H in contents)
		H.keyslot1 = blob.mob_radio.keyslot1
		H.keyslot2 = blob.mob_radio.keyslot2
	Life(1) //Fix my blindness right meow //Has to be moved up here, there exists a circumstance where blob could be deleted without vore organs moving right.

	//Get rid of friend blob
	qdel(blob)

	//Return ourselves in case someone wants it
	return src

/mob/living/simple_mob/protean_blob/proc/appearanceswitch()
	set name = "Switch Appearance"
	set desc = "Allows a protean blob to switch its outwards appearance."
	set category = "Abilities"

	var/blobstyle = input(src, "Which blob style would you like?") in list("Red and Blue Stars", "Blue Star", "Plain")
	switch(blobstyle)
		if("Red and Blue Stars")
			icon_living = "puddle2"
			update_icon()
		if("Blue Star")
			icon_living = "puddle1"
			update_icon()
		if("Plain")
			icon_living = "puddle0"
			update_icon()
