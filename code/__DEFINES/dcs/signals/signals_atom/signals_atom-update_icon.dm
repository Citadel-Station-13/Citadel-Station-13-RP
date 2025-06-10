//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/// Called at the base of update_filters()
/// * Signature: ()
/// * Hook this to re-apply managed filters.
// TODO: 516 added assoc filters; touch-up the datum filter procs and stop doing this.
#define COMSIG_ATOM_RELOAD_FILTERS "atom-reload_filters"
