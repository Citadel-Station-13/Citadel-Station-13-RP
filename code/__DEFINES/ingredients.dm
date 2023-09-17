//? types; sync to tgui when modifying.

#define INGREDIENT_DATA_TYPE "type" //! type of ingredient
#define INGREDIENT_DATA_AMOUNT "amt" //! amount to use; what this means depends on type
#define INGREDIENT_DATA_ALLOW "allow" //! what to allow; data depends on type
#define INGREDIENT_DATA_NAME "name" //! name in selection uis
#define INGREDIENT_DATA_KEY "key" //! what's passed back from use ingredients

/**
 * select: material id
 * amount: sheets
 * allowed: null for any, otherwise list of material ids
 * return: material id
 */
#define INGREDIENT_TYPE_MATERIAL "material"
/**
 * select: reagent id
 * amount: units
 * allowed: null for any, otherwise list of reagent ids
 * return: reagent id
 */
#define INGREDIENT_TYPE_REAGENT "reagent"
/**
 * select: stack path
 * amount: stack amount
 * allowed: null for any, otherwise list of typepaths
 * return: stack path
 */
#define INGREDIENT_TYPE_STACK "stack"
/**
 * select: item ref
 * amount: item count
 * allowed: null for any, otherwise list of typepaths, associate TRUE to enforce exact, otherwise subtypes work
 * return: list of item instances; all selected items are deleted if unkeyed
 */
#define INGREDIENT_TYPE_ITEM "item"
