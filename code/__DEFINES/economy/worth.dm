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

//? categories for objs

#define ECONOMIC_CATEGORY_OBJ_DEFAULT (NONE)

/// hazardous materials
#define ECONOMIC_CATEGORY_OBJ_HAZARD (1<<0)
/// alien tech / anomalous tech
#define ECONOMIC_CATEGORY_OBJ_ALIEN (1<<1)
/// occultist
#define ECONOMIC_CATEGORY_OBJ_OCCULT (1<<2)
/// exotic tech / goods
#define ECONOMIC_CATEGORY_OBJ_EXOTIC (1<<3)

/proc/economic_category_obj_name(cat)
	var/static/list/lookup = list(
		"Hazardous Materials",
		"Alien Technology",
		"Occult Debris",
		"Exotic Goods",
	)
	return (cat && lookup[min(9, log(2, cat) + 1)]) || "Miscellaneous"

#warn define bitfield

//? categories for items

#define ECONOMIC_CATEGORY_ITEM_DEFAULT (NONE)

/// basic fashion
#define ECONOMIC_CATEGORY_ITEM_CLOTHING (1<<0)
/// non-basic fashion
#define ECONOMIC_CATEGORY_ITEM_FASHION (1<<1)
/// ranged weapons
#define ECONOMIC_CATEGORY_ITEM_GUN (1<<2)
/// melee weapons
#define ECONOMIC_CATEGORY_ITEM_MELEE (1<<3)
/// armor, shields ,etc
#define ECONOMIC_CATEGORY_ITEM_ARMOR (1<<4)
/// basic tools / engineering equipment
#define ECONOMIC_CATEGORY_ITEM_TOOL (1<<5)
/// engineering equipment / advanced tools
#define ECONOMIC_CATEGORY_ITEM_ENGINEERING (1<<6)
/// medical equipment / tools
#define ECONOMIC_CATEGORY_ITEM_MEDICAL (1<<7)
/// advanced medical equpiment / tools
#define ECONOMIC_CATEGORY_ITEM_SURGICAL (1<<8)
/// recreational / toys
#define ECONOMIC_CATEGORY_ITEM_TOY (1<<9)
/// collectable items, trading cards, etc
#define ECONOMIC_CATEGORY_ITEM_COLLECTABLE (1<<10)
/// paperwork, camera, etc
#define ECONOMIC_CATEGORY_ITEM_PAPERWORK (1<<11)
/// advanced electronics like pda, tablets, computers, etc
#define ECONOMIC_CATEGORY_ITEM_ELECTRONICS (1<<12)

/proc/economic_category_item_name(cat)
	var/static/list/lookup = list(
		"Clothing",
		"Fashion",
		"Ranged Weapons",
		"Melee Weapons",
		"Armor / Shields",
		"Tools",
		"Engineering Equipment",
		"Medical Tools",
		"Medical Equipment",
		"Toys",
		"Collectables",
		"Recordkeeping",
		"Information Technology",
	)
	return (cat && lookup[min(9, log(2, cat) + 1)]) || "Miscellaneous"

#warn define bitfield

//? categories for mobs

#define ECONOMIC_CATEGORY_MOB_DEFAULT (NONE)

//? categories for materials

#define ECONOMIC_CATEGORY_MATERIAL_DEFAULT (NONE)

#warn add more

/proc/economic_category_material_name(cat)
	var/static/list/lookup = list(
	)
	return (cat && lookup[min(9, log(2, cat) + 1)]) || "Miscellaneous"

#warn define bitfield

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

/proc/economic_category_reagent_name(cat)
	var/static/list/lookup = list(
		"Medicine",
		"Raw Reagents",
		"Drugs",
		"Toxins",
		"Explosives",
		"Exotic",
		"Hydroponics",
		"Catering",
		"Toy Products",
	)
	return (cat && lookup[min(9, log(2, cat) + 1)]) || "Miscellaneous"
