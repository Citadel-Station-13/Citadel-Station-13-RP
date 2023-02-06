/**
 * expensive way of rendering a hologram icon
 *
 * returns an /icon
 *
 * @params
 * * rendering - what to render; must be /atom, /appearance, /mutable_appearance, or /icon.
 *     if you use an /icon it should only have one state if at all possible.
 * * no_anim - kill any animations.
 */
/proc/render_hologram_icon(rendering, no_anim)
	var/icon/processing
	if(!isicon(rendering))
		// cursed : operator; see params for why.
		processing = get_compound_icon(rendering, no_anim = no_anim)
	else
		if(no_anim)
			processing = icon(rendering, frame = 1)
		else
			processing = icon(rendering)
	#warn impl

/**
 * cheap way of just rendering an appearance for a hologram
 *
 * returns a /mutable_appearance
 *
 * @params
 * * rendering - what to render; must be /atom, /appearance, /mutable_appearance, or /icon
 */
/proc/make_hologram_appearance(rendering)


	var/mutable_appearance/rendering
	if(isicon(rendering))

	else

	#warn impl

