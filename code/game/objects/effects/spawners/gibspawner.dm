/proc/gibs(atom/location, var/datum/dna/MobDNA, gibber_type = /obj/effect/gibspawner/generic, var/fleshcolor, var/bloodcolor)
	new gibber_type(location,MobDNA,fleshcolor,bloodcolor)

/obj/effect/gibspawner
	icon_state = "gibspawner"// For the map editor
	var/list/gibtypes = list() // Assoc list of typepaths of the gib decals to spawn to amount to spawn
	var/list/gibdirections = list() // Lists of possible directions to spread each gib decal type towards.
	var/sparks = 0 //whether sparks spread on Gib()
	var/list/gibamounts = list()
	var/fleshcolor //Used for gibbed humans.
	var/bloodcolor //Used for gibbed humans.

/obj/effect/gibspawner/Initialize(mapload, datum/dna/MobDNA, fleshcolor, bloodcolor)
	..()

	if(fleshcolor)
		src.fleshcolor = fleshcolor
	if(bloodcolor)
		src.bloodcolor = bloodcolor
	Gib(loc,MobDNA)

	return INITIALIZE_HINT_QDEL

/obj/effect/gibspawner/proc/Gib(atom/location, datum/dna/MobDNA = null)
	if(gibtypes.len != gibamounts.len || gibamounts.len != gibdirections.len)
		to_chat(world, SPAN_WARNING("Gib list length mismatch!"))
		return

	var/obj/effect/debris/cleanable/blood/gibs/gib = null

	if(sparks)
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread()
		s.set_up(2, 1, get_turf(location)) // Not sure if it's safe to pass an arbitrary object to set_up, todo
		s.start()

	for(var/i = 1, i<= gibtypes.len, i++)
		if(gibamounts[i])
			for(var/j = 1, j<= gibamounts[i], j++)
				var/gibType = gibtypes[i]
				gib = new gibType(location)

				// Apply human species colouration to masks.
				if(fleshcolor)
					gib.fleshcolor = fleshcolor
				if(bloodcolor)
					gib.basecolor = bloodcolor

				gib.update_icon()

				gib.blood_DNA = list()
				if(MobDNA)
					gib.blood_DNA[MobDNA.unique_enzymes] = MobDNA.b_type
				else if(istype(src, /obj/effect/gibspawner/human)) // Probably a monkey
					gib.blood_DNA["Non-human DNA"] = "A+"
				if(istype(location,/turf/))
					var/list/directions = gibdirections[i]
					if(directions.len)
						gib.streak(directions)

	qdel(src)

/obj/effect/gibspawner/generic
	gibtypes = list(/obj/effect/debris/cleanable/blood/gibs,/obj/effect/debris/cleanable/blood/gibs,/obj/effect/debris/cleanable/blood/gibs/core)
	gibamounts = list(2,2,1)

/obj/effect/gibspawner/generic/Initialize(mapload, datum/dna/MobDNA, fleshcolor, bloodcolor)
	gibdirections = list(
		list(WEST, NORTHWEST, SOUTHWEST, NORTH),
		list(EAST, NORTHEAST, SOUTHEAST, SOUTH),
		list(),
	)
	return ..()

/obj/effect/gibspawner/human
	gibtypes = list(/obj/effect/debris/cleanable/blood/gibs,/obj/effect/debris/cleanable/blood/gibs/down,/obj/effect/debris/cleanable/blood/gibs,/obj/effect/debris/cleanable/blood/gibs,/obj/effect/debris/cleanable/blood/gibs,/obj/effect/debris/cleanable/blood/gibs,/obj/effect/debris/cleanable/blood/gibs/core)
	gibamounts = list(1,1,1,1,1,1,1)

/obj/effect/gibspawner/human/Initialize(mapload, datum/dna/MobDNA, fleshcolor, bloodcolor)
	gibdirections = list(
		list(NORTH, NORTHEAST, NORTHWEST),
		list(SOUTH, SOUTHEAST, SOUTHWEST),
		list(WEST, NORTHWEST, SOUTHWEST),
		list(EAST, NORTHEAST, SOUTHEAST),
		GLOB.alldirs,
		GLOB.alldirs,
		list(),
	)
	gibamounts[6] = pick(0,1,2)
	return ..()

/obj/effect/gibspawner/robot
	sparks = 1
	gibtypes = list(/obj/effect/debris/cleanable/blood/gibs/robot/up,/obj/effect/debris/cleanable/blood/gibs/robot/down,/obj/effect/debris/cleanable/blood/gibs/robot,/obj/effect/debris/cleanable/blood/gibs/robot,/obj/effect/debris/cleanable/blood/gibs/robot,/obj/effect/debris/cleanable/blood/gibs/robot/limb)
	gibamounts = list(1,1,1,1,1,1)

/obj/effect/gibspawner/robot/Initialize(mapload, datum/dna/MobDNA, fleshcolor, bloodcolor)
	gibdirections = list(
		list(NORTH, NORTHEAST, NORTHWEST),
		list(SOUTH, SOUTHEAST, SOUTHWEST),
		list(WEST, NORTHWEST, SOUTHWEST),
		list(EAST, NORTHEAST, SOUTHEAST),
		GLOB.alldirs,
		GLOB.alldirs,
	)
	gibamounts[6] = pick(0,1,2)
	return ..()
