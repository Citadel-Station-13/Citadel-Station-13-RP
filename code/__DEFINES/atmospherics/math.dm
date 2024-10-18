//*                                General Functions                                 *//

/// Atmospherics quantization define.
#define XGM_QUANTIZE(variable)		(round(variable,0.00001))/*I feel the need to document what happens here. Basically this is used to catch most rounding errors, however it's previous value made it so that
															once gases got hot enough, most procedures wouldnt occur due to the fact that the mole counts would get rounded away. Thus, we lowered it a few orders of magnititude */
/// floating points are satanic.
///
/// checks if something is close enough to be equivalent.
/// as of right now, this is within 0.01% of the bigger number.
/// mostly only used in unit tests.
#define XGM_MOSTLY_CLOSE_ENOUGH(A, B) (abs(A - B) <= (max(abs(A), abs(B)) * 0.0001))
