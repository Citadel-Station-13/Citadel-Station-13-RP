

/obj/mecha
	// Show the pilot.
	var/show_pilot = FALSE

	// The state of the 'face', or the thing that overlays on the pilot. If this isn't set, it will probably look really weird.
	var/face_state = null
	var/icon/face_overlay

	var/mutable_appearance/pilot_appearance

	// How many pixels do we bump the pilot upward?
	var/pilot_lift = 0

/obj/mecha/update_transform()
	// Now for the regular stuff.
	var/matrix/M = matrix()
	M.Scale(icon_scale_x, icon_scale_y)
	M.Translate(0, 16*(icon_scale_y-1))
	animate(src, transform = M, time = 10)
	return

/obj/mecha/update_icon()
	if(!initial_icon)
		initial_icon = initial(icon_state)

	if(occupant)
		icon_state = initial_icon
	else
		icon_state = "[initial_icon]-open"

	cut_overlays()

	if(show_pilot)
		if(occupant && !istype(occupant, /mob/living/carbon/brain))
			pilot_appearance = new
			pilot_appearance.appearance = occupant
			pilot_appearance.plane = plane
			pilot_appearance.layer = FLOAT_LAYER
			// sue me
			pilot_appearance.appearance_flags |= KEEP_TOGETHER | KEEP_APART

			var/icon/Cutter
			if("[initial_icon]_cutter" in icon_states(icon))
				Cutter = new(src.icon, "[initial_icon]_cutter")

			if(Cutter)
				var/mutable_appearance/cutter_appearance = mutable_appearance(Cutter, layer = FLOAT_LAYER)
				cutter_appearance.blend_mode = BLEND_MULTIPLY
				cutter_appearance.pixel_y = -pilot_lift
				pilot_appearance.overlays += cutter_appearance

			pilot_appearance.pixel_y = pilot_lift

			add_overlay(pilot_appearance)
		else
			pilot_appearance = null

	if(face_state && !face_overlay)
		face_overlay = new(src.icon, icon_state = face_state)

	if(face_overlay)
		add_overlay(face_overlay)

	for(var/obj/item/mecha_parts/mecha_equipment/ME in equipment)
		ME.add_equip_overlay(src)
