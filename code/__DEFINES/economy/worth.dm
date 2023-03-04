//? op flags for /atom/proc/get_worth
/// consider intrinsic value
#define GET_WORTH_INTRINSIC (1<<0)
/// consider raw materials value of the item itself
#define GET_WORTH_MATERIALS (1<<1)
/// consider value of what's inside the item
#define GET_WORTH_CONTAINING (1<<2)

/// default flags for /atom/proc/get_worth
#define GET_WORTH_DEFAULT (GET_WORTH_INTRINSIC | GET_WORTH_MATERIALS | GET_WORTH_CONTAINING)

//? factors for worth_buy_factor - multiplier for core worth system

/// 1.05x intrinsic markup default
#define WORTH_BUY_FACTOR_DEFAULT 1.05

//? elasticities for worth_elasticity - arbitrary multipliers

/// default 1x elasticitiy
#define WORTH_ELASTICITY_DEFAULT 1

//? categories for reagents

#define ECONOMIC_CATEGORY_REAGENT_DEFAULT (NONE)

/// medicine
#define ECONOMIC_CATEGORY_REAGENT_MEDICINE (1<<0)
/// raw materials like iron / gold / phoron /etc
#define ECONOMIC_CATEGORY_REAGENT_RAW (1<<1)
/// drugs :devil:
#define ECONOMIC_CATEGORY_REAGENT_NARCOTICS (1<<2)
/// poisons, lethal or otherwise
#define ECONOMIC_CATEGORY_REAGENT_POISON (1<<3)
/// explosives, chlorine triflouride-like fire, etc
#define ECONOMIC_CATEGORY_REAGENT_PYROTECHNICS (1<<4)
/// exotic / rare reagents
#define ECONOMIC_CATEGORY_REAGENT_EXOTIC (1<<5)
/// agricultural
#define ECONOMIC_CATEGORY_REAGENT_AGRICULTURAL (1<<6)
/// food / whatever
#define ECONOMIC_CATEGORY_REAGENT_FOOD (1<<7)
/// crayon powder, recreational coloring, etc
#define ECONOMIC_CATEGORY_REAGENT_TOYS (1<<8)

DEFINE_BITFIELD(economic_category_reagent, list(
	BITFIELD(ECONOMIC_CATEGORY_REAGENT_MEDICINE),
	BITFIELD(ECONOMIC_CATEGORY_REAGENT_RAW),
	BITFIELD(ECONOMIC_CATEGORY_REAGENT_NARCOTICS),
	BITFIELD(ECONOMIC_CATEGORY_REAGENT_POISON),
	BITFIELD(ECONOMIC_CATEGORY_REAGENT_PYROTECHNICS),
	BITFIELD(ECONOMIC_CATEGORY_REAGENT_EXOTIC),
	BITFIELD(ECONOMIC_CATEGORY_REAGENT_AGRICULTURAL),
	BITFIELD(ECONOMIC_CATEGORY_REAGENT_FOOD),
	BITFIELD(ECONOMIC_CATEGORY_REAGENT_TOYS),
))
