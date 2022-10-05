/obj/structure/largecrate
	name = "large crate"
	desc = "A hefty wooden crate."
	icon = 'icons/obj/storage.dmi'
	icon_state = "densecrate"
	density = 1
	var/list/starts_with
	var/storage_capacity = 2 * MOB_LARGE //This is so that someone can't pack hundreds of items in a locker/crate
							  //then open it in a populated area to crash clients.



/obj/structure/largecrate/Initialize(mapload)	//Shamelessly copied from closets.dm since the old Initializer didnt seem to function properly - Bloop
	. = ..()
	if(mapload)
		addtimer(CALLBACK(src, .proc/take_contents), 0)
	PopulateContents()
	// Closets need to come later because of spawners potentially creating objects during init.
	return INITIALIZE_HINT_LATELOAD

/obj/structure/largecrate/LateInitialize()
	. = ..()
	if(starts_with)
		create_objects_in_loc(src, starts_with)
		starts_with = null
	update_icon()

/obj/structure/largecrate/proc/take_contents()
	// if(istype(loc, /mob/living))
	//	return // No collecting mob organs if spawned inside mob
	// I'll leave this out, if someone dies to this from voring someone who made a closet go yell at a coder to
	// fix the fact you can build closets inside living people, not try to make it work you numbskulls.
	var/obj/item/I
	for(I in src.loc)
		if(I.density || I.anchored || I == src) continue
		I.forceMove(src)
	// adjust locker size to hold all items with 5 units of free store room
	var/content_size = 0
	for(I in src.contents)
		content_size += CEILING(I.w_class/2, 1)
	if(content_size > storage_capacity-5)
		storage_capacity = content_size + 5

/**
 * The proc that fills the closet with its initial contents.
 */
/obj/structure/largecrate/proc/PopulateContents()
	return

/*	/// Doesnt work but im gonna leave this here commented out in case I broke something with the shameless copy pasta from above -Bloop
/obj/structure/largecrate/Initialize(mapload)
	. = ..()
	if(starts_with)
		create_objects_in_loc(src, starts_with)
		starts_with = null
	for(var/obj/I in src.loc)
		if(I.density || I.anchored || I == src || (I.flags & ATOM_ABSTRACT))
			continue
		I.forceMove(src)
	update_icon()

*/

/obj/structure/largecrate/attack_hand(mob/user as mob)
	to_chat(user, "<span class='notice'>You need a crowbar to pry this open!</span>")
	return

/obj/structure/largecrate/attackby(obj/item/W as obj, mob/user as mob)
	var/turf/T = get_turf(src)
	if(!T)
		to_chat(user, "<span class='notice'>You can't open this here!</span>")
	if(W.is_crowbar())
		new /obj/item/stack/material/wood(src)

		for(var/atom/movable/AM in contents)
			if(!(AM.flags & ATOM_ABSTRACT))
				AM.forceMove(T)

		user.visible_message("<span class='notice'>[user] pries \the [src] open.</span>", \
							 "<span class='notice'>You pry open \the [src].</span>", \
							 "<span class='notice'>You hear splitting wood.</span>")
		qdel(src)
	else
		return attack_hand(user)

/obj/structure/largecrate/mule
	name = "MULE crate"

/obj/structure/largecrate/hoverpod
	name = "\improper Hoverpod assembly crate"
	desc = "It comes in a box for the fabricator's sake. Where does the wood come from? ... And why is it lighter?"
	icon_state = "mulecrate"

/obj/structure/largecrate/hoverpod/attackby(obj/item/W as obj, mob/user as mob)
	if(W.is_crowbar())
		var/obj/item/mecha_parts/mecha_equipment/ME
		var/obj/mecha/working/hoverpod/H = new (loc)

		ME = new /obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp
		ME.attach(H)
		ME = new /obj/item/mecha_parts/mecha_equipment/tool/passenger
		ME.attach(H)
	..()

/obj/structure/largecrate/vehicle
	name = "vehicle crate"
	desc = "It comes in a box for the consumer's sake. ..How is this lighter?"
	icon_state = "vehiclecrate"

/obj/structure/largecrate/vehicle/Initialize(mapload)
	. = ..()
	spawn(1)
		for(var/obj/O in contents)
			O.update_icon()

/obj/structure/largecrate/vehicle/bike
	name = "spacebike crate"
	starts_with = list(/obj/structure/vehiclecage/spacebike)

/obj/structure/largecrate/vehicle/quadbike
	name = "\improper ATV crate"
	starts_with = list(/obj/structure/vehiclecage/quadbike)

/obj/structure/largecrate/vehicle/quadtrailer
	name = "\improper ATV trailer crate"
	starts_with = list(/obj/structure/vehiclecage/quadtrailer)

/obj/structure/largecrate/animal
	icon_state = "lisacrate"

/obj/structure/largecrate/animal/mulebot
	name = "Mulebot crate"
	icon_state = "mulecrate"
	starts_with = list(/mob/living/bot/mulebot)

/obj/structure/largecrate/animal/corgi
	name = "corgi carrier"
	starts_with = list(/mob/living/simple_mob/animal/passive/dog/corgi)

/obj/structure/largecrate/animal/cow
	name = "cow crate"
	starts_with = list(/mob/living/simple_mob/animal/passive/cow)

/obj/structure/largecrate/animal/goat
	name = "goat crate"
	starts_with = list(/mob/living/simple_mob/animal/goat)

/obj/structure/largecrate/animal/cat
	name = "cat carrier"
	starts_with = list(/mob/living/simple_mob/animal/passive/cat)

/obj/structure/largecrate/animal/cat/bones
	starts_with = list(/mob/living/simple_mob/animal/passive/cat/bones)

/obj/structure/largecrate/animal/chick
	name = "chicken crate"
	starts_with = list(/mob/living/simple_mob/animal/passive/chick = 5)

/obj/structure/largecrate/animal/carp
	name = "space carp crate"
	starts_with = list(/mob/living/simple_mob/animal/space/carp = 3)

/obj/structure/largecrate/animal/spiders
	name = "spider crate"
	starts_with = list(/mob/living/simple_mob/animal/giant_spider= 3)

//! ## VR FILE MERGE ## !//
/obj/structure/largecrate/birds //This is an awful hack, but it's the only way to get multiple mobs spawned in one crate.
	name = "Bird crate"
	desc = "You hear chirping and cawing inside the crate. It sounds like there are a lot of birds in there..."

/obj/structure/largecrate/birds/attackby(obj/item/W as obj, mob/user as mob)
	if(W.is_crowbar())
		new /obj/item/stack/material/wood(src)
		new /mob/living/simple_mob/animal/passive/bird(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/kea(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/eclectus(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/grey_parrot(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/black_headed_caique(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/white_caique(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/budgerigar(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/budgerigar/blue(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/budgerigar/bluegreen(src)
		new /mob/living/simple_mob/animal/passive/bird/black_bird(src)
		new /mob/living/simple_mob/animal/passive/bird/azure_tit(src)
		new /mob/living/simple_mob/animal/passive/bird/european_robin(src)
		new /mob/living/simple_mob/animal/passive/bird/goldcrest(src)
		new /mob/living/simple_mob/animal/passive/bird/ringneck_dove(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/cockatiel(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/cockatiel/white(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/cockatiel/yellowish(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/cockatiel/grey(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/sulphur_cockatoo(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/white_cockatoo(src)
		new /mob/living/simple_mob/animal/passive/bird/parrot/pink_cockatoo(src)
		var/turf/T = get_turf(src)
		for(var/atom/movable/AM in contents)
			if(!(AM.flags & ATOM_ABSTRACT))
				AM.forceMove(T)
		user.visible_message("<span class='notice'>[user] pries \the [src] open.</span>", \
							 "<span class='notice'>You pry open \the [src].</span>", \
							 "<span class='notice'>You hear splitting wood.</span>")
		qdel(src)
	else
		return attack_hand(user)
/*
/obj/structure/largecrate/animal/pred
	name = "Predator carrier"
	starts_with = list(/mob/living/simple_mob/vore/catgirl)
*/

/obj/structure/largecrate/animal/pred/Initialize(mapload) //This is nessesary to get a random one each time.
	starts_with = list(pick(/mob/living/simple_mob/vore/bee,
						/mob/living/simple_mob/vore/aggressive/frog,
						/mob/living/simple_mob/vore/horse,
						/mob/living/simple_mob/vore/aggressive/panther,
						/mob/living/simple_mob/vore/aggressive/giant_snake,
						/mob/living/simple_mob/animal/wolf,
						/mob/living/simple_mob/animal/space/bear;0.5,
						/mob/living/simple_mob/animal/space/carp,
						/mob/living/simple_mob/vore/aggressive/mimic,
						/mob/living/simple_mob/vore/aggressive/rat,
						/mob/living/simple_mob/vore/aggressive/rat/tame,
//						/mob/living/simple_mob/otie;0.5
						))
	return ..()

/obj/structure/largecrate/animal/dangerous
	name = "Dangerous Predator carrier"
	starts_with = list(/mob/living/simple_mob/animal/space/alien)

/obj/structure/largecrate/animal/dangerous/Initialize(mapload)
	starts_with = list(pick(/mob/living/simple_mob/animal/space/carp/large,
						/mob/living/simple_mob/vore/aggressive/deathclaw,
						/mob/living/simple_mob/vore/aggressive/dino,
						/mob/living/simple_mob/animal/space/alien,
						/mob/living/simple_mob/animal/space/alien/drone,
						/mob/living/simple_mob/animal/space/alien/sentinel,
						/mob/living/simple_mob/animal/space/alien/queen,
						/mob/living/simple_mob/vore/aggressive/corrupthound))
	return ..()

/obj/structure/largecrate/animal/wolfgirl
	name = "Wolfgirl Crate"
	desc = "A sketchy looking crate with airholes that shakes and thuds every now and then. Someone seems to be demanding they be let out."
	starts_with = list(/mob/living/simple_mob/vore/wolfgirl)

/obj/structure/largecrate/animal/fennec
	name = "Fennec Crate"
	desc = "Bounces around a lot. Looks messily packaged, were they in a hurry?"
	starts_with = list(/mob/living/simple_mob/vore/fennec)

/obj/structure/largecrate/animal/fennec/Initialize(mapload)
	starts_with = list(pick(/mob/living/simple_mob/vore/fennec,
						/mob/living/simple_mob/vore/fennix;0.5))
	return ..()

/obj/structure/closet/crate/large/aether
	name = "large atmospherics crate"
	desc = "A hefty metal crate, painted in Aether Atmospherics and Recycling colours."
/obj/structure/closet/crate/large/einstein
	name = "large crate"
	desc = "A hefty metal crate, painted in Einstein Engines colours."
/obj/structure/closet/crate/large/nanotrasen
	name = "large crate"
	desc = "A hefty metal crate, painted in standard NanoTrasen livery."
/obj/structure/closet/crate/large/xion
	name = "large crate"
	desc = "A hefty metal crate, painted in Xion Manufacturing Group orange."
/obj/structure/closet/crate/large/secure/heph
	desc = "A hefty metal crate with an electronic locking system, marked with Hephaestus Industries colours."

/obj/structure/closet/crate/large/secure/xion
	desc = "A hefty metal crate with an electronic locking system, painted in Xion Manufacturing Group orange."
