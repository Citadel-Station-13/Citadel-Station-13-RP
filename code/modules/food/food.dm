#define CELLS 8
#define CELLSIZE (32/CELLS)

////////////////////////////////////////////////////////////////////////////////
/// Food.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/food
	possible_transfer_amounts = null
	volume = 50 //Sets the default container amount for all food items.
	var/filling_color = "#FFFFFF" //Used by sandwiches.
	drop_sound = 'sound/items/drop/food.ogg'
	pickup_sound = 'sound/items/pickup/food.ogg'

	var/list/center_of_mass = list() // Used for table placement

/obj/item/reagent_containers/food/Initialize(mapload)
	. = ..()
	if (center_of_mass.len && !pixel_x && !pixel_y)
		src.pixel_x = rand(-6.0, 6) //Randomizes postion
		src.pixel_y = rand(-6.0, 6)

/obj/item/reagent_containers/food/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(center_of_mass.len && (clickchain_flags & CLICKCHAIN_HAS_PROXIMITY) && istype(target, /obj/structure/table))
		//Places the item on a grid
		var/list/mouse_control = params2list(params)

		var/mouse_x = text2num(mouse_control["icon-x"])
		var/mouse_y = text2num(mouse_control["icon-y"])

		if(!isnum(mouse_x) || !isnum(mouse_y))
			return

		var/cell_x = max(0, min(CELLS-1, round(mouse_x/CELLSIZE)))
		var/cell_y = max(0, min(CELLS-1, round(mouse_y/CELLSIZE)))

		pixel_x = (CELLSIZE * (0.5 + cell_x)) - center_of_mass["x"]
		pixel_y = (CELLSIZE * (0.5 + cell_y)) - center_of_mass["y"]

BLOCK_BYOND_BUG_2072419

#undef CELLS
#undef CELLSIZE
