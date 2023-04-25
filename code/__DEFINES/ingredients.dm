//? types; sync to tgui when modifying.

#define INGREDIENT_DATA_TYPE "type"
#define INGREDIENT_DATA_AMOUNT "amt"
#define INGREDIENT_DATA_ALLOW "allow"

/// datatype: material id; amount: sheets; allowed: id, list of ids, null for any
#define INGREDIENT_TYPE_MATERIAL "material"
/// datatype: reagent id; amount: units; allowed: id, list of ids, null for any
#define INGREDIENT_TYPE_REAGENT "reagent"
/// datatype: stack path; amount: sheets; allowed: path, list of paths, null for any
#define INGREDIENT_TYPE_STACK "stack"
/// datatype :typepath; amount: items; allowed: path, list of paths, null for any - associate TRUE in list to enforce exact typepath.
#define INGREDIENT_TYPE_ITEM "item"
