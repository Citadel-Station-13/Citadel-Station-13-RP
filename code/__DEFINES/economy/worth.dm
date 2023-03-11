//? op flags for /atom/proc/worth
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
	switch(cat)
		if(ECONOMIC_CATEGORY_OBJ_HAZARD)
			return "Hazardous Materials"
		if(ECONOMIC_CATEGORY_OBJ_ALIEN)
			return "Alien Technology"
		if(ECONOMIC_CATEGORY_OBJ_OCCULT)
			return "Occult Debris"
		if(ECONOMIC_CATEGORY_OBJ_EXOTIC)
			return "Exotic Goods"
		else
			return "Miscellaneous"

DEFINE_BITFIELD(economic_category_obj, list(
	BITFIELD(ECONOMIC_CATEGORY_OBJ_HAZARD),
	BITFIELD(ECONOMIC_CATEGORY_OBJ_ALIEN),
	BITFIELD(ECONOMIC_CATEGORY_OBJ_OCCULT),
	BITFIELD(ECONOMIC_CATEGORY_OBJ_EXOTIC),
))

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
	switch(cat)
		if(ECONOMIC_CATEGORY_ITEM_CLOTHING)
			return "Clothing"
		if(ECONOMIC_CATEGORY_ITEM_FASHION)
			return "Fashion"
		if(ECONOMIC_CATEGORY_ITEM_GUN)
			return "Ranged Weaponry"
		if(ECONOMIC_CATEGORY_ITEM_MELEE)
			return "Melee Weaponry"
		if(ECONOMIC_CATEGORY_ITEM_ARMOR)
			return "Defense Equipment"
		if(ECONOMIC_CATEGORY_ITEM_TOOL)
			return "Tools"
		if(ECONOMIC_CATEGORY_ITEM_ENGINEERING)
			return "Engineering Equipment"
		if(ECONOMIC_CATEGORY_ITEM_MEDICAL)
			return "Medicine"
		if(ECONOMIC_CATEGORY_ITEM_SURGICAL)
			return "Medical Equipment"
		if(ECONOMIC_CATEGORY_ITEM_TOY)
			return "Toys"
		if(ECONOMIC_CATEGORY_ITEM_COLLECTABLE)
			return "Collectables"
		if(ECONOMIC_CATEGORY_ITEM_PAPERWORK)
			return "Recordkeeping"
		if(ECONOMIC_CATEGORY_ITEM_ELECTRONICS)
			return "Information Technology"
		else
			return "Miscellaneous"

DEFINE_BITFIELD(economic_category_item, list(
	BITFIELD(ECONOMIC_CATEGORY_ITEM_CLOTHING),
	BITFIELD(ECONOMIC_CATEGORY_ITEM_FASHION),
	BITFIELD(ECONOMIC_CATEGORY_ITEM_GUN),
	BITFIELD(ECONOMIC_CATEGORY_ITEM_MELEE),
	BITFIELD(ECONOMIC_CATEGORY_ITEM_ARMOR),
	BITFIELD(ECONOMIC_CATEGORY_ITEM_TOOL),
	BITFIELD(ECONOMIC_CATEGORY_ITEM_ENGINEERING),
	BITFIELD(ECONOMIC_CATEGORY_ITEM_MEDICAL),
	BITFIELD(ECONOMIC_CATEGORY_ITEM_SURGICAL),
	BITFIELD(ECONOMIC_CATEGORY_ITEM_TOY),
	BITFIELD(ECONOMIC_CATEGORY_ITEM_COLLECTABLE),
	BITFIELD(ECONOMIC_CATEGORY_ITEM_PAPERWORK),
	BITFIELD(ECONOMIC_CATEGORY_ITEM_ELECTRONICS),
))

//? categories for mobs

#define ECONOMIC_CATEGORY_MOB_DEFAULT (NONE)

/// "normal" livestock
#define ECONOMIC_CATEGORY_MOB_LIVESTOCK (1<<0)

/proc/economic_category_mob_name(cat)
	switch(cat)
		if(ECONOMIC_CATEGORY_MOB_LIVESTOCK)
			return "Livestock"
		else
			return "Miscellaneous"

DEFINE_BITFIELD(economic_category_mob, list(
	BITFIELD(ECONOMIC_CATEGORY_MOB_LIVESTOCK),
))

//? categories for materials

#define ECONOMIC_CATEGORY_MATERIAL_DEFAULT (NONE)

/// staple bulk construction materials
#define ECONOMIC_CATEGORY_MATERIAL_CONSTRUCTION (1<<0)
/// luxury goods like exotic animal furs or whatever
#define ECONOMIC_CATEGORY_MATERIAL_LUXURY (1<<1)
/// industrial stuff
#define ECONOMIC_CATEGORY_MATERIAL_INDUSTRIAL (1<<2)
/// rare earth stuff like diamonds
#define ECONOMIC_CATEGORY_MATERIAL_RARE (1<<3)
/// extremely rare stuff like morphium
#define ECONOMIC_CATEGORY_MATERIAL_EXOTIC (1<<4)
/// biological like wood or whatever
#define ECONOMIC_CATEGORY_MATERIAL_ORGANIC (1<<5)

/proc/economic_category_material_name(cat)
	switch(cat)
		if(ECONOMIC_CATEGORY_MATERIAL_CONSTRUCTION)
			return "Bulk Construction"
		if(ECONOMIC_CATEGORY_MATERIAL_LUXURY)
			return "Luxury Materials"
		if(ECONOMIC_CATEGORY_MATERIAL_INDUSTRIAL)
			return "Industrial Resources"
		if(ECONOMIC_CATEGORY_MATERIAL_RARE)
			return "Rare Elements"
		if(ECONOMIC_CATEGORY_MATERIAL_EXOTIC)
			return "Exotic Matter"
		if(ECONOMIC_CATEGORY_MATERIAL_ORGANIC)
			return "Organic Products"

DEFINE_BITFIELD(economic_category_material, list(
	BITFIELD(ECONOMIC_CATEGORY_MATERIAL_CONSTRUCTION),
	BITFIELD(ECONOMIC_CATEGORY_MATERIAL_LUXURY),
	BITFIELD(ECONOMIC_CATEGORY_MATERIAL_INDUSTRIAL),
	BITFIELD(ECONOMIC_CATEGORY_MATERIAL_RARE),
	BITFIELD(ECONOMIC_CATEGORY_MATERIAL_EXOTIC),
	BITFIELD(ECONOMIC_CATEGORY_MATERIAL_ORGANIC),
))

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
	switch(cat)
		if(ECONOMIC_CATEGORY_REAGENT_MEDICINE)
			return "Medicine"
		if(ECONOMIC_CATEGORY_REAGENT_RAW)
			return "Raw Reagents"
		if(ECONOMIC_CATEGORY_REAGENT_NARCOTICS)
			return "Drugs"
		if(ECONOMIC_CATEGORY_REAGENT_POISON)
			return "Toxins"
		if(ECONOMIC_CATEGORY_REAGENT_PYROTECHNICS)
			return "Explosives"
		if(ECONOMIC_CATEGORY_REAGENT_EXOTIC)
			return "Exotic"
		if(ECONOMIC_CATEGORY_REAGENT_AGRICULTURAL)
			return "Hydroponics"
		if(ECONOMIC_CATEGORY_REAGENT_FOOD)
			return "Catering"
		if(ECONOMIC_CATEGORY_REAGENT_TOYS)
			return "Toy Products"
