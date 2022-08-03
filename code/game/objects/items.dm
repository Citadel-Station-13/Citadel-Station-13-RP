/obj/item
	name = "item"
	icon = 'icons/obj/items.dmi'
	w_class = ITEMSIZE_NORMAL

	/// flags relating to items - see [code/__DEFINES/_flags/item_flags.dm]
	var/item_flags = NONE
	/// Miscellaneous flags pertaining to equippable objects. - see [code/__DEFINES/_flags/item_flags.dm]
	var/clothing_flags = NONE
	/// flags for items hidden by this item when worn. as of right now, some flags only work in some slots.
	var/flags_inv = 0
	/// flags for the bodyparts this item covers when worn.
	var/body_parts_covered = 0

	/// This saves our blood splatter overlay, which will be processed not to go over the edges of the sprite
	var/image/blood_overlay = null
	var/r_speed = 1.0
	var/health = null
	var/burn_point = null
	var/burning = null
	/// Sound to play on hit. Set to [HITSOUND_UNSET] to have it automatically set on init.
	var/hitsound = HITSOUND_UNSET
	/// Like hitsound, but for when used properly and not to kill someone.
	var/usesound = null
	var/storage_cost = null
	/// This is used to determine on which slots an item can fit.
	var/slot_flags = 0
	/// If it's an item we don't want to log attack_logs with, set this to TRUE
	var/no_attack_log = FALSE
	pass_flags = PASSTABLE
	pressure_resistance = 5
	var/obj/item/master = null
	/// Used by R&D to determine what research bonuses it grants.
	var/list/origin_tech = null
	/// Used in attackby() to say how something was attacked "[x] has been [z.attack_verb] by [y] with [z]"
	var/list/attack_verb = list()
	var/force = 0

	/// Flags which determine which body parts are protected from heat. Use the HEAD, UPPER_TORSO, LOWER_TORSO, etc. flags. See setup.dm
	var/heat_protection = 0
	/// Flags which determine which body parts are protected from cold. Use the HEAD, UPPER_TORSO, LOWER_TORSO, etc. flags. See setup.dm
	var/cold_protection = 0
	/// Set this variable to determine up to which temperature (IN KELVIN) the item protects against heat damage. Keep at null to disable protection. Only protects areas set by heat_protection flags.
	var/max_heat_protection_temperature
	/// Set this variable to determine down to which temperature (IN KELVIN) the item protects against cold damage. 0 is NOT an acceptable number due to if(varname) tests!! Keep at null to disable protection. Only protects areas set by cold_protection flags.
	var/min_cold_protection_temperature

	/// Set this variable if the item protects its wearer against high pressures below an upper bound. Keep at null to disable protection.
	var/max_pressure_protection
	/// Set this variable if the item protects its wearer against low pressures above a lower bound. Keep at null to disable protection. 0 represents protection against hard vacuum.
	var/min_pressure_protection


	var/datum/action/item_action/action = null
	/// It is also the text which gets displayed on the action button. If not set it defaults to 'Use [name]'. If it's not set, there'll be no button.
	var/action_button_name
	/// If 1, bypass the restrained, lying, and stunned checks action buttons normally test for
	var/action_button_is_hands_free = 0

	var/tool_behaviour = NONE

	/// 0 prevents all transfers, 1 is invisible
	//var/heat_transfer_coefficient = 1
	/// For leaking gas from turf to mask and vice-versa (for masks right now, but at some point, i'd like to include space helmets)
	var/gas_transfer_coefficient = 1
	/// For chemicals/diseases
	var/permeability_coefficient = 1
	/// For electrical admittance/conductance (electrocution checks and shit)
	var/siemens_coefficient = 1
	/// How much clothing is slowing you down. Negative values speeds you up
	var/slowdown = 0
	var/list/armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	var/list/armorsoak = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	/// Suit storage stuff.
	var/list/allowed = null
	/// All items can have an uplink hidden inside, just remember to add the triggers.
	var/obj/item/uplink/hidden/hidden_uplink = null
	/// Name used for message when binoculars/scope is used
	var/zoomdevicename = null
	/// TRUE if item is actively being used to zoom. For scoped guns and binoculars.
	var/zoom = FALSE
	/// 0 won't embed, and 100 will always embed
	var/embed_chance = EMBED_CHANCE_UNSET
	/// Used to override hardcoded clothing dmis in human clothing proc. //TODO: Get rid of this crap -Zandario
	var/icon_override = null

	//** These specify item/icon overrides for _slots_

	/// Overrides the default item_state for particular slots.
	var/list/item_state_slots = list()

	/// Used to specify the icon file to be used when the item is worn. If not set the default icon for that slot will be used.
	/// If icon_override or sprite_sheets are set they will take precendence over this, assuming they apply to the slot in question.
	/// Only slot_l_hand/slot_r_hand are implemented at the moment. Others to be implemented as needed.
	var/list/item_icons = list()

	/// Dimensions of the icon file used when this item is worn, eg: hats.dmi
	/// eg: 32x32 sprite, 64x64 sprite, etc.
	/// allows inhands/worn sprites to be of any size, but still centered on a mob properly
	var/worn_x_dimension = 32
	var/worn_y_dimension = 32
	//Allows inhands/worn sprites for inhands, uses the lefthand_ and righthand_ file vars
	var/inhand_x_dimension = 32
	var/inhand_y_dimension = 32

	//** These specify item/icon overrides for _species_
	//TODO Refactor this from the ground up. Too many overrides. -Zandario
	/* Species-specific sprites, concept stolen from Paradise//vg/.
	 * ex:
	 * sprite_sheets = list(
	 * 	SPECIES_TAJ = 'icons/cat/are/bad'
	 * 	)
	 * If index term exists and icon_override is not set, this sprite sheet will be used.
	*/
	var/list/sprite_sheets = list()

	/// Species-specific sprite sheets for inventory sprites
	/// Works similarly to worn sprite_sheets, except the alternate sprites are used when the clothing/refit_for_species() proc is called.
	var/list/sprite_sheets_obj = list()

	/// This is a multipler on how 'fast' a tool works.  e.g. setting this to 0.5 will make the tool work twice as fast.
	var/toolspeed = 1.0
	/// How long click delay will be when using this, in 1/10ths of a second. Checked in the user's get_attack_speed().
	var/attackspeed = DEFAULT_ATTACK_COOLDOWN
	/// Length of tiles it can reach, 1 is adjacent.
	var/reach = 1
	/// Icon overlay for ADD highlights when applicable.
	var/addblends

	/// Default on-mob icon.
	var/icon/default_worn_icon
	/// Default on-mob layer.
	var/worn_layer

	//* Pickup/Drop/Equip/Throw Sounds
	/// Used when thrown into a mob.
	var/mob_throw_hit_sound
	/// Sound used when equipping the item into a valid slot from hands or ground
	var/equip_sound
	/// Sound used when uneqiupping the item from a valid slot to hands or ground
	var/unequip_sound
	/// Pickup sound - played when picking something up off the floor.
	var/pickup_sound = 'sound/items/pickup/device.ogg'
	/// Drop sound - played when dropping something onto the floor.
	var/drop_sound = 'sound/items/drop/device.ogg'

	/// Deploytype for switchtools. Only really used on switchtool subtype items, but this is on a general item level
	/// in case admins want to do some wierd fucky shit with custom switchtools.
	var/deploytype = null
	/// Whether or not we are heavy. Used for some species to determine if they can two-hand it.
	var/heavy = FALSE

/obj/item/Initialize(mapload)
	. = ..()
	if(islist(origin_tech))
		origin_tech = typelist(NAMEOF(src, origin_tech), origin_tech)
	if(istype(loc, /obj/item/storage))
		item_flags |= IN_STORAGE
	//Potential memory optimization: Making embed chance a getter if unset.
	if(embed_chance == EMBED_CHANCE_UNSET)
		if(sharp)
			embed_chance = max(5, round(force/w_class))
		else
			embed_chance = max(5, round(force/(w_class*3)))
	if(hitsound == HITSOUND_UNSET)
		if(damtype == "fire")
			hitsound = 'sound/items/welder.ogg'
		if(damtype == "brute")
			hitsound = "swing_hit"

/// Check if target is reasonable for us to operate on.
/obj/item/proc/check_allowed_items(atom/target, not_inside, target_self)
	if(((src in target) && !target_self) || ((!istype(target.loc, /turf)) && (!istype(target, /turf)) && (not_inside)))
		return FALSE
	else
		return TRUE

/obj/item/proc/update_twohanding()
	update_held_icon()

/obj/item/proc/is_held_twohanded(mob/living/M)
	var/check_hand
	if(M.l_hand == src && !M.r_hand)
		check_hand = BP_R_HAND //item in left hand, check right hand
	else if(M.r_hand == src && !M.l_hand)
		check_hand = BP_L_HAND //item in right hand, check left hand
	else
		return FALSE

	//would check is_broken() and is_malfunctioning() here too but is_malfunctioning()
	//is probabilistic so we can't do that and it would be unfair to just check one.
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/hand = H.organs_by_name[check_hand]
		if(istype(hand) && hand.is_usable())
			return TRUE
	return FALSE


///Checks if the item is being held by a mob, and if so, updates the held icons
/obj/item/proc/update_held_icon()
	if(isliving(src.loc))
		var/mob/living/M = src.loc
		if(M.l_hand == src)
			M.update_inv_l_hand()
		else if(M.r_hand == src)
			M.update_inv_r_hand()

/obj/item/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return
		if(3.0)
			if (prob(5))
				qdel(src)
				return
		else
	return

//user: The mob that is suiciding
//damagetype: The type of damage the item will inflict on the user
//BRUTELOSS = 1
//FIRELOSS = 2
//TOXLOSS = 4
//OXYLOSS = 8
///Output a creative message and then return the damagetype done
/obj/item/proc/suicide_act(mob/user)
	return

/obj/item/verb/move_to_top()
	set name = "Move To Top"
	set category = "Object"
	set src in oview(1)

	if(!istype(src.loc, /turf) || usr.stat || usr.restrained() )
		return

	var/turf/T = src.loc

	src.loc = null

	src.loc = T

/// See inventory_sizes.dm for the defines.
/obj/item/examine(mob/user)
	. = ..()
	. += "[gender == PLURAL ? "They are" : "It is"] a [weightclass2text(w_class)] item."

	// if(resistance_flags & INDESTRUCTIBLE)
	// 	. += "[src] seems extremely robust! It'll probably withstand anything that could happen to it!"
	// else
	// 	if(resistance_flags & LAVA_PROOF)
	// 		. += "[src] is made of an extremely heat-resistant material, it'd probably be able to withstand lava!"
	// 	if(resistance_flags & (ACID_PROOF | UNACIDABLE))
	// 		. += "[src] looks pretty robust! It'd probably be able to withstand acid!"
	// 	if(resistance_flags & FREEZE_PROOF)
	// 		. += "[src] is made of cold-resistant materials."
	// 	if(resistance_flags & FIRE_PROOF)
	// 		. += "[src] is made of fire-retardant materials."

	// if(item_flags & (ITEM_CAN_BLOCK | ITEM_CAN_PARRY))
	// 	var/datum/block_parry_data/data = return_block_parry_datum(block_parry_data)
	// 	. += "[src] has the capacity to be used to block and/or parry. <a href='?src=[REF(data)];name=[name];block=[item_flags & ITEM_CAN_BLOCK];parry=[item_flags & ITEM_CAN_PARRY];render=1'>\[Show Stats\]</a>"

/proc/weightclass2text(w_class)
	switch(w_class)
		if(WEIGHT_CLASS_TINY, ITEMSIZE_TINY)
			. = "tiny"
		if(WEIGHT_CLASS_SMALL, ITEMSIZE_SMALL)
			. = "small"
		if(WEIGHT_CLASS_NORMAL, ITEMSIZE_NORMAL)
			. = "normal-sized"
		if(WEIGHT_CLASS_BULKY, ITEMSIZE_LARGE)
			. = "bulky"
		if(WEIGHT_CLASS_HUGE, ITEMSIZE_HUGE)
			. = "huge"
		if(WEIGHT_CLASS_GIGANTIC)
			. = "gigantic"
		else
			. = ""

/obj/item/attack_hand(mob/living/user as mob)
	attempt_pickup(user)

/obj/item/proc/attempt_pickup(mob/user)
	if (!user)
		return

	if(anchored)
		to_chat(user, SPAN_NOTICE("\The [src] won't budge, you can't pick it up!"))
		return

	if (hasorgans(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/temp = H.organs_by_name["r_hand"]
		if (H.hand)
			temp = H.organs_by_name["l_hand"]
		if(temp && !temp.is_usable())
			to_chat(user, "<span class='notice'>You try to move your [temp.name], but cannot!</span>")
			return
		if(!temp)
			to_chat(user, "<span class='notice'>You try to use your hand, but realize it is no longer attached!</span>")
			return

	var/old_loc = src.loc

	throwing = 0
	if(user.put_in_active_hand(src))
		if(isturf(old_loc))
			var/obj/effect/temporary_effect/item_pickup_ghost/ghost = new(old_loc)
			ghost.assumeform(src)
			ghost.animate_towards(user)

/obj/item/OnMouseDrop(atom/over, mob/user, proximity, params)
	if(!user.is_in_inventory(src))
		// not being held
		if(!isturf(loc))	// yea nah
			return ..()
		if(user.Adjacent(src))
			// check for equip
			if(istype(over, /atom/movable/screen/inventory/hand))
				var/atom/movable/screen/inventory/hand/H = over
				user.put_in_hand(src, H.index)
				return CLICKCHAIN_DO_NOT_PROPAGATE
			else if(istype(over, /atom/movable/screen/inventory/slot))
				var/atom/movable/screen/inventory/slot/S = over
				user.equip_to_slot_if_possible(src, S.slot_id)
				return CLICKCHAIN_DO_NOT_PROPAGATE
		// check for slide
		if(Adjacent(over) && user.CanSlideItem(src, over) && (istype(over, /obj/structure/rack) || istype(over, /obj/structure/table) || istype(over, /turf)))
			var/turf/old = get_turf(src)
			if(!Move(get_turf(over)))
				return CLICKCHAIN_DO_NOT_PROPAGATE
			//! todo: i want to strangle the mofo who did planes instead of invisibility, which makes it computationally infeasible to check ghost invisibility in get hearers in view
			//! :) FUCK YOU.
			//! this if check is all for you. FUCK YOU.
			if(!isobserver(user))
				user.visible_message(SPAN_NOTICE("[user] slides [src] over."), SPAN_NOTICE("You slide [src] over."), range = MESSAGE_RANGE_COMBAT_SUBTLE)
			log_inventory("[user] slid [src] from [COORD(old)] to [COORD(over)]")
			return CLICKCHAIN_DO_NOT_PROPAGATE
		return ..()
	else
		// being held, check for attempt unequip
		if(istype(over, /atom/movable/screen/inventory/hand))
			var/atom/movable/screen/inventory/hand/H = over
			user.put_in_hand(src, H.index)
			return CLICKCHAIN_DO_NOT_PROPAGATE
		else if(istype(over, /atom/movable/screen/inventory/slot))
			var/atom/movable/screen/inventory/slot/S = over
			user.equip_to_slot_if_possible(src, S.slot_id)
			return CLICKCHAIN_DO_NOT_PROPAGATE
		else if(istype(over, /turf))
			user.drop_item_to_ground(src)
			return CLICKCHAIN_DO_NOT_PROPAGATE
		return ..()

// funny!
/mob/proc/CanSlideItem(obj/item/I, turf/over)
	return FALSE

/mob/living/CanSlideItem(obj/item/I, turf/over)
	return Adjacent(I) && !incapacitated() && !stat && !restrained()

/mob/observer/dead/CanSlideItem(obj/item/I, turf/over)
	return is_spooky

/obj/item/attack_ai(mob/user as mob)
	if (istype(src.loc, /obj/item/robot_module))
		//If the item is part of a cyborg module, equip it
		if(!isrobot(user))
			return
		var/mob/living/silicon/robot/R = user
		R.activate_module(src)
		R.hud_used.update_robot_modules_display()

/obj/item/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/storage))
		var/obj/item/storage/S = W
		if(S.use_to_pickup)
			if(S.collection_mode) //Mode is set to collect all items
				if(isturf(src.loc))
					S.gather_all(src.loc, user)

			else if(S.can_be_inserted(src))
				S.handle_item_insertion(src, user)
	return

/obj/item/proc/talk_into(mob/M as mob, text)
	return

/obj/item/proc/moved(mob/user as mob, old_loc as turf)
	return

/obj/item/proc/get_volume_by_throwforce_and_or_w_class() // This is used for figuring out how loud our sounds are for throwing.
	if(throwforce && w_class)
		return clamp((throwforce + w_class) * 5, 30, 100)// Add the item's throwforce to its weight class and multiply by 5, then clamp the value between 30 and 100
	else if(w_class)
		return clamp(w_class * 8, 20, 100) // Multiply the item's weight class by 8, then clamp the value between 20 and 100
	else
		return 0

/obj/item/throw_impact(atom/hit_atom)
	..()
	if(isliving(hit_atom)) //Living mobs handle hit sounds differently.
		var/volume = get_volume_by_throwforce_and_or_w_class()
		if (throwforce > 0)
			if (mob_throw_hit_sound)
				playsound(hit_atom, mob_throw_hit_sound, volume, TRUE, -1)
			else if(hitsound)
				playsound(hit_atom, hitsound, volume, TRUE, -1)
			else
				playsound(hit_atom, 'sound/weapons/genhit.ogg', volume, TRUE, -1)
		else
			playsound(hit_atom, 'sound/weapons/throwtap.ogg', 1, volume, -1)
	else
		playsound(src, drop_sound, 30, preference = /datum/client_preference/drop_sounds)

// called when this item is removed from a storage item, which is passed on as S. The loc variable is already set to the new destination before this is called.
/obj/item/proc/on_exit_storage(obj/item/storage/S as obj)
	SEND_SIGNAL(src, COMSIG_STORAGE_EXITED, S)

// called when this item is added into a storage item, which is passed on as S. The loc variable is already set to the storage item.
/obj/item/proc/on_enter_storage(obj/item/storage/S as obj)
	SEND_SIGNAL(src, COMSIG_STORAGE_ENTERED, S)

// called when "found" in pockets and storage items. Returns 1 if the search should end.
/obj/item/proc/on_found(mob/finder as mob)
	return

/obj/item/verb/verb_pickup()
	set src in oview(1)
	set category = "Object"
	set name = "Pick up"

	if(!(usr)) //BS12 EDIT
		return
	if(!usr.canmove || usr.stat || usr.restrained() || !Adjacent(usr))
		return
	if((!istype(usr, /mob/living/carbon)) || (istype(usr, /mob/living/carbon/brain)))//Is humanoid, and is not a brain
		to_chat(usr, "<span class='warning'>You can't pick things up!</span>")
		return
	var/mob/living/carbon/C = usr
	if( usr.stat || usr.restrained() )//Is not asleep/dead and is not restrained
		to_chat(usr, "<span class='warning'>You can't pick things up!</span>")
		return
	if(src.anchored) //Object isn't anchored
		to_chat(usr, "<span class='warning'>You can't pick that up!</span>")
		return
	if(C.get_active_held_item()) //Hand is not full
		to_chat(usr, "<span class='warning'>Your hand is full.</span>")
		return
	if(!istype(src.loc, /turf)) //Object is on a turf
		to_chat(usr, "<span class='warning'>You can't pick that up!</span>")
		return

	attempt_pickup(usr)

/**
 *This proc is executed when someone clicks the on-screen UI button.
 *The default action is attack_self().
 */
/obj/item/proc/ui_action_click()
	attack_self(usr)

//RETURN VALUES
//handle_shield should return a positive value to indicate that the attack is blocked and should be prevented.
//If a negative value is returned, it should be treated as a special return value for bullet_act() and handled appropriately.
//For non-projectile attacks this usually means the attack is blocked.
//Otherwise should return 0 to indicate that the attack is not affected in any way.
/obj/item/proc/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	return 0

/obj/item/proc/get_loc_turf()
	var/atom/L = loc
	while(L && !istype(L, /turf/))
		L = L.loc
	return loc

/obj/item/proc/eyestab(mob/living/carbon/M as mob, mob/living/carbon/user as mob)

	var/mob/living/carbon/human/H = M
	var/mob/living/carbon/human/U = user
	if(istype(H))
		for(var/obj/item/protection in list(H.head, H.wear_mask, H.glasses))
			if(protection && (protection.body_parts_covered & EYES))
				// you can't stab someone in the eyes wearing a mask!
				to_chat(user, "<span class='warning'>You're going to need to remove the eye covering first.</span>")
				return

	if(!M.has_eyes())
		to_chat(user, "<span class='warning'>You cannot locate any eyes on [M]!</span>")
		return

	//this should absolutely trigger even if not aim-impaired in some way
	var/hit_zone = get_zone_with_miss_chance(U.zone_sel.selecting, M, U.get_accuracy_penalty(U))
	if(!hit_zone)
		U.do_attack_animation(M)
		playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
		//visible_message("<span class='danger'>[U] attempts to stab [M] in the eyes, but misses!</span>")
		for(var/mob/V in viewers(M))
			V.show_message("<span class='danger'>[U] attempts to stab [M] in the eyes, but misses!</span>")
		return

	add_attack_logs(user,M,"Attack eyes with [name]")

	user.setClickCooldown(user.get_attack_speed())
	user.do_attack_animation(M)

	src.add_fingerprint(user)
	//if((CLUMSY in user.mutations) && prob(50))
	//	M = user
		/*
		to_chat(M, "<span class='warning'>You stab yourself in the eye.</span>")
		M.sdisabilities |= BLIND
		M.weakened += 4
		M.adjustBruteLoss(10)
		*/

	if(istype(H))

		var/obj/item/organ/internal/eyes/eyes = H.internal_organs_by_name[O_EYES]

		if(H != user)
			for(var/mob/O in (viewers(M) - user - M))
				O.show_message("<span class='danger'>[M] has been stabbed in the eye with [src] by [user].</span>", 1)
			to_chat(M, "<span class='danger'>[user] stabs you in the eye with [src]!</span>")
			to_chat(user, "<span class='danger'>You stab [M] in the eye with [src]!</span>")
		else
			user.visible_message( \
				"<span class='danger'>[user] has stabbed themself with [src]!</span>", \
				"<span class='danger'>You stab yourself in the eyes with [src]!</span>" \
			)

		eyes.damage += rand(3,4)
		if(eyes.damage >= eyes.min_bruised_damage)
			if(M.stat != 2)
				if(!(eyes.robotic >= ORGAN_ROBOT)) //robot eyes bleeding might be a bit silly
					to_chat(M, "<span class='danger'>Your eyes start to bleed profusely!</span>")
			if(prob(50))
				if(M.stat != 2)
					to_chat(M, "<span class='warning'>You drop what you're holding and clutch at your eyes!</span>")
					M.drop_active_held_item()
				M.eye_blurry += 10
				M.Paralyse(1)
				M.Weaken(4)
			if (eyes.damage >= eyes.min_broken_damage)
				if(M.stat != 2)
					to_chat(M, "<span class='warning'>You go blind!</span>")
		var/obj/item/organ/external/affecting = H.get_organ(BP_HEAD)
		if(affecting.take_damage(7))
			M:UpdateDamageIcon()
	else
		M.take_organ_damage(7)
	M.eye_blurry += rand(3,4)
	return

/obj/item/clean_blood()
	. = ..()
	if(blood_overlay)
		overlays.Remove(blood_overlay)
	if(istype(src, /obj/item/clothing/gloves))
		var/obj/item/clothing/gloves/G = src
		G.transfer_blood = 0

/obj/item/reveal_blood()
	if(was_bloodied && !fluorescent)
		fluorescent = 1
		blood_color = COLOR_LUMINOL
		blood_overlay.color = COLOR_LUMINOL
		update_icon()

/obj/item/add_blood(mob/living/carbon/human/M as mob)
	if (!..())
		return 0

	if(istype(src, /obj/item/melee/energy))
		return

	//if we haven't made our blood_overlay already
	if( !blood_overlay )
		generate_blood_overlay()

	//Make the blood_overlay have the proper color then apply it.
	blood_overlay.color = blood_color
	overlays += blood_overlay

	//if this blood isn't already in the list, add it
	if(istype(M))
		if(blood_DNA[M.dna.unique_enzymes])
			return 0 //already bloodied with this blood. Cannot add more.
		blood_DNA[M.dna.unique_enzymes] = M.dna.b_type
	return 1 //we applied blood to the item

/obj/item/proc/generate_blood_overlay()
	if(blood_overlay)
		return

	var/icon/I = new /icon(icon, icon_state)
	I.Blend(new /icon('icons/effects/blood.dmi', rgb(255,255,255)),ICON_ADD) //fills the icon_state with white (except where it's transparent)
	I.Blend(new /icon('icons/effects/blood.dmi', "itemblood"),ICON_MULTIPLY) //adds blood and the remaining white areas become transparant

	//not sure if this is worth it. It attaches the blood_overlay to every item of the same type if they don't have one already made.
	for(var/obj/item/A in world)
		if(A.type == type && !A.blood_overlay)
			A.blood_overlay = image(I)

/obj/item/proc/showoff(mob/user)
	for (var/mob/M in view(user))
		M.show_message("[user] holds up [src]. <a HREF=?src=\ref[M];lookitem=\ref[src]>Take a closer look.</a>",1)

/mob/living/carbon/verb/showoff()
	set name = "Show Held Item"
	set category = "Object"

	var/obj/item/I = get_active_held_item()
	if(I && !(I.flags & ATOM_ABSTRACT))
		I.showoff(src)

/*
For zooming with scope or binoculars. This is called from
modules/mob/mob_movement.dm if you move you will be zoomed out
modules/mob/living/carbon/human/life.dm if you die, you will be zoomed out.
*/
//Looking through a scope or binoculars should /not/ improve your periphereal vision. Still, increase viewsize a tiny bit so that sniping isn't as restricted to NSEW

// this is shitcode holy crap
/obj/item/proc/zoom(tileoffset = 14, viewsize = 9, mob/user = usr, wornslot = FALSE) //tileoffset is client view offset in the direction the user is facing. viewsize is how far out this thing zooms. 7 is normal view. slot determines whether the item needs to be held in-hand (by being set to FALSE) OR worn on a specific slot to look through

	var/devicename

	if(zoomdevicename)
		devicename = zoomdevicename
	else
		devicename = src.name

	var/cannotzoom

	if((user.stat && !zoom) || !(istype(user,/mob/living/carbon/human)))
		to_chat(user, "You are unable to focus through the [devicename]")
		cannotzoom = 1
	else if(!zoom && (GLOB.global_hud.darkMask[1] in user.client.screen))
		to_chat(user, "Your visor gets in the way of looking through the [devicename]")
		cannotzoom = 1
	else if(!zoom && user.get_active_held_item() != src && wornslot == FALSE)
		to_chat(user, "You are too distracted to look through the [devicename], perhaps if it was in your active hand this might work better")
		cannotzoom = 1
	else if(!zoom && user.item_by_slot(wornslot) != src && wornslot != FALSE)
		to_chat(user, "You need to wear the [devicename] to look through it properly")
		cannotzoom = 1

	//We checked above if they are a human and returned already if they weren't.
	var/mob/living/carbon/human/H = user

	if(!zoom && !cannotzoom)
		if(H.hud_used.hud_shown)
			H.toggle_zoom_hud()	// If the user has already limited their HUD this avoids them having a HUD when they zoom in
		H.set_viewsize(viewsize)
		zoom = 1

		var/tilesize = 32
		var/viewoffset = tilesize * tileoffset

		switch(H.dir)
			if (NORTH)
				H.client.pixel_x = 0
				H.client.pixel_y = viewoffset
			if (SOUTH)
				H.client.pixel_x = 0
				H.client.pixel_y = -viewoffset
			if (EAST)
				H.client.pixel_x = viewoffset
				H.client.pixel_y = 0
			if (WEST)
				H.client.pixel_x = -viewoffset
				H.client.pixel_y = 0

		H.visible_message("[user] peers through the [zoomdevicename ? "[zoomdevicename] of the [src.name]" : "[src.name]"].")
		H.looking_elsewhere = TRUE
		H.handle_vision()

	else
		H.set_viewsize()	// Reset to default
		if(!H.hud_used.hud_shown)
			H.toggle_zoom_hud()
		zoom = 0

		H.client.pixel_x = 0
		H.client.pixel_y = 0
		H.looking_elsewhere = FALSE
		H.handle_vision()

		if(!cannotzoom)
			user.visible_message("[zoomdevicename ? "[user] looks up from the [src.name]" : "[user] lowers the [src.name]"].")

	return

/obj/item/proc/pwr_drain()
	return 0 // Process Kill

/// Used for non-adjacent melee attacks with specific weapons capable of reaching more than one tile.
/// This uses changeling range string A* but for this purpose its also applicable.
/obj/item/proc/attack_can_reach(var/atom/us, var/atom/them, var/range)
	if(us.Adjacent(them))
		return TRUE // Already adjacent.
	if(AStar(get_turf(us), get_turf(them), /turf/proc/AdjacentTurfsRangedSting, /turf/proc/Distance, max_nodes=25, max_node_depth=range))
		return TRUE
	return FALSE

/// Check if an object should ignite others, like a lit lighter or candle.
/obj/item/proc/is_hot()
	return FALSE

/// Worn icon generation for on-mob sprites
/obj/item/proc/make_worn_icon(var/body_type,var/slot_id,var/inhands,var/default_icon,var/default_layer,var/icon/clip_mask = null)
	//Get the required information about the base icon
	var/icon/icon2use = get_worn_icon_file(body_type = body_type, slot_id = slot_id, default_icon = default_icon, inhands = inhands)
	var/state2use = get_worn_icon_state(slot_id = slot_id)
	var/layer2use = get_worn_layer(default_layer = default_layer)

	//Snowflakey inhand icons in a specific slot
	if(inhands && icon2use == icon_override)
		switch(slot_id)
			if(slot_r_hand_str)
				state2use += "_r"
			if(slot_l_hand_str)
				state2use += "_l"

	// testing("[src] (\ref[src]) - Slot: [slot_id], Inhands: [inhands], Worn Icon:[icon2use], Worn State:[state2use], Worn Layer:[layer2use]")

	//Generate the base onmob icon
	var/icon/standing_icon = icon(icon = icon2use, icon_state = state2use)

	if(!inhands)
		apply_custom(standing_icon)		//Pre-image overridable proc to customize the thing
		apply_addblends(icon2use,standing_icon)		//Some items have ICON_ADD blend shaders

	var/image/standing = image(standing_icon)
	standing = center_image(standing, inhands ? inhand_x_dimension : worn_x_dimension, inhands ? inhand_y_dimension : worn_y_dimension)
	standing.alpha = alpha
	standing.color = color
	standing.layer = layer2use
	if(istype(clip_mask)) //For taur bodies/tails clipping off parts of uniforms and suits.
		standing.filters += filter(type = "alpha", icon = clip_mask)

	if(istype(clip_mask)) //For taur bodies/tails clipping off parts of uniforms and suits.
		standing.filters += filter(type = "alpha", icon = clip_mask)

	//Apply any special features
	if(!inhands)
		apply_blood(standing)			//Some items show blood when bloodied
		apply_accessories(standing)		//Some items sport accessories like webbing

	//Return our icon
	return standing

//Returns the icon object that should be used for the worn icon
/obj/item/proc/get_worn_icon_file(var/body_type,var/slot_id,var/default_icon,var/inhands)

	//1: icon_override var
	if(icon_override)
		return icon_override

	//2: species-specific sprite sheets (skipped for inhands)
	if(LAZYLEN(sprite_sheets))
		var/sheet = sprite_sheets[body_type]
		if(sheet && !inhands)
			return sheet

	//3: slot-specific sprite sheets
	if(LAZYLEN(item_icons))
		var/sheet = item_icons[slot_id]
		if(sheet)
			return sheet

	//4: item's default icon
	if(default_worn_icon)
		return default_worn_icon

	//5: provided default_icon
	if(default_icon)
		return default_icon

	//6: give up
	return

//Returns the state that should be used for the worn icon
/obj/item/proc/get_worn_icon_state(var/slot_id)

	//1: slot-specific sprite sheets
	if(LAZYLEN(item_state_slots))
		var/state = item_state_slots[slot_id]
		if(state)
			return state

	//2: item_state variable
	if(item_state)
		return item_state

	//3: icon_state variable
	if(icon_state)
		return icon_state

/// Returns the layer that should be used for the worn icon (as a FLOAT_LAYER layer, so negative)
/obj/item/proc/get_worn_layer(default_layer = 0)

	//1: worn_layer variable
	if(!isnull(worn_layer)) //Can be zero, so...
		return BODY_LAYER+worn_layer

	//2: your default
	return BODY_LAYER+default_layer

//Apply the addblend blends onto the icon
/obj/item/proc/apply_addblends(var/source_icon, var/icon/standing_icon)

	//If we have addblends, blend them onto the provided icon
	if(addblends && standing_icon && source_icon)
		var/addblend_icon = icon("icon" = source_icon, "icon_state" = addblends)
		standing_icon.Blend(addblend_icon, ICON_ADD)

//STUB
/obj/item/proc/apply_custom(var/icon/standing_icon)
	return standing_icon

//STUB
/obj/item/proc/apply_blood(var/image/standing)
	return standing

//STUB
/obj/item/proc/apply_accessories(var/image/standing)
	return standing

/*
 *	Assorted tool procs, so any item can emulate any tool, if coded
*/
/obj/item/proc/is_screwdriver()
	return FALSE

/obj/item/proc/is_wrench()
	return FALSE

/obj/item/proc/is_crowbar()
	return FALSE

/obj/item/proc/is_wirecutter()
	return FALSE

/obj/item/proc/is_cable_coil()
	return FALSE

/obj/item/proc/is_multitool()
	return FALSE

/obj/item/proc/is_welder()
	return FALSE

// These procs are for RPEDs and part ratings. The concept for this was borrowed from /vg/station.
// Gets the rating of the item, used in stuff like machine construction.
/obj/item/proc/get_rating()
	return FALSE

// Like the above, but used for RPED sorting of parts.
/obj/item/proc/rped_rating()
	return get_rating()

/obj/item/interact(mob/user)
	add_fingerprint(user)
	ui_interact(user)
