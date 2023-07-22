// loadout categories (A-Z)
#define LOADOUT_CATEGORY_ACCESSORIES "Accessories"
#define LOADOUT_CATEGORY_COSMETICS "Cosmetics"
#define LOADOUT_CATEGORY_DONATOR "Donator"
#define LOADOUT_CATEGORY_EARS "Earwear"
#define LOADOUT_CATEGORY_EVENTS "Event Rewards"
#define LOADOUT_CATEGORY_GENERAL "General"
#define LOADOUT_CATEGORY_GLASSES "Glasses and Eyewear"
#define LOADOUT_CATEGORY_GLOVES "Gloves and Handwear"
#define LOADOUT_CATEGORY_HATS "Hats and Headwear"
#define LOADOUT_CATEGORY_MASKS "Masks and Facewear"
#define LOADOUT_CATEGORY_ROLE_RESTRICTED "Role Restricted"
#define LOADOUT_CATEGORY_SEASONAL "Seasonal Items"
#define LOADOUT_CATEGORY_SEASONAL_CHRISTMAS "Seasonal - Christmas"
#define LOADOUT_CATEGORY_SEASONAL_HALLOWEEN "Seasonal - Halloween"
#define LOADOUT_CATEGORY_SHOES "Shoes and Footwear"
#define LOADOUT_CATEGORY_SUITS "Suits and Overwear"
#define LOADOUT_CATEGORY_UNIFORMS "Uniforms and Casual Dress"
#define LOADOUT_CATEGORY_UTILITY "Utility"
#define LOADOUT_CATEGORY_XENOWEAR "Xenowear"

/// allow customizing name
#define LOADOUT_CUSTOMIZE_NAME (1<<0)
/// allow customizing desc
#define LOADOUT_CUSTOMIZE_DESC (1<<1)
/// allow customizing color
#define LOADOUT_CUSTOMIZE_COLOR (1<<2)

DEFINE_BITFIELD(loadout_customize_flags, list(
	BITFIELD(LOADOUT_CUSTOMIZE_NAME),
	BITFIELD(LOADOUT_CUSTOMIZE_DESC),
	BITFIELD(LOADOUT_CUSTOMIZE_COLOR),
))

// *DO NOT RAISE THIS. This is for performance reasons.* //
#define LOADOUT_MAX_SLOTS 10
#define LOADOUT_SLOT_NAME_LENGTH 32
#define LOADOUT_MAX_ITEMS 30
/// Used in chargen for accessory loadout limit.
#define LOADOUT_MAX_COST					20
/// Used in chargen for accessory loadout limit on holidays.
#define LOADOUT_MAX_COST_HOLIDAY_SPAM		30

#define LOADOUT_SLOTDATA_NAME "name"
#define LOADOUT_SLOTDATA_ENTRIES "entries"

#define LOADOUT_ENTRYDATA_RENAME "rename"
#define LOADOUT_ENTRYDATA_REDESC "redesc"
#define LOADOUT_ENTRYDATA_RECOLOR "recolor"
#define LOADOUT_ENTRYDATA_TWEAKS "tweaks"
