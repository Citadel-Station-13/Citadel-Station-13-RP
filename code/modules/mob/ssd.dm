/**
 * "space sleep disorder" is the HRP term for someone who's logged out.
 *
 * people who just don't have minds do not count.
 * people who are AI-controlled never count.
 * people who are dead do not count.
 * adminghosted people do not count.
 */
/mob/proc/is_ssd()
	return ckey && isnull(client) && isnull(teleop) && !IS_DEAD(src)

/mob/living/is_ssd()
	return isnull(ai_holder) && ..()

/**
 * basically, indicates that a player's gone, and there's no ai holder
 */
/mob/proc/is_catatonic()
	return !ckey

/mob/living/is_catatonic()
	return isnull(ai_holder) && ..()

/**
 * update ssd overlay
 *
 * @params
 * * forced_state - if set, adds on TRUE and removes on FALSE, ignoring client status.
 */
/mob/proc/update_ssd_overlay(forced_state)
	var/want = isnull(forced_state)? is_ssd() : forced_state
	if(want)
		if(isnull(ssd_overlay))
			render_ssd_overlay()
			add_overlay(ssd_overlay, TRUE)
		else if(needs_ssd_overlay_update())
			// just update
			cut_overlay(ssd_overlay, TRUE)
			render_ssd_overlay()
			add_overlay(ssd_overlay, TRUE)
	else if(!want && !isnull(ssd_overlay))
		cut_overlay(ssd_overlay, TRUE)
		ssd_overlay = null

/**
 * checks if we need a ssd overlay update
 */
/mob/proc/needs_ssd_overlay_update()
	return TRUE // no support for smart re-renders yet.

/**
 * renders ssd overlay
 *
 * @return TRUE if anything changed, FALSE otherwise
 */
/mob/proc/render_ssd_overlay()
	if(isnull(ssd_overlay))
		ssd_overlay = image(icon = 'icons/screen/atom_hud/status_16x16_oversized.dmi', icon_state = "eepy")
	// flags
	ssd_overlay.appearance_flags = RESET_COLOR | PIXEL_SCALE | KEEP_APART
	// matrix
	var/matrix/transforming_with = matrix()
	// center above
	transforming_with.Translate(8, 32 * transform.get_y_scale())
	// modify transform to new
	ssd_overlay.transform = transforming_with
	return TRUE // no support for smart re-renders yet.
