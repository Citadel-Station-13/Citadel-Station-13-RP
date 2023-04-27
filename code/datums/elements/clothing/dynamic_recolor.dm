/datum/element/clothing/dynamic_recolor

/datum/element/clothing/dynamic_recolor/Attach(obj/item/clothing/target)
	. = ..()
	if(. & ELEMENT_INCOMPATIBLE)
		return
	add_obj_verb(target, /obj/item/clothing/proc/dynamic_recolor_verb)

/datum/element/clothing/dynamic_recolor/Detach(obj/item/clothing/target)
	. = ..()
	remove_obj_verb(target, /obj/item/clothing/proc/dynamic_recolor_verb)

// todo: support matrix
// todo: support hsv
// todo: full tgui with preview ?
// todo: coloration system + support
// todo: when we get /obj level coloration, this might have to be generic so admin vv can have this?

/datum/element/clothing/dynamic_recolor/proc/handle_recolor(mob/user, obj/item/clothing/gear, check_possession, check_mobility)
	var/queried = query_recolor(user, gear)

	if(isnull(queried))
		return

	if(check_possession && gear.worn_mob() != user)
		return

	if(check_mobility && !CHECK_MOBILITY(usr, MOBILITY_CAN_USE))
		usr.action_feedback(SPAN_WARNING("You can't do that right now!"), src)
		return

	recolor(user, gear, queried)

/datum/element/clothing/dynamic_recolor/proc/query_recolor(mob/user, obj/item/clothing/gear)
	return input(user, "Choose a new color", "Recolor - [gear]", istext(gear.color)? gear.color : null) as color|null

/datum/element/clothing/dynamic_recolor/proc/recolor(mob/user, obj/item/clothing/gear, queried)
	gear.color = queried
	gear.update_worn_icon()

/obj/item/clothing/proc/dynamic_recolor_verb()
	set name = "Set Color Style"
	set category = "IC"
	set desc = "Set the coloration of this piece of clothing."
	set src in usr

	if(!CHECK_MOBILITY(usr, MOBILITY_CAN_USE))
		usr.action_feedback(SPAN_WARNING("You can't do that right now!"), src)
		return

	dynamic_recolor(usr, TRUE, TRUE)

/obj/item/clothing/proc/dynamic_recolor(mob/user, check_possession = TRUE, check_mobility = TRUE)
	var/datum/element/clothing/dynamic_recolor/elem = SSdcs.GetElement(list(/datum/element/clothing/dynamic_recolor))
	elem.handle_recolor(user, src, check_possession, check_mobility)
