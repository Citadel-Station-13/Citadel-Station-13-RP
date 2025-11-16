//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/vehicle/sealed/mecha/examine_render_components(datum/event_args/examine/examine)
	. = ..()
	if(comp_armor)
		. += comp_armor.examine_render_on_vehicle(examine)
	else
		. += "It has no armor plating."
	if(comp_hull)
		. += comp_hull.examine_render_on_vehicle(examine)
	else
		. += "It has no hull paneling."

#warn impl
