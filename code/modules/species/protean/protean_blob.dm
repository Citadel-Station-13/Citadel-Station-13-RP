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
	melee_damage_lower = 10
	melee_damage_upper = 10
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

	var/obj/prev_left_hand
	var/obj/prev_right_hand

	player_msg = "In this form, you can move a little faster and your health will regenerate as long as you have metal in you!"
	holder_type = /obj/item/holder/protoblob

/datum/say_list/protean_blob
	speak = list("Blrb?","Sqrsh.","Glrsh!")
	emote_hear = list("squishes softly","spluts quietly","makes wet noises")
	emote_see = list("shifts wetly","undulates placidly")

//Constructor allows passing the human to sync damages
/mob/living/simple_mob/protean_blob/Initialize(mapload, mob/living/carbon/human/H)
	. = ..()
	mob_radio = new(src)
	access_card = new(src)
	if(H)
		humanform = H
		refactory = locate() in humanform.internal_organs
		add_verb(src, /mob/living/proc/hide)
		add_verb(src, /mob/living/simple_mob/protean_blob/proc/useradio)
		add_verb(src, /mob/living/simple_mob/protean_blob/proc/appearanceswitch)
		add_verb(src, /mob/living/simple_mob/protean_blob/proc/rig_transform)
		add_verb(src, /mob/living/proc/usehardsuit)
		INVOKE_ASYNC(src, /mob/living/proc/updatehealth)
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

/mob/living/simple_mob/protean_blob/statpanel_data(client/C)
	. = ..()
	if(humanform && C.statpanel_tab("Species", TRUE))
		. += humanform.species.statpanel_status(C, humanform)

/mob/living/simple_mob/protean_blob/updatehealth()
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
	if(humanform)
		humanform.adjustBruteLossByPart(amount, BP_TORSO)
	else
		..()

/mob/living/simple_mob/protean_blob/adjustFireLoss(var/amount,var/include_robo)
	if(humanform)
		humanform.adjustFireLossByPart(amount, BP_TORSO)
	else
		..()

// citadel hack - FUCK YOU DIE CORRECTLY THIS ENTIRE FETISH RACE IS A SORRY MISTAKE
/mob/living/simple_mob/protean_blob/death(gibbed, deathmessage = "dissolves away, leaving only a few spare parts!")
	if(humanform)
		// ckey transfer you dumb fuck
		humanform.ckey = ckey
		humanform.forceMove(drop_location())
		humanform.death(gibbed = gibbed)
		for(var/organ in humanform.internal_organs)
			var/obj/item/organ/internal/O = organ
			O.removed()
			if(!QDELETED(O))		// MMI_HOLDERS ARE ABSTRACT and qdel themselves :)
				O.forceMove(drop_location())
		var/list/items = humanform.get_equipped_items()
		if(prev_left_hand)
			items += prev_left_hand
		if(prev_right_hand)
			items += prev_right_hand
		for(var/obj/object in items)
			object.forceMove(drop_location())
		QDEL_NULL(humanform) //Don't leave it just sitting in nullspace

	animate(src, alpha = 0, time = 2 SECONDS)
	QDEL_IN(src, 2 SECONDS)

	return ..()

/mob/living/simple_mob/protean_blob/BiologicalLife()
	if((. = ..()))
		return
	if(istype(refactory) && humanform)
		if(!humanform.has_modifier_of_type(/datum/modifier/protean/steelBlob) && health < maxHealth && refactory.get_stored_material(MAT_STEEL) >= 100 && refactory.processingbuffs)
			healing = humanform.add_modifier(/datum/modifier/protean/steelBlob, origin = refactory)
		else if(humanform.has_modifier_of_type(/datum/modifier/protean/steelBlob) && health >= maxHealth)
			humanform.remove_a_modifier_of_type(/datum/modifier/protean/steelBlob)

/mob/living/simple_mob/protean_blob/lay_down()
	..()
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

		if(is_type_in_list(I,edible_trash) | adminbus_trash)
			if(I.hidden_uplink)
				to_chat(src, "<span class='warning'>You really should not be eating this.</span>")
				message_admins("[key_name(src)] has attempted to ingest an uplink item. ([src ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>" : "null"])")
				return
		visible_message("<b>[name]</b> stretches itself over the [I], engulfing it whole!")
		I.forceMove(vore_selected)
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

/mob/living/simple_mob/protean_blob/attack_hand(mob/living/L)
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
	if(loc == /obj/item/rig/protean)
		return
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

	for(var/obj/item/rig/protean/O in things_to_drop)
		things_to_drop -= O

	for(var/obj/item/I in things_to_drop) //rip hoarders
		drop_item_to_ground(I)

	if(wearing_rig)
		for(var/obj/item/I in list(wearing_rig.helmet, wearing_rig.chest, wearing_rig.gloves, wearing_rig.boots))
			transfer_item_to_loc(I, wearing_rig, INV_OP_FORCE)

	for(var/obj/item/radio/headset/HS in things_to_not_drop)
		if(HS.keyslot1)
			blob.mob_radio.keyslot1 = new HS.keyslot1.type(blob.mob_radio)
		if(HS.keyslot2)
			blob.mob_radio.keyslot2 = new HS.keyslot2.type(blob.mob_radio)
		if(HS.adhoc_fallback)
			blob.mob_radio.adhoc_fallback = TRUE
		blob.mob_radio.recalculateChannels()

	for(var/obj/item/pda/P in things_to_not_drop)
		if(P.id)
			var/obj/item/card/id/PID = P.id
			blob.access_card.access += PID.access

	for(var/obj/item/card/id/I in things_to_not_drop)
		blob.access_card.access += I.access

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
		blob.allowmobvore = P.allowmobvore
		blob.vore_taste = P.vore_taste
		blob.permit_healbelly = P.permit_healbelly
		blob.can_be_drop_prey = P.can_be_drop_prey
		blob.can_be_drop_pred = P.can_be_drop_pred

	//Return our blob in case someone wants it
	return blob

//For some reason, there's no way to force drop all the mobs grabbed. This ought to fix that. And be moved elsewhere. Call with caution, doesn't handle cycles.
/proc/remove_micros(var/src, var/mob/root)
	for(var/obj/item/I in src)
		remove_micros(I, root) //Recursion. I'm honestly depending on there being no containment loop, but at the cost of performance that can be fixed too.
		if(istype(I, /obj/item/holder))
			I.forceMove(root.drop_location())

/mob/living/simple_mob/protean_blob/proc/useradio()
	set name = "Utilize Radio"
	set desc = "Allows a protean blob to interact with its internal radio."
	set category = "Abilities"

	if(mob_radio)
		mob_radio.nano_ui_interact(src, state = interactive_state)

/mob/living/simple_mob/protean_blob/proc/rig_transform()
	set name = "Modify Form - Hardsuit"
	set desc = "Allows a protean blob to solidify its form into one extremely similar to a hardsuit."
	set category = "Abilities"

	if(istype(loc, /obj/item/rig/protean))
		var/obj/item/rig/protean/prig = loc
		src.forceMove(get_turf(prig))
		prig.forceMove(humanform)
		return

	if(isturf(loc))
		var/obj/item/rig/protean/prig
		for(var/obj/item/rig/protean/O in humanform.contents)
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

	if(istype(loc, /obj/item/rig/protean))
		var/obj/item/rig/protean/prig = loc
		to_chat(src, "You attempt to interface with the [prig].")
		prig.nano_ui_interact(src, nano_state = interactive_state)
	else
		to_chat(src, "You are not in RIG form.")

/mob/living/carbon/human/proc/nano_outofblob(var/mob/living/simple_mob/protean_blob/blob)
	if(!istype(blob))
		return
	if(blob.loc == /obj/item/rig/protean)
		return

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

	if(blob.prev_left_hand) put_in_left_hand(blob.prev_left_hand) //The restore for when reforming.
	if(blob.prev_right_hand) put_in_right_hand(blob.prev_right_hand)

	Life(1, SSmobs.times_fired)

	//Get rid of friend blob
	qdel(blob)

	//Return ourselves in case someone wants it
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

/mob/living/simple_mob/protean_blob/Login()
	..()
	plane_holder.set_vis(VIS_AUGMENTED, TRUE)

/datum/modifier/protean/steelBlob // Blob regen is stronger than non-blob to have some incentive other than erp
	name = "Protean Blob Effect - Steel"
	desc = "You're affected by the presence of steel."

	on_created_text = "<span class='notice'>You feel new nanites being produced from your stockpile of steel, healing you.</span>"
	on_expired_text = "<span class='notice'>Your steel supply has either run out, or is no longer needed, and your healing stops.</span>"

	material_name = MAT_STEEL

/datum/modifier/protean/steelBlob/tick()
	..()
	if(holder.temporary_form?.resting)
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
