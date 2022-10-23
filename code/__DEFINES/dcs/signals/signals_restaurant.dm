/**
 *! ## Restaurant Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

/// (customer, container) venue signal sent when a venue sells an item. source is the thing sold, which can be a datum, so we send container for location checks
////#define COMSIG_ITEM_SOLD_TO_CUSTOMER "item_sold_to_customer"
