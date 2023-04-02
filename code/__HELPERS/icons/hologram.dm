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
/proc/render_hologram_icon(rendering, use_alpha, no_anim, scanlines = TRUE)
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
		processing.MapColors(arglist(construct_rgba_color_matrix(aa = use_alpha)))
	return processing

GLOBAL_LIST_EMPTY(hologram_scanline_renders)

/proc/hologram_scanline_renderer(width, height)
	var/key = "[width]x[height]"
	var/atom/movable/screen/render/scanline/cached = GLOB.hologram_scanline_renders[key]
	if(isnull(cached))
		cached = new
		cached.render_target = RENDER_SOURCE_HOLOGRAM(key)
		var/icon/generated = icon('icons/system/alphamask_32x32.dmi', "scanline")
		generated.Scale(width, height)
		cached.icon = generated
		GLOB.hologram_scanline_renders[key] = cached
	return cached

/atom/movable/screen/render/scanline

GLOBAL_LIST_EMPTY(hologram_scanline_inverses)

/**
 * output icons have white lines suitable for BLEND_SUBTRACT-ing.
 */
/proc/hologram_scanline_inverse(width, height)
	var/key = "[width]x[height]"
	var/icon/cached = GLOB.hologram_scanline_inverses[key]
	if(isnull(cached))
		cached = icon('icons/system/alphamask_32x32.dmi', "scanline")
		cached.MapColors(arglist(construct_rgba_color_matrix(aa = -1000000, cr = 1, cg = 1, cb = 1, ca = 1)))
		cached.Scale(width, height)
		GLOB.hologram_scanline_inverses[key] = cached
	return cached

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
/proc/make_hologram_appearance(rendering, use_alpha = 140, scanlines = TRUE)
	var/mutable_appearance/rendered
	if(isicon(rendering))
		rendered = new(rendering)
	else if(ismutableappearance(rendering) || isimage(rendering) || IS_APPEARANCE(rendering))
		rendered = new(rendering)
	else if(isatom(rendering))
		var/atom/casted = rendering
		casted.compile_overlays()
		rendered = new(casted)
	else
		CRASH("unexpected input: [rendering]")
	if(!isnull(use_alpha))
		rendered.alpha = use_alpha
	if(scanlines)
		var/icon/I = rendered.icon
		var/width = 32
		var/height = 32
		if(!istype(I, /icon) && I)
			I = icon(I) // try to grab it from stringw
		if(istype(I, /icon))
			width = I.Width()
			height = I.Height()
		var/image/the_overlay = image(hologram_scanline_inverse(width, height), layer = FLOAT_LAYER)
		the_overlay.blend_mode = BLEND_SUBTRACT
		rendered.overlays += the_overlay
	rendered.appearance_flags |= KEEP_TOGETHER
	rendered.density = FALSE
	rendered.opacity = FALSE
	return rendered

/atom/movable/proc/amask_test()
	var/atom/movable/screen/render/renderer = hologram_scanline_renderer(32, 32)
	vis_contents += renderer
	add_filter("test", 1, alpha_mask_filter(render_source = renderer.render_target))

/atom/proc/asub_test()
	appearance_flags |= KEEP_TOGETHER
	var/image/I = image(icon('icons/system/alphamask_32x32.dmi', "scanline"), layer = FLOAT_LAYER)
	I.color = construct_rgba_color_matrix(aa = -1000000, cr = 1, cg = 1, cb = 1, ca = 1)
	I.blend_mode = BLEND_SUBTRACT
	overlays += I
