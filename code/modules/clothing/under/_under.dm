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
	//TFF 5/8/19 - sets /obj/item/clothing/under sensor setting default?
	var/sensor_mode = 3
		/*
		1 = Report living/dead
		2 = Report detailed damages
		3 = Report location
		*/
	var/sensorpref = 5
	var/displays_id = 1

	//! Rolldown Status
	//? Rolldown, sleeve appends are _down, _sleeve respectively.
	/// if true, we assume *all* bodytypes have rolldown states, and to use the new system.
	var/worn_has_rolldown = FALSE
	/// if true, we assume *all* bodytypes have rollsleeve states, and to use the new system.
	var/worn_has_rollsleeve = FALSE
	#warn impl above
	#warn parse below
	var/rolled_down = -1 //0 = unrolled, 1 = rolled, -1 = cannot be toggled
	var/rolled_sleeves = -1 //0 = unrolled, 1 = rolled, -1 = cannot be toggled
	#warn way to have better rolldown/rollsleeve sprites on default rendering holy shit

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

/obj/item/clothing/under/attack_hand(var/mob/user)
	if(LAZYLEN(accessories))
		..()
	if ((ishuman(usr) || issmall(usr)) && src.loc == user)
		return
	..()

/obj/item/clothing/under/Initialize(mapload)
	. = ..()
	var/mob/living/carbon/human/H = loc
	if(snowflake_worn_state)
		if(!item_state_slots)
			item_state_slots = list()
		item_state_slots[SLOT_ID_UNIFORM] = snowflake_worn_state
	else
		snowflake_worn_state = icon_state

	#warn better autodetector
	//autodetect rollability
	if(rolled_down < 0)
		if(("[snowflake_worn_state]_d_s" in icon_states(INV_W_UNIFORM_DEF_ICON)) || ("[snowflake_worn_state]_s" in icon_states(rolled_down_icon)) || ("[snowflake_worn_state]_d_s" in icon_states(icon_override)))
			rolled_down = 0

	if(rolled_down == -1)
		verbs -= /obj/item/clothing/under/verb/rollsuit
	if(rolled_sleeves == -1)
		verbs -= /obj/item/clothing/under/verb/rollsleeves

	//TFF 5/8/19 - define numbers and specifics for suit sensor settings
	sensorpref = isnull(H) ? 1 : (ishuman(H) ? H.sensorpref : 1)
	switch(sensorpref)
		if(1) sensor_mode = 0				//Sensors off
		if(2) sensor_mode = 1				//Sensors on binary
		if(3) sensor_mode = 2				//Sensors display vitals
		if(4) sensor_mode = 3				//Sensors display vitals and enables tracking
		if(5) sensor_mode = pick(0,1,2,3)	//Select a random setting
		else
			sensor_mode = pick(0,1,2,3)
			log_debug("Invalid switch for suit sensors, defaulting to random. [sensorpref] chosen")

//! Rendering
// todo : NUKE THIS SHIT FROM ORBIT ~silicons
//UNIFORM: Always appends "_s" to iconstate, stupidly.
/obj/item/clothing/under/resolve_legacy_state(mob/M, datum/inventory_slot_meta/slot_meta, inhands, bodytype)
	. = ..()
	. += "_s"

/obj/item/clothing/under/base_worn_state(inhands, slot_key, bodytype)
	. = ..()
	if(rolled_down)
		. += "_down"
	else if(rolled_sleeves)
		. += "_sleeves"

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
		rolled_down = -1
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
		rolled_sleeves = -1
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
	#warn random sensors

/obj/item/clothing/under/rank/Initialize(mapload)
	. = ..()
	sensor_mode = pick(0,1,2,3)
