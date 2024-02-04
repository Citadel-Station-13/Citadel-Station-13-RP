/**
 * base type of crayon decals
 *
 * allows for partially shaded debris drawn on the floor via crayon or spraycans.
 */
/obj/effect/debris/cleanable/crayon
	name = "crayon stuff"
	desc = "A scribbling in crayon."
	icon = 'icons/modules/artwork/debris/crayon_paint_32x32.dmi'
	icon_state = "largebrush"

	// turn angle, clockwise of north
	var/turn_angle = 0

/obj/effect/debris/cleanable/crayon/Initialize(mapload, datum/crayon_decal_meta/meta, color, state, angle)
	. = ..()

	if(isnull(meta))
		return

	// init crayon
	icon = meta.icon_ref
	color = color
	icon_state = state

	// init turn
	if(angle)
		turn_angle = angle
		var/matrix/turning = matrix()
		turning.Turn(turn_angle)
		transform = turning

	// todo: maybe just log this instead of doing this bullsiht?
	add_hiddenprint(usr)

#warn below

/obj/effect/debris/cleanable/crayon/chalk
	name = "arcane rune"
	desc = "A rune drawn in chalk."
	icon = 'icons/obj/rune.dmi'
	anchored = 1

/obj/effect/debris/cleanable/crayon/chalk/New(location, main = "#FFFFFF", shade = "#000000", type = "rune")
	..()
	loc = location

	name = type
	desc = "A [type] drawn in chalk."

	switch(type)
		if("rune")
			type = "rune[rand(1,6)]"
		if("graffiti")
			type = pick("end","uboa")

	var/icon/mainOverlay = new/icon('icons/effects/crayondecal.dmi',"[type]",2.1)
	var/icon/shadeOverlay = new/icon('icons/effects/crayondecal.dmi',"[type]s",2.1)

	mainOverlay.Blend(main,ICON_ADD)
	shadeOverlay.Blend(shade,ICON_ADD)

	var/list/overlays_to_add = list()
	overlays_to_add += mainOverlay
	overlays_to_add += shadeOverlay
	add_overlay(overlays_to_add)

	add_hiddenprint(usr)
