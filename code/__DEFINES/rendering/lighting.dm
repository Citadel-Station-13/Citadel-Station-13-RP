//Bay lighting engine shit, not in /code/modules/lighting because BYOND is being shit about it
/// frequency, in 1/10ths of a second, of the lighting process
#define LIGHTING_INTERVAL 1
#define MINIMUM_USEFUL_LIGHT_RANGE 1.4

/// Height off the ground of light sources on the pseudo-z-axis, you should probably leave this alone.
#define LIGHTING_HEIGHT 1
/// Z diff is multiplied by this and LIGHTING_HEIGHT to get the final height of a light source. Affects how much darker A Z light gets with each level transitioned.
#define LIGHTING_Z_FACTOR 10
/// Value used to round lumcounts, values smaller than 1/255 don't matter (if they do, thanks sinking points), greater values will make lighting less precise, but in turn increase performance, VERY SLIGHTLY.
#define LIGHTING_ROUND_VALUE (1 / 200)

/// Icon used for lighting shading effects
#define LIGHTING_ICON 'icons/effects/lighting_overlay.dmi'
/// icon_state used for normal color-matrix based lighting overlays.
#define LIGHTING_BASE_ICON_STATE "matrix"
/// icon_state used for lighting overlays that are just displaying standard station lighting.
#define LIGHTING_STATION_ICON_STATE "tubedefault"
/// icon_state used for lighting overlays with no luminosity.
#define LIGHTING_DARKNESS_ICON_STATE "black"
#define LIGHTING_TRANSPARENT_ICON_STATE "blank"

/// How much the range of a directional light will be reduced while facing a wall.
#define LIGHTING_BLOCKED_FACTOR 0.5

/**
 * If defined, instant updates will be used whenever server load permits.
 * Otherwise queued updates are always used.
 */
#define USE_INTELLIGENT_LIGHTING_UPDATES

/// Maximum light_range before forced to always queue instead of using sync updates. Setting this too high will cause server stutter with moving large lights.
#define LIGHTING_MAXIMUM_INSTANT_RANGE 8

/**
 * Mostly identical to below, but doesn't make sure T is valid first.
 * Should only be used by lighting code.
 */
#define TURF_IS_DYNAMICALLY_LIT_UNSAFE(T) ((T:dynamic_lighting && T:loc:dynamic_lighting))
#define TURF_IS_DYNAMICALLY_LIT(T) (isturf(T) && TURF_IS_DYNAMICALLY_LIT_UNSAFE(T))

// Note: this does not imply the above, a turf can have ambient light without being dynamically lit.
#define TURF_IS_AMBIENT_LIT_UNSAFE(T) (T:ambient_active)
#define TURF_IS_AMBIENT_LIT(T) (isturf(T) && TURF_IS_AMBIENT_LIT_UNSAFE(T))

//! If I were you I'd leave this alone.
#define LIGHTING_BASE_MATRIX \
	list            \
	(               \
		1, 1, 1, 0, \
		1, 1, 1, 0, \
		1, 1, 1, 0, \
		1, 1, 1, 0, \
		0, 0, 0, 1  \
	)               \

// Helpers so we can (more easily) control the colour matrices.
#define CL_MATRIX_RR 1
#define CL_MATRIX_RG 2
#define CL_MATRIX_RB 3
#define CL_MATRIX_RA 4
#define CL_MATRIX_GR 5
#define CL_MATRIX_GG 6
#define CL_MATRIX_GB 7
#define CL_MATRIX_GA 8
#define CL_MATRIX_BR 9
#define CL_MATRIX_BG 10
#define CL_MATRIX_BB 11
#define CL_MATRIX_BA 12
#define CL_MATRIX_AR 13
#define CL_MATRIX_AG 14
#define CL_MATRIX_AB 15
#define CL_MATRIX_AA 16
#define CL_MATRIX_CR 17
#define CL_MATRIX_CG 18
#define CL_MATRIX_CB 19
#define CL_MATRIX_CA 20

//! Higher numbers override lower.
#define LIGHTING_NO_UPDATE    0
#define LIGHTING_VIS_UPDATE   1
#define LIGHTING_CHECK_UPDATE 2
#define LIGHTING_FORCE_UPDATE 3

/**
 * This color of overlay is very common - most of the station is this color when lit fully.
 * Tube lights are a bluish-white, so we can't just assume 1-1-1 is full-illumination.
 * -- If you want to change these, find them *by checking in-game*, just converting tubes' RGB color into floats will not work!
 */
#define LIGHTING_DEFAULT_TUBE_R 0.96
#define LIGHTING_DEFAULT_TUBE_G 1
#define LIGHTING_DEFAULT_TUBE_B 1

//! Some angle presets for directional lighting.
#define LIGHT_OMNI null
#define LIGHT_SEMI 180
#define LIGHT_WIDE 90
#define LIGHT_NARROW 45

/// How many tiles standard fires glow.
#define LIGHT_RANGE_FIRE 3


//! ## DYNAMIC LIGHTING STATE
/// Dynamic lighting disabled. (area stays at full brightness)
#define DYNAMIC_LIGHTING_DISABLED    0
/// Dynamic lighting enabled.
#define DYNAMIC_LIGHTING_ENABLED     1
/// Dynamic lighting enabled even if the area doesn't require power.
#define DYNAMIC_LIGHTING_FORCED      2
/// Dynamic lighting enabled only if starlight is.
#define DYNAMIC_LIGHTING_IFSTARLIGHT 3
#define IS_DYNAMIC_LIGHTING(A) A.dynamic_lighting


#define FLASH_LIGHT_DURATION 2
#define FLASH_LIGHT_POWER    3
#define FLASH_LIGHT_RANGE    3.8

//! Emissive blocking.
/// Uses vis_overlays to leverage caching so that very few new items need to be made for the overlay. For anything that doesn't change outline or opaque area much or at all.
#define EMISSIVE_BLOCK_GENERIC 1
/// Uses a dedicated render_target object to copy the entire appearance in real time to the blocking layer. For things that can change in appearance a lot from the base state, like humans.
#define EMISSIVE_BLOCK_UNIQUE  2

/// The color matrix applied to all emissive overlays. Should be solely dependent on alpha and not have RGB overlap with [EM_BLOCK_COLOR].
#define EMISSIVE_COLOR list(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,1, 1,1,1,0)
/// A globaly cached version of [EMISSIVE_COLOR] for quick access.
GLOBAL_LIST_INIT(emissive_color, EMISSIVE_COLOR)
/// The color matrix applied to all emissive blockers. Should be solely dependent on alpha and not have RGB overlap with [EMISSIVE_COLOR].
#define EM_BLOCK_COLOR list(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,0)
/// A globaly cached version of [EM_BLOCK_COLOR] for quick access.
GLOBAL_LIST_INIT(em_block_color, EM_BLOCK_COLOR)
/// The color matrix used to mask out emissive blockers on the emissive plane. Alpha should default to zero, be solely dependent on the RGB value of [EMISSIVE_COLOR], and be independant of the RGB value of [EM_BLOCK_COLOR].
#define EM_MASK_MATRIX list(0,0,0,1/3, 0,0,0,1/3, 0,0,0,1/3, 0,0,0,0, 1,1,1,0)
/// A globaly cached version of [EM_MASK_MATRIX] for quick access.
GLOBAL_LIST_INIT(em_mask_matrix, EM_MASK_MATRIX)


/// Returns the red part of a #RRGGBB hex sequence as number
#define GETREDPART(hexa) hex2num(copytext(hexa, 2, 4))

/// Returns the green part of a #RRGGBB hex sequence as number
#define GETGREENPART(hexa) hex2num(copytext(hexa, 4, 6))

/// Returns the blue part of a #RRGGBB hex sequence as number
#define GETBLUEPART(hexa) hex2num(copytext(hexa, 6, 8))

/// Parse the hexadecimal color into lumcounts of each perspective.
#define PARSE_LIGHT_COLOR(source) \
do { \
	if (source.light_color) { \
		var/__light_color = source.light_color; \
		source.lum_r = GETREDPART(__light_color) / 255; \
		source.lum_g = GETGREENPART(__light_color) / 255; \
		source.lum_b = GETBLUEPART(__light_color) / 255; \
	} else { \
		source.lum_r = 1; \
		source.lum_g = 1; \
		source.lum_b = 1; \
	}; \
} while (FALSE)

//! ## COLOR FILTERS
/// Icon filter that creates ambient occlusion
#define AMBIENT_OCCLUSION filter(type="drop_shadow", x=0, y=-2, size=4, color="#04080FAA")
/// Icon filter that creates gaussian blur
#define GAUSSIAN_BLUR(filter_size) filter(type="blur", size=filter_size)
