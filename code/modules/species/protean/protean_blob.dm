// Simple animal nanogoopeyness
/mob/living/simple_mob/protean_blob
	name = "protean blob"
	desc = "Some sort of big viscous pool of jelly."
	tt_desc = "Animated nanogoop"
	icon = 'icons/mob/clothing/species/protean/protean.dmi'
	icon_state = "to_puddle"
	icon_living = "puddle2"
	icon_rest = "rest"
	icon_dead = "puddle"

	faction = "neutral"
	maxHealth = 250
	health = 250
	say_list_type = /datum/say_list/protean_blob

	show_stat_health = FALSE //We will do it ourselves
	has_langs = list(LANGUAGE_GALCOM, LANGUAGE_EAL)
	response_help = "pats the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"

	harm_intent_damage = 2
	legacy_melee_damage_lower = 15
	legacy_melee_damage_upper = 15
	attacktext = list("smashed", "rammed") // Why would an amorphous blob be slicing stuff?

	aquatic_movement = 1
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	// THIS IS INTENDED.
	// "But why?"
	// So proteans don't **die** from temperature, rather than being forced into blobform.
	minbodytemp = 0
	maxbodytemp = INFINITY
	heat_resist = 1
	cold_resist = 1
	shock_resist = 0.9
	poison_resist = 1

	movement_cooldown = 0.5
	base_attack_cooldown = 10

	var/mob/living/carbon/human/humanform
	var/obj/item/organ/internal/nano/refactory/refactory
	var/datum/modifier/healing

	var/datum/weakref/prev_left_hand
	var/datum/weakref/prev_right_hand

	player_msg = "In this form, you can move a little faster and your health will regenerate as long as you have metal in you!"
	holder_type = /obj/item/holder/protoblob

/datum/say_list/protean_blob
	speak = list("Blrb?","Sqrsh.","Glrsh!")
	emote_hear = list("squishes softly","spluts quietly","makes wet noises")
	emote_see = list("shifts wetly","undulates placidly")

//Constructor allows passing the human to sync damages
/mob/living/simple_mob/protean_blob/Initialize(mapload, mob/living/carbon/human/H)
	. = ..()
	access_card = new(src)
	if(H)
		humanform = H
		refactory = locate() in humanform.internal_organs
		add_verb(src, /mob/living/proc/hide)
		add_verb(src, /mob/living/simple_mob/protean_blob/proc/appearanceswitch)
		add_verb(src, /mob/living/simple_mob/protean_blob/proc/rig_transform)
		add_verb(src, /mob/living/simple_mob/protean_blob/proc/leap_attack)
		add_verb(src, /mob/living/simple_mob/protean_blob/proc/chameleon_apperance)
		add_verb(src, /mob/living/simple_mob/protean_blob/proc/chameleon_color)
		add_verb(src, /mob/living/simple_mob/protean_blob/proc/chameleon_apperance_rig)
		add_verb(src, /mob/living/proc/usehardsuit)
		INVOKE_ASYNC(src, TYPE_PROC_REF(/mob, update_health))
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

/mob/living/simple_mob/protean_blob/init_melee_style()
	. = ..()
	melee_style.damage_structural_add = 30

/mob/living/simple_mob/protean_blob/init_vore()
	return //Don't make a random belly, don't waste your time

/mob/living/simple_mob/protean_blob/statpanel_data(client/C)
	. = ..()
	if(humanform && C.statpanel_tab("Species", TRUE))
		. += humanform.species.statpanel_status(C, humanform)

/mob/living/simple_mob/protean_blob/update_health()
	if(humanform)
		//Set the max
		maxHealth = humanform.getMaxHealth() + 100 // +100 for crit threshold so you don't die from trying to blob to heal, ironically
		var/obj/item/organ/external/E = humanform.get_organ(BP_TORSO)
		//Set us to their health, but, human health ignores robolimbs so we do it 'the hard way'
		health = maxHealth - E.brute_dam - E.burn_dam
		movement_cooldown = 0.5 + max(0, (maxHealth - health) - 100) / 35
		base_attack_cooldown = 10 + max(0, (maxHealth - health) - 100) / 15

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

/mob/living/simple_mob/protean_blob/stun_effect_act(var/stun_amount, var/agony_amount, var/def_zone, var/used_weapon=null)
	return FALSE //ok so tasers hurt protean blobs what the fuck

/mob/living/simple_mob/protean_blob/adjustBruteLoss(var/amount,var/include_robo)
	return humanform? humanform.take_targeted_damage(brute = amount, body_zone = BP_TORSO) : ..()

/mob/living/simple_mob/protean_blob/adjustFireLoss(var/amount,var/include_robo)
	return humanform? humanform.take_targeted_damage(burn = amount, body_zone = BP_TORSO) : ..()

// citadel hack - FUCK YOU DIE CORRECTLY THIS ENTIRE FETISH RACE IS A SORRY MISTAKE
/mob/living/simple_mob/protean_blob/death(gibbed, deathmessage = "dissolves away, leaving only a few spare parts!")
	if(!QDELETED(humanform))
		humanform.forceMove(loc)
		humanform.ckey = ckey
		humanform.gib()
	humanform = null
	. = ..()
	ASYNC
		if(!QDELETED(src))
			qdel(src)

/mob/living/simple_mob/protean_blob/BiologicalLife()
	if((. = ..()))
		return
	if(isnull(humanform))
		return
	if(istype(refactory) && humanform)
		if(!humanform.has_modifier_of_type(/datum/modifier/protean/steelBlob) && health < maxHealth && refactory.get_stored_material(MAT_STEEL) >= 100 && refactory.processingbuffs)
			healing = humanform.add_modifier(/datum/modifier/protean/steelBlob, origin = refactory)
		else if(humanform.has_modifier_of_type(/datum/modifier/protean/steelBlob) && health >= maxHealth)
			humanform.remove_a_modifier_of_type(/datum/modifier/protean/steelBlob)
	humanform.normalize_bodytemperature(40, 0.5)

/mob/living/simple_mob/protean_blob/update_mobility(blocked, forced)
	if(resting)
		blocked |= MOBILITY_FLAGS_REAL
	return ..()

/mob/living/simple_mob/protean_blob/lay_down()
	toggle_resting()
	if(resting)
		to_chat(src, "<span class='warning'>You blend into the floor beneath you. <b>You will not be able to heal while doing so.</b></span>")
		animate(src,alpha = 40,time = 1 SECOND)
		mouse_opacity = 0
	else
		to_chat(src, "<span class='warning'>You get up from the floor.</span>")
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
				var/allowed = TRUE
				if(target.client && target.can_be_drop_prey)//you can still vore ai mobs with the pref off
					allowed = FALSE
				if(istype(target) && vore_selected && allowed) //no more ooc-noncon vore, thanks
					if(target.buckled)
						target.buckled.unbuckle_mob(target, BUCKLE_OP_FORCE)
					target.forceMove(vore_selected)
					to_chat(target,"<span class='warning'>\The [src] quickly engulfs you, [vore_selected.vore_verb]ing you into their [vore_selected.name]!</span>")

/mob/living/simple_mob/protean_blob/attack_target(var/atom/A)
	if(refactory && istype(A,/obj/item/stack/material))
		var/obj/item/stack/material/S = A
		var/substance = S.material.name
		var/list/edible_materials = list(MAT_STEEL, MAT_SILVER, MAT_GOLD, MAT_URANIUM, MAT_METALHYDROGEN) //Can't eat all materials, just useful ones.
		var/allowed = FALSE
		for(var/material in edible_materials)
			if(material == substance)
				allowed = TRUE
		if(!allowed)
			return
		if(refactory.add_stored_material(S.material.name,1*S.perunit) && S.use(1))
			visible_message("<b>[name]</b> gloms over some of \the [S], absorbing it.")
	else if(isitem(A) && a_intent == "grab")
		var/obj/item/I = A
		if(!vore_selected)
			to_chat(src,"<span class='warning'>You either don't have a belly selected, or don't have a belly!</span>")
			return FALSE
		if(is_type_in_list(I,GLOB.item_vore_blacklist) || I.anchored)
			to_chat(src, "<span class='warning'>You can't eat this.</span>")
			return

		if(is_type_in_list(I, edible_trash) || adminbus_trash)
			if(I.hidden_uplink)
				to_chat(src, "<span class='warning'>You really should not be eating this.</span>")
				message_admins("[key_name(src)] has attempted to ingest an uplink item. ([src ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>" : "null"])")
				return
			visible_message("<b>[name]</b> stretches itself over the [I], engulfing it whole!")
			I.forceMove(vore_selected)
			return
	else
		return ..()

/mob/living/simple_mob/protean_blob/attackby(var/obj/item/O, var/mob/user)
	if(refactory && istype(O,/obj/item/stack/material))
		var/obj/item/stack/material/S = O
		var/substance = S.material.name
		var/list/edible_materials = list("steel", "plasteel", "diamond", "mhydrogen") //Can't eat all materials, just useful ones.
		var/allowed = FALSE
		for(var/material in edible_materials)
			if(material == substance)
				allowed = TRUE
		if(!allowed)
			return
		if(refactory.add_stored_material(S.material.name,1*S.perunit) && S.use(1))
			visible_message("<b>[name]</b> gloms over some of \the [S], absorbing it.")
	else
		return ..()

/mob/living/simple_mob/protean_blob/attack_hand(mob/user, list/params)
	var/mob/living/L = user
	if(!istype(L))
		return
	if(L.get_effective_size() >= (src.get_effective_size() + 0.5) )
		src.get_scooped(L)
	else
		..()

/mob/living/simple_mob/protean_blob/OnMouseDropLegacy(var/atom/over_object)
	if(ishuman(over_object) && usr == src && src.Adjacent(over_object))
		var/mob/living/carbon/human/H = over_object
		get_scooped(H, TRUE)
	else
		return ..()

/mob/living/simple_mob/protean_blob/emp_act(severity)
	to_chat(src, "<font align='center' face='fixedsys' size='10' color='red'><B>*BZZZT*</B></font>")
	to_chat(src, "<font face='fixedsys'><span class='danger'>Warning: Electromagnetic pulse detected.</span></font>")
	to_chat(src, "<font face='fixedsys'><span class='danger'>Warning: Navigation systems offline. Restarting...</span></font>")
	return humanform.emp_act(severity)

/mob/living/simple_mob/protean_blob/MouseEntered(location,control,params)
	if(resting)
		return
	..()

// Helpers - Unsafe, WILL perform change.
/mob/living/carbon/human/proc/nano_intoblob()
	if(loc == /obj/item/hardsuit/protean)
		return
	if(transforming)
		return
	transforming = TRUE
	handle_grasp() //It's possible to blob out before some key parts of the life loop. This results in things getting dropped at null. TODO: Fix the code so this can be done better.
	remove_micros(src, src) //Living things don't fare well in roblobs.

	buckled?.unbuckle_mob(src, BUCKLE_OP_FORCE)
	unbuckle_all_mobs(BUCKLE_OP_FORCE)
	pulledby?.stop_pulling()
	stop_pulling()

	var/panel_selected = client?.statpanel == SPECIES_PROTEAN

	//Record where they should go
	var/atom/creation_spot = drop_location()

	//Create our new blob
	var/mob/living/simple_mob/protean_blob/blob = new(creation_spot,src)

	if(isnull(blob.mob_radio) && istype(l_ear, /obj/item/radio))
		blob.mob_radio = l_ear
		if(!transfer_item_to_loc(l_ear, blob, INV_OP_FORCE | INV_OP_SHOULD_NOT_INTERCEPT | INV_OP_SILENT))
			blob.mob_radio = null
	if(isnull(blob.mob_radio) && istype(r_ear, /obj/item/radio))
		blob.mob_radio = r_ear
		if(!transfer_item_to_loc(r_ear, blob, INV_OP_FORCE | INV_OP_SHOULD_NOT_INTERCEPT | INV_OP_SILENT))
			blob.mob_radio = null

	//Size update
	blob.transform = matrix()*size_multiplier
	blob.size_multiplier = size_multiplier

	if(l_hand)
		blob.prev_left_hand = WEAKREF(l_hand) //Won't save them if dropped above, but necessary if handdrop is disabled.
	if(r_hand)
		blob.prev_right_hand = WEAKREF(r_hand)

	//languages!!
	for(var/datum/language/L in languages)
		blob.add_language(L.name)
	//Put our owner in it (don't transfer var/mind)
	blob.ckey = ckey
	temporary_form = blob

	//Mail them to nullspace
	forceMove(blob)

	if(blob.client && panel_selected)
		blob.client.statpanel = SPECIES_PROTEAN

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

	var/datum/vore_preferences/P = blob.client?.prefs_vr

	if(P)
		blob.digestable = P.digestable
		blob.devourable = P.devourable
		blob.feeding = P.feeding
		blob.digest_leave_remains = P.digest_leave_remains
		blob.vore_taste = P.vore_taste
		blob.permit_healbelly = P.permit_healbelly
		blob.can_be_drop_prey = P.can_be_drop_prey
		blob.can_be_drop_pred = P.can_be_drop_pred

	transforming = FALSE

	//Return our blob in case someone wants it
	return blob

//For some reason, there's no way to force drop all the mobs grabbed. This ought to fix that. And be moved elsewhere. Call with caution, doesn't handle cycles.
/proc/remove_micros(var/src, var/mob/root)
	for(var/obj/item/I in src)
		remove_micros(I, root) //Recursion. I'm honestly depending on there being no containment loop, but at the cost of performance that can be fixed too.
		if(istype(I, /obj/item/holder))
			I.forceMove(root.drop_location())

/mob/living/simple_mob/protean_blob/strip_menu_act(mob/user, action)
	return humanform.strip_menu_act(arglist(args))

/mob/living/simple_mob/protean_blob/strip_menu_options(mob/user)
	return humanform.strip_menu_options(arglist(args))

/mob/living/simple_mob/protean_blob/strip_interaction_prechecks(mob/user, autoclose, allow_loc)
	allow_loc = TRUE
	return humanform.strip_interaction_prechecks(arglist(args))

/mob/living/simple_mob/protean_blob/open_strip_menu(mob/user)
	return humanform.open_strip_menu(arglist(args))

/mob/living/simple_mob/protean_blob/close_strip_menu(mob/user)
	return humanform.close_strip_menu(arglist(args))

/mob/living/simple_mob/protean_blob/request_strip_menu(mob/user)
	return humanform.request_strip_menu(arglist(args))

/mob/living/simple_mob/protean_blob/render_strip_menu(mob/user)
	return humanform.render_strip_menu(arglist(args))

/mob/living/simple_mob/protean_blob/proc/rig_transform()
	set name = "Modify Form - Hardsuit"
	set desc = "Allows a protean blob to solidify its form into one extremely similar to a hardsuit."
	set category = "Abilities"

	if(istype(loc, /obj/item/hardsuit/protean))
		var/obj/item/hardsuit/protean/prig = loc
		src.forceMove(get_turf(prig))
		prig.forceMove(humanform)
		return

	if(isturf(loc))
		var/obj/item/hardsuit/protean/prig
		for(var/obj/item/hardsuit/protean/O in humanform.contents)
			prig = O
			break
		if(prig)
			prig.forceMove(get_turf(src))
			src.forceMove(prig)
			return

/mob/living/proc/usehardsuit()
	set name = "Utilize Hardsuit Interface"
	set desc = "Allows a protean blob to open hardsuit interface."
	set category = "Abilities"

	if(istype(loc, /obj/item/hardsuit/protean))
		var/obj/item/hardsuit/protean/prig = loc
		to_chat(src, "You attempt to interface with the [prig].")
		prig.nano_ui_interact(src, nano_state = interactive_state)
	else
		to_chat(src, "You are not in hardsuit form.")

/mob/living/carbon/human/proc/nano_outofblob(var/mob/living/simple_mob/protean_blob/blob)
	if(!istype(blob))
		return
	if(istype(blob.loc, /obj/item/hardsuit/protean))
		return
	if(transforming)
		return
	transforming = TRUE

	buckled?.unbuckle_mob(src, BUCKLE_OP_FORCE)
	unbuckle_all_mobs(BUCKLE_OP_FORCE)
	pulledby?.stop_pulling()
	stop_pulling()

	var/panel_selected = blob.client?.statpanel == SPECIES_PROTEAN

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

	if(client && panel_selected)
		client.statpanel = SPECIES_PROTEAN

	//Transfer vore organs
	vore_selected = blob.vore_selected
	for(var/belly in blob.vore_organs)
		var/obj/belly/B = belly
		B.forceMove(src)
		B.owner = src

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
	qdel(blob)

	//Return ourselves in case someone wants it
	transforming = FALSE
	return src

/mob/living/simple_mob/protean_blob/say_understands()
	return humanform?.say_understands(arglist(args)) || ..()

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

	if(istype(loc, /obj/item/holder))
		var/obj/item/holder/H = loc
		H.sync()


/mob/living/simple_mob/protean_blob/proc/leap_attack()
	set name = "Pounce"
	set desc = "Allows a protean blob to launch itself at people."
	set category = "Abilities"

	var/mob/living/carbon/human/target
	var/targeted_area
	var/target_displayname

	if(src.incapacitated())
		to_chat(src,"<span class='warning'>You can't do this in your current state.</span>")
		return

	var/list/choices = list()
	for(var/mob/living/carbon/human/M in oviewers(1))
		choices += M

	if(!choices.len)
		to_chat(src,"<span class='warning'>There's nobody nearby to use this on.</span>")
		return

	target = input(src,"Who do you wish to target?","Pounce Target") as null|anything in choices
	if(!istype(target))
		return FALSE

	if(get_dist(src,target) > 1)
		to_chat(src,"<span class='warning'>There's nobody nearby to use this on.</span>")
		return

	visible_message("<span class='warning'>[src] coils itself up like a spring, preparing to leap at [target]!</span>")
	if(do_after(src, 1 SECOND, target)) //1 second
		if(buckled || pinned.len)
			return

		var/obj/item/holder/H = new holder_type(get_turf(src))
		H.held_mob = src
		src.forceMove(H)

		switch(src.zone_sel.selecting)
			if(BP_L_LEG)
				targeted_area = SLOT_ID_UNIFORM //fetish_code.rtf
				target_displayname = "body"
			if(BP_R_LEG)
				targeted_area = SLOT_ID_UNIFORM //fetish_code.rtf
				target_displayname = "body"
			if(BP_TORSO)
				targeted_area = SLOT_ID_SUIT
				target_displayname = "body"
			if(BP_HEAD)
				targeted_area = SLOT_ID_HEAD
				target_displayname = "head"
			if(O_MOUTH)
				targeted_area = SLOT_ID_MASK
				target_displayname = "face"
			if(BP_R_HAND)
				targeted_area = SLOT_ID_GLOVES
				target_displayname = "body"
			if(BP_L_HAND)
				targeted_area = SLOT_ID_GLOVES
				target_displayname = "body"
			if(BP_GROIN)
				targeted_area = SLOT_ID_BACK
				target_displayname = "back"
			if(BP_L_FOOT)
				targeted_area = SLOT_ID_SHOES
				target_displayname = "feet"
			if(BP_R_FOOT)
				targeted_area = SLOT_ID_SHOES
				target_displayname = "feet"
			if(O_EYES)
				targeted_area = SLOT_ID_GLASSES
				target_displayname = "eyes"

		if(target.equip_to_slot_if_possible(H, targeted_area, INV_OP_IGNORE_DELAY | INV_OP_SILENT))
			visible_message("<span class='danger'>[src] leaps at [target]'s [target_displayname]!</span>")
		else
			visible_message("<span class='notice'>[src] leaps at [target]'s [target_displayname] and bounces off harmlessly!</span>")
		H.sync(src)
		return

/mob/living/simple_mob/protean_blob/proc/chameleon_apperance()
	set name = "Chameleon Change"
	set desc = "Allows a protean blob to change or reset its apperance when worn."
	set category = "Abilities"

	if(!istype(loc, /obj/item/holder))
		to_chat(src, "<span class='notice'>You can't do that while not being held or worn.</span>")
		return

	var/obj/item/holder/H = loc
	var/chosen_list
	var/icon_file
	switch(input(src,"What type of clothing would you like to mimic or reset appearance?","Mimic Clothes") as null|anything in list("under", "suit", "hat", "gloves", "shoes", "back", "mask", "glasses", "belt", "ears", "headsets", "reset"))
		if("reset")
			H.color = initial(H.color)
			H.icon_override = null
			H.sync(src)
			return
		if("under")
			chosen_list = GLOB.clothing_under
			icon_file = 'icons/mob/clothing/uniform.dmi'
		if("suit")
			chosen_list = GLOB.clothing_suit
			icon_file = 'icons/mob/clothing/suits.dmi'
		if("hat")
			chosen_list = GLOB.clothing_head
			icon_file = 'icons/mob/clothing/head.dmi'
		if("gloves")
			chosen_list = GLOB.clothing_gloves
			icon_file = 'icons/mob/clothing/hands.dmi'
		if("shoes")
			chosen_list = GLOB.clothing_shoes
			icon_file = 'icons/mob/clothing/feet.dmi'
		if("back")
			chosen_list = GLOB.clothing_backpack
			icon_file = 'icons/mob/clothing/back.dmi'
		if("mask")
			chosen_list = GLOB.clothing_mask
			icon_file = 'icons/mob/clothing/mask.dmi'
		if("glasses")
			chosen_list = GLOB.clothing_glasses
			icon_file = 'icons/mob/clothing/eyes.dmi'
		if("belt")
			chosen_list = GLOB.clothing_belt
			icon_file = 'icons/mob/clothing/belt.dmi'
		if("ears")
			chosen_list = GLOB.clothing_ears
			icon_file = 'icons/mob/clothing/ears.dmi'
		if("headsets")
			chosen_list = GLOB.clothing_headsets
			icon_file = 'icons/mob/clothing/ears.dmi'
			
	var/picked = input(src,"What clothing would you like to mimic?","Mimic Clothes") as null|anything in chosen_list

	if(!ispath(chosen_list[picked]))
		return

	H.disguise(chosen_list[picked])
	if(isnull(H.icon_override))
		H.icon_override = icon_file
	H.update_worn_icon()	//so our overlays update.
	
	if (ismob(H.loc))
		var/mob/M = H.loc
		M.update_inv_belt() //so our overlays
		M.update_inv_back()


/mob/living/simple_mob/protean_blob/proc/chameleon_apperance_rig()
	set name = "Chameleon Hardsuit Change"
	set desc = "Allows a protean blob to change or reset its apperance when worn."
	set category = "Abilities"

	if(!istype(loc, /obj/item/hardsuit/protean))
		to_chat(src, "<span class='notice'>You can't do that while not being held or worn as a hardsuit.</span>")
		return

	var/obj/item/hardsuit/protean/H = loc
	var/chosen_list
	var/obj/item/clothing/chosenpart

	switch(input(src,"What type of clothing would you like to mimic or reset appearance?","Mimic Clothes") as null|anything in list("suit", "helmet", "gloves", "boots", "reset"))
		if("reset")
			H.boots.disguise(H.boots.type) //disguising it as itself just sets its vars back to initial which is what we want
			H.chest.disguise(H.chest.type)
			H.helmet.disguise(H.helmet.type)
			H.gloves.disguise(H.gloves.type)
			H.boots.update_worn_icon()
			H.chest.update_worn_icon()
			H.helmet.update_worn_icon()
			H.gloves.update_worn_icon()
			return
		if("suit")
			chosenpart = H.chest
			chosen_list = GLOB.clothing_suit
		if("helmet")
			chosenpart = H.helmet
			chosen_list = GLOB.clothing_head
		if("gloves")
			chosenpart = H.gloves
			chosen_list = GLOB.clothing_gloves
		if("boots")
			chosenpart = H.boots
			chosen_list = GLOB.clothing_shoes

	
	var/picked = input(src,"What clothing would you like to mimic?","Mimic Clothes") as null|anything in chosen_list

	if(!ispath(chosen_list[picked]))
		return

	chosenpart.disguise(chosen_list[picked])
	chosenpart.update_worn_icon()


/mob/living/simple_mob/protean_blob/proc/chameleon_color()
	set name = "Chameleon Color"
	set desc = "Allows a protean blob to change or reset its color when worn."
	set category = "Abilities"

	if(!istype(loc, /obj/item/holder))
		to_chat(src, "<span class='notice'>You can't do that while not being held or worn.</span>")
		return

	var/obj/item/holder/H = loc
	var/color_in = input("Pick a color. Cancelling sets it to default.","Color", H.color) as null|color
	
	if(color_in)
		H.color = color_in
	else
		H.color = initial(H.color)
	H.update_worn_icon()	//so our overlays update.


/mob/living/simple_mob/protean_blob/make_perspective()
	. = ..()
	self_perspective.set_plane_visible(/atom/movable/screen/plane_master/augmented, INNATE_TRAIT)

/datum/modifier/protean/steelBlob // Blob regen is stronger than non-blob to have some incentive other than erp
	name = "Protean Blob Effect - Steel"
	desc = "You're affected by the presence of steel."

	on_created_text = "<span class='notice'>You feel new nanites being produced from your stockpile of steel, healing you.</span>"
	on_expired_text = "<span class='notice'>Your steel supply has either run out, or is no longer needed, and your healing stops.</span>"

	material_name = MAT_STEEL

/datum/modifier/protean/steelBlob/tick()
	..()
	var/mob/living/living_form = holder.temporary_form
	if(istype(living_form) && living_form.resting)
		return
	var/dt = 2	// put it on param sometime but for now assume 2
	var/mob/living/carbon/human/H = holder
	var/obj/item/organ/external/E = H.get_organ(BP_TORSO)
	var/heal = 5 * dt
	var/brute_heal_left = max(0, heal - E.brute_dam)
	var/burn_heal_left = max(0, heal - E.burn_dam)

	E.heal_damage(min(heal, E.brute_dam), min(heal, E.burn_dam), TRUE, TRUE)

	holder.adjustBruteLoss(-brute_heal_left, include_robo = TRUE)
	holder.adjustFireLoss(-burn_heal_left, include_robo = TRUE)
	holder.adjustToxLoss(-10)
	holder.cure_radiation(RAD_MOB_CURE_PROTEAN_REGEN)

	for(var/organ in H.internal_organs)
		var/obj/item/organ/O = organ
		// Fix internal damage
		if(O.damage > 0)
			O.heal_damage_i(3, can_revive = TRUE)
