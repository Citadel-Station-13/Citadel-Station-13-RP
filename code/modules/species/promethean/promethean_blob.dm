// Prommies are slimes, lets make them a subtype of slimes.
/mob/living/simple_mob/slime/promethean
	name = "Promethean Blob"
	desc = "A promethean expressing their true form."
	//ai_holder_type = null
	color = null // Uses a special icon_state.
	slime_color = "rainbow"
	unity = TRUE
	water_resist = 1 // Lets not kill the prommies
	cores = 0
	movement_cooldown = 3
	//species_appearance_flags = RADIATION_GLOWS
	shock_resist = 0 // Lets not be immune to zaps.
	friendly = list("nuzzles", "glomps", "snuggles", "cuddles", "squishes") // lets be cute :3
	legacy_melee_damage_upper = 0
	legacy_melee_damage_lower = 0
	player_msg = "You're a little squisher! Your cuteness level has increased tenfold."
	heat_damage_per_tick = 20 // Hot and cold are bad, but cold is AS bad for prommies as it is for slimes.
	cold_damage_per_tick = 20
	//glow_range = 0
	//glow_intensity = 0

	var/mob/living/carbon/human/humanform
	var/datum/modifier/healing

	var/datum/weakref/prev_left_hand
	var/datum/weakref/prev_right_hand

	var/human_brute = 0
	var/human_burn = 0
	var/is_wide = FALSE
	var/rad_glow = 0

/mob/living/simple_mob/slime/promethean/Initialize(mapload, null)
	add_verb(src, /mob/living/simple_mob/slime/promethean/proc/prommie_blobform)
	add_verb(src, /mob/living/proc/set_size)
	add_verb(src, /mob/living/proc/hide)
	add_verb(src, /mob/living/simple_mob/proc/animal_nom)
	add_verb(src, /mob/living/proc/shred_limb)
	add_verb(src, /mob/living/simple_mob/slime/promethean/proc/toggle_expand)
	add_verb(src, /mob/living/simple_mob/slime/promethean/proc/prommie_select_colour)
	add_verb(src, /mob/living/simple_mob/slime/promethean/proc/toggle_shine)
	update_mood()
	if(rad_glow)
		rad_glow = clamp(rad_glow,0,250)
		set_light(max(1,min(5,rad_glow/15)), max(1,min(10,rad_glow/25)), color)
	return ..()

/mob/living/simple_mob/slime/promethean/update_icon()
	icon_living = "[icon_state_override ? "[icon_state_override] slime" : "slime"] [is_wide ? "adult" : "baby"][""]"
	..()

/mob/living/simple_mob/slime/promethean/Destroy()
	humanform = null
	vore_organs = null
	vore_selected = null
	set_light(0)
	return ..()

/mob/living/carbon/human/Destroy()
	if(stored_blob)
		stored_blob = null
		qdel(stored_blob)
	return ..()

/mob/living/simple_mob/slime/promethean/statpanel_data(client/C)
	. = ..()
	if(humanform)
		. += humanform.species.statpanel_status(C, humanform)

/mob/living/simple_mob/slime/promethean/handle_special() // Should disable default slime healing, we'll use nutrition based heals instead.
	if(rad_glow)
		rad_glow = clamp(rad_glow,0,250)
		set_light(max(1,min(5,rad_glow/15)), max(1,min(10,rad_glow/25)), color)
	else
		set_light(0)
	update_icon()

	if(!humanform) // If we somehow have a blob with no human, lets just clean up.
		log_debug(SPAN_DEBUGINFO("Cleaning up blob with no prommie!"))
		qdel(src)
	return

//Constructor allows passing the human to sync damages
/mob/living/simple_mob/slime/promethean/New(var/newloc, var/mob/living/carbon/human/H)
	..()
	if(H)
		humanform = H
		update_health()

	else
		qdel(src)

/mob/living/simple_mob/slime/promethean/update_health()
	if(!humanform)
		return ..()

	//Set the max
	maxHealth = humanform.getMaxHealth()*2 //HUMANS, and their 'double health', bleh.
	//Set us to their health, but, human health ignores robolimbs so we do it 'the hard way'
	human_brute = humanform.getActualBruteLoss()
	human_burn = humanform.getActualFireLoss()
	health = maxHealth - humanform.getOxyLoss() - humanform.getToxLoss() - humanform.getCloneLoss() - human_brute - human_burn

	//Alive, becoming dead
	if((stat < DEAD) && (health <= 0))
		death()

	//Overhealth
	if(health > getMaxHealth())
		health = getMaxHealth()

	//Grab any other interesting values
	confused = humanform.confused
	radiation = humanform.radiation

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

// All the damage and such to the blob translates to the human
/mob/living/simple_mob/slime/promethean/apply_effect(var/effect = 0, var/effecttype = STUN, var/blocked = 0, var/check_protection = 1)
	if(humanform)
		return humanform.apply_effect(effect, effecttype, blocked, check_protection)
	else
		return ..()

/mob/living/simple_mob/slime/promethean/adjustBruteLoss(var/amount,var/include_robo)
	amount *= 0.75
	if(humanform)
		return humanform.adjustBruteLoss(amount)
	else
		return ..()

/mob/living/simple_mob/slime/promethean/adjustFireLoss(var/amount,var/include_robo)
	amount *= 2
	if(humanform)
		return humanform.adjustFireLoss(amount)
	else
		return ..()

/mob/living/simple_mob/slime/promethean/adjustToxLoss(amount)
	if(humanform)
		return humanform.adjustToxLoss(amount)
	else
		return ..()

/mob/living/simple_mob/slime/promethean/adjustOxyLoss(amount)
	if(humanform)
		return humanform.adjustOxyLoss(amount)
	else
		return ..()

/mob/living/simple_mob/slime/promethean/adjustHalLoss(amount)
	if(humanform)
		return humanform.adjustHalLoss(amount)
	else
		return ..()

/mob/living/simple_mob/slime/promethean/adjustCloneLoss(amount)
	if(humanform)
		return humanform.adjustCloneLoss(amount)
	else
		return ..()

/mob/living/simple_mob/slime/promethean/legacy_ex_act(severity)
	if(humanform)
		LEGACY_EX_ACT(humanform, severity, null)
	else
		return ..()

/mob/living/simple_mob/slime/promethean/rad_act(severity)
	. = ..()
	rad_glow += severity
	rad_glow = clamp(rad_glow,0,250)
	if(rad_glow > 1)
		set_light(max(1,min(5,rad_glow/15)), max(1,min(10,rad_glow/25)), color)
		update_icon()

/mob/living/simple_mob/slime/promethean/bullet_act(obj/projectile/P)
	if(humanform)
		return humanform.bullet_act(P)
	else
		return ..()

/mob/living/simple_mob/slime/promethean/death(gibbed, deathmessage = "rapidly loses cohesion, splattering across the ground...")
	if(humanform)
		humanform.death(gibbed, deathmessage)
	else
		var/atom/movable/overlay/O = new(loc)
		O.appearance = src
		animate(O, alpha = 0, time = 2 SECONDS)
		QDEL_IN(O, 2 SECONDS)

	if(!QDELETED(src)) // Human's handle death should have taken us, but maybe we were adminspawned or something without a human counterpart
		qdel(src)

/mob/living/simple_mob/slime/promethean/make_perspective()
	. = ..()
	self_perspective.set_plane_visible(/atom/movable/screen/plane_master/augmented, INNATE_TRAIT)

/mob/living/simple_mob/slime/promethean/proc/prommie_blobform()
	set name = "Toggle Blobform"
	set desc = "Switch between amorphous and humanoid forms."
	set category = "Abilities"
	set hidden = FALSE

	var/atom/movable/to_locate = src
	if(!isturf(to_locate.loc))
		to_chat(src,"<span class='warning'>You need more space to perform this action!</span>")
		return

	//Blob form
	if(!ishuman(src))
		if(humanform.temporary_form.stat || !CHECK_MOBILITY(src, MOBILITY_CAN_USE) || restrained())
			to_chat(src,"<span class='warning'>You can only do this while not stunned.</span>")
		else
			humanform.prommie_outofblob(src)

/mob/living/simple_mob/slime/promethean/proc/toggle_expand()
	set name = "Toggle Width"
	set desc = "Switch between smole and lorge."
	set category = "Abilities"
	set hidden = FALSE

	if(stat || world.time < last_special)
		return

	last_special = world.time + 25

	if(is_wide)
		is_wide = FALSE
		src.visible_message("<b>[src.name]</b> pulls together, compacting themselves into a small ball!")
		update_icon()
	else
		is_wide = TRUE
		src.visible_message("<b>[src.name]</b> flows outwards, their goop expanding!")
		update_icon()

/mob/living/simple_mob/slime/promethean/proc/toggle_shine()
	set name = "Toggle Shine"
	set desc = "Shine on you crazy diamond."
	set category = "Abilities"
	set hidden = FALSE

	if(stat || world.time < last_special)
		return

	last_special = world.time + 25

	if(shiny)
		shiny = FALSE
		src.visible_message("<b>[src.name]</b> dulls their shine, becoming more translucent.")
		update_icon()
	else
		shiny = TRUE
		src.visible_message("<b>[src.name]</b> glistens and sparkles, shining brilliantly.")
		update_icon()

/mob/living/simple_mob/slime/promethean/proc/prommie_select_colour()

	set name = "Select Body Colour"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 25

	var/new_skin = input(usr, "Please select a new body color.", "Shapeshifter Colour", color) as null|color
	if(!new_skin)
		return
	color = new_skin
	update_icon()

/mob/living/simple_mob/slime/promethean/get_description_interaction(mob/user)
	return


/mob/living/simple_mob/slime/promethean/get_description_info()
	return

/mob/living/simple_mob/slime/promethean/init_vore()
	return

/mob/living/carbon/human
	var/mob/living/simple_mob/slime/promethean/stored_blob = null


// Helpers - Unsafe, WILL perform change.
/mob/living/carbon/human/proc/prommie_intoblob(force)
	var/global/list/disallowed_promethean_accessories = list(
	/obj/item/clothing/accessory/holster,
	/obj/item/clothing/accessory/storage,
	/obj/item/clothing/accessory/armor
	)
	if(!force && !isturf(loc))
		to_chat(src,"<span class='warning'>You can't change forms while inside something.</span>")
		return

	handle_grasp() //It's possible to blob out before some key parts of the life loop. This results in things getting dropped at null. TODO: Fix the code so this can be done better.
	remove_micros(src, src) //Living things don't fare well in roblobs.

	buckled?.unbuckle_mob(src, BUCKLE_OP_FORCE)
	unbuckle_all_mobs(BUCKLE_OP_FORCE)
	pulledby?.stop_pulling()
	stop_pulling()

	//Record where they should go
	var/atom/creation_spot = drop_location()
	var/mob/living/simple_mob/slime/promethean/blob = null
	//Create our new blob
	if(!stored_blob)
		blob = new(creation_spot,src)
		blob.mood = ":3"
		qdel(blob.ai_holder)
		blob.ai_holder = null
	else
		blob = stored_blob
		blob.forceMove(creation_spot)

	if(isnull(blob.mob_radio) && istype(l_ear, /obj/item/radio))
		blob.mob_radio = l_ear
		if(!transfer_item_to_loc(l_ear, blob, INV_OP_FORCE))
			blob.mob_radio = null
	if(isnull(blob.mob_radio) && istype(r_ear, /obj/item/radio))
		blob.mob_radio = r_ear
		if(!transfer_item_to_loc(r_ear, blob, INV_OP_FORCE))
			blob.mob_radio = null

	var/has_hat = FALSE
	var/obj/item/clothing/head/new_hat

	for(var/obj/item/clothing/head/H in get_equipped_items())
		new_hat = H
		has_hat = TRUE
		temporarily_remove_from_inventory(H, INV_OP_FORCE | INV_OP_SHOULD_NOT_INTERCEPT | INV_OP_SILENT)
		break

	//Size update
	blob.transform = matrix()*size_multiplier
	blob.size_multiplier = size_multiplier

	if(l_hand)
		blob.prev_left_hand = WEAKREF(l_hand) //Won't save them if dropped above, but necessary if handdrop is disabled.
	if(r_hand)
		blob.prev_right_hand = WEAKREF(r_hand)

	//Put our owner in it (don't transfer var/mind)
	blob.transforming = TRUE
	blob.ckey = ckey
	blob.ooc_notes = ooc_notes
	blob.transforming = FALSE
	blob.name = name
	blob.nutrition = nutrition
	blob.color = rgb(r_skin, g_skin, b_skin)
	playsound(src.loc, "sound/effects/slime_squish.ogg", 15)
	if(radiation > 0)
		blob.rad_glow = clamp(radiation / 5, 0, 250)
		blob.radiation = radiation
		set_light(0)
		blob.set_light(max(1,min(5,radiation/15)), max(1,min(10,radiation/25)), blob.color)
		blob.handle_light()
	if(has_hat)
		blob.hat = new_hat
		new_hat.forceMove(blob)

	blob.update_icon()
	remove_verb(blob, /mob/living/proc/ventcrawl) // Absolutely not.
	//remove_verb(blob, /mob/living/simple_mob/proc/set_name) // We already have a name.
	temporary_form = blob
	//Mail them to nullspace
	forceMove(blob)

	//Message
	blob.visible_message("<b>[src.name]</b> squishes into their true form!")

	//Transfer vore organs
	blob.vore_organs = vore_organs
	blob.vore_selected = vore_selected
	for(var/obj/belly/B as anything in vore_organs)
		B.forceMove(blob)
		B.owner = blob

	//We can still speak our languages!
	blob.languages = languages.Copy()

	//Return our blob in case someone wants it
	return blob

/mob/living/carbon/human/proc/prommie_outofblob(var/mob/living/simple_mob/slime/promethean/blob, force)
	if(!istype(blob))
		return

	if(!force && !isturf(blob.loc))
		to_chat(blob,"<span class='warning'>You can't change forms while inside something.</span>")
		return

	buckled?.unbuckle_mob(src, BUCKLE_OP_FORCE)
	unbuckle_all_mobs(BUCKLE_OP_FORCE)
	pulledby?.stop_pulling()
	stop_pulling()

	//Message
	blob.visible_message("<b>[src.name]</b> pulls together, forming a humanoid shape!")

	//Record where they should go
	var/atom/reform_spot = blob.drop_location()

	//Size update
	resize(blob.size_multiplier, FALSE)

	//Move them back where the blob was
	forceMove(reform_spot)

	//Put our owner in it (don't transfer var/mind)
	playsound(src.loc, "sound/effects/slime_squish.ogg", 15)
	transforming = TRUE
	ckey = blob.ckey
	ooc_notes = blob.ooc_notes // Updating notes incase they change them in blob form.
	transforming = FALSE
	blob.name = "Promethean Blob"
	var/obj/item/hat = blob.hat
	blob.drop_hat()

	if(hat)
		if(!equip_to_slot_if_possible(hat, SLOT_ID_HEAD))
			hat.forceMove(drop_location())
	nutrition = blob.nutrition // food good


	temporary_form = null
	var/blob_color = blob.color
	if(!blob_color)
		blob_color = rgb(255, 255, 255)
	shapeshifter_set_colour(blob_color)
	if(blob.radiation > 0)
		radiation = blob.radiation
		set_light(max(1,min(5,radiation/15)), max(1,min(10,radiation/25)), species.get_flesh_colour(src))
	update_icon()

	//Transfer vore organs
	vore_selected = blob.vore_selected
	for(var/obj/belly/B as anything in blob.vore_organs)
		B.forceMove(src)
		B.owner = src

	//vore_organs.Cut()

	if(blob.prev_left_hand)
		put_in_left_hand(blob.prev_left_hand.resolve()) //The restore for when reforming.
	if(blob.prev_right_hand)
		put_in_right_hand(blob.prev_right_hand.resolve())

	if(!isnull(blob.mob_radio))
		if(!equip_to_slots_if_possible(blob.mob_radio, list(
			/datum/inventory_slot_meta/inventory/ears/left,
			/datum/inventory_slot_meta/inventory/ears/right,
		)))
			blob.mob_radio.forceMove(reform_spot)
		blob.mob_radio = null


	Life(1, SSmobs.times_fired)

	//Get rid of friend blob
	stored_blob = blob
	blob.set_light(0)
	blob.moveToNullspace()
	//qdel(blob)

	//Return ourselves in case someone wants it
	return src

/mob/living/simple_mob/slime/promethean/strip_menu_act(mob/user, action)
	return humanform.strip_menu_act(arglist(args))

/mob/living/simple_mob/slime/promethean/strip_menu_options(mob/user)
	return humanform.strip_menu_options(arglist(args))

/mob/living/simple_mob/slime/promethean/strip_interaction_prechecks(mob/user, autoclose, allow_loc)
	allow_loc = TRUE
	return humanform.strip_interaction_prechecks(arglist(args))

/mob/living/simple_mob/slime/promethean/open_strip_menu(mob/user)
	return humanform.open_strip_menu(arglist(args))

/mob/living/simple_mob/slime/promethean/close_strip_menu(mob/user)
	return humanform.close_strip_menu(arglist(args))

/mob/living/simple_mob/slime/promethean/request_strip_menu(mob/user)
	return humanform.request_strip_menu(arglist(args))

/mob/living/simple_mob/slime/promethean/render_strip_menu(mob/user)
	return humanform.render_strip_menu(arglist(args))

/mob/living/simple_mob/slime/promethean/examine(mob/user, dist)
	. = ..()
	if(hat)
		. += "They are wearing \a [hat]."

/mob/living/simple_mob/slime/promethean/say_understands(var/mob/other, var/datum/language/speaking = null)
	if(speaking?.id == LANGUAGE_ID_PROMETHEAN) //Promethean and sign are both nonverbal, so won't work with the same trick as below, so let's check for them
		return TRUE
	else if(speaking?.id == LANGUAGE_ID_SIGN)
		for(var/datum/language/L in humanform.languages)
			if(L.id == LANGUAGE_ID_SIGN)
				return TRUE
	else if(humanform.say_understands(other, speaking))		//So they're speaking something other than promethean or sign, let's just ask our original mob if it understands
		return TRUE
	else return FALSE
