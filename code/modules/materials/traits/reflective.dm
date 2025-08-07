//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/prototype/material_trait/reflective
	id = "reflective"

// todo: reference code

	// if(istype(Proj,/obj/projectile/beam))
	// 	if(material && material.reflectivity >= 0.5) // Time to reflect lasers.
	// 		var/new_damage = damage * material.reflectivity
	// 		var/outgoing_damage = damage - new_damage
	// 		damage = new_damage
	// 		Proj.damage = outgoing_damage

	// 		visible_message("<span class='danger'>\The [src] reflects \the [Proj]!</span>")

	// 		// Find a turf near or on the original location to bounce to
	// 		var/new_x = Proj.starting.x + pick(0, 0, 0, -1, 1, -2, 2)
	// 		var/new_y = Proj.starting.y + pick(0, 0, 0, -1, 1, -2, 2)
	// 		//var/turf/curloc = get_turf(src)
	// 		var/turf/curloc = get_step(src, get_dir(src, Proj.starting))

	// 		Proj.penetrating += 1 // Needed for the beam to get out of the wall.

	// 		// redirect the projectile
	// 		Proj.redirect(new_x, new_y, curloc, null)
