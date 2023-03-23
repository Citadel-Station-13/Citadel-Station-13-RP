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
 * * scanlines - include scanlines
 * * no_anim - kill any animations.
 */
/proc/render_hologram_icon(rendering, use_alpha = (140 / 255), no_anim, scanlines = TRUE)
	var/icon/processing
	if(!isicon(rendering))
		// cursed : operator; see params for why.
		processing = get_compound_icon(rendering, no_anim = no_anim)
	else
		if(no_anim)
			processing = icon(rendering, frame = 1)
		else
			processing = icon(rendering)
	if(scanlines)
		processing.alpha_mask(icon('icons/system/alphamask_32x32.dmi', "scanline"))
	if(!isnull(use_alpha))
		processing.MapColors(arglist(rgba_construct_color_matrix(aa = use_alpha)))
	return processing

GLOBAL_LIST_EMPTY(hologram_scanline_cache)

/**
 * cheap way of just rendering an appearance for a hologram
 * does not color the appearance
 *
 * returns a /mutable_appearance
 *
 * @params
 * * rendering - what to render; must be /atom, /appearance, /image, /mutable_appearance, or /icon
 * * use_alpha - what alpha to render it as
 * * scanlines - include scanlines
 */
/proc/make_hologram_appearance(rendering, use_alpha = (140 / 255), scanlines = TRUE)
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
	if(scanlines)
		var/icon/I = rendered.icon
		var/width = I.Width()
		var/height = I.Height()
		var/key = "[width]x[height]"
		if(!GLOB.hologram_scanline_cache[key])
			var/icon/generated = icon('icons/system/alphamask_32x32.dmi', "scanline")
			generated.Scale(width, height)
			GLOB.hologram_scanline_cache = generated
		rendered.filters += filter(
			type = "alpha",
			icon = GLOB.hologram_scanline_cache[key],
		)
	rendered.appearance_flags |= KEEP_TOGETHER
	return rendered


