// CANATMOSPASS
// make sure it's in this order so we cann use min()
/// lets everything through
#define ATMOS_PASS_NOT_BLOCKED		2
/// block zone merging through this but not air
#define ATMOS_PASS_ZONE_BLOCKED		1
/// blocks everything
#define ATMOS_PASS_AIR_BLOCKED		0
/// ask CanAtmosPass()
#define ATMOS_PASS_PROC				-1
/// if dense, air blocked, else, not blocked
#define ATMOS_PASS_DENSITY			-2
/// ONLY FOR VERTICAL ATMOS PASS - check normal CanAtmosPass
#define ATMOS_PASS_VERTICAL_DEFAULT	-3

#define CANATMOSPASS(A, O, D) ( A.CanAtmosPass == ATMOS_PASS_PROC ? A.CanAtmosPass(O, D) : ( A.CanAtmosPass == ATMOS_PASS_DENSITY ? (A.density? ATMOS_PASS_AIR_BLOCKED : ATMOS_PASS_NOT_BLOCKED) : A.CanAtmosPass ) )
#define CANVERTICALATMOSPASS(A, O, D) (A.CanAtmosPassVertical == ATMOS_PASS_VERTICAL_DEFAULT? CANATMOSPASS(A, O, D) : ( A.CanAtmosPassVertical == ATMOS_PASS_PROC ? A.CanAtmosPass(O, D) : ( A.CanAtmosPassVertical == ATMOS_PASS_DENSITY ? (A.density? ATMOS_PASS_AIR_BLOCKED : ATMOS_PASS_NOT_BLOCKED) : A.CanAtmosPassVertical ) ))

/**
 * LEGACY BELOW
 */

/// Zones with less than this many turfs will always merge, even if the connection is not direct
#define ZONE_MIN_SIZE 14
