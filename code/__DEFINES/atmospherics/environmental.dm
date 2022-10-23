// CANATMOSPASS
// make sure it's in this order so we cann use min()
//! these are actual return values, using them in CanAtmosPass results in it always be returned.
/// lets everything through
#define ATMOS_PASS_NOT_BLOCKED		2
/// block zone merging through this but not air
#define ATMOS_PASS_ZONE_BLOCKED		1
/// blocks everything
#define ATMOS_PASS_AIR_BLOCKED		0
//! these are hints we can use in CanAtmosPass
/// ask CanAtmosPass()
#define ATMOS_PASS_PROC				-1
/// if dense, air blocked, else, not blocked
#define ATMOS_PASS_DENSITY			-2
/// ONLY FOR VERTICAL ATMOS PASS - check normal CanAtmosPass
#define ATMOS_PASS_VERTICAL_DEFAULT	-3

#define CANATMOSPASS(A, O, D) (A.CanAtmosPass > -1? A.CanAtmosPass : (A.CanAtmosPass == ATMOS_PASS_PROC? A.CanAtmosPass(O, D) : (A.density? ATMOS_PASS_AIR_BLOCKED : ATMOS_PASS_NOT_BLOCKED)))
#define CANVERTICALATMOSPASS(A, O, D) (A.CanAtmosPassVertical == ATMOS_PASS_VERTICAL_DEFAULT? CANATMOSPASS(A, O, D) : (A.CanAtmosPassVertical > -1? A.CanAtmosPassVertical : (A.CanAtmosPassVertical == ATMOS_PASS_PROC? A.CanAtmosPass(O, D) : (A.density? ATMOS_PASS_AIR_BLOCKED : ATMOS_PASS_NOT_BLOCKED))))

/**
 * LEGACY BELOW
 */

/// Zones with less than this many turfs will always merge, even if the connection is not direct
#define ZONE_MIN_SIZE 14
