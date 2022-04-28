/**
 *! ## Food Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

/// Called when an item is used as an ingredient: (atom/customized)
////#define COMSIG_ITEM_USED_AS_INGREDIENT "item_used_as_ingredient"
/// Called when an edible ingredient is added: (datum/component/edible/ingredient)
////#define COMSIG_EDIBLE_INGREDIENT_ADDED "edible_ingredient_added"

//! Food Signals
/// From Edible component: (mob/living/eater, mob/feeder, bitecount, bitesize)
////#define COMSIG_FOOD_EATEN "food_eaten"
/// From base of datum/component/edible/on_entered: (mob/crosser, bitecount)
////#define COMSIG_FOOD_CROSSED "food_crossed"

/// From base of Component/edible/On_Consume: (mob/living/eater, mob/living/feeder)
////#define COMSIG_FOOD_CONSUMED "food_consumed"

////#define COMSIG_ITEM_FRIED "item_fried"
	////#define COMSIG_FRYING_HANDLED (1<<0)

//! Drink Signals
/// From base of obj/item/reagent_containers/food/drinks/attack(): (mob/living/M, mob/user)
////#define COMSIG_DRINK_DRANK "drink_drank"
/// From base of obj/item/reagent_containers/glass/attack(): (mob/M, mob/user)
////#define COMSIG_GLASS_DRANK "glass_drank"
