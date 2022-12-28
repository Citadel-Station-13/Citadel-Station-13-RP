/turf/simulated/wall/r_wall
	icon_state = "rgeneric"
	rad_insulation = RAD_INSULATION_SUPER

	material        = /datum/material/plasteel
	reinf_material  = /datum/material/plasteel
	girder_material = null

/turf/simulated/wall/shull
	material        = /datum/material/steel/hull
	reinf_material  = null
	girder_material = /datum/material/steel/hull

/turf/simulated/wall/rshull
	material        = /datum/material/steel/hull
	reinf_material  = /datum/material/steel/hull
	girder_material = /datum/material/steel/hull

/turf/simulated/wall/pshull
	material        = /datum/material/plasteel/hull
	reinf_material  = null
	girder_material = /datum/material/plasteel/hull

/turf/simulated/wall/rpshull
	material        = /datum/material/plasteel/hull
	reinf_material  = /datum/material/plasteel/hull
	girder_material = /datum/material/plasteel/hull

/turf/simulated/wall/dshull
	material        = /datum/material/durasteel/hull
	reinf_material  = null
	girder_material = /datum/material/durasteel/hull

/turf/simulated/wall/rdshull
	material        = /datum/material/durasteel/hull
	reinf_material  = /datum/material/durasteel/hull
	girder_material = /datum/material/durasteel/hull

/turf/simulated/wall/thull
	material        = /datum/material/plasteel/titanium/hull
	reinf_material  = null
	girder_material = /datum/material/plasteel/titanium/hull

/turf/simulated/wall/rthull
	material        = /datum/material/plasteel/titanium/hull
	reinf_material  = /datum/material/plasteel/titanium/hull
	girder_material = /datum/material/plasteel/titanium/hull


/turf/simulated/wall/cult
	icon_state = "cult"

	material        = /datum/material/cult
	reinf_material  = /datum/material/cult/reinf
	girder_material = /datum/material/cult

/turf/unsimulated/wall/cult
	name = "cult wall"
	desc = "Hideous images dance beneath the surface."
	icon = 'icons/turf/walls/_previews.dmi'
	icon_state = "cult"

/turf/simulated/wall/iron
	material        = /datum/material/iron
	reinf_material  = null
	girder_material = null

/turf/simulated/wall/uranium
	material        = /datum/material/uranium
	reinf_material  = null
	girder_material = null

/turf/simulated/wall/diamond
	material        = /datum/material/diamond
	reinf_material  = null
	girder_material = null

/turf/simulated/wall/gold
	material        = /datum/material/gold
	reinf_material  = null
	girder_material = null

/turf/simulated/wall/silver
	material        = /datum/material/silver
	reinf_material  = null
	girder_material = null

/turf/simulated/wall/lead
	material        = /datum/material/silver
	reinf_material  = null
	girder_material = null

/turf/simulated/wall/r_lead
	material        = /datum/material/silver
	reinf_material  = /datum/material/silver
	girder_material = null

/turf/simulated/wall/phoron
	material        = /datum/material/phoron
	reinf_material  = null
	girder_material = null

/turf/simulated/wall/sandstone
	material        = /datum/material/sandstone
	reinf_material  = null
	girder_material = null

/turf/simulated/wall/ironphoron
	material        = /datum/material/iron
	reinf_material  = /datum/material/phoron
	girder_material = null

/turf/simulated/wall/golddiamond
	material        = /datum/material/gold
	reinf_material  = /datum/material/diamond
	girder_material = null

/turf/simulated/wall/silvergold
	material        = /datum/material/silver
	reinf_material  = /datum/material/gold
	girder_material = null

/turf/simulated/wall/sandstonediamond
	material        = /datum/material/sandstone
	reinf_material  = /datum/material/diamond
	girder_material = null

/turf/simulated/wall/snowbrick
	material        = /datum/material/snowbrick
	reinf_material  = null
	girder_material = null

/turf/simulated/wall/resin
	material        = /datum/material/resin
	reinf_material  = null
	girder_material = /datum/material/resin

// Kind of wondering if this is going to bite me in the butt.
/turf/simulated/wall/skipjack
	material        = /datum/material/alienalloy
	reinf_material  = null
	girder_material = null

/turf/simulated/wall/skipjack/attackby()
	return

/turf/simulated/wall/titanium
	material        = /datum/material/plasteel/titanium
	reinf_material  = null
	girder_material = null

/turf/simulated/wall/durasteel
	material        = /datum/material/durasteel
	reinf_material  = /datum/material/durasteel
	girder_material = null

/turf/simulated/wall/wood
	material        = /datum/material/wood
	reinf_material  = null
	girder_material = null

/turf/simulated/wall/sifwood
	material        = /datum/material/wood/sif
	reinf_material  = null
	girder_material = null

/turf/simulated/wall/hardwood
	material        = /datum/material/wood/hardwood
	reinf_material  = null
	girder_material = null

/turf/simulated/wall/log
	material        = /datum/material/wood/log
	reinf_material  = null
	girder_material = null

/turf/simulated/wall/log_sif
	material        = /datum/material/wood/log/sif
	reinf_material  = null
	girder_material = null

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
