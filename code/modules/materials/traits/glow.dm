//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * It makes things glow.
 *
 * Data should be list("power" = power, "range" = range, "color" = color, "sensitivity" = sensitivity)
 * sensitivity is a multiplier for how sensitive we are to material_trait_multiplier.
 *
 * todo: does not support blending data together yet. also does not support 'stacking' multiple together, so this is primary_only for now.
 * todo: this currently ignores sensitivity & significance. this is probably a good thing due to how badly light stacking can get.
 * todo: lohikar said to just let lightning engine do blending; we'll see but i want to avoid too many virtual lighting objects if people get insane with the glow materials.
 */
/datum/material_trait/glow
	primary_only = TRUE

/datum/material_trait/glow/on_add(atom/host, existing_data, our_data)
	. = ..()
	var/atom/movable/render/material_glow/renderer
	if(isnull(existing_data))
		renderer = new
		host.contents += renderer
	else
		renderer = locate() in host.contents
	renderer.set_light(our_data["power"], our_data["range"], our_data["color"])

/datum/material_trait/glow/on_remove(atom/host, existing_data, our_data)
	. = ..()
	qdel(locate(/atom/movable/render/material_glow/renderer) in what.contents)

/atom/movable/render/material_glow

/atom/movable/render/material_glow/doMove(atom/destination)
	if(!QDESTROYING(src))
		CRASH("something tried to move us")
	return ..()
