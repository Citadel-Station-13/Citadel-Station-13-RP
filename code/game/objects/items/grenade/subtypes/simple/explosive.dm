/obj/item/grenade/simple/explosive
	name = "fragmentation grenade"
	desc = "A fragmentation grenade, optimized for harming personnel without causing massive structural damage."
	icon_state = "frag"
	worn_state = "grenade"

	var/ex_size_1 = 0
	var/ex_size_2 = 0
	var/ex_size_3 = 2
	var/ex_size_flash = 1

	var/fragment_types = list(/obj/projectile/bullet/pellet/fragment, /obj/projectile/bullet/pellet/fragment, /obj/projectile/bullet/pellet/fragment, /obj/projectile/bullet/pellet/fragment/strong)
	/// total number of fragments produced by the grenade
	var/num_fragments = 63
	/// The radius of the circle used to launch projectiles. Lower values mean less projectiles are used but if set too low gaps may appear in the spread pattern
	var/spread_range = 7
	loadable = null

/obj/item/grenade/simple/explosive/on_detonate(turf/location)
	..()
	shrapnel_explosion(num_fragments, spread_range, fragment_types)
	explosion(location, ex_size_1, ex_size_2, ex_size_3, ex_size_flash)

// Waaaaay more pellets
/obj/item/grenade/simple/explosive/frag
	name = "fragmentation grenade"
	desc = "A military fragmentation grenade, designed to explode in a deadly shower of fragments."
	icon_state = "frag2"
	loadable = null

	fragment_types = list(/obj/projectile/bullet/pellet/fragment)
	num_fragments = 200  //total number of fragments produced by the grenade

/obj/item/grenade/simple/explosive/mini
	name = "mini fragmentation grenade"
	desc = "A miniaturized fragmentation grenade, this one poses relatively little threat on its own."
	icon_state = "minifrag"
	fragment_types = list(/obj/projectile/bullet/pellet/fragment/weak, /obj/projectile/bullet/pellet/fragment/weak, /obj/projectile/bullet/pellet/fragment, /obj/projectile/bullet/pellet/fragment/strong)
	ex_size_3 = 1
	num_fragments = 20
	spread_range = 3

/obj/item/grenade/simple/explosive/ied
	name = "improvised explosive device"
	desc = "A crude explosive device made out of common household materials, designed to rupture and send shrapnel out in a wide radius."
	icon_state = "ied"
	fragment_types = list(/obj/projectile/bullet/pellet/fragment/weak, /obj/projectile/bullet/pellet/fragment/weak, /obj/projectile/bullet/pellet/fragment, /obj/projectile/bullet/pellet/fragment/strong)
	ex_size_3 = 1
	num_fragments = 20
	spread_range = 3
	activation_detonate_delay = 20

/obj/item/grenade/simple/explosive/ied/Initialize(mapload)
	. = ..()
	var/list/times = list("5" = 10, "-1" = 20, "[rand(30,80)]" = 50, "[rand(65,180)]" = 20)// "Premature, Dud, Short Fuse, Long Fuse"=[weighting value]
	activation_detonate_delay = text2num(pickweight(times))
	if(activation_detonate_delay < 0) //checking for 'duds'
		ex_size_3 = 1
		activation_detonate_delay = rand(30,80)
	else
		ex_size_3 = pick(2,2,2,3,3,3,4)

/obj/item/grenade/simple/explosive/ied/tyrmalin
	name = "\improper Tyrmalin mining charge"
	desc = "A stick of dynamite with a crude blasting cap and timer assembly attached. These volatile explosives are frequently used by Tyrmalin for blast mining. It does not look safe."
	icon_state = "goblincharge"
	ex_size_2 = 2
	ex_size_3 = 4
	ex_size_flash = 7
	fragment_types = list(/obj/projectile/bullet/pellet/fragment/weak, /obj/projectile/bullet/pellet/fragment/weak, /obj/projectile/bullet/pellet/fragment/strong)
	num_fragments = 10
	spread_range = 3
	activation_detonate_delay = 20
	worth_intrinsic = 75

/obj/item/grenade/simple/explosive/ied/tyrmalin/large
	name = "\improper Tyrmalin heavy-duty mining charge"
	desc = "A hefty bundle of hastily rigged dynamite. These bulky explosives are preferred for Tyrmalin blast mining operations. It does not look safe."
	icon_state = "goblincharge_big"
	ex_size_1 = 3
	ex_size_2 = 5
	ex_size_3 = 7
	ex_size_flash = 11
	fragment_types = list(/obj/projectile/bullet/pellet/fragment/weak, /obj/projectile/bullet/pellet/fragment/weak, /obj/projectile/bullet/pellet/fragment/weak, /obj/projectile/bullet/pellet/fragment/strong, /obj/projectile/bullet/pellet/fragment/strong)
	num_fragments = 30
	spread_range = 5
	activation_detonate_delay = 20

//Ashlander Frag Grenade
/obj/item/grenade/simple/explosive/ashlander
	name = "\improper heaven shaker"
	desc = "A clay ball packed with alchemical solution. A small fleck of elderstone protrudes from the sphere - it looks like it can be depressed."
	icon_state = "ashlandercharge"
	ex_size_1 = 1
	ex_size_2 = 3
	ex_size_3 = 5
	ex_size_flash = 7
	fragment_types = list(/obj/projectile/bullet/pellet/fragment/weak, /obj/projectile/bullet/pellet/fragment/weak, /obj/projectile/bullet/pellet/fragment/strong)
	num_fragments = 5
	spread_range = 3
	activation_detonate_delay = 40

/obj/item/grenade/simple/explosive/ashlander/fragmentation
	name = "\improper heaven shaker (fragmentation)"
	desc = "A scored clay ball packed with alchemical solution. A small fleck of elderstone protrudes from the sphere - it looks like it can be depressed."
	ex_size_1 = 0
	ex_size_2 = 1
	ex_size_3 = 3
	ex_size_flash = 7
	fragment_types = list(/obj/projectile/bullet/pellet/fragment, /obj/projectile/bullet/pellet/fragment/strong, /obj/projectile/bullet/pellet/fragment/strong)
	num_fragments = 150
	spread_range = 3
