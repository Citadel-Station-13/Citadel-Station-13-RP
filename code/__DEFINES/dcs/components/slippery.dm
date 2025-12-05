//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station developers.          *//

/**
 * Slip classes
 *
 * Despite being defined in the component file, this may be used basically everywhere.
 */

/// water slip
#define SLIP_CLASS_WATER (1<<0)
/// lube slip
#define SLIP_CLASS_LUBRICANT (1<<1)
/// oil slip
///
/// * sensically this is just weaker [SLIP_CLASS_LUBRICANT]
#define SLIP_CLASS_OIL (1<<2)
/// no-grav / no-friction slips
///
/// * used for very futuristic slips
#define SLIP_CLASS_KINESIS (1<<3)
/// ice-like surfaces
#define SLIP_CLASS_ICE (1<<4)
/// foam surfaces
///
/// * not necessarily as bad as [SLIP_CLASS_OIL] but also specialized
#define SLIP_CLASS_FOAM (1<<5)

// todo: DEFINE_BITFIELD_NAMED
