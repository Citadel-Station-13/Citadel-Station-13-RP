/obj/item
	name = "item"
	icon = 'icons/obj/items.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	// todo: better way, for now, block all rad contamination to interior
	rad_flags = RAD_BLOCK_CONTENTS
	obj_flags = OBJ_IGNORE_MOB_DEPTH | OBJ_RANGE_TARGETABLE
	depth_level = 0
	climb_allowed = FALSE

	//* Actions *//
	/// cached action descriptors
	///
	/// this can be:
	/// * a /datum/action instance
	/// * a /datum/action typepath
	/// * a list of /datum/action instancse
	/// * a list of /datum/action typepaths
	///
	/// typepaths get instanced on us entering inventory
	var/item_actions
	/// if [item_actions] is not set, and this is, we make a single action rendering ourselves
	/// and set its name to this
	var/item_action_name
	/// if [item_actions] is not set, and [action_name] is set, this is the mobility flags
	/// the action will check for
	var/item_action_mobility_flags = MOBILITY_CAN_HOLD | MOBILITY_CAN_USE

	//* Combat *//
	/// Amount of damage we do on melee.
	var/damage_force = 0
	/// armor flag for melee attacks
	var/damage_flag = ARMOR_MELEE
	/// damage tier
	var/damage_tier = 3
	/// damage_mode bitfield - see [code/__DEFINES/combat/damage.dm]
	var/damage_mode = NONE
	/// DAMAGE_TYPE_* enum
	///
	/// * This is the primary damage type this object does on usage as a melee / thrown weapon.
	var/damage_type = DAMAGE_TYPE_BRUTE
	/// passive parry data / frame
	///
	/// * anonymous typepath is allowed
	/// * typepath is allowed
	/// * instance is allowed
	///
	/// note that the component will not be modified while held;
	/// if this is changed, the component needs to be remade.
	var/passive_parry
	/// base melee click cooldown
	var/melee_click_cd_base = 0.8 SECONDS
	/// base melee click cooldown multiplier
	var/melee_click_cd_multiply = 1

	//* Economy
	/// economic category for items
	var/economic_category_item = ECONOMIC_CATEGORY_ITEM_DEFAULT

	//* Flags *//
	/// Item flags.
	/// These flags are listed in [code/__DEFINES/inventory/item_flags.dm].
	var/item_flags = ITEM_ENCUMBERS_WHILE_HELD
	/// Miscellaneous flags pertaining to equippable objects.
	/// These flags are listed in [code/__DEFINES/inventory/item_flags.dm].
	var/clothing_flags = NONE
	/// Flags for items (or in some cases mutant parts) hidden by this item when worn.
	/// As of right now, some flags only work in some slots.
	/// These flags are listed in [code/__DEFINES/inventory/item_flags.dm].
	var/inv_hide_flags = NONE
	/// Flags for the bodyparts this item covers when worn.
	/// These flags are listed in [code/__DEFINES/inventory/item_flags.dm].
	///
	/// * Do not set these directly, use set_body_cover_flags()!
	var/body_cover_flags = NONE
	/// Flags which determine which body parts are protected from heat. Use the HEAD, UPPER_TORSO, LOWER_TORSO, etc. flags. See setup.dm
	/// These flags are listed in [code/__DEFINES/inventory/item_flags.dm].
	var/heat_protection_cover = NONE
	/// Flags which determine which body parts are protected from cold. Use the HEAD, UPPER_TORSO, LOWER_TORSO, etc. flags. See setup.dm
	/// These flags are listed in [code/__DEFINES/inventory/item_flags.dm].
	var/cold_protection_cover = NONE
	/// This is used to determine on which slots an item can fit, for inventory slots that use flags to determine this.
	/// These flags are listed in [code/__DEFINES/inventory/slots.dm].
	var/slot_flags = NONE
	/// This is used to determine how we persist, in addition to potentially atom_persist_flags and obj_persist_flags (not yet made)
	/// These flags are listed in [code/__DEFINES/inventory/item_flags.dm].
	var/item_persist_flags = NONE
	/// This is used to determine how default item-level interaction hooks are handled.
	/// These flags are listed in [code/__DEFINES/_flags/interaction_flags.dm]
	var/interaction_flags_item = INTERACT_ITEM_ATTACK_SELF

	//* Inventory *//
	/// Currently equipped slot ID or hand index if held in hand
	var/inv_slot_or_index
	/// The inventory datum we're in.
	///
	/// * This also doubles as an 'is in inventory' check, as this will always be set if we are in inventory.
	/// * This also doubles as 'get worn mob' by doing `inv_inside?.owner`.
	var/datum/inventory/inv_inside
	/// currently equipped slot id
	///
	/// todo: `worn_slot_or_index`
	var/worn_slot
	/// current hand index, if held in hand
	///
	/// todo: `worn_slot_or_index`
	var/held_index
	/**
	 * current item we fitted over
	 * ! DANGER: While this is more or less bug-free for "won't lose the item when you unequip/won't get stuck", we
	 * ! do not promise anything for functionality - this is a SNOWFLAKE SYSTEM.
	 */
	var/obj/item/worn_over
	/**
	 * current item we're fitted in.
	 */
	var/obj/item/worn_inside
	/// suppress auto inventory hooks in forceMove
	var/worn_hook_suppressed = FALSE

	//* Environmentals *//
	/// Set this variable to determine up to which temperature (IN KELVIN) the item protects against heat damage. Keep at null to disable protection. Only protects areas set by heat_protection flags.
	var/max_heat_protection_temperature
	/// Set this variable to determine down to which temperature (IN KELVIN) the item protects against cold damage. 0 is NOT an acceptable number due to if(varname) tests!! Keep at null to disable protection. Only protects areas set by cold_protection flags.
	var/min_cold_protection_temperature

	/// Set this variable if the item protects its wearer against high pressures below an upper bound. Keep at null to disable protection.
	var/max_pressure_protection
	/// Set this variable if the item protects its wearer against low pressures above a lower bound. Keep at null to disable protection. 0 represents protection against hard vacuum.
	var/min_pressure_protection

	//* Carry Weight *//
	/// encumberance.
	/// calculated as max() of all encumbrance
	/// result is calculated into slowdown value
	/// and then max()'d with carry weight for the final slowdown used.
	var/encumbrance = ITEM_ENCUMBRANCE_BASELINE
	/// registered encumbrance - null if not in inventory
	var/encumbrance_registered
	/// carry weight in kgs. this might be generalized later so KEEP IT REALISTIC.
	var/weight = ITEM_WEIGHT_BASELINE
	/// registered carry weight - null if not in inventory.
	var/weight_registered
	/// flat encumbrance - while worn, you are treated as at **least** this encumbered
	/// e.g. if someone is wearing a flat 50 encumbrance item, but their regular encumbrance tally is only 45, they still have 50 total.
	var/flat_encumbrance = 0
	/// Hard slowdown. Applied before carry weight.
	/// This affects multiplicative movespeed.
	var/slowdown = 0

	//* Storage *//
	/// storage cost for volumetric storage
	/// null to default to weight class
	var/weight_volume

	//? unsorted / legacy
	/// This saves our blood splatter overlay, which will be processed not to go over the edges of the sprite
	var/image/blood_overlay = null
	pass_flags = ATOM_PASS_TABLE
	pressure_resistance = 5
	var/obj/item/master = null
	/// Used by R&D to determine what research bonuses it grants.
	var/list/origin_tech = null
	/**
	 * Used in attackby() to say how something was attacked "[x] has been [z.attack_verb] by [y] with [z]"
	 * Either a list() with equal chances or a single verb.
	 */
	var/list/attack_verb = "attacked"

	/// 0 prevents all transfers, 1 is invisible
	//var/heat_transfer_coefficient = 1
	/// For leaking gas from turf to mask and vice-versa (for masks right now, but at some point, i'd like to include space helmets)
	var/gas_transfer_coefficient = 1
	/// For chemicals/diseases
	var/permeability_coefficient = 1
	/// For electrical admittance/conductance (electrocution checks and shit)
	var/siemens_coefficient = 1
	/// Suit storage stuff.
	// todo: kill with fire
	var/list/allowed = null
	// todo: kill with fire
	/// All items can have an uplink hidden inside, just remember to add the triggers.
	var/obj/item/uplink/hidden/hidden_uplink = null
	/// Name used for message when binoculars/scope is used
	// todo: kill with fire
	var/zoomdevicename = null
	/// TRUE if item is actively being used to zoom. For scoped guns and binoculars.
	// todo: kill with fire
	var/zoom = FALSE
	/// 0 won't embed, and 100 will always embed
	var/embed_chance = EMBED_CHANCE_UNSET

	/// Length of tiles it can reach, 1 is adjacent.
	var/reach = 1
	/// Icon overlay for ADD highlights when applicable.
	var/addblends

	//? Sounds
	/// sound used when used in melee attacks. null for default for our damage tpye.
	var/attack_sound
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

	/// Whether or not we are heavy. Used for some species to determine if they can two-hand it.
	var/heavy = FALSE

	/// If true, a 'cleaving' attack will occur.
	var/can_cleave = FALSE
	/// Used to avoid infinite cleaving.
	var/cleaving = FALSE

/obj/item/Initialize(mapload)
	. = ..()
	loc?.on_contents_item_new(src)
	if(islist(origin_tech))
		origin_tech = typelist(NAMEOF(src, origin_tech), origin_tech)
	//Potential memory optimization: Making embed chance a getter if unset.
	if(embed_chance == EMBED_CHANCE_UNSET)
		if(damage_mode & DAMAGE_MODE_SHARP)
			embed_chance = max(5, round(damage_force/w_class))
		else
			embed_chance = max(5, round(damage_force/(w_class*3)))

/obj/item/Destroy()
	// run inventory hooks
	if(worn_slot && !worn_hook_suppressed)
		var/mob/M = get_worn_mob()
		if(!ismob(M))
			stack_trace("invalid current equipped slot [worn_slot] on an item not on a mob.")
			return ..()
		M.temporarily_remove_from_inventory(src, INV_OP_FORCE | INV_OP_DELETING)
	return ..()

/// Check if target is reasonable for us to operate on.
/obj/item/proc/check_allowed_items(atom/target, not_inside, target_self)
	if(((src in target) && !target_self) || ((!istype(target.loc, /turf)) && (!istype(target, /turf)) && (not_inside)))
		return FALSE
	else
		return TRUE

/obj/item/legacy_ex_act(severity)
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

/obj/item/verb/move_to_top()
	set name = "Move To Top"
	set category = VERB_CATEGORY_OBJECT
	set src in oview(1)

	if(!istype(src.loc, /turf) || usr.stat || usr.restrained() )
		return

	var/turf/T = src.loc

	src.loc = null
	src.loc = T

/// See inventory_sizes.dm for the defines.
/obj/item/examine(mob/user, dist)
	. = ..()
	. += "[gender == PLURAL ? "They are" : "It is"] a [weightclass2text(w_class)] item."
	switch(get_encumbrance())
		if(-INFINITY to 0.1)
			. += "It looks effortless to carry around and wear."
		if(0.1 to 0.75)
			. += "It looks very easy to carry around and wear."
		if(0.75 to 2)
			. += "It looks decently able to be carried around and worn."
		if(2 to 5)
			. += "It looks somewhat unwieldly."
		if(5 to 10)
			. += "It looks quite unwieldly."
		if(10 to 20)
			. += "It looks very unwieldly. It would take a good effort to run around with it."
		if(20 to 40)
			. += "It looks extremely unwieldly. You probably will have a hard time running with it."
		if(40 to INFINITY)
			. += "It's so unwieldly that it's a surprise you can hold it at all. You really won't be doing much running with it."
	switch(get_weight())
		if(-INFINITY to 0.1)
			// todo: put this in when we actually get weight
			// . += "It looks like it weighs practically nothing."
		if(0.1 to 0.75)
			. += "It looks like it weighs very little."
		if(0.75 to 2)
			. += "It looks like it's decently lightweight."
		if(2 to 5)
			. += "It looks like it weighs a bit."
		if(5 to 10)
			. += "It looks like it weighs a good amount."
		if(10 to 20)
			. += "It looks like it is heavy. It would take a good effort to run around with it."
		if(20 to 40)
			. += "It looks like it weighs a lot. You probably will have a hard time running with it."
		if(40 to INFINITY)
			. += "It looks like it weighs a ton. You really won't be doing much running with it."

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
		if(WEIGHT_CLASS_TINY, WEIGHT_CLASS_TINY)
			. = "tiny"
		if(WEIGHT_CLASS_SMALL, WEIGHT_CLASS_SMALL)
			. = "small"
		if(WEIGHT_CLASS_NORMAL, WEIGHT_CLASS_NORMAL)
			. = "normal-sized"
		if(WEIGHT_CLASS_BULKY, WEIGHT_CLASS_BULKY)
			. = "bulky"
		if(WEIGHT_CLASS_HUGE, WEIGHT_CLASS_HUGE)
			. = "huge"
		if(WEIGHT_CLASS_GIGANTIC)
			. = "gigantic"
		else
			. = ""

/obj/item/attack_ai(mob/user as mob)
	if (istype(src.loc, /obj/item/robot_module))
		//If the item is part of a cyborg module, equip it
		if(!isrobot(user))
			return
		var/mob/living/silicon/robot/R = user
		R.activate_module(src)
		R.hud_used.update_robot_modules_display()

/obj/item/proc/talk_into(mob/M as mob, text)
	return

/obj/item/proc/get_volume_by_throwforce_and_or_w_class() // This is used for figuring out how loud our sounds are for throwing.
	if(throw_force && w_class)
		return clamp((throw_force + w_class) * 5, 30, 100)// Add the item's throw_force to its weight class and multiply by 5, then clamp the value between 30 and 100
	else if(w_class)
		return clamp(w_class * 8, 20, 100) // Multiply the item's weight class by 8, then clamp the value between 20 and 100
	else
		return 0


/obj/item/throw_impact(atom/A, datum/thrownthing/TT)
	. = ..()
	if(QDELETED(A))
		return
/*
		if(get_temperature() && isliving(hit_atom))
			var/mob/living/L = hit_atom
			L.IgniteMob()
*/
	if(isliving(A)) //Living mobs handle hit sounds differently.
		var/volume = get_volume_by_throwforce_and_or_w_class()
		if (throw_force > 0)
			if (mob_throw_hit_sound)
				playsound(A, mob_throw_hit_sound, volume, TRUE, -1)
			else if(attack_sound)
				playsound(A, attack_sound, volume, TRUE, -1)
			else
				playsound(A, 'sound/weapons/genhit.ogg', volume, TRUE, -1)
		else
			playsound(A, 'sound/weapons/throwtap.ogg', 1, volume, -1)
	else
		playsound(src, drop_sound, 30)

/obj/item/throw_land(atom/A, datum/thrownthing/TT)
	. = ..()
	if(TT.throw_flags & THROW_AT_IS_NEAT)
		return
	var/matrix/M = matrix(transform)
	M.Turn(rand(-170, 170))
	transform = M
	set_pixel_offsets(rand(-8, 8), rand(-8, 8))

/obj/item/verb/verb_pickup()
	set src in oview(1)
	set category = VERB_CATEGORY_OBJECT
	set name = "Pick up"

	if(!(usr)) //BS12 EDIT
		return
	if(!CHECK_MOBILITY(usr, MOBILITY_CAN_PICKUP) || !Adjacent(usr))
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

/obj/item/ui_action_click(datum/action/action, datum/event_args/actor/actor)
	attack_self(usr)
	return TRUE

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
			if(protection && (protection.body_cover_flags & EYES))
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

	user.setClickCooldownLegacy(user.get_attack_speed_legacy())
	user.do_attack_animation(M)

	src.add_fingerprint(user)
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
				M.afflict_unconscious(20 * 1)
				M.afflict_paralyze(20 * 4)
			if (eyes.damage >= eyes.min_broken_damage)
				if(M.stat != 2)
					to_chat(M, "<span class='warning'>You go blind!</span>")
		var/obj/item/organ/external/affecting = H.get_organ(BP_HEAD)
		affecting.inflict_bodypart_damage(
			brute = 7,
		)
	else
		M.take_random_targeted_damage(brute = 7)
	M.eye_blurry += rand(3,4)
	return

/obj/item/clean_blood()
	. = ..()
	if(blood_overlay)
		cut_overlay(blood_overlay)
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

	if(istype(src, /obj/item/melee/transforming/energy))
		return

	//if we haven't made our blood_overlay already
	if( !blood_overlay )
		generate_blood_overlay()

	//Make the blood_overlay have the proper color then apply it.
	blood_overlay.color = blood_color
	add_overlay(blood_overlay)

	//if this blood isn't already in the list, add it
	if(istype(M))
		if(blood_DNA[M.dna.unique_enzymes])
			return 0 //already bloodied with this blood. Cannot add more.
		blood_DNA[M.dna.unique_enzymes] = M.dna.b_type
	return 1 //we applied blood to the item

// Protip: don't use world scans to implement caching. Yes, that is how this used to work.
GLOBAL_LIST_EMPTY(blood_overlay_cache)

/obj/item/proc/generate_blood_overlay()
	if(blood_overlay)
		return

	if (GLOB.blood_overlay_cache[type])
		blood_overlay = GLOB.blood_overlay_cache[type]
		return

	var/icon/I = new /icon(icon, icon_state)
	I.Blend(new /icon('icons/effects/blood.dmi', rgb(255,255,255)), ICON_ADD) //fills the icon_state with white (except where it's transparent)
	I.Blend(new /icon('icons/effects/blood.dmi', "itemblood"), ICON_MULTIPLY) //adds blood and the remaining white areas become transparant

	blood_overlay = GLOB.blood_overlay_cache[type] = image(I)

/obj/item/proc/showoff(mob/user)
	for (var/mob/M in view(user))
		M.show_message("[user] holds up [src]. <a HREF=?src=\ref[M];lookitem=\ref[src]>Take a closer look.</a>",1)

/mob/living/carbon/verb/showoff()
	set name = "Show Held Item"
	set category = VERB_CATEGORY_OBJECT

	var/obj/item/I = get_active_held_item()
	if(I && !(I.atom_flags & ATOM_ABSTRACT))
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
	else if(!zoom && user.item_by_slot_id(wornslot) != src && wornslot != FALSE)
		to_chat(user, "You need to wear the [devicename] to look through it properly")
		cannotzoom = 1
	//We checked above if they are a human and returned already if they weren't.
	var/mob/living/carbon/human/H = user
	if(!zoom && !cannotzoom)
		H.ensure_self_perspective()
		H.self_perspective.set_augmented_view(viewsize - 2, viewsize - 2)
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
		H.ensure_self_perspective()
		H.self_perspective.set_augmented_view(0, 0)
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

/// Check if an object should ignite others, like a lit lighter or candle.
/obj/item/proc/is_hot()
	return FALSE

/// These procs are for RPEDs and part ratings. The concept for this was borrowed from /vg/station.
/// Gets the rating of the item, used in stuff like machine construction.
/// return null for don't use as part
/obj/item/proc/get_rating()
	return null

/// These procs are for RPEDs and part ratings, but used for RPED sorting of parts.
/obj/item/proc/rped_rating()
	return get_rating()

// todo: WHAT?
/obj/item/interact(mob/user)
	add_fingerprint(user)
	ui_interact(user)

//* Actions *//

/**
 * instructs all our action buttons to re-render
 */
/obj/item/proc/update_action_buttons()
	if(islist(item_actions))
		for(var/datum/action/action in item_actions)
			action.update_buttons()
	else if(istype(item_actions, /datum/action))
		var/datum/action/action = item_actions
		action.update_buttons()

/**
 * ensures our [item_actions] variable is set to:
 *
 * * null
 * * a list of actions
 * * an action instance
 */
/obj/item/proc/ensure_item_actions_loaded()
	if(item_actions)
		if(islist(item_actions))
			var/requires_init = FALSE
			for(var/i in 1 to length(item_actions))
				if(ispath(item_actions[i]))
					requires_init = TRUE
					break
			if(requires_init)
				set_actions_to(item_actions)
		else if(ispath(item_actions))
			set_actions_to(item_actions)
	else if(item_action_name)
		var/datum/action/item_action/created = new(src)
		created.name = item_action_name
		created.check_mobility_flags = item_action_mobility_flags
		set_actions_to(created)

/**
 * setter for [item_actions]
 *
 * accepts:
 *
 * * an instance of /datum/action
 * * a typepath of /datum/action
 * * a list of /datum/action instances and typepaths
 * * null
 */
/obj/item/proc/set_actions_to(descriptor)
	var/mob/get_worn_mob = get_worn_mob()

	if(get_worn_mob)
		unregister_item_actions(get_worn_mob)

	if(ispath(descriptor, /datum/action))
		descriptor = new descriptor(src)
	else if(islist(descriptor))
		var/list/transforming = descriptor:Copy()
		for(var/i in 1 to length(transforming))
			if(ispath(transforming[i], /datum/action))
				var/path = transforming[i]
				transforming[i] = new path(src)
		descriptor = transforming
	else
		item_actions = descriptor

	if(get_worn_mob)
		register_item_actions(get_worn_mob)

/**
 * handles action granting
 */
/obj/item/proc/register_item_actions(mob/user)
	ensure_item_actions_loaded()
	if(islist(item_actions))
		for(var/datum/action/action in item_actions)
			action.grant(user.inventory.actions)
	else if(istype(item_actions, /datum/action))
		var/datum/action/action = item_actions
		action.grant(user.inventory.actions)

/**
 * handles action revoking
 */
/obj/item/proc/unregister_item_actions(mob/user)
	if(islist(item_actions))
		for(var/datum/action/action in item_actions)
			action.revoke(user.inventory.actions)
	else if(istype(item_actions, /datum/action))
		var/datum/action/action = item_actions
		action.revoke(user.inventory.actions)

//* Attack *//

/**
 * grabs an attack verb to use
 *
 * @params
 * * target - thing being attacked
 * * user - person attacking
 *
 * @return attack verb
 */
/obj/item/proc/get_attack_verb(atom/target, mob/user)
	return length(attack_verb)? pick(attack_verb) : attack_verb

/**
 * can be sharp; even if not being used as such
 *
 * @params
 * * strict - require us to be toggled to sharp mode if there's multiple modes of attacking.
 */
/obj/item/proc/is_sharp(strict)
	return (damage_mode & DAMAGE_MODE_SHARP)

/**
 * can be edged; even if not being used as such
 *
 * @params
 * * strict - require us to be toggled to sharp mode if there's multiple modes of attacking.
 */
/obj/item/proc/is_edge(strict)
	return (damage_mode & DAMAGE_MODE_EDGE)

/**
 * can be piercing; even if not being used as such
 *
 * @params
 * * strict - require us to be toggled to sharp mode if there's multiple modes of attacking.
 */
/obj/item/proc/is_pierce(strict)
	return (damage_mode & DAMAGE_MODE_PIERCE)

/**
 * can be shredding; even if not being used as such
 *
 * @params
 * * strict - require us to be toggled to sharp mode if there's multiple modes of attacking.
 */
/obj/item/proc/is_shred(strict)
	return (damage_mode & DAMAGE_MODE_SHRED)

//* Combat *//

/obj/item/proc/load_passive_parry()
	if(!passive_parry)
		return
	passive_parry = resolve_passive_parry_data(passive_parry)
	var/datum/component/passive_parry/loaded = GetComponent(/datum/component/passive_parry)
	if(loaded)
		loaded.parry_data = passive_parry

/obj/item/proc/reload_passive_parry()
	load_passive_parry()

//* Flags *//

/obj/item/proc/set_body_cover_flags(new_body_cover_flags)
	body_cover_flags = new_body_cover_flags
	inv_inside.invalidate_coverage_cache()

//* Interactions *//

/obj/item/attackby(obj/item/I, mob/user, list/params, clickchain_flags, damage_multiplier)
	if(isturf(loc) && I.obj_storage?.allow_mass_gather && I.obj_storage.allow_mass_gather_via_click)
		I.obj_storage.auto_handle_interacted_mass_pickup(new /datum/event_args/actor(user), src)
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
	return ..()

/**
 * Hitsound override when successfully melee attacking someone for melee_hit()
 *
 * We get final say by returning a sound here.
 */
/obj/item/proc/attacksound_override(atom/target, attack_type)
	return

//* Inventory *//

/**
 * Called when someone clisk us on a storage, before the storage handler's
 * 'put item in' runs. Return FALSE to deny.
 */
/obj/item/proc/allow_auto_storage_insert(datum/event_args/actor/actor, datum/object_system/storage/storage)
	return TRUE

/obj/item/proc/on_exit_storage(datum/object_system/storage/storage)
	SEND_SIGNAL(src, COMSIG_STORAGE_EXITED, storage)

/obj/item/proc/on_enter_storage(datum/object_system/storage/storage)
	SEND_SIGNAL(src, COMSIG_STORAGE_ENTERED, storage)

//* Materials *//

/obj/item/material_trait_brittle_shatter()
	var/datum/prototype/material/material = get_primary_material()
	var/turf/T = get_turf(src)
	T.visible_message("<span class='danger'>\The [src] [material.destruction_desc]!</span>")
	// if(istype(loc, /mob/living))
	// 	var/mob/living/M = loc
	// 	if(material.shard_type == SHARD_SHARD) // Wearing glass armor is a bad idea.
	// 		var/obj/item/material/shard/S = material.place_shard(T)
	// 		M.embed(S)

	playsound(src, "shatter", 70, 1)
	qdel(src)

//* Mouse *//

/obj/item/MouseEntered(location, control, params)
	..()
	SEND_SIGNAL(src, COMSIG_ITEM_MOUSE_ENTERED, usr)

/obj/item/MouseExited(location, control, params)
	..()
	SEND_SIGNAL(src, COMSIG_ITEM_MOUSE_EXITED, usr)

//* Rendering *//

/**
 * invokes
 *
 * * update_icon()
 * * update_worn_icon()
 * * update_action_buttons()
 *
 * please be very delicate with this, this is expensive
 */
/obj/item/proc/update_full_icon()
	update_icon()
	update_worn_icon()
	update_action_buttons()

//* Storage *//

/obj/item/proc/get_weight_class()
	return w_class

/obj/item/proc/get_weight_volume()
	return isnull(weight_volume)? global.w_class_to_volume[w_class || WEIGHT_CLASS_GIGANTIC] : weight_volume

/obj/item/proc/set_weight_class(weight_class)
	var/old = w_class
	w_class = weight_class
	loc?.on_contents_weight_class_change(src, old, weight_class)

/obj/item/proc/set_weight_volume(volume)
	var/old = weight_volume
	weight_volume = volume
	loc?.on_contents_weight_volume_change(src, old, volume)

/**
 * called when someone is opening a storage with us in it
 *
 * @return TRUE to stop the storage from opening
 */
/obj/item/proc/on_containing_storage_opening(datum/event_args/actor/actor, datum/object_system/storage/storage)
	return FALSE

//* VV *//

/obj/item/vv_get_var(var_name, resolve)
	switch(var_name)
		if(NAMEOF(src, passive_parry))
			if(resolve)
				load_passive_parry()
	return ..()

/obj/item/vv_edit_var(var_name, var_value, mass_edit, raw_edit)
	switch(var_name)
		if(NAMEOF(src, passive_parry))
			. = ..()
			reload_passive_parry()
		if(NAMEOF(src, item_flags))
			var/requires_update = (item_flags & (ITEM_ENCUMBERS_WHILE_HELD | ITEM_ENCUMBERS_ONLY_HELD)) != (var_value & (ITEM_ENCUMBERS_WHILE_HELD | ITEM_ENCUMBERS_ONLY_HELD))
			. = ..()
			if(. && requires_update)
				var/mob/living/L = get_worn_mob()
				// check, as get_worn_mob() returns /mob, not /living
				if(istype(L))
					L.recalculate_carry()
					L.update_carry()
		if(NAMEOF(src, weight), NAMEOF(src, encumbrance), NAMEOF(src, flat_encumbrance))
			// todo: introspection system update - this should be 'handled', as opposed to hooked.
			. = ..()
			if(. )
				var/mob/living/L = get_worn_mob()
				// check, as get_worn_mob() returns /mob, not /living
				if(istype(L))
					L.update_carry_slowdown()
		if(NAMEOF(src, slowdown))
			. = ..()
			if(.)
				var/mob/living/L = get_worn_mob()
				// check, as get_worn_mob() returns /mob, not /living
				if(istype(L))
					L.update_item_slowdown()
		if(NAMEOF(src, w_class))
			if(!isnum(var_value) && !raw_edit)
				return FALSE
			if((var_value < WEIGHT_CLASS_MIN) || (var_value > WEIGHT_CLASS_MAX))
				return FALSE
			set_weight_class(var_value)
			return TRUE
		if(NAMEOF(src, weight_volume))
			if(!isnum(var_value) && !raw_edit)
				return FALSE
			if(var_value < 0)
				return FALSE
			set_weight_volume(var_value)
			return TRUE
		else
			return ..()
