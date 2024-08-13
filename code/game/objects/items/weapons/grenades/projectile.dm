/obj/item/grenade/shooter
	name = "projectile grenade"	// I have no idea what else to call this, but the base type should never be used
	icon_state = "frggrenade"
	item_state = "grenade"

	var/list/projectile_types = list(/obj/projectile/bullet/pistol/rubber)	// What sorts of projectiles might we make?

	//The radius of the circle used to launch projectiles. Lower values mean less projectiles are used but if set too low gaps may appear in the spread pattern
	var/spread_range = 7
	var/total_pellets = 1 // default value of 1 just forces one per turf as we round up

	loadable = FALSE

/obj/item/grenade/shooter/detonate()
	..()

	var/turf/O = get_turf(src)
	if(!O)
		return

	shrapnel_explosion(total_pellets, spread_range, projectile_types)
	qdel(src)

/obj/item/grenade/shooter/rubber
	name = "rubber pellet grenade"
	desc = "An anti-riot grenade that fires a cloud of rubber projectiles upon detonation."
	projectile_types = list(/obj/projectile/bullet/pistol/rubber)

// Exists mostly so I don't have to copy+paste the sprite vars to a billion things
/obj/item/grenade/shooter/energy
	icon_state = "flashbang"
	item_state = "flashbang"
	spread_range = 3	// Because dear god

/obj/item/grenade/shooter/energy/laser
	name = "laser grenade"
	desc = "A horrifically dangerous rave in a can."
	projectile_types = list(/obj/projectile/beam/midlaser)

/obj/item/grenade/shooter/energy/flash
	name = "flash grenade"
	desc = "A grenade that creates a large number of flashes upon detonation."
	projectile_types = list(/obj/projectile/energy/flash)

/obj/item/grenade/shooter/energy/tesla
	name = "tesla grenade"
	projectile_types = list(/obj/projectile/beam/chain_lightning/lesser)
