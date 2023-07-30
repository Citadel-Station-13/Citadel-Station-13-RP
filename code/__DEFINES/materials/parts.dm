//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/// material part key that a single-material-part object is treated as having
#define MATERIAL_PART_DEFAULT "structure"
/// material_parts value for object does not use material parts system
#define MATERIAL_DEFAULT_DISABLED "DISABLED"
/// material_parts value for object uses hardcoded vars / overrides the abstraction API
#define MATERIAL_DEFAULT_ABSTRACTED "ABSTRACTED"
/// material_parts value for object has a single material but it's absent
#define MATERIAL_DEFAULT_NONE null
/// material ID to pass to Initialize() procs for "erase the default material of this slot"
#define MATERIAL_ID_ERASE "___ERASE___"
