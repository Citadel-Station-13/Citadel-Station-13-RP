//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* raise fault types *//

/// ground fault: power is going somewhere else other than the circuit
///
/// args: (duration)
///
/// * someone is getting shocked
/// * arc flash to other objects
#define POWERNET_FAULT_GROUND "ground-fault"
/// surge fault: power is being rapidly used at an unreasonable rate
///
/// args: (duration)
///
/// * unrealistic as this is, this is usually used for 'this thing is draining everything on the network, not just the powernet'
/// * power sinks
/// * massive machinery that blows out network, etc
#define POWERNET_FAULT_DRAIN "drain"
