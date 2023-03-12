// For convenience and easier comparing and maintaining of item prices,
// all these will be defined here and sorted in different sections.

// The item price in thalers. atom/movable so we can also assign a price to animals and other things.
/atom/movable/var/price_tag = null

// The proc that is called when the price is being asked for. Use this to refer to another object if necessary.
/atom/movable/proc/get_item_cost()
	return price_tag


/datum/reagent/var/price_tag = null

// todo: kill this shit with fire
