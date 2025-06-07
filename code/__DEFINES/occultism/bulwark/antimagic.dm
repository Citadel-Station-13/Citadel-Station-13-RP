//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

//* Antimagic call args *//

/// magic potency
#define ANTIMAGIC_ARG_POTENCY 1
/// magic type
#define ANTIMAGIC_ARG_TYPE 2
/// magic data
#define ANTIMAGIC_ARG_DATA 3
/// antimagic call flagsj
#define ANTIMAGIC_ARG_FLAGS 4
/// entity doing the blocking
#define ANTIMAGIC_ARG_TARGET 5
/// magic target zone
#define ANTIMAGIC_ARG_TARGET_ZONE 6

//* Antimagic call flags *//

/// stop iterating
#define ANTIMAGIC_FLAG_TERMINATE (1<<0)

//* Antimagic Priorities; lower is higher *//

#define ANTIMAGIC_PRIORITY_DEFAULT 0
#define ANTIMATIC_PRIORITY_INVENTORY(SLOT_LOGICAL_LAYER) 1
