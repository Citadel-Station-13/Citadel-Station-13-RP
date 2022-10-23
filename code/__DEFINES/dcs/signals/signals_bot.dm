/**
 *! ## Bot Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

/// Called in /obj/structure/moneybot/add_money(). (to_add)
////#define COMSIG_MONEYBOT_ADD_MONEY "moneybot_add_money"

/// Called in /obj/structure/dispenserbot/add_item(). (obj/item/to_add)
////#define COMSIG_DISPENSERBOT_ADD_ITEM "moneybot_add_item"

/// Called in /obj/structure/dispenserbot/remove_item(). (obj/item/to_remove)
////#define COMSIG_DISPENSERBOT_REMOVE_ITEM "moneybot_remove_item"
