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

#warn below stuff

// /economic_category - an item's major economic category
/// default
#define ECONOMIC_CATEGORY_DEFAULT					"default"
/// firearms
#define ECONOMIC_CATEGORY_FIREARM


