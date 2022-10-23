/**
 *! ## /mob/silicon Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

/// Sent from borg recharge stations: (amount, repairs)
////#define COMSIG_PROCESS_BORGCHARGER_OCCUPANT "living_charge"
/// Sent from borg mobs to itself, for tools to catch an upcoming destroy() due to safe decon (rather than detonation)
////#define COMSIG_BORG_SAFE_DECONSTRUCT "borg_safe_decon"
