//Original lighting falloff calculation. This looks the best out of the three. However, this is also the most expensive.
//#define LUM_FALLOFF(C, T) (1 - CLAMP01(sqrt((C.x - T.x) ** 2 + (C.y - T.y) ** 2 + LIGHTING_HEIGHT) / max(1, light_range)))

//Cubic lighting falloff. This has the *exact* same range as the original lighting falloff calculation, down to the exact decimal, but it looks a little unnatural due to the harsher falloff and how it's generally brighter across the board.
//#define LUM_FALLOFF(C, T) (1 - CLAMP01((((C.x - T.x) * (C.x - T.x)) + ((C.y - T.y) * (C.y - T.y)) + LIGHTING_HEIGHT) / max(1, light_range*light_range)))

//Linear lighting falloff. This resembles the original lighting falloff calculation the best, but results in lights having a slightly larger range, which is most noticable with large light sources. This also results in lights being diamond-shaped, fuck. This looks the darkest out of the three due to how lights are brighter closer to the source compared to the original falloff algorithm. This falloff method also does not at all take into account lighting height, as it acts as a flat reduction to light range with this method.
//#define LUM_FALLOFF(C, T) (1 - CLAMP01(((abs(C.x - T.x) + abs(C.y - T.y))) / max(1, light_range+1)))

// This is the define used to calculate falloff.
#define LUM_FALLOFF(Cx,Cy,Tx,Ty,HEIGHT) (1 - CLAMP01(sqrt(((Cx) - (Tx)) ** 2 + ((Cy) - (Ty)) ** 2 + HEIGHT) / max(1, actual_range)))

// Macro that applies light to a new corner.
// It is a macro in the interest of speed, yet not having to copy paste it.
// If you're wondering what's with the backslashes, the backslashes cause BYOND to not automatically end the line.
// As such this all gets counted as a single line.
// The braces and semicolons are there to be able to do this on a single line.

#define APPLY_CORNER(C,now,Tx,Ty,hdiff)         \
	. = LUM_FALLOFF(C.x, C.y, Tx, Ty, hdiff) * light_power;    \
	var/OLD = effect_str[C];                 \
	effect_str[C] = .;                       \
	C.update_lumcount                        \
	(                                        \
		(. * lum_r) - (OLD * applied_lum_r), \
		(. * lum_g) - (OLD * applied_lum_g), \
		(. * lum_b) - (OLD * applied_lum_b), \
		now                                  \
	);

// I don't need to explain what this does, do I?
#define REMOVE_CORNER(C,now)         \
	. = -effect_str[C];              \
	C.update_lumcount                \
	(                                \
		. * applied_lum_r,           \
		. * applied_lum_g,           \
		. * applied_lum_b,           \
		now                          \
	);

// Converts two Z levels into a height value for LUM_FALLOFF or HEIGHT_FALLOFF.
#define CALCULATE_CORNER_HEIGHT(ZA,ZB) (((max(ZA,ZB) - min(ZA,ZB)) + 1) * LIGHTING_HEIGHT * LIGHTING_Z_FACTOR)

#define APPLY_CORNER_BY_HEIGHT(now)                       \
	if (C.z != Sz) {                                      \
		corner_height = CALCULATE_CORNER_HEIGHT(C.z, Sz); \
	}                                                     \
	else {                                                \
		corner_height = LIGHTING_HEIGHT;                  \
	}                                                     \
	APPLY_CORNER(C, now, Sx, Sy, corner_height);
