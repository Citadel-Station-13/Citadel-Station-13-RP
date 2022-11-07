//! worn_render_flags on /obj/item
/// _all for state
#define WORN_RENDER_SLOT_ONE_FOR_ALL (1<<0)
/// _all for state on inhands
#define WORN_RENDER_INHAND_ONE_FOR_ALL (1<<1)
/// allow worn defaulting
#define WORN_RENDER_SLOT_ALLOW_DEFAULT (1<<2)
/// allow inhand defaulting
#define WORN_RENDER_INHAND_ALLOW_DEFAULT (1<<3)
/// don't render in slots; render_additional still used, others aren't
#define WORN_RENDER_SLOT_NO_RENDER (1<<4)
/// don't render in inhands; render_additional still used, others aren't
#define WORN_RENDER_INHAND_NO_RENDER (1<<5)
/// use plural key when we can; overridden by ONE_FOR_ALL
#define WORN_RENDER_SLOT_USE_PLURAL (1<<6)

DEFINE_BITFIELD(worn_render_flags, list(
	BITFIELD(WORN_RENDER_SLOT_ONE_FOR_ALL),
	BITFIELD(WORN_RENDER_INHAND_ONE_FOR_ALL),
	BITFIELD(WORN_RENDER_SLOT_ALLOW_DEFAULT),
	BITFIELD(WORN_RENDER_INHAND_ALLOW_DEFAULT),
	BITFIELD(WORN_RENDER_SLOT_NO_RENDER),
	BITFIELD(WORN_RENDER_INHAND_NO_RENDER),
	BITFIELD(WORN_RENDER_SLOT_USE_PLURAL),
))

//! list indices for resolve_worn_assets
//? the fact this proc is necessary is bad, so, we'll remove it later for something better.
//? see: we'll do that when all the snowflaking is out of the codebase.
#define WORN_DATA_ICON 1
#define WORN_DATA_STATE 2
#define WORN_DATA_LAYER 3
#define WORN_DATA_SIZE_X 4
#define WORN_DATA_SIZE_Y 5
#define WORN_DATA_LIST_SIZE 5
