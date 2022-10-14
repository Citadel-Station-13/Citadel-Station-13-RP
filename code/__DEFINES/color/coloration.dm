//! General coloration mode defines
/// shouldn't be recolored
#define COLORATION_MODE_NONE 0
/// simple .color one color var or a color matrix
#define COLORATION_MODE_SIMPLE 1
/// matrix RGB for primary-secondary-tertiary
#define COLORATION_MODE_MATRIX_FULL 2
/// matrix RG for primary-secondary
#define COLORATION_MODE_MATRIX_REDGREEN 3
/// matrix GB for primary-secondary
#define COLORATION_MODE_MATRIX_GREENBLUE 4
/// matrix RB for primary-secondary
#define COLORATION_MODE_MATRIX_REDBLUE 5
/// use overlays _1, _2, _3 appended to state right after but not before modifiers like slot/front/adj/etc
#define COLORATION_MODE_OVERLAYS 6
/// use full GAGS; implementation-derived of how it handles this.
#define COLORATION_MODE_GAGS 7
