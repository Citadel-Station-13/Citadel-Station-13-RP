//Under clothing
/obj/item/clothing/under
	icon = 'icons/obj/clothing/uniforms.dmi'
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_uniforms.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_uniforms.dmi',
		)
	name = "under"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	permeability_coefficient = 0.90
	slot_flags = SLOT_ICLOTHING
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	equip_sound = 'sound/items/jumpsuit_equip.ogg'
	w_class = ITEMSIZE_NORMAL
	show_messages = 1
	blood_sprite_state = "uniformblood"

	//! Suit Sensors
	/// do we have suit sensors?
	var/has_sensors = UNIFORM_HAS_SUIT_SENSORS
	/// suit sensor mode
	var/sensor_mode = SUIT_SENSOR_OFF

	var/displays_id = 1

	//! Rolldown Status
	//? Rolldown, sleeve appends are _down, _sleeve respectively.
	//? AUTODETECT ONLY WORKS FOR SHARED SPRITES.
	//? If you are using new rendering, you must NOT use autodetection.
	//? Read the procs for these in the rendering section to know why.
	/// if true, we assume *all* bodytypes have rolldown states, and to use the new system.
	var/worn_has_rolldown = UNIFORM_AUTODETECT_ROLL
	/// if true, we assume *all* bodytypes have rollsleeve states, and to use the new system.
	var/worn_has_rollsleeve = UNIFORM_AUTODETECT_ROLL
	/// these bodytypes have rolldown if not autodetecting
	var/worn_rolldown_bodytypes = ALL
	/// these bodytypes have rollsleeve if not autodetecting
	var/worn_rollsleeve_bodytypes = ALL
	/// rolldown status
	var/worn_rolled_down = UNIFORM_ROLL_NULLED
	/// rollsleeve status
	var/worn_rolled_sleeves = UNIFORM_ROLL_NULLED

	// todo: unify this iwth worn state, probably by converting the system used to do this
	// todo: awful shit.
	//convenience var for defining the icon state for the overlay used when the clothing is worn.
	//Also used by rolling/unrolling.
	var/snowflake_worn_state = null
	valid_accessory_slots = (\
		ACCESSORY_SLOT_UTILITY\
		|ACCESSORY_SLOT_WEAPON\
		|ACCESSORY_SLOT_ARMBAND\
		|ACCESSORY_SLOT_DECOR\
		|ACCESSORY_SLOT_MEDAL\
		|ACCESSORY_SLOT_INSIGNIA\
		|ACCESSORY_SLOT_TIE\
		|ACCESSORY_SLOT_OVER)
	restricted_accessory_slots = (\
		ACCESSORY_SLOT_UTILITY\
		|ACCESSORY_SLOT_WEAPON\
		|ACCESSORY_SLOT_ARMBAND\
		|ACCESSORY_SLOT_TIE\
		|ACCESSORY_SLOT_OVER)

	var/icon/rolled_down_icon = 'icons/mob/clothing/uniform_rolled_down.dmi'
	var/icon/rolled_down_sleeves_icon = 'icons/mob/clothing/uniform_sleeves_rolled.dmi'

// todo kick to item flag for auto-unequip-without-clickdrag
/obj/item/clothing/under/attack_hand(var/mob/user)
	if(LAZYLEN(accessories))
		..()
	if ((ishuman(usr) || issmall(usr)) && src.loc == user)
		return
	..()

/obj/item/clothing/under/Initialize(mapload)
	. = ..()
	// for NOW, we need to autoset if null.
	// todo: remove this lol
	if(isnull(snowflake_worn_state))
		snowflake_worn_state = item_state_slots?[SLOT_ID_UNIFORM] || item_state || icon_state
	var/mob/living/carbon/human/H = loc
	init_sensors(istype(H)? H : null)

/obj/item/clothing/under/proc/init_sensors(mob/living/carbon/human/H)
	if(H)
		switch(H.sensorpref)
			if(1) sensor_mode = SUIT_SENSOR_OFF				//Sensors off
			if(2) sensor_mode = SUIT_SENSOR_BINARY				//Sensors on binary
			if(3) sensor_mode = SUIT_SENSOR_VITAL				//Sensors display vitals
			if(4) sensor_mode = SUIT_SENSOR_TRACKING				//Sensors display vitals and enables tracking
			else
				sensor_mode = pick(SUIT_SENSOR_OFF, SUIT_SENSOR_BINARY, SUIT_SENSOR_VITAL, SUIT_SENSOR_TRACKING)	//Select a random setting
	else
		sensor_mode = SUIT_SENSOR_OFF

//! Inventory
/obj/item/clothing/under/pickup(mob/user, flags, atom/oldLoc)
	. = ..()
	// since updating is now semi-cheap, update immediately
	update_rolldown()
	update_rollsleeve()

//! Rendering
// todo : NUKE THIS SHIT FROM ORBIT ~silicons
//UNIFORM: Always appends "_s" to iconstate, stupidly.
/obj/item/clothing/under/resolve_legacy_state(mob/M, datum/inventory_slot_meta/slot_meta, inhands, bodytype)
	if(snowflake_worn_state && (slot_meta.id == SLOT_ID_UNIFORM))
		return snowflake_worn_state + "_s"
	return ..()

/obj/item/clothing/under/base_worn_state(inhands, slot_key, bodytype)
	. = ..()
	if(worn_rolled_down == UNIFORM_ROLL_TRUE)
		. += "_down"
	else if(worn_rolled_sleeves == UNIFORM_ROLL_TRUE)
		. += "_sleeves"

/obj/item/clothing/under/proc/update_rolldown(updating)
	var/has_roll
	var/detected_bodytype = BODYTYPE_DEFAULT
	var/mob/living/carbon/human/H = worn_mob()
	if(istype(H))
		detected_bodytype = H.species.get_effective_bodytype(H, src, worn_slot)
	switch(worn_has_rolldown)
		if(UNIFORM_HAS_ROLL)
			has_roll = (worn_rolldown_bodytypes & detected_bodytype)
		if(UNIFORM_HAS_NO_ROLL)
			has_roll = FALSE
		if(UNIFORM_AUTODETECT_ROLL)
			has_roll = autodetect_rolldown(detected_bodytype)

	if(!has_roll)
		verbs -= /obj/item/clothing/under/verb/rollsuit
		worn_rolled_down = UNIFORM_ROLL_NULLED
	else
		verbs |= /obj/item/clothing/under/verb/rollsuit
		if(worn_rolled_down == UNIFORM_ROLL_NULLED)
			worn_rolled_down = UNIFORM_ROLL_FALSE
	if(!updating)
		update_worn_icon()

/obj/item/clothing/under/proc/update_rollsleeve(updating)
	var/has_sleeves
	var/detected_bodytype = BODYTYPE_DEFAULT
	var/mob/living/carbon/human/H = worn_mob()
	if(istype(H))
		detected_bodytype = H.species.get_effective_bodytype(H, src, worn_slot)
	switch(worn_has_rollsleeve)
		if(UNIFORM_HAS_ROLL)
			has_sleeves = (worn_rollsleeve_bodytypes & detected_bodytype)
		if(UNIFORM_HAS_NO_ROLL)
			has_sleeves = FALSE
		if(UNIFORM_AUTODETECT_ROLL)
			has_sleeves  = autodetect_rollsleeve(detected_bodytype)

	if(!has_sleeves)
		verbs -= /obj/item/clothing/under/verb/rollsleeves
		worn_rolled_sleeves = UNIFORM_ROLL_NULLED
	else
		verbs |= /obj/item/clothing/under/verb/rollsleeves
		if(worn_rolled_sleeves == UNIFORM_ROLL_NULLED)
			worn_rolled_sleeves = UNIFORM_ROLL_FALSE
	if(!updating)
		update_worn_icon()

/obj/item/clothing/under/proc/autodetect_rolldown(bodytype)
	var/datum/inventory_slot_meta/inventory/uniform/wow_this_sucks = resolve_inventory_slot_meta(SLOT_ID_UNIFORM)
	return wow_this_sucks.check_rolldown_cache(bodytype, resolve_legacy_state(null, wow_this_sucks, FALSE, bodytype))

/obj/item/clothing/under/proc/autodetect_rollsleeve(bodytype)
	var/datum/inventory_slot_meta/inventory/uniform/wow_this_sucks = resolve_inventory_slot_meta(SLOT_ID_UNIFORM)
	return wow_this_sucks.check_rollsleeve_cache(bodytype, resolve_legacy_state(null, wow_this_sucks, FALSE, bodytype))

/obj/item/clothing/under/verb/rollsuit()
	set name = "Roll Jumpsuit"
	set category = "Object"
	set src in usr

	var/mob/user = usr
	// todo: mobility flags
	if(!istype(user, /mob/living)) return
	if(user.stat) return

	update_rolldown(TRUE)

	switch(worn_rolled_down)
		if(UNIFORM_ROLL_NULLED)
			to_chat(user, SPAN_NOTICE("[src] cannot be rolled down."))
			return
		if(UNIFORM_ROLL_FALSE)
			worn_rolled_down = UNIFORM_ROLL_TRUE
			// todo: update_bodypart_coverage() for clothing damage
			body_parts_covered &= ~(UPPER_TORSO | ARMS)
			to_chat(user, SPAN_NOTICE("You roll [src] down."))
		if(UNIFORM_ROLL_TRUE)
			worn_rolled_down = UNIFORM_ROLL_FALSE
			// todo: update_bodypart_coverage() for clothing damage
			body_parts_covered = initial(body_parts_covered)
			to_chat(user, SPAN_NOTICE("You roll [src] up."))

	update_worn_icon()

/obj/item/clothing/under/verb/rollsleeves()
	set name = "Roll Up Sleeves"
	set category = "Object"
	set src in usr

	var/mob/user = usr
	// todo: mobility flags
	if(!istype(user, /mob/living)) return
	if(user.stat) return

	update_rollsleeve(TRUE)

	switch(worn_rolled_sleeves)
		if(UNIFORM_ROLL_NULLED)
			to_chat(user, SPAN_NOTICE("[src] cannot have its sleeves rolled."))
			return
		if(UNIFORM_ROLL_FALSE)
			worn_rolled_sleeves = UNIFORM_ROLL_TRUE
			// todo: update_bodypart_coverage() for clothing damage
			body_parts_covered &= ~(ARMS)
			to_chat(user, SPAN_NOTICE("You roll [src]'s sleeves up."))
		if(UNIFORM_ROLL_TRUE)
			worn_rolled_sleeves = UNIFORM_ROLL_FALSE
			// todo: update_bodypart_coverage() for clothing damage
			body_parts_covered = initial(body_parts_covered)
			to_chat(user, SPAN_NOTICE("You roll [src]'s sleeves back down."))

	update_worn_icon()

//! Examine
/obj/item/clothing/under/examine(mob/user)
	. = ..()
	switch(sensor_mode)
		if(0)
			. += "Its sensors appear to be disabled."
		if(1)
			. += "Its binary life sensors appear to be enabled."
		if(2)
			. += "Its vital tracker appears to be enabled."
		if(3)
			. += "Its vital tracker and tracking beacon appear to be enabled."

//! Suit Sensors
/obj/item/clothing/under/proc/set_sensors(mob/user)
	if (istype(user, /mob/observer))
		return FALSE
	if (user.stat || user.restrained())
		return FALSE
	switch(has_sensors)
		if(UNIFORM_HAS_LOCKED_SENSORS)
			to_chat(user, "The controls are locked.")
			return FALSE
		if(UNIFORM_HAS_NO_SENSORS)
			to_chat(user, "This suit does not have any sensors.")
			return FALSE

	var/list/modes = list("Off", "Binary sensors", "Vitals tracker", "Tracking beacon")
	var/switchMode = input(user, "Select a sensor mode:", "Suit Sensor Mode", modes[sensor_mode + 1]) in modes
	if(get_dist(user, src) > 1)
		to_chat(user, "You have moved too far away.")
		return
	sensor_mode = modes.Find(switchMode) - 1

	if (loc == user)
		switch(sensor_mode)
			if(SUIT_SENSOR_OFF)
				user.visible_message("[user] adjusts their sensors.", "You disable your suit's remote sensing equipment.")
			if(SUIT_SENSOR_BINARY)
				user.visible_message("[user] adjusts their sensors.", "Your suit will now report whether you are live or dead.")
			if(SUIT_SENSOR_VITAL)
				user.visible_message("[user] adjusts their sensors.", "Your suit will now report your vital lifesigns.")
			if(SUIT_SENSOR_TRACKING)
				user.visible_message("[user] adjusts their sensors.", "Your suit will now report your vital lifesigns as well as your coordinate position.")

	else if (istype(loc, /mob))
		user.visible_message("[user] adjusts [loc]'s sensors.", "You adjust [loc]'s sensors.")

/obj/item/clothing/under/verb/toggle()
	set name = "Toggle Suit Sensors"
	set category = "Object"
	set src in usr
	set_sensors(usr)

//! Strip Menu
/obj/item/clothing/under/strip_menu_options(mob/user)
	. = ..()
	.["sensors"] = "Set Suit Sensors"

/obj/item/clothing/under/strip_menu_act(mob/user, action)
	. = ..()
	switch(action)
		if("sensors")
			visible_message(
				SPAN_WARNING("[user] is trying to set \the [src]'s sensors!"),
				SPAN_WARNING("[user] is trying to set your sensors!")
			)
			var/mob/M = worn_mob()
			if(do_after(user, HUMAN_STRIP_DELAY, M, FALSE))
				. = strip_menu_sensor_interact(user, M)

/obj/item/clothing/under/proc/strip_menu_sensor_interact(mob/user, mob/wearer = worn_mob())
	add_attack_logs(user, wearer, "Adjusted suit sensor level")
	set_sensors(user)

/obj/item/clothing/under/rank

/obj/item/clothing/under/rank/init_sensors(mob/living/carbon/human/H)
	if(!H)
		sensor_mode = pick(SUIT_SENSOR_OFF, SUIT_SENSOR_BINARY, SUIT_SENSOR_VITAL, SUIT_SENSOR_TRACKING)	//Select a random setting
	return ..()
