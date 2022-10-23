/// sent on attempt_dynamic_currency: (list/query) - register on the list to be dynamic_currency_call signal'd
#define COMSIG_ITEM_DYNAMIC_CURRENCY_QUERY		"dynamic_currency_query"
/// sent on attempt_dynamic_currency: (mob/user, atom/movable/predicate, amount, force, prevent_types, list/data, silent, visual_range = 7)
#define COMSIG_ITEM_DYNAMIC_CURRENCY_CALL		"dynamic_currency_call"
	#define COMPONENT_HANDLED_PAYMENT		(1<<0)
	#define COMPONENT_ERRORED_PAYMENT		(1<<1)
	#define COMPONENT_INSUFFICIENT_PAYMENT	(1<<2)
