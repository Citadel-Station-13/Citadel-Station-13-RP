//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//! Atom destruction types, used in /deconstruct() and its derived/child/called functions. These are flags for checks, but should always be single values in params.

/// Atom was neatly deconstructed
#define ATOM_DECONSTRUCT_DISASSEMBLED (1<<0)
/// Atom received excess kinetic energy, usually through weaponry
#define ATOM_DECONSTRUCT_DESTROYED (1<<1)
/// Atom was the victim of a corrosive or caustic chemical
#define ATOM_DECONSTRUCT_ACID (1<<2)
/// Atom was put out of commission by an unexpected thermal event
#define ATOM_DECONSTRUCT_FIRE (1<<3)
