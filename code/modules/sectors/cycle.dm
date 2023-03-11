/**
 * So what is a cycle?
 *
 * Basically, you know how we used to simulate sun / moon?
 *
 * Yeah uh, that was kind of bad.
 *
 * And I was wondering how to make it better
 *
 * And it occurred to me, the answer was to stop simulating suns. And moons.
 *
 * Instead, we simulate the concept of an orbital body.
 *
 * Cycles:
 * - Can be a visible celestial object, or not
 * - Can "broadcast" a power ratio of a user's choice
 * - Can be set to the "main" cycle of a planet, which is often used for the main day/night cycle.
 * - All planets must have a main cycle, or its main cycle will be 0 ratio always.
 */
/datum/sector_cycle
	//? identity
	/// name of cycle
	var/name = "Cycle"
	/// description of this cycle
	var/desc = "Some sort of natural cycle."
	/// enum key to "push" our phase power with, if any. you usually don't need this.
	var/key

	//? main / sync
	/// this is the main cycle of a sector
	var/main = FALSE
	/// this is in-sync with the main cycle. useful for moons.
	var/sync_to_main = FALSE
	/// ratio offset from main. for moons, you probably want 0.5 or something.
	var/sync_offset = 0
	/// apply additively, or compete with other cycles?
	var/additive = FALSE
	/// our relative strength, if competitive
	var/relative_strength = 1

	//? stages
	/// ratio offset of the first stage
	var/ratio_offset = 0
	/// phase list
	var/list/phases = list()
	/// phase border "behind" the current time
	var/tmp/datum/sector_phase/phase_behind
	/// phase border "ahead" the current time
	var/tmp/datum/sector_phase/phase_ahead
	/// ratio of 0 at behind and 1 at ahead, used for interpolation
	var/tmp/phase_ratio = 0
	/// current light color
	var/tmp/light_color = "#ffffff"
	/// current light power
	var/tmp/light_power = 0
	/// current temperature adjust
	var/tmp/temperature_adjust = 0
	/// current phase poewr
	var/tmp/phase_power = 0

	//? fluff
	/// can we be seen in look-up at all?
	var/sky_visible = FALSE
	/// what we're seen as in the sky
	var/sky_desc = "Some kind of orbiting body."
	/// level - if above obscuration, obscuring thing obscures us from view
	var/sky_level = SECTOR_CYCLE_LEVEL_DEFAULT

/datum/sector_cycle/New()
	#warn normalize phaess to 1 ratio total

/datum/sector_cycle/proc/normalize_phases()
	#warn impl

/**
 * called to do special effects
 * make sure you know exactly what you are doing.
 *
 * * old_power - null if we're applying for the first time
 * * new_power - null if we're being removed
 */
/datum/sector_cycle/proc/apply(datum/world_sector/sector, old_power, new_power)
	return
	#warn hook

/datum/sector_cycle/proc/update(timeofday_ratio)
	// check for phases
	if(!length(phases))
		light_power = 0
		temperature_adjust = 0
		phase_power = 0
		return
	else if(length(phases) == 1)
		light_power = phases[1].light_power
		temperature_adjust = phases[1].temperature_adjust
		phase_power = 0
		return
	// 2+ phases, do normal stuff
	// gather / compute phases
	for(var/datum/sector_phase/phase as anything in phases)
	#warn impl

	// interpolate
	light_color = rgb(
		LERP(phase_behind.light_color_cached[1], phase_ahead.light_color_cached[1], phase_ratio),
		LERP(phase_behind.light_color_cached[2], phase_ahead.light_color_cached[2], phase_ratio),
		LERP(phase_behind.light_color_cached[3], phase_ahead.light_color_cached[3], phase_ratio),
	)
	light_power = LERP(phase_behind.light_power, phase_ahead.light_power, phase_ratio)
	temperature_adjust = LERP(phase_behind.temperature_adjust, phase_ahead.temperature_adjust, phase_ratio)

/**
 * return msg of look-up message, or null if we're not visible
 */
/datum/sector_cycle/proc/in_sky_desc(timeofday_ratio, mob/M)
	#warn implh

/datum/sector_cycle/sun
	name = "Sun"
	desc = "The day-night cycle of some kind of star."
	sky_visible = TRUE
	sky_desc = "The planet's sun."

/datum/sector_cycle/sun/main
	desc = "The day-night cycle of the planet's sun."
	main = TRUE

/datum/sector_cycle/sun/main/default
	ratio_offset = -0.333
	phases = list(
		/datum/sector_phase{ // night
			relative_ratio = 0.4;
			light_color = "#000000";
			light_power = 0;
			temperature_adjust = -5;
		},
		/datum/sector_phase{ // morning
			relative_ratio = 0.2;
			light_color = "#AA3300";
			light_power = 0.4;
		},
		/datum/sector_phase{ // noon
			relative_ratio = 0.2;
			light_color = "#EEEEEE";
			light_power = 1;
			temperature_adjust = 3;
		},
		/datum/sector_phase{ // evening
			relative_ratio = 0.2;
			light_color = "#88CC00";
			light_power = 0.4;
		},
	)

/datum/sector_cycle/moon
	name = "Moon"
	desc = "The orbit of some kind of moon."
	sync_to_main = TRUE
	sync_offset = 0.5
	sky_visible = TRUE
	sky_desc = "The planet's moon."

/datum/sector_cycle/moon/default
	desc = "The orbit of the planet's primary moon."
	#warn imppl

/datum/sector_cycle/eldritch_fucking_horror
	name = "Uh Oh"
	desc = "Gods are cruel today."
	sync_to_main = FALSE
	phases = list(
		/datum/sector_phase{
			relative_ratio = 1;
			light_power = 1;
			light_color = "#ff77ff";
			sky_visible = TRUE;
		}
	)
	sky_visible = TRUE
	sky_desc = SPAN_DANGER("Run.")

/**
 * cycle stages
 */
/datum/sector_phase
	/// relative duration - make sure this adds up to 1 throughout all phases for speed
	var/relative_ratio = 1
	/// light intensity at 0% cloud cover
	var/light_power = 0
	/// light color
	var/light_color = "#ffffff"
	/// light color as rgb values cached
	var/list/light_color_cached
	/// are we visible in the sky?
	var/sky_visible = FALSE
	/// are we visible in the sky leading / following this phase, even if the previous/next ones aren't?
	var/sky_transit = FALSE
	/// override msg for sky
	var/override_sky_msg
	/// override msg for sky leading edge
	var/override_skyrise_msg
	/// override msg for sky trailing edge
	var/override_skyset_msg
	/// temperature adjust
	var/temperature_adjust = 0
	/// phase power
	var/phase_power = 1

/datum/sector_phase/New()
	light_color_cached = hex2rgb(light_color)
