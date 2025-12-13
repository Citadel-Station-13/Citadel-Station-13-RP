//* payment_type bitflags *//

/// cash
#define PAYMENT_TYPE_CASH				(1<<0)
/// chargecard; basically electronic cash wallet
#define PAYMENT_TYPE_CHARGE_CARD		(1<<1)
/// bank-linked account
#define PAYMENT_TYPE_BANK_CARD			(1<<2)

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
/// do not allow user input
#define PAYMENT_OP_SKIP_USER_INPUT (1<<2)

//* payment_result enums *//

#define PAYMENT_RESULT_UNSET "unset"
#define PAYMENT_RESULT_SUCCESS "success"
#define PAYMENT_RESULT_INSUFFICIENT "insufficient"
#define PAYMENT_RESULT_ERROR "error"
