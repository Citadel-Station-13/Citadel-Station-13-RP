/obj/structure/poster
	prototype_id = "Poster"
	name = "poster"
	desc = "A large piece of space-resistant printed paper."
	icon = 'icons/modules/artwork/posters/poster.dmi'
	anchored = TRUE

	/// random poster design tag or tags no [poster_design_id] is filled out
	///
	/// * null = pick all possible
	/// * accepts null, POSTER_TAG_* enum, or list of POSTER_TAG_* enum's
	var/poster_random_tag
	/// our poster design id or type.
	var/poster_design_id
	/// were we macro-defined? lets us skip a few things.
	var/macro_defined = FALSE

	var/ruined = 0
	var/roll_type

/obj/structure/poster/Initialize(mapload, placement_dir, poster_design_id)
	. = ..()
	switch (placement_dir)
		if (NORTH)
			pixel_x = 0
			pixel_y = 32
		if (SOUTH)
			pixel_x = 0
			pixel_y = -32
		if (EAST)
			pixel_x = 32
			pixel_y = 0
		if (WEST)
			pixel_x = -32
			pixel_y = 0

	if(macro_defined)
		return
	poster_design_id = poster_design_id || src.poster_design_id
	if(!poster_design_id)
		poster_design_id = pick(RSposter_designs.fetch_by_tag_mutable(poster_random_tag))
	if(poster_design_id != src.poster_design_id)
		src.poster_design_id = poster_design_id
	set_poster_design(RSposter_designs.fetch_local_or_throw(poster_design_id))

/obj/structure/poster/proc/set_poster_design(datum/prototype/poster_design/design)
	src.name = "rolled-up-poster - [design.name]"
	src.desc = "[/obj/structure/poster::desc] [design.desc]"
	src.poster_design_id = design.id
	src.icon = design.icon
	src.icon_state = design.icon_state

/obj/structure/poster/attackby(obj/item/W as obj, mob/user as mob)
	if(W.is_wirecutter())
		playsound(src.loc, W.tool_sound, 100, 1)
		if(ruined)
			to_chat(user, "<span class='notice'>You remove the remnants of the poster.</span>")
			qdel(src)
		else
			to_chat(user, "<span class='notice'>You carefully remove the poster from the wall.</span>")
			roll_and_drop(user.loc)

/obj/structure/poster/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	if(ruined)
		return

	if(alert("Do I want to rip the poster from the wall?","You think...","Yes","No") == "Yes")

		if(ruined || !user.Adjacent(src))
			return

		visible_message("<span class='warning'>[user] rips [src] in a single, decisive motion!</span>" )
		playsound(src.loc, 'sound/items/poster_ripped.ogg', 100, 1)
		ruined = TRUE
		icon = initial(icon)
		icon_state = "poster_ripped"
		name = "ripped poster"
		desc = "You can't make out anything from the poster's original print. It's ruined."
		add_fingerprint(user)

/obj/structure/poster/proc/roll_and_drop(turf/newloc)
	new /obj/item/poster(newloc, poster_design_id)
	qdel(src)

/obj/structure/poster/nanotrasen
	poster_random_tag = POSTER_TAG_NANOTRASEN
