
/obj/structure/flora
	name = "flora"
	desc = "A perfectly generic plant."
	anchored = TRUE // Usually, plants don't move. Usually.

	var/randomize_size = FALSE
	var/max_x_scale = 1.25
	var/max_y_scale = 1.25
	var/min_x_scale = 0.9
	var/min_y_scale = 0.9

	var/harvest_tool = null // The type of item used to harvest the plant.
	var/harvest_count = 0

	var/randomize_harvest_count = TRUE
	var/max_harvests = 0
	var/min_harvests = -1
	var/list/harvest_loot = null	// Should be an associative list for things to spawn, and their weights. An example would be a branch from a tree.

/obj/structure/flora/Initialize(mapload)
	. = ..()

	if(randomize_size)
		icon_scale_x = rand(min_x_scale * 100, max_x_scale * 100) / 100
		icon_scale_y = rand(min_y_scale * 100, max_y_scale * 100) / 100

		if(prob(50))
			icon_scale_x *= -1
		update_transform()

	if(randomize_harvest_count)
		max_harvests = max(0, rand(min_harvests, max_harvests)) // Incase you want to weight it more toward 'not harvestable', set min_harvests to a negative value.

/obj/structure/flora/examine(mob/user)
	. = ..()
	if(harvest_count < max_harvests)
		. += "<span class='notice'>\The [src] seems to have something hanging from it.</span>"

/obj/structure/flora/attackby(obj/item/W, mob/living/user)
	if(can_harvest(W))
		var/harvest_spawn = pickweight(harvest_loot)
		var/atom/movable/AM = spawn_harvest(harvest_spawn, user)

		if(!AM)
			to_chat(user, "<span class='notice'>You fail to harvest anything from \the [src].</span>")

		else
			to_chat(user, "<span class='notice'>You harvest \the [AM] from \the [src].</span>")
			return

	..(W, user)

/obj/structure/flora/proc/can_harvest(obj/item/I)
	. = FALSE
	if(harvest_tool && istype(I, harvest_tool) && harvest_loot && harvest_loot.len && harvest_count < max_harvests)
		. = TRUE
	return .

/obj/structure/flora/proc/spawn_harvest(path = null, mob/user = null)
	if(!ispath(path))
		return 0
	var/turf/Target = get_turf(src)
	if(user)
		Target = get_turf(user)

	var/atom/movable/AM = new path(Target)

	harvest_count++
	return AM

/****************
 *! Skeleton??? *
 ****************/

/obj/structure/flora/skeleton
	name = "hanging skeleton model"
	icon = 'icons/obj/flora/plants.dmi' // What an interesting plant.
	icon_state = "hangskele"
	desc = "It's an anatomical model of a human skeletal system made of plaster."
