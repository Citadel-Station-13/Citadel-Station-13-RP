//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * A gun-attached flashlight
 *
 * * [light_range] and [light_color] are set directly, as they don't determine
 *   if a light source is enabled.
 * * [light_power] is toggled when on/off.
 */
/obj/item/gun_attachment/flashlight
	light_range = 4.75
	light_color = "#ffffff"

	/// power when on
	var/light_power_on = 0.75

// todo: make this directional at some point
/obj/item/gun_attachment/flashlight/rail

// todo: make this directional at some point
/obj/item/gun_attachment/flashlight/maglight

#warn impl ; how do we do seclite?
