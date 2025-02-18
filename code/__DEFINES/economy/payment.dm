//* payment_type bitflags *//

/// coins
#define PAYMENT_TYPE_COIN				(1<<0)
/// cash
#define PAYMENT_TYPE_CASH				(1<<1)
/// chargecard; basically electronic cash wallet
#define PAYMENT_TYPE_CHARGE_CARD		(1<<2)
/// bank-linked account
#define PAYMENT_TYPE_BANK_CARD			(1<<3)

/// all payment typesw
#define PAYMENT_TYPE_ALL				ALL
/// only these types
#define PAYMENT_TYPES_ALLOW_ONLY(types)		(~(types))
/// prevent these types
#define PAYMENT_TYPES_EXCEPT_FOR(types)		(~(types))

//* payment op flags *//

/// no sound
#define PAYMENT_OP_SILENT (1<<0)
/// no message
#define PAYMENT_OP_SUPPRESSED (1<<1)

//* payment_result enums *//

#define PAYMENT_RESULT_UNSET "unset"
#define PAYMENT_RESULT_SUCCESS "success"
#define PAYMENT_RESULT_INSUFFICIENT "insufficient"
#define PAYMENT_RESULT_ERROR "error"
