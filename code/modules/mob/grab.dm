/**
 * returns everyone we're grabbing associated to state
 */
/mob/proc/grabbing()
	RETURN_TYPE(/list)
	. = list()
	for(var/obj/item/grab/G in get_held_items())
		.[G.affecting] = G.state

/**
 * returns everyone we're grabbing, recursively; this can include ourselves!
 */
/mob/proc/grabbing_recursive(list/L = list())
	RETURN_TYPE(/list)
	. = L
	for(var/obj/item/grab/G in get_held_items())
		.[G.affecting] = max(.[G.affecting], G.state)
		grabbing_recursive(G.affecting)

/**
 * check the grab state of us to someone
 */
/mob/proc/check_grab(mob/M)
	for(var/obj/item/grab/G in get_held_items())
		if(G.affecting == M)
			return G.state
	// CRASH("in grabbed by but no grab item?")

/**
 * drops our grab to someone immediately
 */
/mob/proc/drop_grab(mob/M)
	for(var/obj/item/grab/G in get_held_items())
		if(G.affecting == M)
			qdel(G)

#define UPGRADE_COOLDOWN	40
#define UPGRADE_KILL_TIMER	100

///Process_Grab()
///Called by client/Move()
///Checks to see if you are grabbing or being grabbed by anything and if moving will affect your grab.
/client/proc/Process_Grab()
	//if we are being grabbed
	if(isliving(mob))
		var/mob/living/L = mob
		if(!L.canmove && L.grabbed_by.len)
			L.resist() //shortcut for resisting grabs

		//if we are grabbing someone
		for(var/obj/item/grab/G in list(L.l_hand, L.r_hand))
			G.reset_kill_state() //no wandering across the station/asteroid while choking someone

/obj/item/grab
	name = "grab"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "reinforce"
	item_flags = ITEM_ABSTRACT | ITEM_DROPDEL
	flags = ATOM_ABSTRACT
	drop_sound = null
	pickup_sound = null
	equip_sound = null
	unequip_sound = null

	var/atom/movable/screen/grab/hud = null
	var/mob/living/affecting = null
	var/mob/living/carbon/human/assailant = null
	var/state = GRAB_PASSIVE

	var/allow_upgrade = 1
	var/last_action = 0
	var/last_hit_zone = 0
	var/force_down //determines if the affecting mob will be pinned to the ground
	var/dancing //determines if assailant and affecting keep looking at each other. Basically a wrestling position

	item_state = "nothing"
	w_class = ITEMSIZE_HUGE

/obj/item/grab/Initialize(mapload, mob/victim)
	. = ..()
	var/mob/user = loc
	assailant = user
	affecting = victim

	if(affecting.anchored || !assailant.Adjacent(victim) || affecting.buckled)
		affecting = null
		assailant = null
		return INITIALIZE_HINT_QDEL

	affecting.grabbed_by += src
	affecting.reveal("<span class='warning'>You are revealed as [assailant] grabs you.</span>")
	assailant.reveal("<span class='warning'>You reveal yourself as you grab [affecting].</span>")

	hud = new /atom/movable/screen/grab(src)
	hud.icon_state = "reinforce"
	icon_state = "grabbed"
	hud.name = "reinforce grab"
	hud.master = src

	//check if assailant is grabbed by victim as well
	if(assailant.grabbed_by)
		for (var/obj/item/grab/G in assailant.grabbed_by)
			if(G.assailant == affecting && G.affecting == assailant)
				G.dancing = 1
				G.adjust_position()
				dancing = 1

	//stop pulling the affected
	if(assailant.pulling == affecting)
		assailant.stop_pulling()

	adjust_position()

//This makes sure that the grab screen object is displayed in the correct hand.
/obj/item/grab/proc/synch() //why is this needed?
	if(QDELETED(src))
		return
	if(affecting)
		if(assailant.r_hand == src)
			hud.screen_loc = ui_rhand
		else
			hud.screen_loc = ui_lhand

/obj/item/grab/process(delta_time)
	if(QDELETED(src)) // GC is trying to delete us, we'll kill our processing so we can cleanly GC
		return PROCESS_KILL

	confirm()
	if(!assailant)
		qdel(src) // Same here, except we're trying to delete ourselves.
		return PROCESS_KILL

	if(assailant.client)
		assailant.client.screen -= hud
		assailant.client.screen += hud

	if(state <= GRAB_AGGRESSIVE)
		allow_upgrade = 1
		//disallow upgrading if we're grabbing more than one person
		if((assailant.l_hand && assailant.l_hand != src && istype(assailant.l_hand, /obj/item/grab)))
			var/obj/item/grab/G = assailant.l_hand
			if(G.affecting != affecting)
				allow_upgrade = 0
		if((assailant.r_hand && assailant.r_hand != src && istype(assailant.r_hand, /obj/item/grab)))
			var/obj/item/grab/G = assailant.r_hand
			if(G.affecting != affecting)
				allow_upgrade = 0

		//disallow upgrading past aggressive if we're being grabbed aggressively
		for(var/obj/item/grab/G in affecting.grabbed_by)
			if(G == src) continue
			if(G.state >= GRAB_AGGRESSIVE)
				allow_upgrade = 0

		if(allow_upgrade)
			if(state < GRAB_AGGRESSIVE)
				hud.icon_state = "reinforce"
			else
				hud.icon_state = "reinforce1"
		else
			hud.icon_state = "!reinforce"

	if(state >= GRAB_AGGRESSIVE)
		affecting.drop_all_held_items()

		if(iscarbon(affecting))
			handle_eye_mouth_covering(affecting, assailant, assailant.zone_sel.selecting)

		if(force_down)
			if(affecting.loc != assailant.loc || size_difference(affecting, assailant) > 0)
				force_down = 0
			else
				affecting.Weaken(2)

	if(state >= GRAB_NECK)
		affecting.Stun(3)

	if(state >= GRAB_KILL)
		//affecting.apply_effect(STUTTER, 5) //would do this, but affecting isn't declared as mob/living for some stupid reason.
		affecting.stuttering = max(affecting.stuttering, 5) //It will hamper your voice, being choked and all.
		affecting.Weaken(5)	//Should keep you down unless you get help.
		affecting.losebreath = max(affecting.losebreath + 2, 3)

	adjust_position()

/obj/item/grab/proc/handle_eye_mouth_covering(mob/living/carbon/target, mob/user, var/target_zone)
	var/announce = (target_zone != last_hit_zone) //only display messages when switching between different target zones
	last_hit_zone = target_zone

	switch(target_zone)
		if(O_MOUTH)
			if(announce)
				user.visible_message("<span class='warning'>\The [user] covers [target]'s mouth!</span>")
			if(target.silent < 3)
				target.silent = 3
		if(O_EYES)
			if(announce)
				assailant.visible_message("<span class='warning'>[assailant] covers [affecting]'s eyes!</span>")
			if(affecting.eye_blind < 3)
				affecting.Blind(3)

/obj/item/grab/attack_self()
	return s_click(hud)

/obj/item/grab/throw_resolve_actual(mob/user)
	if(affecting.buckled)
		return
	if(state < GRAB_AGGRESSIVE)
		return
	animate(affecting, pixel_x = initial(affecting.pixel_x), pixel_y = initial(affecting.pixel_y), 4, 1)
	return affecting

/obj/item/grab/throw_resolve_finalize(atom/movable/resolver, mob/user)
	qdel(src)

/obj/item/grab/throw_resolve_override(atom/movable/resolved, mob/user)
	return TRUE

//Updating pixelshift, position and direction
//Gets called on process, when the grab gets upgraded or the assailant moves
/obj/item/grab/proc/adjust_position()
	if(QDELETED(src))
		return
	if(!affecting)
		qdel(src)
		return
	if(affecting.buckled)
		animate(affecting, pixel_x = initial(affecting.pixel_x), pixel_y = initial(affecting.pixel_y), 4, 1, LINEAR_EASING)
		return
	if(affecting.lying && state != GRAB_KILL)
		animate(affecting, pixel_x = initial(affecting.pixel_x), pixel_y = initial(affecting.pixel_y), 5, 1, LINEAR_EASING)
		if(force_down)
			affecting.setDir(SOUTH) //face up
		return
	var/shift = 0
	var/adir = get_dir(assailant, affecting)
	affecting.set_base_layer(MOB_LAYER)
	switch(state)
		if(GRAB_PASSIVE)
			shift = 8
			if(dancing) //look at partner
				shift = 10
				assailant.setDir(get_dir(assailant, affecting))
		if(GRAB_AGGRESSIVE)
			shift = 12
		if(GRAB_NECK)
			shift = -10
			adir = assailant.dir
			affecting.forceMove(assailant.loc)
			affecting.setDir(assailant.dir)
		if(GRAB_KILL)
			shift = 0
			adir = 1
			affecting.forceMove(assailant.loc)
			affecting.setDir(SOUTH) //face up

	switch(adir)
		if(NORTH)
			animate(affecting, pixel_x = initial(affecting.pixel_x), pixel_y =-shift, 5, 1, LINEAR_EASING)
			affecting.set_base_layer(BELOW_MOB_LAYER)
		if(SOUTH)
			animate(affecting, pixel_x = initial(affecting.pixel_x), pixel_y = shift, 5, 1, LINEAR_EASING)
		if(WEST)
			animate(affecting, pixel_x = shift, pixel_y = initial(affecting.pixel_y), 5, 1, LINEAR_EASING)
		if(EAST)
			animate(affecting, pixel_x =-shift, pixel_y = initial(affecting.pixel_y), 5, 1, LINEAR_EASING)

/obj/item/grab/proc/s_click(atom/movable/screen/S)
	if(QDELETED(src))
		return
	if(!affecting)
		return
	if(!assailant.canClick())
		return
	if(world.time < (last_action + UPGRADE_COOLDOWN))
		return
	if(!assailant.canmove || assailant.lying)
		qdel(src)
		return

	var/datum/gender/TU = GLOB.gender_datums[assailant.get_visible_gender()]

	last_action = world.time

	if(state < GRAB_AGGRESSIVE)
		if(!allow_upgrade)
			return
		if(!affecting.lying || size_difference(affecting, assailant) > 0)
			assailant.visible_message("<span class='warning'>[assailant] has grabbed [affecting] aggressively (now hands)!</span>")
		else
			assailant.visible_message("<span class='warning'>[assailant] pins [affecting] down to the ground (now hands)!</span>")
			apply_pinning(affecting, assailant)

		state = GRAB_AGGRESSIVE
		icon_state = "grabbed1"
		hud.icon_state = "reinforce1"
	else if(state < GRAB_NECK)
		if(isslime(affecting))
			to_chat(assailant, "<span class='notice'>You squeeze [affecting], but nothing interesting happens.</span>")
			return

		assailant.visible_message("<span class='warning'>[assailant] has reinforced [TU.his] grip on [affecting] (now neck)!</span>")
		state = GRAB_NECK
		icon_state = "grabbed+1"
		assailant.setDir(get_dir(assailant, affecting))
		add_attack_logs(assailant,affecting,"Neck grabbed")
		hud.icon_state = "kill"
		hud.name = "kill"
		affecting.Stun(10) //10 ticks of ensured grab
	else if(state < GRAB_KILL)
		assailant.visible_message("<span class='danger'>[assailant] starts to tighten [TU.his] grip on [affecting]'s neck!</span>")
		hud.icon_state = "kill1"

		state = GRAB_KILL
		assailant.visible_message("<span class='danger'>[assailant] has tightened [TU.his] grip on [affecting]'s neck!</span>")
		add_attack_logs(assailant,affecting,"Strangled")
		affecting.setClickCooldown(10)
		affecting.AdjustLosebreath(1)
		affecting.setDir(WEST)
	adjust_position()

//This is used to make sure the victim hasn't managed to yackety sax away before using the grab.
/obj/item/grab/proc/confirm()
	if(!assailant || !affecting)
		qdel(src)
		return 0

	if(affecting)
		if(!isturf(assailant.loc) || ( !isturf(affecting.loc) || assailant.loc != affecting.loc && get_dist(assailant, affecting) > 1) )
			qdel(src)
			return 0

	return 1

/obj/item/grab/attack(mob/M, mob/living/user)
	if(QDELETED(src))
		return
	if(!affecting)
		return
	if(world.time < (last_action + 20))
		return

	last_action = world.time
	reset_kill_state() //using special grab moves will interrupt choking them

	//clicking on the victim while grabbing them
	if(M == affecting)
		if(ishuman(affecting))
			var/mob/living/carbon/human/H = affecting
			var/hit_zone = assailant.zone_sel.selecting
			flick(hud.icon_state, hud)
			switch(assailant.a_intent)
				if(INTENT_HELP)
					if(force_down)
						to_chat(assailant, "<span class='warning'>You are no longer pinning [affecting] to the ground.</span>")
						force_down = 0
						return
					if(state >= GRAB_AGGRESSIVE)
						H.apply_pressure(assailant, hit_zone)
					else
						inspect_organ(affecting, assailant, hit_zone)

				if(INTENT_GRAB)
					jointlock(affecting, assailant, hit_zone)

				if(INTENT_HARM)
					if(hit_zone == O_EYES)
						attack_eye(affecting, assailant)
					else if(hit_zone == BP_HEAD)
						headbutt(affecting, assailant)
					else
						dislocate(affecting, assailant, hit_zone)

				if(INTENT_DISARM)
					pin_down(affecting, assailant)

	//clicking on yourself while grabbing them
	if(M == assailant && state >= GRAB_AGGRESSIVE)
		devour(affecting, assailant)

/obj/item/grab/proc/reset_kill_state()
	if(state == GRAB_KILL)
		var/datum/gender/T = GLOB.gender_datums[assailant.get_visible_gender()]
		assailant.visible_message("<span class='warning'>[assailant] lost [T.his] tight grip on [affecting]'s neck!</span>")
		hud.icon_state = "kill"
		state = GRAB_NECK

/obj/item/grab/proc/handle_resist()
	var/grab_name
	var/break_strength = 1
	var/list/break_chance_table = list(100)
	switch(state)
		//if(GRAB_PASSIVE)

		if(GRAB_AGGRESSIVE)
			grab_name = "grip"
			//Being knocked down makes it harder to break a grab, so it is easier to cuff someone who is down without forcing them into unconsciousness.
			if(!affecting.incapacitated(INCAPACITATION_KNOCKDOWN))
				break_strength++
			break_chance_table = list(15, 60, 100)

		if(GRAB_NECK)
			grab_name = "headlock"
			//If the you move when grabbing someone then it's easier for them to break free. Same if the affected mob is immune to stun.
			if(world.time - assailant.l_move_time < 30 || !affecting.stunned)
				break_strength++
			break_chance_table = list(3, 18, 45, 100)


		if(GRAB_KILL)
			grab_name = "stranglehold"
			break_chance_table = list(5, 20, 40, 80, 100)

	//It's easier to break out of a grab by a smaller mob
	break_strength += max(size_difference(affecting, assailant), 0)

	var/break_chance = break_chance_table[clamp(break_strength, 1, break_chance_table.len)]
	if(prob(break_chance))
		if(state == GRAB_KILL)
			reset_kill_state()
			return
		else if(grab_name)
			affecting.visible_message("<span class='warning'>[affecting] has broken free of [assailant]'s [grab_name]!</span>")
		qdel(src)

//returns the number of size categories between affecting and assailant, rounded. Positive means A is larger than B
/obj/item/grab/proc/size_difference(mob/A, mob/B)
	return mob_size_difference(A.mob_size, B.mob_size)

/obj/item/grab/Destroy()
	if(affecting)
		animate(affecting, pixel_x = initial(affecting.pixel_x), pixel_y = initial(affecting.pixel_y), 4, 1, LINEAR_EASING)
		affecting.reset_plane_and_layer()
		affecting.grabbed_by -= src
		affecting = null
	if(assailant)
		if(assailant.client)
			assailant.client.screen -= hud
		assailant = null
	qdel(hud)
	hud = null
	return ..()


/obj/item/grab/proc/inspect_organ(mob/living/carbon/human/H, mob/user, var/target_zone)

	var/obj/item/organ/external/E = H.get_organ(target_zone)

	if(!E || E.is_stump())
		to_chat(user, "<span class='notice'>[H] is missing that bodypart.</span>")
		return

	user.visible_message("<span class='notice'>[user] starts inspecting [affecting]'s [E.name] carefully.</span>")
	if(!do_mob(user,H, 10))
		to_chat(user, "<span class='notice'>You must stand still to inspect [E] for wounds.</span>")
	else if(E.wounds.len)
		to_chat(user, "<span class='warning'>You find [E.get_wounds_desc()]</span>")
	else
		to_chat(user, "<span class='notice'>You find no visible wounds.</span>")

	to_chat(user, "<span class='notice'>Checking bones now...</span>")
	if(!do_mob(user, H, 20))
		to_chat(user, "<span class='notice'>You must stand still to feel [E] for fractures.</span>")
	else if(E.status & ORGAN_BROKEN)
		to_chat(user, "<span class='warning'>The [E.encased ? E.encased : "bone in the [E.name]"] moves slightly when you poke it!</span>")
		H.custom_pain("Your [E.name] hurts where it's poked.", 40)
	else
		to_chat(user, "<span class='notice'>The [E.encased ? E.encased : "bones in the [E.name]"] seem to be fine.</span>")

	to_chat(user, "<span class='notice'>Checking skin now...</span>")
	if(!do_mob(user, H, 10))
		to_chat(user, "<span class='notice'>You must stand still to check [H]'s skin for abnormalities.</span>")
	else
		var/bad = 0
		if(H.getToxLoss() >= 40)
			to_chat(user, "<span class='warning'>[H] has an unhealthy skin discoloration.</span>")
			bad = 1
		if(H.getOxyLoss() >= 20)
			to_chat(user, "<span class='warning'>[H]'s skin is unusaly pale.</span>")
			bad = 1
		if(E.status & ORGAN_DEAD)
			to_chat(user, "<span class='warning'>[E] is decaying!</span>")
			bad = 1
		if(!bad)
			to_chat(user, "<span class='notice'>[H]'s skin is normal.</span>")

/obj/item/grab/proc/jointlock(mob/living/carbon/human/target, mob/attacker, var/target_zone)
	if(state < GRAB_AGGRESSIVE)
		to_chat(attacker, "<span class='warning'>You require a better grab to do this.</span>")
		return

	var/obj/item/organ/external/organ = target.get_organ(check_zone(target_zone))
	if(!organ || organ.dislocated == -1)
		return

	attacker.visible_message("<span class='danger'>[attacker] [pick("bent", "twisted")] [target]'s [organ.name] into a jointlock!</span>")

	if(target.species.flags & NO_PAIN)
		return

	var/armor = target.run_armor_check(target, "melee")
	var/soaked = target.get_armor_soak(target, "melee")
	if(armor + soaked < 60)
		to_chat(target, "<span class='danger'>You feel extreme pain!</span>")

		var/max_halloss = round(target.species.total_health * 0.8) //up to 80% of passing out
		affecting.adjustHalLoss(clamp(0, max_halloss - affecting.halloss, 30))

/obj/item/grab/proc/attack_eye(mob/living/carbon/human/target, mob/living/carbon/human/attacker)
	if(!istype(attacker))
		return

	var/datum/unarmed_attack/attack = attacker.get_unarmed_attack(target, O_EYES)

	if(!attack)
		return
	if(state < GRAB_NECK)
		to_chat(attacker, "<span class='warning'>You require a better grab to do this.</span>")
		return
	for(var/obj/item/protection in list(target.head, target.wear_mask, target.glasses))
		if(protection && (protection.body_parts_covered & EYES))
			to_chat(attacker, "<span class='danger'>You're going to need to remove the eye covering first.</span>")
			return
	if(!target.has_eyes())
		to_chat(attacker, "<span class='danger'>You cannot locate any eyes on [target]!</span>")
		return

	add_attack_logs(attacker,target,"Eye gouge using grab")

	attack.handle_eye_attack(attacker, target)

/obj/item/grab/proc/headbutt(mob/living/carbon/human/target, mob/living/carbon/human/attacker)
	if(!istype(attacker))
		return
	if(target.lying)
		return
	var/datum/gender/T = GLOB.gender_datums[attacker.get_visible_gender()]
	attacker.visible_message("<span class='danger'>[attacker] thrusts [T.his] head into [target]'s skull!</span>")

	var/damage = 20
	var/obj/item/clothing/hat = attacker.head
	if(istype(hat))
		damage += hat.force * 3

	var/armor = target.run_armor_check(BP_HEAD, "melee")
	var/soaked = target.get_armor_soak(BP_HEAD, "melee")
	target.apply_damage(damage, BRUTE, BP_HEAD, armor, soaked)
	attacker.apply_damage(10, BRUTE, BP_HEAD, attacker.run_armor_check(BP_HEAD), attacker.get_armor_soak(BP_HEAD), "melee")

	if(!armor && target.headcheck(BP_HEAD) && prob(damage))
		target.apply_effect(20, PARALYZE)
		target.visible_message("<span class='danger'>[target] [target.species.get_knockout_message(target)]</span>")

	playsound(attacker.loc, "swing_hit", 25, 1, -1)
	add_attack_logs(attacker,target,"Headbutted using grab")

	qdel(src)

/obj/item/grab/proc/dislocate(mob/living/carbon/human/target, mob/living/attacker, var/target_zone)
	if(state < GRAB_NECK)
		to_chat(attacker, "<span class='warning'>You require a better grab to do this.</span>")
		return
	if(target.grab_joint(attacker, target_zone))
		playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		return

/obj/item/grab/proc/pin_down(mob/target, mob/attacker)
	if(state < GRAB_AGGRESSIVE)
		to_chat(attacker, "<span class='warning'>You require a better grab to do this.</span>")
		return
	if(force_down)
		to_chat(attacker, "<span class='warning'>You are already pinning [target] to the ground.</span>")
		return
	if(size_difference(affecting, assailant) > 10)
		to_chat(attacker, "<span class='warning'>You are too small to do that!</span>")
		return

	attacker.visible_message("<span class='danger'>[attacker] starts forcing [target] to the ground!</span>")
	if(do_after(attacker, 20) && target)
		last_action = world.time
		attacker.visible_message("<span class='danger'>[attacker] forces [target] to the ground!</span>")
		apply_pinning(target, attacker)

/obj/item/grab/proc/apply_pinning(mob/target, mob/attacker)
	force_down = 1
	target.Weaken(3)
	target.lying = 1
	step_to(attacker, target)
	attacker.setDir(EAST) //face the victim
	target.setDir(SOUTH) //face up

/obj/item/grab/proc/devour(mob/target, mob/user)
	var/can_eat
	if((MUTATION_FAT in user.mutations) && ismini(target))
		can_eat = 1
	else
		var/mob/living/carbon/human/H = user
		if(istype(H) && H.species.gluttonous)
			if(H.species.gluttonous == 2)
				can_eat = 2
			else if((H.mob_size > target.mob_size) && !ishuman(target) && ismini(target))
				can_eat = 1

	if(can_eat)
		var/mob/living/carbon/attacker = user
		user.visible_message("<span class='danger'>[user] is attempting to devour [target]!</span>")
		if(can_eat == 2)
			if(!do_mob(user, target)||!do_after(user, 30)) return
		else
			if(!do_mob(user, target)||!do_after(user, 70)) return
		user.visible_message("<span class='danger'>[user] devours [target]!</span>")
		target.loc = user
		attacker.stomach_contents.Add(target)
		qdel(src)
