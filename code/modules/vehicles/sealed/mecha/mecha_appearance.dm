

/obj/vehicle/sealed/mecha
	// Show the pilot.
	var/show_pilot = FALSE

	// The state of the 'face', or the thing that overlays on the pilot. If this isn't set, it will probably look really weird.
	var/face_state = null
	var/icon/face_overlay

	var/icon/pilot_image

	// How many pixels do we bump the pilot upward?
	var/pilot_lift = 0

/obj/vehicle/sealed/mecha/apply_transform(matrix/to_apply)
	animate(src, transform = to_apply, time = 1 SECONDS)

/obj/vehicle/sealed/mecha/base_transform(matrix/applying)
	var/matrix/base_matrix = ..()
	base_matrix.Translate(0, 16 * (icon_scale_y - 1))
	return base_matrix

/obj/vehicle/sealed/mecha/update_icon()
	if(!initial_icon)
		initial_icon = initial(icon_state)

	if(occupant_legacy)
		icon_state = initial_icon
	else
		icon_state = "[initial_icon]-open"

	cut_overlays()

	if(show_pilot)
		if(occupant_legacy)
			pilot_image = get_compound_icon(occupant_legacy)

			if(!istype(occupant_legacy, /mob/living/carbon/brain))

				var/icon/Cutter

				if("[initial_icon]_cutter" in icon_states(icon))
					Cutter = new(src.icon, "[initial_icon]_cutter")

				if(Cutter)
					pilot_image.Blend(Cutter, ICON_MULTIPLY, y = (-1 * pilot_lift))

				var/image/Pilot = image(pilot_image)

				Pilot.pixel_y = pilot_lift

				add_overlay(Pilot)
		else
			pilot_image = null

	if(face_state && !face_overlay)
		face_overlay = new(src.icon, icon_state = face_state)

	if(face_overlay)
		add_overlay(face_overlay)

	for(var/obj/item/vehicle_module/ME in equipment)

		ME.add_equip_overlay(src)
