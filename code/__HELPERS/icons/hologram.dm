/**
 * expensive way of rendering a hologram icon
 * does not color the appearance
 *
 * returns an /icon
 *
 * @params
 * * rendering - what to render; must be /atom, /appearance, /mutable_appearance, or /icon.
 *     if you use an /icon it should only have one state if at all possible.
 * * use_alpha - what alpha to render it as
 * * no_anim - kill any animations.
 */
/proc/render_hologram_icon(rendering, use_alpha = (140 / 255), no_anim)
	var/icon/processing
	if(!isicon(rendering))
		// cursed : operator; see params for why.
		processing = get_compound_icon(rendering, no_anim = no_anim)
	else
		if(no_anim)
			processing = icon(rendering, frame = 1)
		else
			processing = icon(rendering)
	#warn render in scanlines
	if(!isnull(use_alpha))
		processing.MapColors(arglist(rgba_construct_color_matrix(aa = use_alpha)))
	return processing

/**
 * cheap way of just rendering an appearance for a hologram
 * does not color the appearance
 *
 * returns a /mutable_appearance
 *
 * @params
 * * rendering - what to render; must be /atom, /appearance, /image, /mutable_appearance, or /icon
 * * use_alpha - what alpha to render it as
 */
/proc/make_hologram_appearance(rendering, use_alpha = (140 / 255))
	var/appearance/compiling
	if(isicon(rendering))
		compiling = icon2appearance(rendering)
	else if(ismutableappearance(rendering))
		compiling = rendering:appearance
	else // /atom, /appearance, /image
		compiling = rendering:appearance
	var/mutable_appearance/rendered = new(compiling)
	if(!isnull(use_alpha))
		rendered.alpha = use_alpha
	#warn alpha mask scanlines
	return rendered

