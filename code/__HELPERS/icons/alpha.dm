/**
 * alphamasks us with another icon.
 *
 * the mask's colors are entirely ignored, we only care about the alpha values.
 *
 * if mask is not the same size, mask is scaled to match.
 *
 * @params
 * * mask - an /icon instance or an icon file
 */
/icon/proc/alpha_mask(icon/mask)
	var/our_x = Width()
	var/our_y = Height()
	var/icon/temp = icon(mask)
	var/their_x = temp.Width()
	var/their_y = temp.Height()
	if(our_x != their_x || our_y != their_y)
		temp.Scale(our_x, our_y)
	// we don't want it to modify colors, only alphas
	temp.Blend("#ffffff", ICON_SUBTRACT)
	// ICON_ADD --> AND op on both icons, since mask is black we don't touch the colors.
	Blend(temp, ICON_ADD)
