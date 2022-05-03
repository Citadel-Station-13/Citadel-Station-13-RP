/// sent to check item value as payment: (payment_type, prevent_types, amount, list/considered = list()) - component must add itself to considered associated to amount AND return flag
#define COMSIG_ITEM_PAYMENT_CHECK				"check_payment"
	#define PAYMENT_CAPABLE				(1<<0)		// we can be used to pay for this amount
/// sent to attempt payment: (payment_type, prevent_types, amount, reason, datum/initiator, datum/acceptor, list/data) - **send to one returned datum at a time to prevent doubles**
#define COMSIG_ITEM_ATTEMPT_PAYMENT				"attempt_payment"
	#define PAYMENT_SUCCESS				(1<<0)		// payment succeeded
