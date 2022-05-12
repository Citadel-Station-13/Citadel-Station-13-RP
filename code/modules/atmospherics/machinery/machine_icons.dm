/obj/machinery/atmospherics/update_appearance(updates)
	. = ..()
	update_layer()
	update_alpha()

/**
 * Icon update proc: Updates our pipe layer visuals
 */
/obj/machinery/atmospherics/proc/update_layer()
	layer = initial(layer) + (pipe_layer - PIPE_LAYER_DEFAULT) * PIPE_LAYER_LCHANGE

/**
 * Icon update proc: Updates our alpha
 */
/obj/machinery/atmospherics/proc/update_alpha()
	return

#warn impl

/**
 * generates cap image
 */

/**
 * generates pipe underlay
 */


/obj/machinery/atmospherics/proc/getpipeimage(iconset, iconstate, direction, col=rgb(255,255,255), pipe_layer=2)

	//Add identifiers for the iconset
	if(iconsetids[iconset] == null)
		iconsetids[iconset] = num2text(iconsetids.len + 1)

	//Generate a unique identifier for this image combination
	var/identifier = iconsetids[iconset] + "_[iconstate]_[direction]_[col]_[pipe_layer]"

	if((!(. = pipeimages[identifier])))
		var/image/pipe_overlay
		pipe_overlay = . = pipeimages[identifier] = image(iconset, iconstate, dir = direction)
		pipe_overlay.color = col
		PIPE_LAYER_SHIFT(pipe_overlay, pipe_layer)
