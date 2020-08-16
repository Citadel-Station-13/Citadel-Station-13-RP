
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// fossils

/obj/item/fossil
	name = "Fossil"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "bone"
	desc = "It's a fossil."
	var/animal = 1
	var/processable = FALSE

/obj/item/fossil/base/Initialize(mapload)
	. = ..()
	var/list/l = list("/obj/item/fossil/bone"=9,"/obj/item/fossil/skull"=3,
	"/obj/item/fossil/skull/horned"=2)
	var/t = pickweight(l)
	var/obj/item/W = new t(drop_location())
	var/turf/T = get_turf(src)
	if(istype(T, /turf/simulated/mineral))
		var/turf/simulated/mineral/M = T
		M.last_find = W
	qdel(src)

/obj/item/fossil/bone
	name = "Fossilised bone"
	icon_state = "bone"
	desc = "It's a fossilised bone."

/obj/item/fossil/skull
	name = "Fossilised skull"
	icon_state = "skull"
	desc = "It's a fossilised skull."

/obj/item/fossil/skull/horned
	icon_state = "hskull"
	desc = "It's a fossilised, horned skull."

/obj/item/fossil/skull/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/fossil/bone))
		var/obj/o = new /obj/skeleton(get_turf(src))
		var/a = new /obj/item/fossil/bone
		var/b = new type
		o.contents.Add(a)
		o.contents.Add(b)
		qdel(W)
		qdel(src)

/obj/skeleton
	name = "Incomplete skeleton"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "uskel"
	desc = "Incomplete skeleton."
	var/bnum = 1
	var/breq
	var/bstate = 0
	var/plaque_contents = "Unnamed alien creature"

/obj/skeleton/Initialize(mapload)
	. = ..()
	breq = rand(6)+3
	desc = "An incomplete skeleton, looks like it could use [breq-bnum] more bones."

/obj/skeleton/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/fossil/bone))
		if(!bstate)
			bnum++
			contents.Add(new/obj/item/fossil/bone)
			qdel(W)
			if(bnum==breq)
				usr = user
				icon_state = "skel"
				bstate = 1
				density = 1
				name = "alien skeleton display"
				if(contents.Find(/obj/item/fossil/skull/horned))
					desc = "A creature made of [contents.len-1] assorted bones and a horned skull. The plaque reads \'[plaque_contents]\'."
				else
					desc = "A creature made of [contents.len-1] assorted bones and a skull. The plaque reads \'[plaque_contents]\'."
			else
				desc = "Incomplete skeleton, looks like it could use [breq-bnum] more bones."
				to_chat(user, "Looks like it could use [breq-bnum] more bones.")
		else
			..()
	else if(istype(W,/obj/item/pen))
		plaque_contents = sanitize(input("What would you like to write on the plaque:","Skeleton plaque",""))
		user.visible_message("[user] writes something on the base of [src].","You relabel the plaque on the base of \icon[src] [src].")
		if(contents.Find(/obj/item/fossil/skull/horned))
			desc = "A creature made of [contents.len-1] assorted bones and a horned skull. The plaque reads \'[plaque_contents]\'."
		else
			desc = "A creature made of [contents.len-1] assorted bones and a skull. The plaque reads \'[plaque_contents]\'."
	else
		..()

//shells and plants do not make skeletons
/obj/item/fossil/shell
	name = "Fossilised shell"
	icon_state = "shell"
	desc = "It's a fossilised shell."

/obj/item/fossil/plant
	name = "Fossilised plant"
	icon_state = "plant1"
	desc = "It's fossilised plant remains."
	animal = 0
	processable = "seed"


/obj/item/fossil/plant/Initialize(mapload)
	. = ..()
	icon_state = "plant[rand(1,4)]"
