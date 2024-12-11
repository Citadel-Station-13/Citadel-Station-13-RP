/**
 * Tear down a layer of flooring.
 *
 * Will drop product if we're not too badly broken.
 *
 * @return layers strpped
 */
/turf/simulated/floor/proc/auto_dismantle_flooring()
	return dismantle_flooring(!broken && !burnt)

/**
 * Tear down a layer of flooring.
 *
 * @params
 * * drop_product - drop dismantled product
 * * strip_to_base - strip every layer of flooring.
 *
 * @return layers strpped
 */
/turf/simulated/floor/proc/dismantle_flooring(drop_product, strip_to_base)
	if(!flooring)
		return 0
	if(strip_to_base)
		var/safety = 10
		// incase ChangeTurf is invoked
		var/turf/simulated/floor/self_reference_maybe = src
		src = null
		while(istype(self_reference_maybe) && self_reference_maybe.flooring)
			--safety
			if(safety < 0)
				CRASH("infinite loop guard triggered on dismantling flooring to base.")
			self_reference_maybe.dismantle_flooring(drop_product, FALSE)
			++.
	else
		if(drop_product)
			flooring.drop_product(src)
		set_flooring(RSflooring.fetch(flooring.base_flooring))
		. = 1

/**
 * Sets our flooring to a specific instance.
 *
 * * This will trample any variable overrides like appearance data that we have on us
 *   in favor of the flooring's!
 * * Passing in 'null' will clear flooring.
 *
 * @params
 * * instance - the instance to use. this can be null.
 * * init - are we being hit from Initialize()? if so, we will refrain from setting variables
 *          already set by macros.
 */
/turf/simulated/floor/proc/set_flooring(datum/prototype/flooring/instance, init)
	if(instance == flooring)
		return
	if(!init && ((!instance) ^ (!flooring)))
		// swap out underfloor vs abovefloor decals
		var/list/current_decals = decals
		decals = flooring_inversed_decals
		flooring_inversed_decals = current_decals

	flooring = instance

	var/new_mz_flags
	if(instance)
		if(!init || !instance.__is_not_legacy)
			name = instance.name
			icon = instance.icon
			icon_state = instance.icon_base
		new_mz_flags = instance.mz_flags
	else
		name = /turf/simulated/floor::name
		icon = /turf/simulated/floor::icon
		icon_state = /turf/simulated/floor::icon_state
		new_mz_flags = /turf/simulated/floor::mz_flags

	if(new_mz_flags & MZ_MIMIC_BELOW)
		enable_zmimic(new_mz_flags)
	else
		disable_zmimic()
	if(mz_flags != new_mz_flags)
		mz_flags = new_mz_flags

	if(!init)
		QUEUE_SMOOTH(src)
		QUEUE_SMOOTH_NEIGHBORS(src)
		update_underfloor_objects()
		update_layer()

	//! LEGACY !//
	if(instance)
		footstep_sounds = instance.footstep_sounds
	else
		footstep_sounds = base_footstep_sounds
	color = null
	broken = null
	burnt = null
	flooring_legacy_override_state = null
	//! END !//
