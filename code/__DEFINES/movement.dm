/// The minimum for glide_size to be clamped to.
#define MIN_GLIDE_SIZE 1
/// The maximum for glide_size to be clamped to.
/// This shouldn't be higher than the icon size, and generally you shouldn't be changing this, but it's here just in case.
#define MAX_GLIDE_SIZE 32

/// Compensating for time dialation
GLOBAL_VAR_INIT(glide_size_multiplier, 1.0)
/// Default world glide size
GLOBAL_VAR_INIT(default_glide_size, 0)

///Broken down, here's what this does:
/// divides the world icon_size (32) by delay divided by ticklag to get the number of pixels something should be moving each tick.
/// The division result is given a min value of 1 to prevent obscenely slow glide sizes from being set
/// Then that's multiplied by the global glide size multiplier. 1.25 by default feels pretty close to spot on. This is just to try to get byond to behave.
/// The whole result is then clamped to within the range above.
/// Not very readable but it works
#define DELAY_TO_GLIDE_SIZE(delay) (clamp(((world.icon_size / max((delay) / world.tick_lag, 1)) * GLOB.glide_size_multiplier), MIN_GLIDE_SIZE, MAX_GLIDE_SIZE) + world.tick_lag * 2)

//? tg's
// (clamp(((world.icon_size / max((delay) / world.tick_lag, 1)) * GLOB.glide_size_multiplier), MIN_GLIDE_SIZE, MAX_GLIDE_SIZE))
//? lohikar's
// if (current_map.map_is_laggy || !config.use_movement_smoothing)
//     mob.glide_size = 0
// else
//     mob.glide_size = NONUNIT_CEILING(WORLD_ICON_SIZE / max(move_delay, world.tick_lag) * world.tick_lag, world.tick_lag) + world.tick_lag * 2

/// Enables smooth movement
#define SMOOTH_MOVEMENT

/// Set appearance flags in vars
#ifdef SMOOTH_MOVEMENT
	#define SET_APPEARANCE_FLAGS(_flags) appearance_flags = (_flags | LONG_GLIDE)
#else
	#define SET_APPEARANCE_FLAGS(_flags) appearance_flags = _flags
#endif

/// set glide size of atom based on if smooth movement is on or not
#ifdef SMOOTH_MOVEMENT
	#define SMOOTH_GLIDE_SIZE(AM, size, args...)	AM.set_glide_size(size, args)
#else
	#define SMOOTH_GLIDE_SIZE(AM, size, args...)	AM.set_glide_size(GLOB.default_glide_size, args)
#endif

//? Don't even think about smooth movement until movespeed modification is done ~silicons
