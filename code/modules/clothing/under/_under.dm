//Under clothing
/obj/item/clothing/under
	icon = 'icons/obj/clothing/uniforms.dmi'
	inhand_default_type = INHAND_DEFAULT_ICON_UNIFORMS
	name = "under"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	permeability_coefficient = 0.90
	slot_flags = SLOT_ICLOTHING
	armor_type = /datum/armor/none
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
	var/datum/bodytypes/worn_rolldown_bodytypes = BODYTYPES_ALL
	/// these bodytypes have rollsleeve if not autodetecting
	var/datum/bodytypes/worn_rollsleeve_bodytypes = BODYTYPES_ALL
	/// rolldown status
	var/worn_rolled_down = UNIFORM_ROLL_NULLED
	/// rollsleeve status
	var/worn_rolled_sleeves = UNIFORM_ROLL_NULLED
	/// rolldown state override - applies to new rendering, will replace worn_state as well as icon_state.
	var/worn_rolldown_state
	/// rollsleeve state override - applies to new rendering, will replace worn_state as well as icon_state.
	var/worn_rollsleeve_state

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
/obj/item/clothing/under/attack_hand(mob/user, list/params)
	if(LAZYLEN(accessories))
		..()
	if ((ishuman(usr) || issmall(usr)) && src.loc == user)
		return
	..()

/obj/item/clothing/under/Initialize(mapload)
	. = ..()
	CONSTRUCT_BODYTYPES(worn_rolldown_bodytypes)
	CONSTRUCT_BODYTYPES(worn_rollsleeve_bodytypes)
	// for NOW, we need to autoset if null.
	// todo: remove this lol
	if(isnull(snowflake_worn_state))
		snowflake_worn_state = item_state_slots?[SLOT_ID_UNIFORM] || item_state || icon_state
	addtimer(CALLBACK(src, PROC_REF(init_sensors)), 0)



/obj/item/clothing/under/proc/init_sensors()
	var/mob/living/carbon/human/H = loc
	if(!istype(H))
		return
	if(has_sensors == UNIFORM_HAS_LOCKED_SENSORS)
		return
	if(istype(H))
		switch(H.sensorpref)
			if(1) sensor_mode = SUIT_SENSOR_OFF				//Sensors off
			if(2) sensor_mode = SUIT_SENSOR_BINARY				//Sensors on binary
			if(3) sensor_mode = SUIT_SENSOR_VITAL				//Sensors display vitals
			if(4) sensor_mode = SUIT_SENSOR_TRACKING				//Sensors display vitals and enables tracking
			else
				sensor_mode = pick(SUIT_SENSOR_OFF, SUIT_SENSOR_BINARY, SUIT_SENSOR_VITAL, SUIT_SENSOR_TRACKING)	//Select a random setting
	else
		sensor_mode = SUIT_SENSOR_OFF

//? Styles

/obj/item/clothing/under/available_styles(mob/user)
	. = list()
	var/old_roll = worn_rolled_down
	var/old_sleeves = worn_rolled_sleeves
	worn_rolled_down = UNIFORM_ROLL_FALSE
	worn_rolled_sleeves = UNIFORM_ROLL_FALSE
	.["normal"] = render_mob_appearance(user, SLOT_ID_UNIFORM)
	if(old_roll != UNIFORM_ROLL_NULLED)
		worn_rolled_down = UNIFORM_ROLL_TRUE
		.["rolled down"] = render_mob_appearance(user, SLOT_ID_UNIFORM)
		worn_rolled_down = UNIFORM_ROLL_FALSE
	if(old_sleeves != UNIFORM_ROLL_NULLED)
		worn_rolled_sleeves = UNIFORM_ROLL_TRUE
		.["rolled sleeves"] = render_mob_appearance(user, SLOT_ID_UNIFORM)
		worn_rolled_sleeves = UNIFORM_ROLL_FALSE
	worn_rolled_down = old_roll
	worn_rolled_sleeves = old_sleeves

/obj/item/clothing/under/set_style(style, mob/user)
	. = ..()
	if(.)
		return
	switch(style)
		if("normal")
			worn_rolled_down = UNIFORM_ROLL_FALSE
			worn_rolled_sleeves = UNIFORM_ROLL_FALSE
			body_cover_flags = initial(body_cover_flags)
			update_worn_icon()
			to_chat(user, SPAN_NOTICE("You roll [src] back to normal."))
			return TRUE
		if("rolled down")
			worn_rolled_down = UNIFORM_ROLL_TRUE
			worn_rolled_sleeves = UNIFORM_ROLL_FALSE
			body_cover_flags = (initial(body_cover_flags) & ~(UPPER_TORSO | ARMS | HANDS))
			update_worn_icon()
			to_chat(user, SPAN_NOTICE("You roll [src] down."))
			return TRUE
		if("rolled sleeves")
			worn_rolled_down = UNIFORM_ROLL_FALSE
			worn_rolled_sleeves = UNIFORM_ROLL_TRUE
			body_cover_flags = (initial(body_cover_flags) & ~(ARMS | HANDS))
			update_worn_icon()
			to_chat(user, SPAN_NOTICE("You roll [src]'s sleeves."))
			return TRUE

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
		if(worn_rolldown_state)
			return worn_rolldown_state
		. += "_down"
	else if(worn_rolled_sleeves == UNIFORM_ROLL_TRUE)
		if(worn_rollsleeve_state)
			return worn_rollsleeve_state
		. += "_sleeves"

/obj/item/clothing/under/proc/update_rolldown(updating)
	var/has_roll
	var/detected_bodytype = BODYTYPE_DEFAULT
	var/mob/living/carbon/human/H = worn_mob()
	if(istype(H))
		detected_bodytype = H.species.get_effective_bodytype(H, src, worn_slot)
	switch(worn_has_rolldown)
		if(UNIFORM_HAS_ROLL)
			has_roll = CHECK_BODYTYPE(worn_rolldown_bodytypes, detected_bodytype)
		if(UNIFORM_HAS_NO_ROLL)
			has_roll = FALSE
		if(UNIFORM_AUTODETECT_ROLL)
			has_roll = autodetect_rolldown(detected_bodytype)

	if(!has_roll)
		worn_rolled_down = UNIFORM_ROLL_NULLED
	else
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
			has_sleeves = CHECK_BODYTYPE(worn_rollsleeve_bodytypes, detected_bodytype)
		if(UNIFORM_HAS_NO_ROLL)
			has_sleeves = FALSE
		if(UNIFORM_AUTODETECT_ROLL)
			has_sleeves = autodetect_rollsleeve(detected_bodytype)

	if(!has_sleeves)
		worn_rolled_sleeves = UNIFORM_ROLL_NULLED
	else
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

//! Examine
/obj/item/clothing/under/examine(mob/user, dist)
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
			if(do_after(user, HUMAN_STRIP_DELAY, M, DO_AFTER_IGNORE_ACTIVE_ITEM))
				. = strip_menu_sensor_interact(user, M)

/obj/item/clothing/under/proc/strip_menu_sensor_interact(mob/user, mob/wearer = worn_mob())
	add_attack_logs(user, wearer, "Adjusted suit sensor level")
	set_sensors(user)

/obj/item/clothing/under/rank

/obj/item/clothing/under/rank/init_sensors(mob/living/carbon/human/H)
	if(!H)
		sensor_mode = pick(SUIT_SENSOR_OFF, SUIT_SENSOR_BINARY, SUIT_SENSOR_VITAL, SUIT_SENSOR_TRACKING)	//Select a random setting
	return ..()
