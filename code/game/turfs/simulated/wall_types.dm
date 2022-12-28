/turf/simulated/wall/r_wall
	icon_state = "rgeneric"
	rad_insulation = RAD_INSULATION_SUPER

/turf/simulated/wall/r_wall/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, /datum/material/plasteel, /datum/material/plasteel) //3strong

/turf/simulated/wall/shull/Initialize(mapload, materialtype, rmaterialtype, girdertype)	//Spaaaace ship.
	return ..(mapload, /datum/material/steel/hull, null, /datum/material/steel/hull)

/turf/simulated/wall/rshull/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, /datum/material/steel/hull, /datum/material/steel/hull, /datum/material/steel/hull)

/turf/simulated/wall/pshull/Initialize(mapload, materialtype, rmaterialtype, girdertype)	//Spaaaace-er ship.
	return ..(mapload, /datum/material/plasteel/hull, null, /datum/material/plasteel/hull)

/turf/simulated/wall/rpshull/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, /datum/material/plasteel/hull, /datum/material/plasteel/hull, /datum/material/plasteel/hull)

/turf/simulated/wall/dshull/Initialize(mapload, materialtype, rmaterialtype, girdertype)	//Spaaaace-est ship.
	return ..(mapload, /datum/material/durasteel/hull, null, /datum/material/durasteel/hull)

/turf/simulated/wall/rdshull/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, /datum/material/durasteel/hull, /datum/material/durasteel/hull, /datum/material/durasteel/hull)

/turf/simulated/wall/thull/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, /datum/material/plasteel/titanium/hull, null, /datum/material/plasteel/titanium/hull)

/turf/simulated/wall/rthull/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, /datum/material/plasteel/titanium/hull, /datum/material/plasteel/titanium/hull, /datum/material/plasteel/titanium/hull)

/turf/simulated/wall/cult
	icon_state = "cult"

/turf/simulated/wall/cult/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, "cult", "cult2", "cult")

/turf/unsimulated/wall/cult
	name = "cult wall"
	desc = "Hideous images dance beneath the surface."
	icon = 'icons/turf/walls/_previews.dmi'
	icon_state = "cult"

/turf/simulated/wall/iron/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, /datum/material/iron)

/turf/simulated/wall/uranium/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, /datum/material/uranium)

/turf/simulated/wall/diamond/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, /datum/material/diamond)

/turf/simulated/wall/gold/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, /datum/material/gold)

/turf/simulated/wall/silver/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, /datum/material/silver)

/turf/simulated/wall/lead/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, /datum/material/lead)

/turf/simulated/wall/r_lead/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, /datum/material/lead, /datum/material/lead)

/turf/simulated/wall/phoron/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, /datum/material/phoron)

/turf/simulated/wall/sandstone/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, /datum/material/sandstone)

/turf/simulated/wall/ironphoron/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, /datum/material/iron, /datum/material/phoron)

/turf/simulated/wall/golddiamond/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, /datum/material/gold, /datum/material/diamond)

/turf/simulated/wall/silvergold/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, /datum/material/silver, /datum/material/gold)

/turf/simulated/wall/sandstonediamond/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, /datum/material/sandstone, /datum/material/diamond)

/turf/simulated/wall/snowbrick/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, /datum/material/snowbrick)

/turf/simulated/wall/resin/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, /datum/material/resin, null, /datum/material/resin)

// Kind of wondering if this is going to bite me in the butt.
/turf/simulated/wall/skipjack/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, /datum/material/alienalloy)
/turf/simulated/wall/skipjack/attackby()
	return
/turf/simulated/wall/titanium/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, /datum/material/plasteel/titanium)

/turf/simulated/wall/durasteel/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, /datum/material/durasteel, /datum/material/durasteel)

/turf/simulated/wall/wood/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, /datum/material/wood)

/turf/simulated/wall/sifwood/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, /datum/material/wood/sif)

/turf/simulated/wall/hardwood/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, /datum/material/wood/hardwood)

/turf/simulated/wall/log/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, /datum/material/wood/log)

/turf/simulated/wall/log_sif/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, /datum/material/wood/log/sif)

// TODO: Nuke. @Zandario
// Shuttle Walls
/turf/simulated/shuttle/wall
	name = "autojoin wall"
	icon_state = "light"
	opacity = TRUE
	density = TRUE
	blocks_air = TRUE

	/// The base iconstate to base sprites on
	var/base_state = "light"
	/// Forces hard corners (as opposed to diagonals)
	var/hard_corner = 0
	/// What to rename this to on init
	var/true_name = "wall"

	//Extra things this will try to locate and act like we're joining to. You can put doors, or whatever.
	//Carefully means only if it's on a /turf/simulated/shuttle subtype turf.
	var/static/list/join_carefully = list(
		/obj/machinery/door/blast/regular,
		/obj/structure/grille,
	)
	var/static/list/join_always = list(
		/obj/machinery/door/airlock/voidcraft,
		/obj/structure/shuttle/engine,
		/obj/structure/shuttle/window,
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

/turf/simulated/shuttle/wall/Initialize(mapload)
	. = ..()
	//To allow mappers to rename shuttle walls to like "redfloor interior" or whatever for ease of use.
	name = true_name

/turf/simulated/shuttle/wall/Initialize(mapload)
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
	if(IS_DIAGONAL(join_flags))
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

/turf/simulated/shuttle/wall/voidcraft/Initialize(mapload)
	. = ..()
	update_icon()

/turf/simulated/shuttle/wall/voidcraft/update_icon()
	if(stripe_color)
		cut_overlays()
		var/image/I = image(icon = src.icon, icon_state = "o_[icon_state]")
		I.color = stripe_color
		add_overlay(I)
