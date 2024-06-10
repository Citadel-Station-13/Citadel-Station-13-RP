//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * base type of crayon decals
 *
 * allows for partially shaded debris drawn on the floor via crayon or spraycans.
 */
/obj/effect/debris/cleanable/crayon
	name = "crayon scribble"
	desc = "A scribbling in crayon."
	icon = 'icons/modules/artwork/debris/crayon_paint_32x32.dmi'
	icon_state = "largebrush"

	// turn angle, clockwise of north
	var/turn_angle = 0

/obj/effect/debris/cleanable/crayon/Initialize(mapload, datum/crayon_decal_meta/meta, color, state, angle, pixel_x, pixel_y)
	. = ..()

	if(isnull(meta))
		return

	// init crayon
	icon = meta.icon_ref
	src.color = color
	src.pixel_x = pixel_x + meta.centering_pixel_x
	src.pixel_y = pixel_y + meta.centering_pixel_y
	icon_state = state

	// init turn
	if(angle)
		turn_angle = angle
		var/matrix/turning = matrix()
		turning.Turn(turn_angle)
		transform = turning

	// todo: maybe just log drawing instead of doing this bullsiht?
	add_hiddenprint(usr)

/obj/effect/debris/cleanable/crayon/serialize()
	. = ..()
	.["angle"] = turn_angle
	.["color"] = color
	.["icon"] = "[icon]"
	.["state"] = icon_state
	.["pixel_x"] = pixel_x
	.["pixel_y"] = pixel_y

/obj/effect/debris/cleanable/crayon/deserialize(list/data)
	. = ..()
	var/icon_path_as_string = data["icon"]
	var/datum/crayon_decal_meta/metadata = GLOB.crayon_data_lookup_by_string_icon_path[icon_path_as_string]
	if(isnull(metadata))
		return FALSE
	var/state = data["state"]
	if(!(state in metadata.states))
		return FALSE
	icon = metadata.icon_ref
	icon_state = state
	var/angle = data["angle"]
	if(angle)
		turn_angle = angle
		var/matrix/turning = matrix()
		turning.Turn(turn_angle)
		transform = turning
	color = data["color"]
	pixel_x = data["pixel_x"]
	pixel_y = data["pixel_y"]

/obj/effect/debris/cleanable/crayon/chalk
	name = "chalk drawing"
	desc = "A scribbling in chalk."

/obj/effect/debris/cleanable/crayon/marker
	name = "marker sketch"
	desc = "A sketch made with a marker."

/obj/effect/debris/cleanable/crayon/spraycan
	name = "sprayed graffiti"
	desc = "A symbol made with spray paint."
