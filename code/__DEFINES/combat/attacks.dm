
/// Alternate attack defines. Return these at the end of procs like afterattack_secondary.
/// Calls the normal attack proc. For example, if returned in afterattack_secondary, will call afterattack.
/// Will continue the chain depending on the return value of the non-alternate proc, like with normal attacks.
#define SECONDARY_ATTACK_CALL_NORMAL 1

/// Cancels the attack chain entirely.
#define SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN 2

/// Proceed with the attack chain, but don't call the normal methods.
#define SECONDARY_ATTACK_CONTINUE_CHAIN 3
