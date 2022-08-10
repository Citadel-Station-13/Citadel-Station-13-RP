//Under clothing
/obj/item/clothing/under
	icon = 'icons/obj/clothing/uniforms.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_uniforms.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_uniforms.dmi',
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

	var/has_sensor = 1 //For the crew computer 2 = unable to change mode
	//TFF 5/8/19 - sets /obj/item/clothing/under sensor setting default?
	var/sensor_mode = 3
		/*
		1 = Report living/dead
		2 = Report detailed damages
		3 = Report location
		*/
	var/sensorpref = 5
	var/displays_id = 1
	var/rolled_down = -1 //0 = unrolled, 1 = rolled, -1 = cannot be toggled
	var/rolled_sleeves = -1 //0 = unrolled, 1 = rolled, -1 = cannot be toggled
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/mob/clothing/species/teshari/uniform.dmi',
		SPECIES_VOX = 'icons/mob/clothing/species/vox/uniform.dmi',
		SPECIES_WEREBEAST = 'icons/mob/clothing/species/werebeast/uniform.dmi')

	//convenience var for defining the icon state for the overlay used when the clothing is worn.
	//Also used by rolling/unrolling.
	var/worn_state = null
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
	if(worn_state)
		if(!item_state_slots)
			item_state_slots = list()
		item_state_slots[SLOT_ID_UNIFORM] = worn_state
	else
		worn_state = icon_state

	//autodetect rollability
	if(rolled_down < 0)
		if(("[worn_state]_d_s" in icon_states(INV_W_UNIFORM_DEF_ICON)) || ("[worn_state]_s" in icon_states(rolled_down_icon)) || ("[worn_state]_d_s" in icon_states(icon_override)))
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

/obj/item/clothing/under/proc/update_rolldown_status()
	var/mob/living/carbon/human/H
	if(istype(src.loc, /mob/living/carbon/human))
		H = src.loc

	var/icon/under_icon
	if(icon_override)
		under_icon = icon_override
	else if(H && sprite_sheets && sprite_sheets[H.species.get_worn_legacy_bodytype(H)])
		under_icon = sprite_sheets[H.species.get_worn_legacy_bodytype(H)]
	else if(item_icons && item_icons[SLOT_ID_UNIFORM])
		under_icon = item_icons[SLOT_ID_UNIFORM]
	else if ("[worn_state]_s" in icon_states(rolled_down_icon))
		under_icon = rolled_down_icon
	else
		under_icon = INV_W_UNIFORM_DEF_ICON

	// The _s is because the icon update procs append it.
	if((under_icon == rolled_down_icon && ("[worn_state]_s" in icon_states(under_icon))) || ("[worn_state]_d_s" in icon_states(under_icon)))
		if(rolled_down != 1)
			rolled_down = 0
	else
		rolled_down = -1
	if(H) update_worn_icon()

/obj/item/clothing/under/proc/update_rollsleeves_status()
	var/mob/living/carbon/human/H
	if(istype(src.loc, /mob/living/carbon/human))
		H = src.loc

	var/icon/under_icon
	if(icon_override)
		under_icon = icon_override
	else if(H && sprite_sheets && sprite_sheets[H.species.get_worn_legacy_bodytype(H)])
		under_icon = sprite_sheets[H.species.get_worn_legacy_bodytype(H)]
	else if(item_icons && item_icons[SLOT_ID_UNIFORM])
		under_icon = item_icons[SLOT_ID_UNIFORM]
	else if ("[worn_state]_s" in icon_states(rolled_down_sleeves_icon))
		under_icon = rolled_down_sleeves_icon
	else
		under_icon = INV_W_UNIFORM_DEF_ICON

	// The _s is because the icon update procs append it.
	if((under_icon == rolled_down_sleeves_icon && ("[worn_state]_s" in icon_states(under_icon))) || ("[worn_state]_r_s" in icon_states(under_icon)))
		if(rolled_sleeves != 1)
			rolled_sleeves = 0
	else
		rolled_sleeves = -1
	if(H) update_worn_icon()

/obj/item/clothing/under/examine(mob/user)
	. = ..()
	switch(src.sensor_mode)
		if(0)
			. += "Its sensors appear to be disabled."
		if(1)
			. += "Its binary life sensors appear to be enabled."
		if(2)
			. += "Its vital tracker appears to be enabled."
		if(3)
			. += "Its vital tracker and tracking beacon appear to be enabled."

/obj/item/clothing/under/proc/set_sensors(mob/usr as mob)
	var/mob/M = usr
	if (istype(M, /mob/observer)) return
	if (usr.stat || usr.restrained()) return
	if(has_sensor >= 2)
		to_chat(usr, "The controls are locked.")
		return 0
	if(has_sensor <= 0)
		to_chat(usr, "This suit does not have any sensors.")
		return 0

	var/list/modes = list("Off", "Binary sensors", "Vitals tracker", "Tracking beacon")
	var/switchMode = input("Select a sensor mode:", "Suit Sensor Mode", modes[sensor_mode + 1]) in modes
	if(get_dist(usr, src) > 1)
		to_chat(usr, "You have moved too far away.")
		return
	sensor_mode = modes.Find(switchMode) - 1

	if (src.loc == usr)
		switch(sensor_mode)
			if(0)
				usr.visible_message("[usr] adjusts their sensors.", "You disable your suit's remote sensing equipment.")
			if(1)
				usr.visible_message("[usr] adjusts their sensors.", "Your suit will now report whether you are live or dead.")
			if(2)
				usr.visible_message("[usr] adjusts their sensors.", "Your suit will now report your vital lifesigns.")
			if(3)
				usr.visible_message("[usr] adjusts their sensors.", "Your suit will now report your vital lifesigns as well as your coordinate position.")

	else if (istype(src.loc, /mob))
		usr.visible_message("[usr] adjusts [src.loc]'s sensors.", "You adjust [src.loc]'s sensors.")

/obj/item/clothing/under/verb/toggle()
	set name = "Toggle Suit Sensors"
	set category = "Object"
	set src in usr
	set_sensors(usr)

/obj/item/clothing/under/verb/rollsuit()
	set name = "Roll Jumpsuit"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

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
		if("[worn_state]_s" in icon_states(rolled_down_icon))
			icon_override = rolled_down_icon
			item_state_slots[SLOT_ID_UNIFORM] = "[worn_state]"
		else
			item_state_slots[SLOT_ID_UNIFORM] = "[worn_state]_d"

		to_chat(usr, "<span class='notice'>You roll your [src].</span>")
	else
		body_parts_covered = initial(body_parts_covered)
		if(icon_override == rolled_down_icon)
			icon_override = initial(icon_override)
		item_state_slots[SLOT_ID_UNIFORM] = "[worn_state]"
		to_chat(usr, "<span class='notice'>You unroll your [src].</span>")
	update_worn_icon()

/obj/item/clothing/under/verb/rollsleeves()
	set name = "Roll Up Sleeves"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

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
		if("[worn_state]_s" in icon_states(rolled_down_sleeves_icon))
			icon_override = rolled_down_sleeves_icon
			item_state_slots[SLOT_ID_UNIFORM] = "[worn_state]"
		else
			item_state_slots[SLOT_ID_UNIFORM] = "[worn_state]_r"
		to_chat(usr, "<span class='notice'>You roll up your [src]'s sleeves.</span>")
	else
		body_parts_covered = initial(body_parts_covered)
		if(icon_override == rolled_down_sleeves_icon)
			icon_override = initial(icon_override)
		item_state_slots[SLOT_ID_UNIFORM] = "[worn_state]"
		to_chat(usr, "<span class='notice'>You roll down your [src]'s sleeves.</span>")
	update_worn_icon()

/obj/item/clothing/under/rank/Initialize(mapload)
	. = ..()
	sensor_mode = pick(0,1,2,3)
