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

// list return for /datum/proc/transaction_charge_details(list/data)
/// recipient identity
#define CHARGE_DETAIL_RECIPIENT				"recipient"
/// location as string - **player facing** so feel free to obfuscate this
#define CHARGE_DETAIL_LOCATION				"location"
/// machine/charge device identity
#define CHARGE_DETAIL_DEVICE				"device"
