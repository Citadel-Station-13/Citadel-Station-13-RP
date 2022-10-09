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
	init_sensors(istype(H)? H : null)

/obj/item/clothing/under/proc/init_sensors(mob/living/carbon/human/H)
	if(H)
		switch(H.sensorpref)
			if(1) sensor_mode = SUIT_SENSOR_OFF				//Sensors off
			if(2) sensor_mode = SUIT_SENSOR_BINARY				//Sensors on binary
			if(3) sensor_mode = SUIT_SENSOR_VITAL				//Sensors display vitals
			if(4) sensor_mode = SUIT_SENSOR_TRACKING				//Sensors display vitals and enables tracking
			else
				sensor_mode = pick(
					SUIT_SENSOR_OFF,
					SUIT_SENSOR_BINARY,
					SUIT_SENSOR_VITAL,
					SUIT_SENSOR_TRACKING
				)	//Select a random setting
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

/obj/item/clothing/under/proc/update_rolldown()
	var/has_roll
	var/detected_bodytype = BODYTYPE_DEFAULT
	var/mob/living/carbon/human/H = worn_mob()
	if(istype(H))
		detected_bodytype = H.species.get_effective_bodytype(src, worn_slot)
	switch(worn_has_rolldown)
		if(UNIFORM_HAS_ROLL)
			has_roll = (worn_rolldown_bodytypes & detected_bodytype)
		if(UNIFORM_HAS_NO_ROLL)
			has_roll = FALSE
		if(UNIFORM_AUTODETECT_ROLL)

	if(!has_roll)
		verbs -= /obj/item/clothing/under/verb/rollsuit
		return
	verbs |= /obj/item/clothing/under/verb/rollsuit

/obj/item/clothing/under/proc/update_rollsleeve()
	var/has_sleeves
	var/detected_bodytype = BODYTYPE_DEFAULT
	var/mob/living/carbon/human/H = worn_mob()
	if(istype(H))
		detected_bodytype = H.species.get_effective_bodytype(src, worn_slot)
	switch(worn_has_rollsleeve)
		if(UNIFORM_HAS_ROLL)
			has_sleeves = (worn_rollsleeve_bodytypes & detected_bodytype)
		if(UNIFORM_HAS_NO_ROLL)
			has_sleeves = FALSE
		if(UNIFORM_AUTODETECT_ROLL)

	if(!has_sleeves)
		verbs -= /obj/item/clothing/under/verb/rollsleeves
		return
	verbs |= /obj/item/clothing/under/verb/rollsleeves

#warn autodetect
/*
	#warn better autodetector
	//autodetect rollability

	if(rolled_down < 0)
		if(("[snowflake_worn_state]_d_s" in icon_states(INV_W_UNIFORM_DEF_ICON)) || ("[snowflake_worn_state]_s" in icon_states(rolled_down_icon)) || ("[snowflake_worn_state]_d_s" in icon_states(icon_override)))
			rolled_down = 0

	if(rolled_down == -1)
		verbs -= /obj/item/clothing/under/verb/rollsuit
	if(rolled_sleeves == -1)
		verbs -= /obj/item/clothing/under/verb/rollsleeves
*/

/obj/item/clothing/under/proc/update_rolldown_status()
	var/mob/living/carbon/human/H = ishuman(loc)? loc : null
	var/icon/under_icon = resolve_worn_assets(H, SLOT_ID_UNIFORM, FALSE, H?.species?.get_effective_bodytype(src, SLOT_ID_UNIFORM))[1]
	#warn fix
	// if(icon_override)
	// 	under_icon = icon_override
	// else if(H && sprite_sheets && sprite_sheets[H.species.get_worn_legacy_bodytype(H)])
	// 	under_icon = sprite_sheets[H.species.get_worn_legacy_bodytype(H)]
	// else if(item_icons && item_icons[SLOT_ID_UNIFORM])
	// 	under_icon = item_icons[SLOT_ID_UNIFORM]
	// else if ("[snowflake_worn_state]_s" in icon_states(rolled_down_icon))
	// 	under_icon = rolled_down_icon
	// else
	// 	under_icon = INV_W_UNIFORM_DEF_ICON

	// The _s is because the icon update procs append it.
	if((under_icon == rolled_down_icon && ("[snowflake_worn_state]_s" in icon_states(under_icon))) || ("[snowflake_worn_state]_d_s" in icon_states(under_icon)))
		if(rolled_down != 1)
			rolled_down = 0
	else
		worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	if(H)
		update_worn_icon()

/obj/item/clothing/under/proc/update_rollsleeves_status()
	var/mob/living/carbon/human/H
	if(istype(src.loc, /mob/living/carbon/human))
		H = src.loc

	var/icon/under_icon = resolve_worn_assets(H, SLOT_ID_UNIFORM, FALSE, H?.species?.get_effective_bodytype(src, SLOT_ID_UNIFORM))[1]
	#warn fix
	// var/icon/under_icon = resolve_worn_assets()
	// if(icon_override)
	// 	under_icon = icon_override
	// else if(H && sprite_sheets && sprite_sheets[H.species.get_worn_legacy_bodytype(H)])
	// 	under_icon = sprite_sheets[H.species.get_worn_legacy_bodytype(H)]
	// else if(item_icons && item_icons[SLOT_ID_UNIFORM])
	// 	under_icon = item_icons[SLOT_ID_UNIFORM]
	// else if ("[snowflake_worn_state]_s" in icon_states(rolled_down_sleeves_icon))
	// 	under_icon = rolled_down_sleeves_icon
	// else
	// 	under_icon = INV_W_UNIFORM_DEF_ICON

	// The _s is because the icon update procs append it.
	if((under_icon == rolled_down_sleeves_icon && ("[snowflake_worn_state]_s" in icon_states(under_icon))) || ("[snowflake_worn_state]_r_s" in icon_states(under_icon)))
		if(rolled_sleeves != 1)
			rolled_sleeves = 0
	else
		worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	if(H)
		update_worn_icon()

/obj/item/clothing/under/verb/rollsuit()
	set name = "Roll Jumpsuit"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	#warn better detector
	update_rolldown_status()
	if(rolled_down == -1)
		to_chat(usr, "<span class='notice'>You cannot roll down [src]!</span>")
		return
	if((rolled_sleeves == 1) && !(rolled_down))
		rolled_sleeves = 0

	rolled_down = !rolled_down
	if(rolled_down)
		body_parts_covered = initial(body_parts_covered)
		body_parts_covered &= ~(UPPER_TORSO|ARMS)
		if("[snowflake_worn_state]_s" in icon_states(rolled_down_icon))
			icon_override = rolled_down_icon
			item_state_slots[SLOT_ID_UNIFORM] = "[snowflake_worn_state]"
		else
			item_state_slots[SLOT_ID_UNIFORM] = "[snowflake_worn_state]_d"

		to_chat(usr, "<span class='notice'>You roll your [src].</span>")
	else
		body_parts_covered = initial(body_parts_covered)
		if(icon_override == rolled_down_icon)
			icon_override = initial(icon_override)
		item_state_slots[SLOT_ID_UNIFORM] = "[snowflake_worn_state]"
		to_chat(usr, "<span class='notice'>You unroll your [src].</span>")
	update_worn_icon()

/obj/item/clothing/under/verb/rollsleeves()
	set name = "Roll Up Sleeves"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	#warn better detector
	update_rollsleeves_status()
	if(rolled_sleeves == -1)
		to_chat(usr, "<span class='notice'>You cannot roll up your [src]'s sleeves!</span>")
		return
	if(rolled_down == 1)
		to_chat(usr, "<span class='notice'>You must roll up your [src] first!</span>")
		return

	rolled_sleeves = !rolled_sleeves
	if(rolled_sleeves)
		body_parts_covered &= ~(ARMS)
		if("[snowflake_worn_state]_s" in icon_states(rolled_down_sleeves_icon))
			icon_override = rolled_down_sleeves_icon
			item_state_slots[SLOT_ID_UNIFORM] = "[snowflake_worn_state]"
		else
			item_state_slots[SLOT_ID_UNIFORM] = "[snowflake_worn_state]_r"
		to_chat(usr, "<span class='notice'>You roll up your [src]'s sleeves.</span>")
	else
		body_parts_covered = initial(body_parts_covered)
		if(icon_override == rolled_down_sleeves_icon)
			icon_override = initial(icon_override)
		item_state_slots[SLOT_ID_UNIFORM] = "[snowflake_worn_state]"
		to_chat(usr, "<span class='notice'>You roll down your [src]'s sleeves.</span>")
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
		sensor_mode = pick(
			SUIT_SENSOR_OFF,
			SUIT_SENSOR_BINARY,
			SUIT_SENSOR_VITAL,
			SUIT_SENSOR_TRACKING
		)	//Select a random setting
	return ..()
