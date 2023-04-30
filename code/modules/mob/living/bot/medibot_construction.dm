/**
 *! Medibot Assembly
 */
/obj/item/bot_assembly/medibot
	name = "incomplete medibot assembly"
	desc = "A first aid kit with a robot arm permanently grafted to it."
	icon = 'icons/obj/bots/medibots.dmi'
	icon_state = "medibot"
	base_icon_state = "medkit"
	w_class = ITEMSIZE_NORMAL
	created_name = "Medibot" // To preserve the name if it's a unique medibot I guess.

	var/healthanalyzer = /obj/item/healthanalyzer
	var/firstaid = /obj/item/storage/firstaid


/obj/item/bot_assembly/medibot/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/item/bot_assembly/medibot/LateInitialize()
	. = ..()
	update_appearance()

/obj/item/bot_assembly/medibot/update_overlays()
	. = ..()

	/// We add our overlays to this list, then add them all at once to avoid appearance churn.
	var/list/temp_overlays = list()

	if(skin)
		temp_overlays.Add("[base_icon_state]-[skin]")
	temp_overlays.Add("[base_icon_state]-arm")

	add_overlay(temp_overlays)

/obj/item/bot_assembly/medibot/attackby(obj/item/target_item, mob/user, params)
	..()
	switch(build_step)
		if(ASSEMBLY_FIRST_STEP)
			if(istype(target_item, /obj/item/healthanalyzer))
				if(!user.attempt_consume_item_for_construction(target_item))
					return
				healthanalyzer = target_item.type
				to_chat(user, SPAN_NOTICE("You add the health sensor to [src]."))
				name = "First aid/robot arm/health analyzer assembly"
				add_overlay("[base_icon_state]-scanner")
				build_step++

		if(ASSEMBLY_SECOND_STEP)
			if(isprox(target_item))
				if(!can_finish_build(target_item, user))
					return
				if(!user.attempt_consume_item_for_construction(target_item))
					return
				var/mob/living/bot/medibot/new_medibot = new(get_turf(src), skin)
				to_chat(user, SPAN_NOTICE("You complete the Medibot! Beep boop."))
				new_medibot.name = created_name
				new_medibot.firstaid = firstaid
				new_medibot.robot_arm = robot_arm
				new_medibot.healthanalyzer = healthanalyzer
				qdel(src)


/**
 *! Medibot Construction
 */

/obj/item/storage/firstaid/attackby(obj/item/robot_parts/target_part, mob/user, params)

	if ((!istype(target_part, /obj/item/robot_parts/l_arm)) && (!istype(target_part, /obj/item/robot_parts/r_arm)))
		..()
		return

	if(contents.len >= 1)
		to_chat(user, SPAN_NOTICE("You need to empty [src] out first."))
		return

	var/obj/item/bot_assembly/medibot/new_medibot = new

	if(istype(src, /obj/item/storage/firstaid/fire))
		new_medibot.created_name = "\improper Mr. Burns"
		new_medibot.skin = "burn"
	else if(istype(src, /obj/item/storage/firstaid/toxin))
		new_medibot.created_name = "\improper Toxic"
		new_medibot.skin = "toxin"
	else if(istype(src, /obj/item/storage/firstaid/o2))
		new_medibot.created_name = "\improper Lifeless"
		new_medibot.skin = "o2"
	else if(istype(src, /obj/item/storage/firstaid/adv))
		new_medibot.created_name = "\improper Super Medibot"
		new_medibot.skin = "advfirstaid"
	else if(istype(src, /obj/item/storage/firstaid/clotting))
		new_medibot.created_name = "\improper Leaky"
		new_medibot.skin = "clottingkit"
	else if(istype(src, /obj/item/storage/firstaid/bonemed))
		new_medibot.created_name = "\improper Pinky"
		new_medibot.skin = "bonemed"
	else if(istype(src, /obj/item/storage/firstaid/combat))
		new_medibot.created_name = "\improper Mysterious Medibot"
		new_medibot.desc = "International Medibot of mystery. Though after a closer look, it looks like a fraud."
		new_medibot.skin = "bezerk"

	user.put_in_hands_or_drop(new_medibot)
	to_chat(user, SPAN_NOTICE("You add [target_part] to [src]."))
	new_medibot.robot_arm = target_part.type
	new_medibot.firstaid = type
	qdel(target_part)
	qdel(src)
