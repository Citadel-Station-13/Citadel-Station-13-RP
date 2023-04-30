// payment_type bitflags
/// coin
#define PAYMENT_TYPE_COIN				(1<<0)
/// cash
#define PAYMENT_TYPE_CASH				(1<<1)
/// holochips
#define PAYMENT_TYPE_HOLOCHIPS          (1<<2)
/// some kind of bank card that's linked to an account
#define PAYMENT_TYPE_BANK_CARD			(1<<3)
/// chargecard
#define PAYMENT_TYPE_CHARGE_CARD		(1<<4)

/// not a method - example for something that can be blocked/filtered - this payment type requires biometric authentication
#define PAYMENT_TYPE_BIOMETRIC			(1<<23)

/// all payment types
#define PAYMENT_TYPE_ALL				ALL
/// only these types
#define PAYMENT_TYPES_ALLOW_ONLY(types)		(~(types))
/// prevent these types
#define PAYMENT_TYPES_EXCEPT_FOR(types)		(~(types))

// kinds of static currency
/// not static currency
#define NOT_STATIC_CURRENCY				0
/// discrete object, e.g. coins, chargecards
#define DISCRETE_STATIC_CURRENCY			1
/// stack, e.g. cash, holochips
#define PLURAL_STATIC_CURRENCY			2

// attempt_dynamic_payment and attempt_use_currency
/// successful - syntatically, even 0 is fine
#define PAYMENT_SUCCESS				0
/// errored
#define PAYMENT_DYNAMIC_ERROR		-1
/// didn't try at all
#define PAYMENT_NOT_CURRENCY		-2
/// not enough money - this is only for "dumb" currency, if it's a dynamic method use payment error for logical errors like "bank account insufficient" and return error
#define PAYMENT_INSUFFICIENT		-3

// list return for /datum/proc/transaction_charge_details(list/data)
/// recipient identity
#define CHARGE_DETAIL_RECIPIENT				"recipient"
/// location as string - **player facing** so feel free to obfuscate this
#define CHARGE_DETAIL_LOCATION				"location"
/// machine/charge device identity
#define CHARGE_DETAIL_DEVICE				"device"
/// reason field
#define CHARGE_DETAIL_REASON				"reason"


// datalist for dynamic payment keys
/// error message on failure
#define DYNAMIC_PAYMENT_DATA_FAIL_REASON		"fail_reason"
/// paid amount
#define DYNAMIC_PAYMENT_DATA_PAID_AMOUNT		"amount"
/// bank account used if any
#define DYNAMIC_PAYMENT_DATA_BANK_ACCOUNT       "account"
/// payment type used
#define DYNAMIC_PAYMENT_DATA_CURRENCY_TYPE		"currency_type"
