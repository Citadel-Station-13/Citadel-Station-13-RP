/obj/vehicle/ridden/skateboard
	name = "The essence of tony hawk"
	desc = "You shouldn't be seeing this. Contact an Admin."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "skateboard"
	density = FALSE
	integrity = 100
	integrity_max = 100
	riding_handler_type = /datum/component/riding_handler/vehicle/ridden/skateboard

	var/board_item_type

/datum/component/riding_handler/vehicle/ridden/skateboard
	rider_offsets = list(
		list(
			list(0, 2, 0.1, 4),
			list(0, 2, 0.1, 2),
			list(0, 2, 0.1, 8),
			list(0, 2, 0.1, 1)
		)
	)
	rider_offset_format = CF_RIDING_OFFSETS_ENUMERATED
	rider_check_flags = list(CF_RIDING_CHECK_ARMS,
	CF_RIDING_CHECK_RESTRAINED,
	CF_RIDING_CHECK_UNCONSCIOUS,
	CF_RIDING_CHECK_INCAPACITATED
	)
	riding_handler_flags = list(CF_RIDING_HANDLER_ALLOW_BORDER,
	CF_RIDING_HANDLER_IS_CONTROLLABLE)

	vehicle_move_delay = 1
	allowed_turf_types = list(
		/turf/simulated,
		/turf/unsimulated
	)

// If we click the board, it needs to turn into a holdable item.
/obj/vehicle/ridden/skateboard/OnMouseDrop(atom/over, mob/user, proximity, params)
	. = ..()
	if(!istype(user) || user.incapacitated() || !proximity)
		return
	if(has_buckled_mobs() && over == user)
		to_chat(user, "<span class='warning'>You can't lift this up when somebody's on it.</span>")
		return
	if(over == user)
		var/board = new board_item_type(get_turf(user))
		user.put_in_hands(board)
		qdel(src)




// Skateboards
/obj/vehicle/ridden/skateboard/improv
	name = "improvised skateboard"
	desc = "A crude assembly which can only barely be called a skateboard. It's still rideable, but probably unsafe. Looks like you'll need to add a few rods to make handlebars."
	board_item_type = /obj/item/melee/skateboard/improv
	icon_state = "skateboard"

/obj/vehicle/ridden/skateboard/beginner
	name = "skateboard"
	desc = "A XTREME SPORTZ brand skateboard for beginners. Ages 8 and up."
	board_item_type = /obj/item/melee/skateboard/beginner
	icon_state = "skateboard"

/obj/vehicle/ridden/skateboard/pro
	name = "skateboard"
	desc = "A RaDSTORMz brand professional skateboard. Looks a lot more stable than the average board."
	board_item_type = /obj/item/melee/skateboard/pro
	icon_state = "skateboard2"

/obj/vehicle/ridden/skateboard/hoverboard
	name = "hoverboard"
	desc = "A blast from the past, so retro!"
	board_item_type = /obj/item/melee/skateboard/hoverboard
	icon_state = "hoverboard_red"

/obj/vehicle/ridden/skateboard/hoverboard/admin
	name = "\improper Board Of Directors"
	desc = "The engineering complexity of a spaceship concentrated inside of a board. Just as expensive, too."
	board_item_type = /obj/item/melee/skateboard/hoverboard/admin
	icon_state = "hoverboard_nt"

//If this was the 90's you'd be killed for this
/obj/vehicle/ridden/skateboard/scooter
	name = "scooter"
	desc = "A fun way to get around."
	icon_state = "scooter"
	board_item_type = /obj/item/melee/skateboard/scooter
