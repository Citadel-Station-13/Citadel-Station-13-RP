/**
 * Center's an image or a mutable appearance or anything with pixel x/y based on a given dimension.
 * Requires:
 * The Image
 * The x dimension of the icon file used in the image
 * The y dimension of the icon file used in the image
 *  eg: center_image(I, 32,32)
 *  eg2: center_image(I, 96,96)
 */
/proc/center_appearance(mutable_appearance/MA, x_dimension, y_dimension)
	MA.pixel_x = (WORLD_ICON_SIZE - x_dimension) * 0.5
	MA.pixel_y = (WORLD_ICON_SIZE - y_dimension) * 0.5
	return MA
