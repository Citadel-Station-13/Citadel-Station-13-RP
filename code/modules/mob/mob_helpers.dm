// fun if you want to typecast humans/monkeys/etc without writing long path-filled lines.
/proc/isxenomorph(A)
	if(istype(A, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = A
		return istype(H.species, /datum/species/xenos)
	return 0

/proc/issmall(A)
	if(A && istype(A, /mob/living))
		var/mob/living/L = A
		return L.mob_size <= MOB_SMALL
	return 0

//returns the number of size categories between two mob_sizes, rounded. Positive means A is larger than B
/proc/mob_size_difference(var/mob_size_A, var/mob_size_B)
	return round(log(2, mob_size_A/mob_size_B), 1)

/mob/proc/can_wield_item(obj/item/W)
	if(W.w_class >= ITEMSIZE_LARGE && issmall(src))
		return FALSE //M is too small to wield this
	return TRUE

/proc/istiny(A)
	if(A && istype(A, /mob/living))
		var/mob/living/L = A
		return L.mob_size <= MOB_TINY
	return 0


/proc/ismini(A)
	if(A && istype(A, /mob/living))
		var/mob/living/L = A
		return L.mob_size <= MOB_MINISCULE
	return 0

/mob/living/silicon/isSynthetic()
	return 1

/mob/proc/isMonkey()
	return 0

/mob/living/carbon/human/isMonkey()
	return istype(species, /datum/species/monkey)

/proc/isdeaf(A)
	if(istype(A, /mob))
		var/mob/M = A
		return (M.sdisabilities & SDISABILITY_DEAF) || M.ear_deaf
	return 0

/mob/proc/get_ear_protection()
	return 0

/mob/proc/break_cloak()
	return

/mob/proc/is_cloaked()
	return FALSE

/proc/hasorgans(A) // Fucking really??
	return ishuman(A)

/proc/iscuffed(A)
	if(istype(A, /mob/living/carbon))
		var/mob/living/carbon/C = A
		if(C.handcuffed)
			return 1
	return 0

/proc/hassensorlevel(A, var/level)
	var/mob/living/carbon/human/H = A
	if(istype(H) && istype(H.w_uniform, /obj/item/clothing/under))
		var/obj/item/clothing/under/U = H.w_uniform
		return U.sensor_mode >= level
	return 0

/proc/getsensorlevel(A)
	var/mob/living/carbon/human/H = A
	if(istype(H) && istype(H.w_uniform, /obj/item/clothing/under))
		var/obj/item/clothing/under/U = H.w_uniform
		return U.sensor_mode
	return SUIT_SENSOR_OFF


/proc/is_admin(var/mob/user)
	return check_rights(R_ADMIN, 0, user) != 0

/**
 * Returns true if the user should have admin AI level access
 *! TO-BE-DEPRICATED
 */
/proc/IsAdminGhost(mob/user)
	if(!user)		//Are they a mob? Auto interface updates call this with a null src
		return
	if(!user.client) // Do they have a client?
		return
	if(!isobserver(user)) // Are they a ghost?
		return
	if(!check_rights(R_ADMIN, 0, user)) // Are they allowed?
		return
	if(!user.client.AI_Interact) // Do they have it enabled?
		return
	return TRUE

/// Is the passed in mob a ghost with admin powers, doesn't check for AI interact like isAdminGhost() used to
/proc/isAdminObserver(mob/user)
	if(!user) //Are they a mob? Auto interface updates call this with a null src
		return
	if(!user.client) // Do they have a client?
		return
	if(!isobserver(user)) // Are they a ghost?
		return
	if(!check_rights_for(user.client, R_ADMIN)) // Are they allowed?
		return
	return TRUE

/// Is the passed in mob an admin ghost WITH AI INTERACT enabled
/proc/isAdminGhostAI(mob/user)
	if(!isAdminObserver(user))
		return
	if(!user.client.AI_Interact) // Do they have it enabled?
		return
	return TRUE

/**
 * Returns true if the AI has silicon control with those flags
 */
/* - Unused until AI interaction refactor
/atom/proc/hasSiliconAccessInArea(mob/user, flags = PRIVILEDGES_SILICON, all = FALSE)
	return all? ((user.silicon_privileges & (flags)) == flags) : (user.silicon_privileges & flags)
*/

/*
	Miss Chance
*/

/proc/check_zone(zone)
	if(!zone)	return BP_TORSO
	switch(zone)
		if(O_EYES)
			zone = BP_HEAD
		if(O_MOUTH)
			zone = BP_HEAD
	return zone

// Returns zone with a certain probability. If the probability fails, or no zone is specified, then a random body part is chosen.
// Do not use this if someone is intentionally trying to hit a specific body part.
// Use get_zone_with_miss_chance() for that.
/proc/ran_zone(zone, probability)
	if (zone)
		zone = check_zone(zone)
		if (prob(probability))
			return zone

	var/ran_zone = zone
	while (ran_zone == zone)
		ran_zone = pick (
			organ_rel_size[BP_HEAD];   BP_HEAD,
			organ_rel_size[BP_TORSO];  BP_TORSO,
			organ_rel_size[BP_GROIN];  BP_GROIN,
			organ_rel_size[BP_L_ARM];  BP_L_ARM,
			organ_rel_size[BP_R_ARM];  BP_R_ARM,
			organ_rel_size[BP_L_LEG];  BP_L_LEG,
			organ_rel_size[BP_R_LEG];  BP_R_LEG,
			organ_rel_size[BP_L_HAND]; BP_L_HAND,
			organ_rel_size[BP_R_HAND]; BP_R_HAND,
			organ_rel_size[BP_L_FOOT]; BP_L_FOOT,
			organ_rel_size[BP_R_FOOT]; BP_R_FOOT,
		)

	return ran_zone

// Emulates targetting a specific body part, and miss chances
// May return null if missed
// miss_chance_mod may be negative.
/proc/get_zone_with_miss_chance(zone, var/mob/target, var/miss_chance_mod = 0, var/ranged_attack=0)
	zone = check_zone(zone)

	if(!ranged_attack)
		// you cannot miss if your target is prone or restrained
		if(target.buckled || target.lying)
			return zone
		// if your target is being grabbed aggressively by someone you cannot miss either
		for(var/obj/item/grab/G in target.grabbed_by)
			if(G.state >= GRAB_AGGRESSIVE)
				return zone

	var/miss_chance = 10
	if (zone in base_miss_chance)
		miss_chance = base_miss_chance[zone]
	if (zone == "eyes" || zone == "mouth")
		miss_chance = base_miss_chance["head"]
	miss_chance = max(miss_chance + miss_chance_mod, 0)
	if(prob(miss_chance))
		if(prob(70))
			return null
		return pick(base_miss_chance)
	return zone

/proc/findname(msg)
	for(var/mob/M in GLOB.mob_list)
		if (M.real_name == text("[msg]"))
			return 1
	return 0

/mob/proc/abiotic(full_body)
	return FALSE

/mob/proc/item_considered_abiotic(obj/item/I)
	return I && (I.item_flags & ITEM_ABSTRACT)

//converts intent-strings into numbers and back
var/list/intents = list(INTENT_HELP,INTENT_DISARM,INTENT_GRAB,INTENT_HARM)
/proc/intent_numeric(argument)
	if(istext(argument))
		switch(argument)
			if(INTENT_HELP)
				return 0
			if(INTENT_DISARM)
				return 1
			if(INTENT_GRAB)
				return 2
			else
				return 3
	else
		switch(argument)
			if(0)
				return INTENT_HELP
			if(1)
				return INTENT_DISARM
			if(2)
				return INTENT_GRAB
			else
				return INTENT_HARM

//change a mob's act-intent. Input the intent as a string such as "help" or use "right"/"left
/mob/verb/a_intent_change(input as text)
	set name = "a-intent"
	set hidden = 1

	if(isliving(src) && !isrobot(src))
		switch(input)
			if(INTENT_HELP,INTENT_DISARM,INTENT_GRAB,INTENT_HARM)
				a_intent = input
			if(INTENT_HOTKEY_RIGHT)
				a_intent = intent_numeric((intent_numeric(a_intent)+1) % 4)
			if(INTENT_HOTKEY_LEFT)
				a_intent = intent_numeric((intent_numeric(a_intent)+3) % 4)
		if(hud_used && hud_used.action_intent)
			hud_used.action_intent.icon_state = "intent_[a_intent]"

	else if(isrobot(src))
		switch(input)
			if(INTENT_HELP)
				a_intent = INTENT_HELP
			if(INTENT_HARM)
				a_intent = INTENT_HARM
			if(INTENT_HOTKEY_RIGHT, INTENT_HOTKEY_LEFT)
				a_intent = intent_numeric(intent_numeric(a_intent) - 3)
		if(hud_used && hud_used.action_intent)
			if(a_intent == INTENT_HARM)
				hud_used.action_intent.icon_state = INTENT_HARM
			else
				hud_used.action_intent.icon_state = INTENT_HELP

/proc/is_blind(A)
	if(istype(A, /mob/living/carbon))
		var/mob/living/carbon/C = A
		if(C.sdisabilities & SDISABILITY_NERVOUS || C.blinded)
			return 1
	return 0

/proc/mobs_in_area(var/area/A)
	var/list/mobs = new
	for(var/mob/living/M in GLOB.mob_list)
		if(get_area(M) == A)
			mobs += M
	return mobs

//Direct dead say used both by emote and say
//It is somewhat messy. I don't know what to do.
//I know you can't see the change, but I rewrote the name code. It is significantly less messy now
/proc/say_dead_direct(var/message, var/mob/subject = null)
	var/name
	var/keyname
	if(subject && subject.client)
		var/client/C = subject.client
		keyname = (C.holder && C.holder.fakekey) ? C.holder.fakekey : C.key
		if(C.mob) //Most of the time this is the observer/dead mob; we can totally use him if there is no better name
			var/mindname
			var/realname = C.mob.real_name
			if(C.mob.mind)
				mindname = C.mob.mind.name
				if(C.mob.mind.original && C.mob.mind.original.real_name)
					realname = C.mob.mind.original.real_name
			if(mindname && mindname != realname)
				name = "[realname] died as [mindname]"
			else
				name = realname

	if(subject && subject.forbid_seeing_deadchat && !subject.client.holder)
		return // Can't talk in deadchat if you can't see it.

	for(var/mob/M in GLOB.player_list)
		if(M.client && ((!istype(M, /mob/new_player) && M.stat == DEAD) || (M.client.holder && M.client.holder.rights)) && M.is_preference_enabled(/datum/client_preference/show_dsay))
			var/follow
			var/lname
			if(M.forbid_seeing_deadchat && !M.client.holder)
				continue

			if(subject)
				if(M.is_key_ignored(subject.client.key)) // If we're ignored, do nothing.
					continue
				if(subject != M)
					follow = "([ghost_follow_link(subject, M)]) "
				if(M.stat != DEAD && M.client.holder)
					follow = "([admin_jump_link(subject, M.client.holder)]) "
				var/mob/observer/dead/DM
				if(istype(subject, /mob/observer/dead))
					DM = subject
				var/anonsay = DM?.is_preference_enabled(/datum/client_preference/anonymous_ghost_chat)
				if(M.client.holder) 							// What admins see
					lname = "[keyname][(anonsay) ? "*" : (DM ? "" : "^")] ([name])"
				else
					if(anonsay)						// If the person is actually observer they have the option to be anonymous
						lname = "[name]"
					else if(DM)									// Non-anons
						lname = "[keyname] ([name])"
					else										// Everyone else (dead people who didn't ghost yet, etc.)
						lname = name
				lname = "<span class='name'>[lname]</span> "
			to_chat(M, "<span class='deadsay'>" + "<b>DEAD:</b> "+ "[lname][follow][message]</span>")

/proc/say_dead_object(var/message, var/obj/subject = null)
	for(var/mob/M in GLOB.player_list)
		if(M.client && ((!istype(M, /mob/new_player) && M.stat == DEAD) || (M.client.holder && M.client.holder.rights)) && M.is_preference_enabled(/datum/client_preference/show_dsay))
			var/follow
			var/lname = "Game Master"
			if(M.forbid_seeing_deadchat && !M.client.holder)
				continue

			if(subject)
				lname = "[subject.name] ([subject.x],[subject.y],[subject.z])"

			lname = "<span class='name'>[lname]</span> "
			to_chat(M, "<span class='deadsay'>" + "EVENT:"+ " [lname][follow][message]</span>")

//Announces that a ghost has joined/left, mainly for use with wizards
/proc/announce_ghost_joinleave(O, var/joined_ghosts = 1, var/message = "")
	var/client/C
	//Accept any type, sort what we want here
	if(istype(O, /mob))
		var/mob/M = O
		if(M.client)
			C = M.client
	else if(istype(O, /client))
		C = O
	else if(istype(O, /datum/mind))
		var/datum/mind/M = O
		if(M.current && M.current.client)
			C = M.current.client
		else if(M.original && M.original.client)
			C = M.original.client

	if(C)
		if(!isnull(C.holder?.fakekey) || !C.is_preference_enabled(/datum/client_preference/announce_ghost_joinleave))
			return
		var/name
		if(C.mob)
			var/mob/M = C.mob
			if(M.mind && M.mind.name)
				name = M.mind.name
			if(M.real_name && M.real_name != name)
				if(name)
					name += " ([M.real_name])"
				else
					name = M.real_name
		if(!name)
			name = (C.holder && C.holder.fakekey) ? C.holder.fakekey : C.key
		if(joined_ghosts)
			say_dead_direct("The ghost of <span class='name'>[name]</span> now [pick("skulks","lurks","prowls","creeps","stalks")] among [pick("the dead","the spirits","the graveyard","the deceased","us")]. [message]")
		else
			say_dead_direct("<span class='name'>[name]</span> no longer [pick("skulks","lurks","prowls","creeps","stalks")] in the realm of the dead. [message]")

/**
 * WARNING: Proc direct ported from main
 *
 * ignore_key, ignore_dnr_observers will NOT work!
 */
/proc/notify_ghosts(message, ghost_sound, enter_link, atom/source, mutable_appearance/alert_overlay, action = NOTIFY_JUMP, flashwindow = TRUE, ignore_mapload = TRUE, ignore_key, ignore_dnr_observers = FALSE, header) //Easy notification of ghosts.
	// Don't notify for objects created during a mapload.
	if(ignore_mapload && SSatoms.initialized != INITIALIZATION_INNEW_REGULAR)
		return
	for(var/mob/observer/dead/O in GLOB.player_list)
		if(!O.client)
			continue
		to_chat(O, "<span class='ghostalert'>[message][(enter_link) ? " [enter_link]" : ""]</span>")
		if(ghost_sound)
			SEND_SOUND(O, sound(ghost_sound))
		if(flashwindow)
			window_flash(O.client)
		if(source)
			var/atom/movable/screen/alert/notify_action/A = O.throw_alert("[REF(source)]_notify_action", /atom/movable/screen/alert/notify_action)
			if(A)
				if(O.client.prefs && O.client.prefs.UI_style)
					A.icon = ui_style2icon(O.client.prefs.UI_style)
				if (header)
					A.name = header
				A.desc = message
				A.action = action
				A.target = source
				if(!alert_overlay)
					alert_overlay = new(source)
				alert_overlay.layer = FLOAT_LAYER
				alert_overlay.plane = FLOAT_PLANE
				A.add_overlay(alert_overlay)

/mob/proc/switch_to_camera(obj/machinery/camera/C)
	if (!C.can_use() || stat || (get_dist(C, src) > 1 || machine != src || blinded || !canmove))
		return FALSE
	check_eye(src)
	return TRUE

/mob/living/silicon/ai/switch_to_camera(obj/machinery/camera/C)
	if(!C.can_use() || !is_in_chassis())
		return FALSE

	eyeobj.setLoc(C)
	return TRUE

/// Returns TRUE if the mob has a client which has been active in the last given X minutes.
/mob/proc/is_client_active(active = TRUE)
	return client && client.inactivity < active MINUTES

/mob/proc/can_eat()
	return TRUE

/mob/proc/can_force_feed()
	return TRUE

#define SAFE_PERP -50
/mob/living/proc/assess_perp(obj/access_obj, check_access, auth_weapons, check_records, check_arrest)
	if(stat == DEAD)
		return SAFE_PERP

	return FALSE

/mob/living/carbon/assess_perp(obj/access_obj, check_access, auth_weapons, check_records, check_arrest)
	if(handcuffed)
		return SAFE_PERP

	return ..()

/mob/living/carbon/human/assess_perp(obj/access_obj, check_access, auth_weapons, check_records, check_arrest)
	var/threatcount = ..()
	if(. == SAFE_PERP)
		return SAFE_PERP

	// Agent cards lower threatlevel.
	var/obj/item/card/id/id = GetIdCard()
	if(id && istype(id, /obj/item/card/id/syndicate))
		threatcount -= 2
	// A proper	CentCom id is hard currency.
	else if(id && istype(id, /obj/item/card/id/centcom))
		return SAFE_PERP

	if(check_access && !access_obj.allowed(src))
		threatcount += 4

	if(auth_weapons && !access_obj.allowed(src))
		if(istype(l_hand, /obj/item/gun) || istype(l_hand, /obj/item/melee))
			threatcount += 4

		if(istype(r_hand, /obj/item/gun) || istype(r_hand, /obj/item/melee))
			threatcount += 4

		if(istype(belt, /obj/item/gun) || istype(belt, /obj/item/melee))
			threatcount += 2

		if(species.name != SPECIES_HUMAN)
			threatcount += 2

	if(check_records || check_arrest)
		var/perpname = name
		if(id)
			perpname = id.registered_name

		var/datum/data/record/R = find_security_record("name", perpname)
		if(check_records && !R)
			threatcount += 4

		if(check_arrest && R && (R.fields["criminal"] == "*Arrest*"))
			threatcount += 4

	return threatcount

/mob/living/simple_mob/assess_perp(obj/access_obj, check_access, auth_weapons, check_records, check_arrest)
	var/threatcount = ..()
	if(. == SAFE_PERP)
		return SAFE_PERP

	// Otherwise Runtime gets killed.
	if(has_AI() && ai_holder.hostile && faction != "neutral")
		threatcount += 4
	return threatcount

/// Beepsky will (try to) only beat 'bad' slimes.
/mob/living/simple_mob/slime/xenobio/assess_perp(obj/access_obj, check_access, auth_weapons, check_records, check_arrest)
	var/threatcount = 0

	if(stat == DEAD)
		return SAFE_PERP

	if(is_justified_to_discipline())
		threatcount += 4
/*
	if(discipline && !rabid)
		if(!target_mob || istype(target_mob, /mob/living/carbon/human/monkey))
			return SAFE_PERP

	if(target_mob)
		threatcount += 4

	if(victim)
		threatcount += 4
*/
	if(has_AI())
		var/datum/ai_holder/simple_mob/xenobio_slime/AI = ai_holder
		if(AI.rabid)
			threatcount = 10

	return threatcount

#undef SAFE_PERP


//TODO: Integrate defence zones and targeting body parts with the actual organ system, move these into organ definitions.

/// The base miss chance for the different defence zones
var/list/global/base_miss_chance = list(
	BP_HEAD   = 40,
	BP_CHEST  = 10,
	BP_GROIN  = 20,
	BP_L_LEG  = 30,
	BP_R_LEG  = 30,
	BP_L_ARM  = 30,
	BP_R_ARM  = 30,
	BP_L_HAND = 50,
	BP_R_HAND = 50,
	BP_L_FOOT = 50,
	BP_R_FOOT = 50,
)

/**
 * Used to weight organs when an organ is hit randomly (i.e. not a directed, aimed attack).
 * Also used to weight the protection value that armour provides for covering that body part when calculating protection from full-body effects.
 */
var/list/global/organ_rel_size = list(
	BP_HEAD   = 25,
	BP_CHEST  = 70,
	BP_GROIN  = 30,
	BP_L_LEG  = 25,
	BP_R_LEG  = 25,
	BP_L_ARM  = 25,
	BP_R_ARM  = 25,
	BP_L_HAND = 10,
	BP_R_HAND = 10,
	BP_L_FOOT = 10,
	BP_R_FOOT = 10,
)

/mob/proc/flash_eyes(intensity = FLASH_PROTECTION_MODERATE, override_blindness_check = FALSE, affect_silicon = FALSE, visual = FALSE, type = /atom/movable/screen/fullscreen/tiled/flash)
	return

/// Recalculates what planes this mob can see using their plane_holder, for humans this is checking slots, for others, could be whatever.
/mob/proc/recalculate_vis()
	return

/// General HUD updates done regularly (health puppet things, etc)
/mob/proc/handle_regular_hud_updates()
	return

/// Handle eye things like the Byond SEE_TURFS, SEE_OBJS, etc.
/mob/proc/handle_vision()
	return

/mob/proc/get_sound_env(pressure_factor)
	if (pressure_factor < 0.5)
		return SPACE
	else
		var/area/A = get_area(src)
		return A.sound_env

/mob/proc/position_hud_item(obj/item/item, slot)
	var/held = is_holding(item)
	if(!istype(hud_used) || !slot || !LAZYLEN(hud_used.slot_info))
		return

	// They may have hidden their entire hud but the hands.
	if(!hud_used.hud_shown && held)
		item.screen_loc = null
		return

	// They may have hidden the icons in the bottom left with the hide button.
	if(!hud_used.inventory_shown && !held && (resolve_inventory_slot_meta(slot)?.inventory_slot_flags & INV_SLOT_HUD_REQUIRES_EXPAND))
		item.screen_loc = null
		return

	var/screen_place = held? hud_used.hand_info["[get_held_index(item)]"] : hud_used.slot_info["[slot]"]
	if(!screen_place)
		item.screen_loc = null
		return

	item.screen_loc = screen_place

/mob/proc/can_see_reagents()
	// Dead guys and silicons can always see reagents.
	return stat == DEAD || issilicon(src)

/// Ingnores the possibility of breaking tags.
/proc/stars_no_html(text, pr, re_encode)
	// We don't want to screw up escaped characters.
	text = html_decode(text)
	. = list()
	for(var/i = 1, i <= length_char(text), i++)
		var/char = copytext_char(text, i, i+1)
		if(char == " " || prob(pr))
			. += char
		else
			. += "*"
	. = JOINTEXT(.)
	if(re_encode)
		. = html_encode(.)
