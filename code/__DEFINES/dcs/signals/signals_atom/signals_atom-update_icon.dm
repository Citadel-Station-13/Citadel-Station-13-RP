//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/// Called at the base of update_filters()
/// * Signature: ()
/// * Hook this to re-apply managed filters.
/// todo: 516 deprecates this. we will have named filters. rework managed filters to use names.
#define COMSIG_ATOM_RELOAD_FILTERS "atom-reload_filters"
