/turf/simulated/wall/r_wall
	icon_state = "solid-reinf"
	// material = /datum/material/solid/metal/plasteel
	reinf_material = /datum/material/solid/metal/plasteel

/turf/simulated/wall/shull // Spaaaace ship.
	icon_state = "hull"
	color = "#666677"
	material = /datum/material/solid/metal/steel/hull
	girder_material = /datum/material/solid/metal/steel/hull

/turf/simulated/wall/rshull
	icon_state = "hull"
	color = "#666677"
	material = /datum/material/solid/metal/steel/hull
	reinf_material = /datum/material/solid/metal/steel/hull
	girder_material = /datum/material/solid/metal/steel/hull

/turf/simulated/wall/pshull // Spaaaace-er ship.
	icon_state = "hull"
	color = "#777788"
	material = /datum/material/solid/metal/plasteel/hull
	girder_material = /datum/material/solid/metal/plasteel/hull

/turf/simulated/wall/rpshull
	icon_state = "hull"
	color = "#777788"
	material = /datum/material/solid/metal/plasteel/hull
	reinf_material = /datum/material/solid/metal/plasteel/hull
	girder_material = /datum/material/solid/metal/plasteel/hull

/turf/simulated/wall/dshull // Spaaaace-est ship.
	icon_state = "hull"
	color = "#45829a"
	material = /datum/material/solid/metal/durasteel/hull
	girder_material = /datum/material/solid/metal/durasteel/hull

/turf/simulated/wall/rdshull
	icon_state = "hull"
	color = "#45829a"
	material = /datum/material/solid/metal/durasteel/hull
	reinf_material = /datum/material/solid/metal/durasteel/hull
	girder_material = /datum/material/solid/metal/durasteel/hull

/turf/simulated/wall/thull
	icon_state = "hull"
	color = "#D1E6E3"
	material = /datum/material/solid/metal/plasteel/titanium/hull
	girder_material = /datum/material/solid/metal/plasteel/titanium/hull

/turf/simulated/wall/rthull
	icon_state = "hull"
	color = "#D1E6E3"
	material = /datum/material/solid/metal/plasteel/titanium/hull
	reinf_material = /datum/material/solid/metal/plasteel/titanium/hull
	girder_material = /datum/material/solid/metal/plasteel/titanium/hull

/turf/simulated/wall/cult
	icon_state = "cult"

/turf/simulated/wall/cult
	material = /datum/material/cult
	reinf_material = /datum/material/cult/reinf
	girder_material = /datum/material/cult

/turf/unsimulated/wall/cult
	name = "cult wall"
	desc = "Hideous images dance beneath the surface."
	icon = 'icons/turf/walls/_previews.dmi'
	icon_state = "cult"

/turf/simulated/wall/iron
	material = /datum/material/solid/metal/iron
	return ..(mapload, MAT_IRON)

/turf/simulated/wall/uranium/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, MAT_URANIUM)
/turf/simulated/wall/diamond/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, MAT_DIAMOND)
/turf/simulated/wall/gold/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, MAT_GOLD)
/turf/simulated/wall/silver/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, MAT_SILVER)
/turf/simulated/wall/lead/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, MAT_LEAD)
/turf/simulated/wall/r_lead/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, MAT_LEAD, MAT_LEAD)
/turf/simulated/wall/phoron/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, MAT_PHORON)
/turf/simulated/wall/sandstone/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, MAT_SANDSTONE)
/turf/simulated/wall/ironphoron/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, MAT_IRON, MAT_PHORON)
/turf/simulated/wall/golddiamond/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, MAT_GOLD, MAT_DIAMOND)
/turf/simulated/wall/silvergold/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, MAT_SILVER, MAT_GOLD)
/turf/simulated/wall/sandstonediamond/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, MAT_SANDSTONE, MAT_DIAMOND)
/turf/simulated/wall/snowbrick/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, MAT_SNOW_PACKED)

/turf/simulated/wall/resin/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, MAT_RESIN, null, MAT_RESIN)

// Kind of wondering if this is going to bite me in the butt.
/turf/simulated/wall/skipjack/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload,"alienalloy")
/turf/simulated/wall/skipjack/attackby()
	return
/turf/simulated/wall/titanium/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload,"titanium")

/turf/simulated/wall/durasteel/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload,"durasteel", "durasteel")

/turf/simulated/wall/wood/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, MAT_WOOD)

/turf/simulated/wall/sifwood/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, MAT_SIFWOOD)

/turf/simulated/wall/hardwood/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, MAT_HARDWOOD)

/turf/simulated/wall/log/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, MAT_LOG)

/turf/simulated/wall/log_sif/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	return ..(mapload, MAT_SIFLOG)

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

/turf/simulated/flesh
	name = "flesh wall"
	desc = "The fleshy surface of this wall squishes nicely under your touch but looks and feels extremly strong"
	icon = 'icons/turf/stomach_vr.dmi'
	icon_state = "flesh"
	opacity = 1
	density = 1
	blocks_air = 1

/turf/simulated/flesh/colour
	name = "flesh wall"
	desc = "The fleshy surface of this wall squishes nicely under your touch but looks and feels extremly strong"
	icon = 'icons/turf/stomach_vr.dmi'
	icon_state = "colorable-wall"
	opacity = 1
	density = 1
	blocks_air = 1

/turf/simulated/flesh/attackby()
	return

/turf/simulated/flesh/Initialize(mapload)
	. = ..()
	update_icon(1)	//TODO: TG icon smoothing

var/list/flesh_overlay_cache = list()

/turf/simulated/flesh/update_icon(var/update_neighbors)
	cut_overlays()

	if(density)
		icon = 'icons/turf/stomach_vr.dmi'
		icon_state = "flesh"
		for(var/direction in GLOB.cardinal)
			var/turf/T = get_step(src,direction)
			if(istype(T) && !T.density)
				var/place_dir = turn(direction, 180)
				if(!flesh_overlay_cache["flesh_side_[place_dir]"])
					flesh_overlay_cache["flesh_side_[place_dir]"] = image('icons/turf/stomach_vr.dmi', "flesh_side", dir = place_dir)
				add_overlay(flesh_overlay_cache["flesh_side_[place_dir]"])

	if(update_neighbors)
		for(var/direction in GLOB.alldirs)
			if(istype(get_step(src, direction), /turf/simulated/flesh))
				var/turf/simulated/flesh/F = get_step(src, direction)
				F.update_icon()
