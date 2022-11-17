//! General coloration mode defines
//? If you change these, change the following:
//? sprite_accessory_meta.dm
//* Make sure these start at 1 and are continuous for fast list indexing!
/// shouldn't be recolored
#define COLORATION_MODE_NONE 1
/// simple .color one color var or a color matrix
#define COLORATION_MODE_SIMPLE 2
/// matrix RGB for primary-secondary-tertiary
#define COLORATION_MODE_MATRIX_FULL 3
/// matrix RG for primary-secondary
#define COLORATION_MODE_MATRIX_REDGREEN 4
/// matrix GB for primary-secondary
#define COLORATION_MODE_MATRIX_GREENBLUE 5
/// matrix RB for primary-secondary
#define COLORATION_MODE_MATRIX_REDBLUE 6
/// use overlays _1, _2, _3 appended to state right after but not before modifiers like slot/front/adj/etc
#define COLORATION_MODE_OVERLAYS 7
/// use full GAGS; implementation-derived of how it handles this.
#define COLORATION_MODE_GAGS 8
