//? This is here because the linter will explode if this isn't here. Don't believe me? Remove it. I dare you.
/datum/prototype/language_server_error_blocker

//## Core settings
//! Fastboot flags - useful for debugging
/// Disable loading late maps.
// #define FASTBOOT_DISABLE_LATELOAD
/// Disable automatic roundstart icon smoothing.
// #define FASTBOOT_DISABLE_SMOOTHING
/// Disable atmospherics zone build.
// #define FASTBOOT_DISABLE_ZONES

/// Comment this out if you are debugging problems that might be obscured by custom error handling in world/Error.
#ifdef DEBUG
	#define USE_CUSTOM_ERROR_HANDLER
	#define DEBUG_SHUTTLES
#endif

#if defined(OPENDREAM) && !defined(SPACEMAN_DMM) && !defined(CIBUILDING)
// The code is being compiled for OpenDream, and not just for the CI linting.
#define OPENDREAM_REAL
#endif

/**
 * By using the testing("message") proc you can create debug-feedback for people with this uncommented,
 * but not visible in the release version.
 */
#ifdef TESTING
	/// Used to find the sources of harddels, quite laggy, don't be surpised if it freezes your client for a good while.
	// #define REFERENCE_TRACKING
	#ifdef REFERENCE_TRACKING
		/**
		 * Used for doing dry runs of the reference finder, to test for feature completeness.
		 * Slightly slower, higher in memory. Just not optimal.
		 */
		// #define REFERENCE_TRACKING_DEBUG


		///Run a lookup on things hard deleting by default.
		//#define GC_FAILURE_HARD_LOOKUP
		#ifdef GC_FAILURE_HARD_LOOKUP
			///Don't stop when searching, go till you're totally done
			#define FIND_REF_NO_CHECK_TICK
		#endif //ifdef GC_FAILURE_HARD_LOOKUP

	#endif //ifdef REFERENCE_TRACKING


	/**
	 * Enables debug messages for every single reaction step.
	 * This is 1 message per 0.5s for a SINGLE reaction.
	 * Useful for tracking down bugs/asking me for help in the main reaction handiler (equilibrium.dm).
	 *
	 * * Requires TESTING to be defined to work.
	 * ! Not implemented yet.
	 */
	// #define REAGENTS_TESTING


	/// Highlights atmos active turfs in green.
	#define VISUALIZE_ACTIVE_TURFS
#endif //ifdef TESTING

/// If this is uncommented, we set up the ref tracker to be used in a live environment
/// And to log events to [log_dir]/harddels.log
//#define REFERENCE_DOING_IT_LIVE
#ifdef REFERENCE_DOING_IT_LIVE
// compile the backend
#define REFERENCE_TRACKING
// actually look for refs
#define GC_FAILURE_HARD_LOOKUP
// Log references in their own file
#define REFERENCE_TRACKING_LOG_APART
#endif // REFERENCE_DOING_IT_LIVE

/// Sets up the reftracker to be used locally, to hunt for hard deletions
/// Errors are logged to [log_dir]/harddels.log
//#define REFERENCE_TRACKING_STANDARD
#ifdef REFERENCE_TRACKING_STANDARD
// compile the backend
#define REFERENCE_TRACKING
// actually look for refs
#define GC_FAILURE_HARD_LOOKUP
// spend ALL our time searching, not just part of it
#define FIND_REF_NO_CHECK_TICK
// Log references in their own file
#define REFERENCE_TRACKING_LOG_APART
#endif // REFERENCE_TRACKING_STANDARD

// If this is uncommented, we do a single run though of the game setup and tear down process with unit tests in between
//#define UNIT_TESTS

// If this is uncommented, will attempt to load and initialize prof.dll/libprof.so by default.
// Even if it's not defined, you can pass "tracy" via -params in order to try to load it.
// We do not ship byond-tracy. Build it yourself here: https://github.com/mafemergency/byond-tracy,
// or the fork which writes profiling data to a file: https://github.com/ParadiseSS13/byond-tracy
// #define USE_BYOND_TRACY

// If defined, we will compile with FULL timer debug info, rather then a limited scope
// Be warned, this increases timer creation cost by 5x
// #define TIMER_DEBUG

// If defined, we will NOT defer asset generation till later in the game, and will instead do it all at once, during initiialize
//#define DO_NOT_DEFER_ASSETS

/// If this is uncommented, will profile mapload atom initializations
// #define PROFILE_MAPLOAD_INIT_ATOM

#ifndef PRELOAD_RSC
	/**
	 * Set to:
	 * * 0 to allow using external resources or on-demand behaviour;
	 * * 1 to use the default behaviour;
	 * * 2 for preloading absolutely everything;
	 */
	#define PRELOAD_RSC	2
#endif

#ifdef LOWMEMORYMODE
// TODO only load centcom or something
// #ifndef ABSOLUTE_MINIMUM
// #define FORCE_MAP "runtimestation"
// #else
// #define FORCE_MAP "runtimestation_minimal"
// #endif
// #define FORCE_MAP_DIRECTORY "_maps"
#endif

//Additional code for the above flags.
#ifdef TESTING
	#warn compiling in TESTING mode. testing() debug messages will be visible.
#endif

#if defined(CIBUILDING) && !defined(OPENDREAM)
#define UNIT_TESTS
#endif

#ifdef CITESTING
#define TESTING
#endif

#if defined(UNIT_TESTS)
//Hard del testing defines
#define REFERENCE_TRACKING
#define REFERENCE_TRACKING_DEBUG
#define FIND_REF_NO_CHECK_TICK
#define GC_FAILURE_HARD_LOOKUP
//Ensures all early assets can actually load early
#define DO_NOT_DEFER_ASSETS
//Test at full capacity, the extra cost doesn't matter
#define TIMER_DEBUG
// cit specific
#define CF_ATOM_TRACE_INIT_EARLY_QDEL
#endif

#ifdef TGS
// TGS performs its own build of dm.exe, but includes a prepended TGS define.
#define CBT
#endif

#if defined(OPENDREAM)
	#if !defined(CIBUILDING)
		#warn You are building with OpenDream. Remember to build TGUI manually.
		#warn You can do this by running tgui-build.cmd from the bin directory.
	#endif
#else
	#if !defined(CBT) && !defined(SPACEMAN_DMM)
		#warn Building with Dream Maker is no longer supported and will result in errors.
		#warn In order to build, run BUILD.cmd in the root directory.
		#warn Consider switching to VSCode editor instead, where you can press Ctrl+Shift+B to build.
	#endif
#endif

/**
 * ## MAPPING
 * IN_MAP_EDITOR macro is used to make some things appear visually more clearly in the map editor
 * this handles StrongDMM (and other editors using SpacemanDMM parser), toggle it manually if using a different editor
 */
#if (defined(SPACEMAN_DMM) || defined(FASTDMM))
#define IN_MAP_EDITOR
#endif


/**
 * ## Sections follow
 */

// ## Assets

/**
 * If defined, we will NOT defer asset generation till later in the game, and will instead do it all at once, during initiialize.
 */
//#define DO_NOT_DEFER_ASSETS

// ## Atoms

/**
 * Trace Destroy() before Initialize().
 */
// #define CF_ATOM_TRACE_INIT_EARLY_QDEL

// ## AI Holders / AI System

/**
 * Enables high-overhead debug assertions.
 */
#define CF_AI_HOLDER_DEBUG_ASSERTIONS

// ## Atmospherics

/// Enable this if you're doing weird atmos things.
///
/// * This helps bad behaviors get caught in testmerge.
/// * This only enables basic debug assertions. If you're touching zones, go to the ZAS section and set flags accordingly.
#define CF_ATMOS_IM_DOING_WACKY_THINGS_TODAY

#ifdef CF_ATMOS_IM_DOING_WACKY_THINGS_TODAY
	#define CF_ATMOS_XGM_DEBUG_ASSERTIONS
	#define CF_ATMOS_ZAS_DEBUG_ASSERTIONS
#endif

//? Gasmixtures

/// Enable general gasmixture assertions.
// #define CF_ATMOS_XGM_DEBUG_ASSERTIONS

/// Ensures update_values() is enforced
///
/// * VERY. VERY. LAGGY.
#define CF_ATMOS_XGM_UPDATE_VALUES_ASSERTIONS

//? ZAS (Environmental)

/// Enable general environmental assertions.
// #define CF_ATMOS_ZAS_DEBUG_ASSERTIONS

/// Uncomment to turn on Multi-Z ZAS Support!
#define MULTIZAS

/// Uncomment to enable laggy as sin ZAS debugging systems coded in for when doing bugfixes or major systems overhaulling.
// #define ZAS_ASSERTIONS

/// Uncomment to enable *actually* laggy as sin ZAS debugging, like "list in contents". don't do this without a major reason.
// #define ZAS_ASSERTIONS_EXPENSIVE

/// Uncomment to enable debugging graphics. you probably want to keep this off in live!
// #define ZAS_DEBUG_GRAPHICS

/// Uncomment to enable some otherwise useless hook points for zas debugging.
// #define ZAS_BREAKPOINT_HOOKS

#ifdef ZAS_DEBUG_GRAPHICS
	#define ZAS_BREAKPOINT_HOOKS
#endif

// ## Lighting

// #define AO_USE_LIGHTING_OPACITY

// ## Overlays

/**
 * A reasonable number of maximum overlays an object needs.
 * If you think you need more, rethink it.
 */
#define MAX_ATOM_OVERLAYS 100

// ## Projectiles

/**
 * Enable raycast visuals
 */
// #define CF_PROJECTILE_RAYCAST_VISUALS

#ifdef CF_PROJECTILE_RAYCAST_VISUALS
	#warn Visualization of projectile raycast algorithm enabled.
#endif

// ## Timers

// #define TIMER_LOOP_DEBUGGING

// ## Misc visualizations

/**
 * terraria-like damage bubble toasts every time something takes significant damage
*/
// #define CF_VISUALIZE_DAMAGE_TICKS

#ifdef CF_VISUALIZE_DAMAGE_TICKS
	#warn Visualization of atom damage ticks enabled.
#endif
