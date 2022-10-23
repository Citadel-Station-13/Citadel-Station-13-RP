/**
 * called by Ssmobs every tick
 *
 * only abstract updates like HUD updates should be done here, otherwise put it in physical or biological life
 *
 * always call parent and check for ..() at start - if nonzero is returned, we should halt as we got deleted or killed
 *
 * @params
 * - seconds - seconds between each fire
 * - times_fired - cycle
 */
/mob/proc/Life(seconds, times_fired)
	SHOULD_CALL_PARENT(TRUE)
	if(transforming)
		return TRUE

	. = SEND_SIGNAL(src, COMSIG_MOB_ON_LIFE, seconds, times_fired)

	if(!(. & COMPONENT_INTERRUPT_PHYSICAL_LIFE))
		PhysicalLife(seconds, times_fired)

	if(!(. & COMPONENT_INTERRUPT_BIOLOGICAL_LIFE))
		BiologicalLife(seconds, times_fired)

	handle_modifiers(.) // Needs to be done even if in nullspace.

	. = FALSE

	if(spell_masters && spell_masters.len)
		for(var/atom/movable/screen/movable/spell_master/spell_master in spell_masters)
			spell_master.update_spells(0, src)

/**
 * processes physical life processes like being on fire
 * return TRUE if deleted
 *
 * always call parent and check for ..() at start - if nonzero is returned, we should halt as we got deleted or killed
 */
/mob/proc/PhysicalLife(seconds, times_fired)
	SHOULD_CALL_PARENT(TRUE)

/**
 * processes biological life processes like metabolism
 * return TRUE if deleted
 *
 * always call parent and check for ..() at start - if nonzero is returned, we should halt as we got deleted or killed
 */
/mob/proc/BiologicalLife(seconds, times_fired)
	SHOULD_CALL_PARENT(TRUE)

/**
 * handle modifiers - physical/biological life haltedd is passed in
 */
/mob/proc/handle_modifiers(component_signal)
