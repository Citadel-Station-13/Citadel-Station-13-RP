/*
IconProcs README

A BYOND library for manipulating icons and colors

by Lummox JR

version 1.0

The IconProcs library was made to make a lot of common icon operations much easier. BYOND's icon manipulation
routines are very capable but some of the advanced capabilities like using alpha transparency can be unintuitive to beginners.

CHANGING ICONS

Several new procs have been added to the /icon datum to simplify working with icons. To use them,
remember you first need to setup an /icon var like so:

GLOBAL_DATUM_INIT(my_icon, /icon, new('iconfile.dmi'))

icon/ChangeOpacity(amount = 1)
	A very common operation in DM is to try to make an icon more or less transparent. Making an icon more
	transparent is usually much easier than making it less so, however. This proc basically is a frontend
	for MapColors() which can change opacity any way you like, in much the same way that SetIntensity()
	can make an icon lighter or darker. If amount is 0.5, the opacity of the icon will be cut in half.
	If amount is 2, opacity is doubled and anything more than half-opaque will become fully opaque.
icon/GrayScale()
	Converts the icon to grayscale instead of a fully colored icon. Alpha values are left intact.
icon/ColorTone(tone)
	Similar to GrayScale(), this proc converts the icon to a range of black -> tone -> white, where tone is an
	RGB color (its alpha is ignored). This can be used to create a sepia tone or similar effect.
	See also the global ColorTone() proc.
icon/MinColors(icon)
	The icon is blended with a second icon where the minimum of each RGB pixel is the result.
	Transparency may increase, as if the icons were blended with ICON_ADD. You may supply a color in place of an icon.
icon/MaxColors(icon)
	The icon is blended with a second icon where the maximum of each RGB pixel is the result.
	Opacity may increase, as if the icons were blended with ICON_OR. You may supply a color in place of an icon.
icon/Opaque(background = COLOR_BLACK)
	All alpha values are set to 255 throughout the icon. Transparent pixels become black, or whatever background color you specify.
icon/BecomeAlphaMask()
	You can convert a simple grayscale icon into an alpha mask to use with other icons very easily with this proc.
	The black parts become transparent, the white parts stay white, and anything in between becomes a translucent shade of white.
icon/AddAlphaMask(mask)
	The alpha values of the mask icon will be blended with the current icon. Anywhere the mask is opaque,
	the current icon is untouched. Anywhere the mask is transparent, the current icon becomes transparent.
	Where the mask is translucent, the current icon becomes more transparent.
icon/UseAlphaMask(mask, mode)
	Sometimes you may want to take the alpha values from one icon and use them on a different icon.
	This proc will do that. Just supply the icon whose alpha mask you want to use, and src will change
	so it has the same colors as before but uses the mask for opacity.

COLOR MANAGEMENT AND HSV

RGB isn't the only way to represent color. Sometimes it's more useful to work with a model called HSV, which stands for hue, saturation, and value.

	* The hue of a color describes where it is along the color wheel. It goes from red to yellow to green to
	cyan to blue to magenta and back to red.
	* The saturation of a color is how much color is in it. A color with low saturation will be more gray,
	and with no saturation at all it is a shade of gray.
	* The value of a color determines how bright it is. A high-value color is vivid, moderate value is dark,
	and no value at all is black.

While rgb is typically stored in the #rrggbb" format (with optional "aa" on the end), HSV never needs to be displayed.
Most procs that work in HSV "space" will simply accept RGB inputs and convert them in place using rgb2num(color, space = COLORSPACE_HSV).

That said, if you want to manually modify these values rgb2hsv() will hand you back a list in the format list(hue, saturation, value, alpha).
Converting back is simple, just a hsv2rgb(hsv) call

Hue ranges from 0 to 360 (it's in degrees of a color wheel)
Saturation ranges from 0 to 100
Value ranges from 0 to 100

Knowing this, you can figure out that red is list(0, 100, 100) in HSV format, which is hue 0 (red), saturation 100 (as colorful as possible),
value 255 (as bright as possible). Green is list(120, 100, 100) and blue is list(240, 100, 100).

It is worth noting that while we do not have helpers for them currently, these same ideas apply to all of byond's color spaces
HSV (hue saturation value), HSL (hue satriation luminosity) and HCY (hue chroma luminosity)

Here are some procs you can use for color management:

BlendRGB(rgb1, rgb2, amount)
	Blends between two RGB or RGBA colors using regular RGB blending. If amount is 0, the first color is the result;
	if 1, the second color is the result. 0.5 produces an average of the two. Values outside the 0 to 1 range are allowed as well.
	Returns an RGB or RGBA string
BlendHSV(rgb1, rgb2, amount)
	Blends between two RGB or RGBA colors using HSV blending, which tends to produce nicer results than regular RGB
	blending because the brightness of the color is left intact. If amount is 0, the first color is the result; if 1,
	the second color is the result. 0.5 produces an average of the two. Values outside the 0 to 1 range are allowed as well.
	Returns an RGB or RGBA string
HueToAngle(hue)
	Converts a hue to an angle range of 0 to 360. Angle 0 is red, 120 is green, and 240 is blue.
AngleToHue(hue)
	Converts an angle to a hue in the valid range.
RotateHue(rgb, angle)
	Takes an RGB or RGBA value and rotates the hue forward through red, green, and blue by an angle from 0 to 360.
	(Rotating red by 60° produces yellow.)
	Returns an RGB or RGBA string
GrayScale(rgb)
	Takes an RGB or RGBA color and converts it to grayscale. Returns an RGB or RGBA string.
ColorTone(rgb, tone)
	Similar to GrayScale(), this proc converts an RGB or RGBA color to a range of black -> tone -> white instead of
	using strict shades of gray. The tone value is an RGB color; any alpha value is ignored.
*/

#define TO_HEX_DIGIT(n) ascii2text((n&15) + ((n&15)<10 ? 48 : 87))

/icon/proc/MakeLying()
	var/icon/I = new(src,dir=SOUTH)
	I.BecomeLying()
	return I

/icon/proc/BecomeLying()
	Turn(90)
	Shift(SOUTH,6)
	Shift(EAST,1)

// Multiply all alpha values by this float
/icon/proc/ChangeOpacity(opacity = 1)
	MapColors(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,opacity, 0,0,0,0)

// Convert to grayscale
/icon/proc/GrayScale()
	MapColors(0.3,0.3,0.3, 0.59,0.59,0.59, 0.11,0.11,0.11, 0,0,0)

/icon/proc/ColorTone(tone)
	GrayScale()

	var/list/TONE = rgb2num(tone)
	var/gray = round(TONE[1]*0.3 + TONE[2]*0.59 + TONE[3]*0.11, 1)

	var/icon/upper = (255-gray) ? new(src) : null

	if(gray)
		MapColors(255/gray,0,0, 0,255/gray,0, 0,0,255/gray, 0,0,0)
		Blend(tone, ICON_MULTIPLY)
	else SetIntensity(0)
	if(255-gray)
		upper.Blend(rgb(gray,gray,gray), ICON_SUBTRACT)
		upper.MapColors((255-TONE[1])/(255-gray),0,0,0, 0,(255-TONE[2])/(255-gray),0,0, 0,0,(255-TONE[3])/(255-gray),0, 0,0,0,0, 0,0,0,1)
		Blend(upper, ICON_ADD)

// Take the minimum color of two icons; combine transparency as if blending with ICON_ADD
/icon/proc/MinColors(icon)
	var/icon/new_icon = new(src)
	new_icon.Opaque()
	new_icon.Blend(icon, ICON_SUBTRACT)
	Blend(new_icon, ICON_SUBTRACT)

// Take the maximum color of two icons; combine opacity as if blending with ICON_OR
/icon/proc/MaxColors(icon)
	var/icon/new_icon
	if(isicon(icon))
		new_icon = new(icon)
	else
		// solid color
		new_icon = new(src)
		new_icon.Blend(COLOR_BLACK, ICON_OVERLAY)
		new_icon.SwapColor(COLOR_BLACK, null)
		new_icon.Blend(icon, ICON_OVERLAY)
	var/icon/blend_icon = new(src)
	blend_icon.Opaque()
	new_icon.Blend(blend_icon, ICON_SUBTRACT)
	Blend(new_icon, ICON_OR)

// make this icon fully opaque--transparent pixels become black
/icon/proc/Opaque(background = COLOR_BLACK)
	SwapColor(null, background)
	MapColors(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,0, 0,0,0,1)

// Change a grayscale icon into a white icon where the original color becomes the alpha
// I.e., black -> transparent, gray -> translucent white, white -> solid white
/icon/proc/BecomeAlphaMask()
	SwapColor(null, "#000000ff") // don't let transparent become gray
	MapColors(0,0,0,0.3, 0,0,0,0.59, 0,0,0,0.11, 0,0,0,0, 1,1,1,0)

/icon/proc/UseAlphaMask(mask)
	Opaque()
	AddAlphaMask(mask)

/icon/proc/AddAlphaMask(mask)
	var/icon/mask_icon = new(mask)
	mask_icon.Blend("#ffffff", ICON_SUBTRACT)
	// apply mask
	Blend(mask_icon, ICON_ADD)

/// Converts an rgb color into a list storing hsva
/// Exists because it's useful to have a guaranteed alpha value
/proc/rgb2hsv(rgb)
	var/list/hsv = rgb2num(rgb, COLORSPACE_HSV)
	if(length(hsv) < 4)
		hsv += 255 // Max alpha, just to make life easy
	return hsv

/// Converts a list storing hsva into an rgb color
/proc/hsv2rgb(hsv)
	if(length(hsv) < 3)
		return COLOR_BLACK
	if(length(hsv) == 3)
		return rgb(hsv[1], hsv[2], hsv[3], space = COLORSPACE_HSV)
	return rgb(hsv[1], hsv[2], hsv[3], hsv[4], space = COLORSPACE_HSV)

/*
	Smooth blend between RGB colors interpreted as HSV

	amount=0 is the first color
	amount=1 is the second color
	amount=0.5 is directly between the two colors

	amount<0 or amount>1 are allowed
 */
/proc/BlendHSV(hsv1, hsv2, amount)
	return hsv_gradient(amount, 0, hsv1, 1, hsv2, "loop")

/*
	Smooth blend between RGB colors

	amount=0 is the first color
	amount=1 is the second color
	amount=0.5 is directly between the two colors

	amount<0 or amount>1 are allowed
 */
/proc/BlendRGB(rgb1, rgb2, amount)
	return rgb_gradient(amount, 0, rgb1, 1, rgb2, "loop")

/proc/HueToAngle(hue)
	// normalize hsv in case anything is screwy
	if(hue < 0 || hue >= 1536)
		hue %= 1536
	if(hue < 0)
		hue += 1536
	// Compress hue into easier-to-manage range
	hue -= hue >> 8
	return hue / (1530/360)

/proc/AngleToHue(angle)
	// normalize hsv in case anything is screwy
	if(angle < 0 || angle >= 360)
		angle -= 360 * round(angle / 360)
	var/hue = angle * (1530/360)
	// Decompress hue
	hue += round(hue / 255)
	return hue

// positive angle rotates forward through red->green->blue
/proc/RotateHue(rgb, angle)
	var/list/HSV = rgb2hsv(rgb)

	// normalize hsv in case anything is screwy
	if(HSV[1] >= 1536)
		HSV[1] %= 1536
	if(HSV[1] < 0)
		HSV[1] += 1536

	// Compress hue into easier-to-manage range
	HSV[1] -= HSV[1] >> 8

	if(angle < 0 || angle >= 360)
		angle -= 360 * round(angle / 360)
	HSV[1] = round(HSV[1] + angle * (1530/360), 1)

	// normalize hue
	if(HSV[1] < 0 || HSV[1] >= 1530)
		HSV[1] %= 1530
	if(HSV[1] < 0)
		HSV[1] += 1530
	// decompress hue
	HSV[1] += round(HSV[1] / 255)

	return hsv2rgb(HSV)

// Convert an rgb color to grayscale
/proc/GrayScale(rgb)
	var/list/RGB = rgb2num(rgb)
	var/gray = RGB[1]*0.3 + RGB[2]*0.59 + RGB[3]*0.11
	return (RGB.len > 3) ? rgb(gray, gray, gray, RGB[4]) : rgb(gray, gray, gray)

// Change grayscale color to black->tone->white range
/proc/ColorTone(rgb, tone)
	var/list/RGB = rgb2num(rgb)
	var/list/TONE = rgb2num(tone)

	var/gray = RGB[1]*0.3 + RGB[2]*0.59 + RGB[3]*0.11
	var/tone_gray = TONE[1]*0.3 + TONE[2]*0.59 + TONE[3]*0.11

	if(gray <= tone_gray)
		return BlendRGB(COLOR_BLACK, tone, gray/(tone_gray || 1))
	else
		return BlendRGB(tone, "#ffffff", (gray-tone_gray)/((255-tone_gray) || 1))


//Used in the OLD chem colour mixing algorithm
/proc/GetColors(hex)
	hex = uppertext(hex)
	// No alpha set? Default to full alpha.
	if(length(hex) == 7)
		hex += "FF"
	var/hi1 = text2ascii(hex, 2) // R
	var/lo1 = text2ascii(hex, 3) // R
	var/hi2 = text2ascii(hex, 4) // G
	var/lo2 = text2ascii(hex, 5) // G
	var/hi3 = text2ascii(hex, 6) // B
	var/lo3 = text2ascii(hex, 7) // B
	var/hi4 = text2ascii(hex, 8) // A
	var/lo4 = text2ascii(hex, 9) // A
	return list(((hi1 >= 65 ? hi1-55 : hi1-48)<<4) | (lo1 >= 65 ? lo1-55 : lo1-48),
		((hi2 >= 65 ? hi2-55 : hi2-48)<<4) | (lo2 >= 65 ? lo2-55 : lo2-48),
		((hi3 >= 65 ? hi3-55 : hi3-48)<<4) | (lo3 >= 65 ? lo3-55 : lo3-48),
		((hi4 >= 65 ? hi4-55 : hi4-48)<<4) | (lo4 >= 65 ? lo4-55 : lo4-48))

/proc/getIconMask(atom/atom_to_mask)//By yours truly. Creates a dynamic mask for a mob/whatever. /N
	var/icon/alpha_mask = new(atom_to_mask.icon, atom_to_mask.icon_state)//So we want the default icon and icon state of atom_to_mask.
	for(var/iterated_image in atom_to_mask.overlays)//For every image in overlays. var/image/image will not work, don't try it.
		var/image/image = iterated_image
		if(image.layer > atom_to_mask.layer)
			continue//If layer is greater than what we need, skip it.
		var/icon/image_overlay = new(image.icon, image.icon_state)//Blend only works with icon objects.
		//Also, icons cannot directly set icon_state. Slower than changing variables but whatever.
		alpha_mask.Blend(image_overlay, ICON_OR)//OR so they are lumped together in a nice overlay.
	return alpha_mask//And now return the mask.

/mob/proc/AddCamoOverlay(atom/A)//A is the atom which we are using as the overlay.
	var/icon/opacity_icon = new(A.icon, A.icon_state)//Don't really care for overlays/underlays.
	//Now we need to culculate overlays+underlays and add them together to form an image for a mask.
	var/icon/alpha_mask = getIconMask(src)//getFlatIcon(src) is accurate but SLOW. Not designed for running each tick. This is also a little slow since it's blending a bunch of icons together but good enough.
	opacity_icon.AddAlphaMask(alpha_mask)//Likely the main source of lag for this proc. Probably not designed to run each tick.
	opacity_icon.ChangeOpacity(0.4)//Front end for MapColors so it's fast. 0.5 means half opacity and looks the best in my opinion.
	for(var/i in 1 to 5)//And now we add it as overlays. It's faster than creating an icon and then merging it.
		var/image/camo_image = image("icon" = opacity_icon, "icon_state" = A.icon_state, "layer" = layer+0.8)//So it's above other stuff but below weapons and the like.
		switch(i)//Now to determine offset so the result is somewhat blurred.
			if(2)
				camo_image.pixel_x--
			if(3)
				camo_image.pixel_x++
			if(4)
				camo_image.pixel_y--
			if(5)
				camo_image.pixel_y++
		add_overlay(camo_image)//And finally add the overlay.

/proc/getHologramIcon(icon/A, safety = TRUE, opacity = 0.5)//If safety is on, a new icon is not created.
	var/icon/flat_icon = safety ? A : new(A)//Has to be a new icon to not constantly change the same icon.
	// flat_icon.ColorTone(rgb(125,180,225))//Let's make it bluish.
	// flat_icon.ChangeOpacity(opacity)
	var/icon/alpha_mask = new('icons/effects/effects.dmi', "scanline")//Scanline effect.
	flat_icon.AddAlphaMask(alpha_mask)//Finally, let's mix in a distortion effect.
	return flat_icon

/proc/getPAIHologramIcon(icon/A, safety = TRUE)
	var/icon/flat_icon = safety? A : new(A)
	flat_icon.SetIntensity(0.75, 1, 0.75)
	flat_icon.ChangeOpacity(0.7)
	var/icon/alpha_mask = new('icons/effects/effects.dmi', "scanlineslow")//Scanline effect.
	flat_icon.AddAlphaMask(alpha_mask)//Finally, let's mix in a distortion effect.
	return flat_icon

//What the mob looks like as animated static
//By vg's ComicIronic
/proc/getStaticIcon(icon/A, safety = TRUE)
	var/icon/flat_icon = safety ? A : new(A)
	flat_icon.Blend(rgb(255,255,255))
	flat_icon.BecomeAlphaMask()
	var/icon/static_icon = icon('icons/effects/effects.dmi', "static_base")
	static_icon.AddAlphaMask(flat_icon)
	return static_icon

//What the mob looks like as a pitch black outline
//By vg's ComicIronic
/proc/getBlankIcon(icon/A, safety=1)
	var/icon/flat_icon = safety ? A : new(A)
	flat_icon.Blend(rgb(255,255,255))
	flat_icon.BecomeAlphaMask()
	var/icon/blank_icon = new/icon('icons/effects/effects.dmi', "blank_base")
	blank_icon.AddAlphaMask(flat_icon)
	return blank_icon


//Dwarf fortress style icons based on letters (defaults to the first letter of the Atom's name)
//By vg's ComicIronic
/proc/getLetterImage(atom/A, letter= "", uppercase = 0)
	if(!A)
		return

	var/icon/atom_icon = new(A.icon, A.icon_state)

	if(!letter)
		letter = A.name[1]
		if(uppercase == 1)
			letter = uppertext(letter)
		else if(uppercase == -1)
			letter = lowertext(letter)

	var/image/text_image = new(loc = A)
	text_image.maptext = MAPTEXT("<span style='font-size: 24pt'>[letter]</span>")
	text_image.pixel_x = 7
	text_image.pixel_y = 5
	qdel(atom_icon)
	return text_image
/*
GLOBAL_LIST_EMPTY(friendly_animal_types)

// Pick a random animal instead of the icon, and use that instead
/proc/getRandomAnimalImage(atom/A)
	if(!GLOB.friendly_animal_types.len)
		for(var/T in typesof(/mob/living/simple_animal))
			var/mob/living/simple_animal/SA = T
			if(initial(SA.gold_core_spawnable) == FRIENDLY_SPAWN)
				GLOB.friendly_animal_types += SA


	var/mob/living/simple_animal/SA = pick(GLOB.friendly_animal_types)

	var/icon = initial(SA.icon)
	var/icon_state = initial(SA.icon_state)

	var/image/final_image = image(icon, icon_state=icon_state, loc = A)

	if(ispath(SA, /mob/living/simple_animal/butterfly))
		final_image.color = rgb(rand(0,255), rand(0,255), rand(0,255))

	// For debugging
	final_image.text = initial(SA.name)
	return final_image
*/
//Interface for using DrawBox() to draw 1 pixel on a coordinate.
//Returns the same icon specifed in the argument, but with the pixel drawn
/proc/DrawPixel(icon/icon_to_use, colour, drawX, drawY)
	if(!icon_to_use)
		return 0

	var/icon_width = icon_to_use.Width()
	var/icon_height = icon_to_use.Height()

	if(drawX > icon_width || drawX <= 0)
		return 0
	if(drawY > icon_height || drawY <= 0)
		return 0

	icon_to_use.DrawBox(colour, drawX, drawY)
	return icon_to_use

//Interface for easy drawing of one pixel on an atom.
/atom/proc/DrawPixelOn(colour, drawX, drawY)
	var/icon/icon_one = new(icon)
	var/icon/result = DrawPixel(icon_one, colour, drawX, drawY)
	if(result) //Only set the icon if it succeeded, the icon without the pixel is 1000x better than a black square.
		icon = result
		return result
	return FALSE

//Hook, override to run code on- wait this is images
//Images have dir without being an atom, so they get their own definition.
//Lame.
/image/proc/setDir(newdir)
	dir = newdir

/// Gets a dummy savefile for usage in icon generation.
/// Savefiles generated from this proc will be empty.
/proc/get_dummy_savefile(from_failure = FALSE)
	var/static/next_id = 0
	if(next_id++ > 9)
		next_id = 0
	var/savefile_path = "tmp/dummy-save-[next_id].sav"
	try
		if(fexists(savefile_path))
			fdel(savefile_path)
		return new /savefile(savefile_path)
	catch(var/exception/error)
		// if we failed to create a dummy once, try again; maybe someone slept somewhere they shouldn't have
		if(from_failure) // this *is* the retry, something fucked up
			CRASH("get_dummy_savefile failed to create a dummy savefile: '[error]'")
		return get_dummy_savefile(from_failure = TRUE)

/**
 * Converts an icon to base64. Operates by putting the icon in the iconCache savefile,
 * exporting it as text, and then parsing the base64 from that.
 * (This relies on byond automatically storing icons in savefiles as base64)
 */
/proc/icon2base64(icon/icon)
	if (!isicon(icon))
		return FALSE
	var/savefile/dummySave = get_dummy_savefile()
	WRITE_FILE(dummySave["dummy"], icon)
	var/iconData = dummySave.ExportText("dummy")
	var/list/partial = splittext(iconData, "{")
	return replacetext(copytext_char(partial[2], 3, -5), "\n", "") //if cleanup fails we want to still return the correct base64

///given a text string, returns whether it is a valid dmi icons folder path
/proc/is_valid_dmi_file(icon_path)
	if(!istext(icon_path) || !length(icon_path))
		return FALSE

	var/is_in_icon_folder = findtextEx(icon_path, "icons/")
	var/is_dmi_file = findtextEx(icon_path, ".dmi")

	if(is_in_icon_folder && is_dmi_file)
		return TRUE
	return FALSE

/// given an icon object, dmi file path, or atom/image/mutable_appearance, attempts to find and return an associated dmi file path.
/// a weird quirk about dm is that /icon objects represent both compile-time or dynamic icons in the rsc,
/// but stringifying rsc references returns a dmi file path
/// ONLY if that icon represents a completely unchanged dmi file from when the game was compiled.
/// so if the given object is associated with an icon that was in the rsc when the game was compiled, this returns a path. otherwise it returns ""
/proc/get_icon_dmi_path(icon/icon)
	/// the dmi file path we attempt to return if the given object argument is associated with a stringifiable icon
	/// if successful, this looks like "icons/path/to/dmi_file.dmi"
	var/icon_path = ""

	if(isatom(icon) || istype(icon, /image) || istype(icon, /mutable_appearance))
		var/atom/atom_icon = icon
		icon = atom_icon.icon
		//atom icons compiled in from 'icons/path/to/dmi_file.dmi' are weird and not really icon objects that you generate with icon().
		//if they're unchanged dmi's then they're stringifiable to "icons/path/to/dmi_file.dmi"

	if(isicon(icon) && isfile(icon))
		//icons compiled in from 'icons/path/to/dmi_file.dmi' at compile time are weird and aren't really /icon objects,
		///but they pass both isicon() and isfile() checks. they're the easiest case since stringifying them gives us the path we want
		var/icon_ref = ref(icon)
		var/locate_icon_string = "[locate(icon_ref)]"

		icon_path = locate_icon_string

	else if(isicon(icon) && "[icon]" == "/icon")
		// icon objects generated from icon() at runtime are icons, but they AREN'T files themselves, they represent icon files.
		// if the files they represent are compile time dmi files in the rsc, then
		// the rsc reference returned by fcopy_rsc() will be stringifiable to "icons/path/to/dmi_file.dmi"
		var/rsc_ref = fcopy_rsc(icon)

		var/icon_ref = ref(rsc_ref)

		var/icon_path_string = "[locate(icon_ref)]"

		icon_path = icon_path_string

	else if(istext(icon))
		var/rsc_ref = fcopy_rsc(icon)
		//if its the text path of an existing dmi file, the rsc reference returned by fcopy_rsc() will be stringifiable to a dmi path

		var/rsc_ref_ref = ref(rsc_ref)
		var/rsc_ref_string = "[locate(rsc_ref_ref)]"

		icon_path = rsc_ref_string

	if(is_valid_dmi_file(icon_path))
		return icon_path

	return FALSE

/**
 * generate an asset for the given icon or the icon of the given appearance for [thing], and send it to any clients in target.
 * Arguments:
 * * thing - either a /icon object, or an object that has an appearance (atom, image, mutable_appearance).
 * * target - either a reference to or a list of references to /client's or mobs with clients
 * * icon_state - string to force a particular icon_state for the icon to be used
 * * dir - dir number to force a particular direction for the icon to be used
 * * frame - what frame of the icon_state's animation for the icon being used
 * * moving - whether or not to use a moving state for the given icon
 * * sourceonly - if TRUE, only generate the asset and send back the asset url, instead of tags that display the icon to players
 * * extra_clases - string of extra css classes to use when returning the icon string
 */
/proc/icon2html(atom/thing, client/target, icon_state, dir = SOUTH, frame = 1, moving = FALSE, sourceonly = FALSE, extra_classes = null)
	if (!thing)
		return
//	if(SSlag_switch.measures[DISABLE_USR_ICON2HTML] && usr && !HAS_TRAIT(usr, TRAIT_BYPASS_MEASURES))
//		return

	var/icon/icon2collapse = thing

	if (!target)
		return
	if (target == world)
		target = GLOB.clients

	var/list/targets
	if (!islist(target))
		targets = list(target)
	else
		targets = target
	if(!length(targets))
		return

	if (!isicon(icon2collapse))
		if (isfile(thing)) //special snowflake
			var/url = SSassets.send_anonymous_file(targets, icon2collapse, "png")
			if(sourceonly)
				return url
			return "<img class='[extra_classes] icon icon-misc' src='[url]'>"

		//its either an atom, image, or mutable_appearance, we want its icon var
		icon2collapse = thing.icon

		if (isnull(icon_state))
			icon_state = thing.icon_state
			//Despite casting to atom, this code path supports mutable appearances, so let's be nice to them
			if (isnull(icon_state) || !(icon_state in icon_states(icon2collapse, 1)))
				icon_state = initial(thing.icon_state)
				if (isnull(dir))
					dir = initial(thing.dir)

		if (isnull(dir))
			dir = thing.dir

		if (ishuman(thing)) // Shitty workaround for a BYOND issue.
			var/icon/temp = icon2collapse
			icon2collapse = icon()
			icon2collapse.Insert(temp, dir = SOUTH)
			dir = SOUTH
	else
		if (isnull(dir))
			dir = SOUTH
		if (isnull(icon_state))
			icon_state = ""

	icon2collapse = icon(icon2collapse, icon_state, dir, frame, moving)

	var/url = SSassets.send_anonymous_file(targets, icon2collapse, "png")
	if(sourceonly)
		return url
	return "<img class='[extra_classes] icon icon-[icon_state]' src='[url]'>"

/proc/icon2base64html(target)
	if (!target)
		return
	var/static/list/bicon_cache = list()
	if (isicon(target))
		var/icon/target_icon = target
		var/icon_base64 = icon2base64(target_icon)

		if (target_icon.Height() > world.icon_size || target_icon.Width() > world.icon_size)
			var/icon_md5 = md5(icon_base64)
			icon_base64 = bicon_cache[icon_md5]
			if (!icon_base64) // Doesn't exist yet, make it.
				bicon_cache[icon_md5] = icon_base64 = icon2base64(target_icon)

		return "<img class='icon icon-misc' src='data:image/png;base64,[icon_base64]'>"

	// Either an atom or somebody fucked up and is gonna get a runtime, which I'm fine with.
	var/atom/target_atom = target
	var/key = "[istype(target_atom.icon, /icon) ? "[REF(target_atom.icon)]" : target_atom.icon]:[target_atom.icon_state]"

	if (!bicon_cache[key]) // Doesn't exist, make it.
		var/icon/target_icon = icon(target_atom.icon, target_atom.icon_state, SOUTH, 1)
		if (ishuman(target)) // Shitty workaround for a BYOND issue.
			var/icon/temp = target_icon
			target_icon = icon()
			target_icon.Insert(temp, dir = SOUTH)

		bicon_cache[key] = icon2base64(target_icon)

	return "<img class='icon icon-[target_atom.icon_state]' src='data:image/png;base64,[bicon_cache[key]]'>"

/// Costlier version of icon2html() that uses get_flat_icon() to account for overlays, underlays, etc. Use with extreme moderation, ESPECIALLY on mobs.
/proc/costly_icon2html(thing, target, sourceonly = FALSE)
	if (!thing)
		return
//	if(SSlag_switch.measures[DISABLE_USR_ICON2HTML] && usr && !HAS_TRAIT(usr, TRAIT_BYPASS_MEASURES))
//		return

	if (isicon(thing))
		return icon2html(thing, target)

	var/icon/I = get_flat_icon(thing)
	return icon2html(I, target, sourceonly = sourceonly)

/// Perform a shake on an atom, resets its position afterwards
/atom/proc/Shake(pixelshiftx = 2, pixelshifty = 2, duration = 2.5 SECONDS, shake_interval = 0.02 SECONDS)
	var/initialpixelx = pixel_x
	var/initialpixely = pixel_y
	animate(src, pixel_x = initialpixelx + rand(-pixelshiftx,pixelshiftx), pixel_y = initialpixelx + rand(-pixelshifty,pixelshifty), time = shake_interval, flags = ANIMATION_PARALLEL)
	for (var/i in 3 to ((duration / shake_interval))) // Start at 3 because we already applied one, and need another to reset
		animate(pixel_x = initialpixelx + rand(-pixelshiftx,pixelshiftx), pixel_y = initialpixely + rand(-pixelshifty,pixelshifty), time = shake_interval)
	animate(pixel_x = initialpixelx, pixel_y = initialpixely, time = shake_interval)

// citadel edit: use this so we can VV it at a negligible performance hit.
GLOBAL_LIST_EMPTY(icon_exists_cache)

///Checks if the given iconstate exists in the given file, caching the result. Setting scream to TRUE will print a stack trace ONCE.
/proc/icon_exists(file, state, scream)
	if(GLOB.icon_exists_cache[file]?[state])
		return TRUE

	if(GLOB.icon_exists_cache[file]?[state] == FALSE)
		return FALSE

	var/list/states = icon_states(file)

	if(!GLOB.icon_exists_cache[file])
		GLOB.icon_exists_cache[file] = list()

	if(state in states)
		GLOB.icon_exists_cache[file][state] = TRUE
		return TRUE
	else
		GLOB.icon_exists_cache[file][state] = FALSE
		if(scream)
			stack_trace("Icon Lookup for state: [state] in file [file] failed.")
		return FALSE

/**
 * Returns the size of the sprite in tiles.
 * Takes the icon size and divides it by the world icon size (default 32).
 * This gives the size of the sprite in tiles.
 *
 * @return size of the sprite in tiles
 */
/proc/get_size_in_tiles(obj/target)
	var/icon/size_check = icon(target.icon, target.icon_state)
	var/size = size_check.Width() / 32

	return size

/// Returns a list containing the width and height of an icon file
/proc/get_icon_dimensions(icon_path)
	// Icons can be a real file(), a rsc backed file(), a dynamic rsc (dyn.rsc) reference (known as a cache reference in byond docs), or an /icon which is pointing to one of those.
	// Runtime generated dynamic icons are an unbounded concept cache identity wise, the same icon can exist millions of ways and holding them in a list as a key can lead to unbounded memory usage if called often by consumers.
	// Check distinctly that this is something that has this unspecified concept, and thus that we should not cache.
	if (!isfile(icon_path) || !length("[icon_path]"))
		var/icon/my_icon = icon(icon_path)
		return list("width" = my_icon.Width(), "height" = my_icon.Height())
	if (isnull(GLOB.icon_dimensions[icon_path]))
		var/icon/my_icon = icon(icon_path)
		GLOB.icon_dimensions[icon_path] = list("width" = my_icon.Width(), "height" = my_icon.Height())
	return GLOB.icon_dimensions[icon_path]

/// VSTATION SPECIFIC ///

/proc/adjust_brightness(color, value)
	if (!color)
		return "#FFFFFF"
	if (!value)
		return color

	var/list/RGB = rgb2num(color)
	RGB[1] = clamp(RGB[1]+value,0,255)
	RGB[2] = clamp(RGB[2]+value,0,255)
	RGB[3] = clamp(RGB[3]+value,0,255)
	return rgb(RGB[1],RGB[2],RGB[3])

/proc/sort_atoms_by_layer(list/atoms)
	// Comb sort icons based on levels
	var/list/result = atoms.Copy()
	var/gap = result.len
	var/swapped = 1
	while (gap > 1 || swapped)
		swapped = 0
		if(gap > 1)
			gap = round(gap / 1.3) // 1.3 is the emperic comb sort coefficient
		if(gap < 1)
			gap = 1
		for(var/i = 1; gap + i <= result.len; i++)
			var/atom/l = result[i]		//Fucking hate
			var/atom/r = result[gap+i]	//how lists work here
			if(l.layer > r.layer)		//no "result[i].layer" for me
				result.Swap(i, gap + i)
				swapped = 1
	return result

/*
 * * Accurate - Use more accurate color averaging, usually has better results and prevents muddied or overly dark colors. Mad thanks to wwjnc.
 * * ignoreGreyscale - Excempts greyscale colors from the color list, useful for filtering outlines or plate overlays.
 */
/proc/AverageColor(icon/I, accurate = FALSE, ignoreGreyscale = FALSE)
	var/list/colors = ListColors(I, ignoreGreyscale)
	if(!colors.len)
		return null

	var/list/colorsum = list(0, 0, 0) //Holds the sum of the RGB values to calculate the average
	var/list/RGB = list(0, 0, 0) //Temp list for each color
	var/total = colors.len

	var/final_average
	if (accurate) //keeping it legible
		for(var/i = 1 to total)
			RGB = rgb2num(colors[i])
			colorsum[1] += RGB[1]*RGB[1]
			colorsum[2] += RGB[2]*RGB[2]
			colorsum[3] += RGB[3]*RGB[3]
		final_average = rgb(sqrt(colorsum[1]/total), sqrt(colorsum[2]/total), sqrt(colorsum[3]/total))
	else
		for(var/i = 1 to total)
			RGB = rgb2num(colors[i])
			colorsum[1] += RGB[1]
			colorsum[2] += RGB[2]
			colorsum[3] += RGB[3]
		final_average = rgb(colorsum[1]/total, colorsum[2]/total, colorsum[3]/total)
	return final_average

/proc/ListColors(icon/I, ignoreGreyscale = FALSE)
	var/list/colors = list()
	for(var/x_pixel = 1 to I.Width())
		for(var/y_pixel = 1 to I.Height())
			var/this_color = I.GetPixel(x_pixel, y_pixel)
			if(this_color)
				if (ignoreGreyscale && rgb2hsv(this_color)[2] == 0) //If saturation is 0, must be greyscale
					continue
				colors.Add(this_color)
	return colors

/proc/empty_Y_space(icon/I) //Returns the amount of lines containing only transparent pixels in an icon, starting from the bottom
	for(var/y_pixel = 1 to I.Height())
		for(var/x_pixel = 1 to I.Width())
			if (I.GetPixel(x_pixel, y_pixel))
				return y_pixel - 1
	return null

/* Gives the result RGB of a RGB string after a matrix transformation. No alpha.
 * Input: rr, rg, rb, gr, gg, gb, br, bg, bb, cr, cg, cb
 * Output: RGB string
 */
/proc/RGBMatrixTransform(list/color, list/cm)
	ASSERT(cm.len >= 9)
	if(cm.len < 12)		// fill in the rest
		for(var/i in 1 to (12 - cm.len))
			cm += 0
	if(!islist(color))
		color = rgb2num(color)
	color[1] = color[1] * cm[1] + color[2] * cm[2] + color[3] * cm[3] + cm[10] * 255
	color[2] = color[1] * cm[4] + color[2] * cm[5] + color[3] * cm[6] + cm[11] * 255
	color[3] = color[1] * cm[7] + color[2] * cm[8] + color[3] * cm[9] + cm[12] * 255
	return rgb(color[1], color[2], color[3])
