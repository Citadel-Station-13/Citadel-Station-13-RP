/obj/item/grenade/simple/concussion
	name = "concussion grenade"
	desc = "A polymer concussion grenade, optimized for disorienting personnel without causing large amounts of injury."
	icon_state = "concussion"
	item_state = "grenade"

	var/blast_radius = 5

/obj/item/grenade/simple/concussion/on_detonate(turf/location, atom/grenade_location)
	..()
	SSspatial_effects.run_concussion_blast(location, blast_radius)

/obj/item/grenade/simple/concussion/frag
	name = "concussion-frag grenade"
	desc = "A polymer and steel concussion grenade, optimized for disorienting personnel and being accused of war crimes."
	icon_state = "conc-frag"

	var/fragment_types = list(/obj/projectile/bullet/pellet/fragment, /obj/projectile/bullet/pellet/fragment/strong, /obj/projectile/bullet/pellet/fragment/rubber, /obj/projectile/bullet/pellet/fragment/rubber/strong)
	var/num_fragments = 40  //total number of fragments produced by the grenade
	var/spread_range = 5 // for above and below, see code\game\objects\items\weapons\grenades\explosive.dm

/obj/item/grenade/simple/concussion/frag/on_detonate(turf/location, atom/grenade_location)
	..()
	shrapnel_explosion(num_fragments, spread_range, fragment_types)
