GLOBAL_LIST_INIT(holograms, __init_holograms())

/proc/__init_holograms()
	. = list()
	for(var/datum/hologram/H as anything in subtypesof(/datum/hologram))
		if(initial(H.abstract_type) == H)
			continue
		H = new H
		if(!H.name)
			stack_trace("null name on [H.type]")
			continue
		if(.[H.name])
			// dreaded colon operator
			stack_trace("collision on [H.type] vs [.[H.name]:type].")
			continue
		.[H.name] = H
	tim_sort(., GLOBAL_PROC_REF(name_asc), TRUE)

/**
 * fetches a hologram datum
 *
 * @params
 * * typepath_or_name - a /datum/hologram typepath or the name
 */
/proc/fetch_hologram_datum(datum/hologram/typepath_or_name)
	RETURN_TYPE(/datum/hologram)
	if(ispath(typepath_or_name))
		typepath_or_name = initial(typepath_or_name.name)
	return GLOB.holograms[typepath_or_name]

/datum/hologram
	abstract_type = /datum/hologram

	/// our name - must be unique
	var/name
	/// our category
	var/category
	/// icon file
	var/icon
	/// icon state
	var/icon_state
	/// are we precolored? if so, don't re-color unless we're doing a forceful matrix multiply to force another color.
	var/already_colored = FALSE
	/// do we already have scanlines? if so, don't apply scanline overlays
	var/already_scanlined = FALSE

/datum/hologram/proc/render(cheap, alpha = 140 / 255, color = "#55ccff")
	if(cheap)
		var/mutable_appearance/rendering = make_hologram_appearance(image(icon = icon, icon_state = icon_state), alpha)
		rendering.color = rgba_auto_greyscale_matrix(color)
		return rendering
	else
		var/icon/rendering = render_hologram_icon(image(icon = icon, icon_state = icon_state), alpha)
		rendering.MapColors(arglist(rgba_auto_greyscale_matrix(color)))
		return rendering

/datum/hologram/proc/render_greyscale(cheap, alpha = 140 / 255)
	if(cheap)
		var/mutable_appearance/rendering = make_hologram_appearance(image(icon = icon, icon_state = icon_state), alpha)
		rendering.color = color_matrix_greyscale()
		return rendering

	else
		var/icon/rendering = render_hologram_icon(image(icon = icon, icon_state = icon_state), alpha)
		rendering.MapColors(arglist(color_matrix_greyscale()))
		return rendering
