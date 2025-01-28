/obj/item/poster
	prototype_id = "ItemPoster"
	name = "rolled-up poster"
	desc = "The poster comes with its own automatic adhesive mechanism, for easy pinning to any vertical surface."
	icon = 'icons/modules/artwork/posters/poster.dmi'
	icon_state = "rolled_poster"
	drop_sound = 'sound/items/drop/wrapper.ogg'
	pickup_sound = 'sound/items/pickup/wrapper.ogg'

	/// random poster design tag or tags no [poster_design_id] is filled out
	///
	/// * null = pick all possible
	/// * accepts null, POSTER_TAG_* enum, or list of POSTER_TAG_* enum's
	var/poster_random_tag
	/// our poster design id or type.
	var/poster_design_id
	/// were we macro-defined? lets us skip a few things.
	var/macro_defined = FALSE

/obj/item/poster/Initialize(mapload, poster_design_id)
	. = ..()
	if(macro_defined)
		return
	poster_design_id = poster_design_id || src.poster_design_id
	if(!poster_design_id)
		poster_design_id = pick(RSposter_designs.fetch_by_tag_mutable(poster_random_tag))
	if(poster_design_id != src.poster_design_id)
		src.poster_design_id = poster_design_id
	set_poster_design(RSposter_designs.fetch_local_or_throw(poster_design_id))

/obj/item/poster/proc/set_poster_design(datum/prototype/poster_design/design)
	src.name = "rolled-up-poster - [design.name]"
	src.desc = "[/obj/item/poster::desc] [design.desc]"
	src.poster_design_id = design.id

//Places the poster on a wall
/obj/item/poster/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if (!(clickchain_flags & CLICKCHAIN_HAS_PROXIMITY))
		return

	//must place on a wall and user must not be inside a closet/mecha/whatever
	var/turf/W = target
	if (!iswall(W) || !isturf(user.loc))
		to_chat(user, "<span class='warning'>You can't place this here!</span>")
		return

	var/placement_dir = get_dir(user, W)
	if (!(placement_dir in GLOB.cardinal))
		to_chat(user, "<span class='warning'>You must stand directly in front of the wall you wish to place that on.</span>")
		return

	//just check if there is a poster on or adjacent to the wall
	var/stuff_on_wall = 0
	if (locate(/obj/structure/poster) in W)
		stuff_on_wall = 1

	//crude, but will cover most cases. We could do stuff like check pixel_x/y but it's not really worth it.
	for (var/dir in GLOB.cardinal)
		var/turf/T = get_step(W, dir)
		if (locate(/obj/structure/poster) in T)
			stuff_on_wall = 1
			break

	if (stuff_on_wall)
		to_chat(user, "<span class='notice'>There is already a poster there!</span>")
		return

	to_chat(user, "<span class='notice'>You start placing the poster on the wall...</span>") //Looks like it's uncluttered enough. Place the poster.

	var/obj/structure/poster/P = new(user.loc, get_dir(user, W), poster_design_id)

	flick(icon('icons/modules/artwork/posters/poster.dmi', "poster_being_set"), P)

	// todo: refactor
	//playsound(W, 'sound/items/poster_being_created.ogg', 100, 1) //why the hell does placing a poster make printer sounds?
	var/oldsrc = src //get a reference to src so we can delete it after detaching ourselves
	src = null
	spawn(17)
		if(!P)
			return

		if(iswall(W) && user && P.loc == user.loc) //Let's check if everything is still there
			to_chat(user, "<span class='notice'>You place the poster!</span>")
		else
			P.roll_and_drop(P.drop_location())

	qdel(oldsrc)	//delete it now to cut down on sanity checks afterwards. Agouri's code supports rerolling it anyway

/obj/item/poster/nanotrasen
	icon_state = "rolled_poster_nt"
	poster_random_tag = POSTER_TAG_NANOTRASEN
