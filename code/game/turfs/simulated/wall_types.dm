/turf/simulated/wall/r_wall
	icon_state = "rgeneric"
	material_primary = MATERIAL_ID_PLASTEEL
	material_reinforcing = MATERIAL_ID_PLASTEEL

/turf/simulated/wall/shull
	material_primary = MATERIAL_ID_STEEL_HULL
	material_girder = MATERIAL_ID_STEEL_HULL

/turf/simulated/wall/rshull
	material_primary = MATERIAL_ID_STEEL_HULL
	material_reinforcing = MATERIAL_ID_STEEL_HULL
	material_girder = MATERIAL_ID_STEEL_HULL

/turf/simulated/wall/pshull
	material_primary = MATERIAL_ID_PLASTEEL_HULL
	material_girder = MATERIAL_ID_PLASTEEL_HULL

/turf/simulated/wall/pshull
	material_primary = MATERIAL_ID_PLASTEEL_HULL
	material_girder = MATERIAL_ID_PLASTEEL_HULL
	material_reinforcing = MATERIAL_ID_PLASTEEL_HULL

/turf/simulated/wall/dshull
	material_primary = MATERIAL_ID_DURASTEEL_HULL
	material_girder = MATERIAL_ID_DURASTEEL_HULL

/turf/simulated/wall/dshull
	material_primary = MATERIAL_ID_DURASTEEL_HULL
	material_girder = MATERIAL_ID_DURASTEEL_HULL
	material_reinforcing = MATERIAL_ID_DURASTEEL_HULL

/turf/simulated/wall/thull
	material_primary = MATERIAL_ID_TITANIUM_HULL
	material_girder = MATERIAL_ID_TITANIUM_HULL

/turf/simulated/wall/thull
	material_primary = MATERIAL_ID_TITANIUM_HULL
	material_girder = MATERIAL_ID_TITANIUM_HULL
	material_reinforcing = MATERIAL_ID_TITANIUM_HULL

/turf/simulated/wall/cult
	icon_state = "cult"
	material_primary = MATERIAL_ID_CULT
	material_reinforcing = MATERIAL_ID_CULT_REINFORCED
	material_girder = MATERIAL_ID_CULT

/turf/unsimulated/wall/cult
	name = "cult wall"
	desc = "Hideous images dance beneath the surface."
	icon = 'icons/turf/wall_masks.dmi'
	icon_state = "cult"

/turf/simulated/wall/iron
	material_primary = MATERIAL_ID_IRON

/turf/simulated/wall/uranium
	material_primary = MATERIAL_ID_URANIUM

/turf/simulated/wall/diamond
	material_primary = MATERIAL_ID_DIAMOND

/turf/simulated/wall/gold
	material_primary = MATERIAL_ID_GOLD

/turf/simulated/wall/silver
	material_primary = MATERIAL_ID_SILVER

/turf/simulated/wall/lead
	material_primary = MATERIAL_ID_LEAD

/turf/simulated/wall/r_lead
	material_primary = MATERIAL_ID_LEAD
	material_reinforcing = MATERIAL_ID_LEAD

/turf/simulated/wall/phoron
	material_primary = MATERIAL_ID_PHORON

/turf/simulated/wall/sandstone
	material_primary = MATERIAL_ID_SANDSTONE

/turf/simulated/wall/ironphoron
	material_primary = MATERIAL_ID_IRON
	material_reinforcing = MATERIAL_ID_PHORON

/turf/simulated/wall/golddiamond
	material_primary = MATERIAL_ID_GOLD
	material_reinforcing = MATERIAL_ID_DIAMOND

/turf/simulated/wall/silvergold
	material_primary = MATERIAL_ID_SILVER
	material_reinforcing = MATERIAL_ID_GOLD

/turf/simulated/wall/sandstonediamond
	material_priamry = MATERIAL_ID_SANDSTONE
	material_reinforcing = MATERIAL_ID_DIAMOND

/turf/simulated/wall/snowbrick
	material_primary = MATERIAL_ID_SNOWBRICK

//this is shitcode, remove posthaste.
/turf/simulated/wall/skipjack/attackby()
	return

/turf/simulated/wall/skipjack
	material_primary = MATERIAL_ID_ALIEN_ALLOY

/turf/simulated/wall/titanium
	material_primary = MATERIAL_ID_TITANIUM

/turf/simualted/wall/durasteel
	material_primary = MATERIAL_ID_DURASTEEL
	material_reinforcing = MATERIAL_ID_DURASTEEL

/turf/simulated/wall/wood
	material_primary = MATERIAL_ID_WOOD

/turf/simulated/wall/sifwood
	material_primary = MATERIAL_ID_SIFWOOD

/turf/simulated/wall/log
	mateiral_primary = MATERIAL_ID_LOG

/turf/simulated/wall/log_sif
	material_priamry = MATERIAL_ID_SIFLOG

// Shuttle Walls
/turf/simulated/shuttle/wall
	name = "autojoin wall"
	icon_state = "light"
	opacity = 1
	density = 1
	blocks_air = 1

	var/base_state = "light" //The base iconstate to base sprites on
	var/hard_corner = 0 //Forces hard corners (as opposed to diagonals)
	var/true_name = "wall" //What to rename this to on init

	//Extra things this will try to locate and act like we're joining to. You can put doors, or whatever.
	//Carefully means only if it's on a /turf/simulated/shuttle subtype turf.
	var/static/list/join_carefully = list(
	/obj/structure/grille,
	/obj/machinery/door/blast/regular
	)
	var/static/list/join_always = list(
	/obj/structure/shuttle/engine,
	/obj/structure/shuttle/window,
	/obj/machinery/door/airlock/voidcraft
	)

/turf/simulated/shuttle/wall/hard_corner
	name = "hardcorner wall"
	icon_state = "light-hc"
	hard_corner = 1

/turf/simulated/shuttle/wall/no_join
	icon_state = "light-nj"
	join_group = null

/turf/simulated/shuttle/wall/dark
	icon = 'icons/turf/shuttle_dark.dmi'
	icon_state = "dark"
	base_state = "dark"

/turf/simulated/shuttle/wall/dark/hard_corner
	name = "hardcorner wall"
	icon_state = "dark-hc"
	hard_corner = 1

/turf/simulated/shuttle/wall/dark/no_join
	name = "nojoin wall"
	icon_state = "dark-nj"
	join_group = null

/turf/simulated/shuttle/wall/alien
	icon = 'icons/turf/shuttle_alien.dmi'
	icon_state = "alien"
	base_state = "alien"
	light_range = 3
	light_power = 0.75
	light_color = "#ff0066" // Pink-ish
	block_tele = TRUE // Will be used for dungeons so this is needed to stop cheesing with handteles.

/turf/simulated/shuttle/wall/alien/hard_corner
	name = "hardcorner wall"
	icon_state = "alien-hc"
	hard_corner = 1

/turf/simulated/shuttle/wall/alien/no_join
	name = "nojoin wall"
	icon_state = "alien-nj"
	join_group = null

/turf/simulated/shuttle/wall/New()
	..()
	//To allow mappers to rename shuttle walls to like "redfloor interior" or whatever for ease of use.
	name = true_name

/turf/simulated/shuttle/wall/Initialize()
	. = ..()

	if(join_group)
		src.auto_join()
	else
		icon_state = base_state

	if(takes_underlays)
		underlay_update()

/turf/simulated/shuttle/wall/proc/auto_join()
	match_turf(NORTH, NORTH)
	match_turf(EAST, EAST)
	match_turf(SOUTH, SOUTH)
	match_turf(WEST, WEST)

	icon_state = "[base_state][join_flags]"
	if(isDiagonal(join_flags))
		if(hard_corner) //You are using 'hard' (aka full-tile) corners.
			icon_state += "h" //Hard corners have 'h' at the end of the state
		else //Diagonals need an underlay to not look ugly.
			takes_underlays = 1
	else //Everything else doesn't deserve our time!
		takes_underlays = initial(takes_underlays)

	return join_flags

/turf/simulated/shuttle/wall/proc/match_turf(direction, flag, mask=0)
	if((join_flags & mask) == mask)
		var/turf/simulated/shuttle/wall/adj = get_step(src, direction)
		if(istype(adj, /turf/simulated/shuttle/wall) && adj.join_group == src.join_group)
			join_flags |= flag      // turn on the bit flag
			return

		else if(istype(adj, /turf/simulated/shuttle))
			var/turf/simulated/shuttle/adj_cast = adj
			if(adj_cast.join_group == src.join_group)
				var/found
				for(var/E in join_carefully)
					found = locate(E) in adj
					if(found) break
				if(found)
					join_flags |= flag      // turn on the bit flag
					return

		var/always_found
		for(var/E in join_always)
			always_found = locate(E) in adj
			if(always_found) break
		if(always_found)
			join_flags |= flag      // turn on the bit flag
		else
			join_flags &= ~flag     // turn off the bit flag

/turf/simulated/shuttle/wall/voidcraft
	name = "voidcraft wall"
	icon = 'icons/turf/shuttle_void.dmi'
	icon_state = "void"
	base_state = "void"
	var/stripe_color = null // If set, generates a colored stripe overlay.  Accepts #XXXXXX as input.

/turf/simulated/shuttle/wall/voidcraft/hard_corner
	name = "hardcorner wall"
	icon_state = "void-hc"
	hard_corner = 1

/turf/simulated/shuttle/wall/voidcraft/no_join
	name = "nojoin wall"
	icon_state = "void-nj"
	join_group = null

/turf/simulated/shuttle/wall/voidcraft/red
	stripe_color = "#FF0000"

/turf/simulated/shuttle/wall/voidcraft/blue
	stripe_color = "#0000FF"

/turf/simulated/shuttle/wall/voidcraft/green
	stripe_color = "#00FF00"

/turf/simulated/shuttle/wall/voidcraft/Initialize()
	. = ..()
	update_icon()

/turf/simulated/shuttle/wall/voidcraft/update_icon()
	if(stripe_color)
		cut_overlays()
		var/image/I = image(icon = src.icon, icon_state = "o_[icon_state]")
		I.color = stripe_color
		add_overlay(I)
