//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* /datum/character_record character_record_flags *//

/// ICly sealed
///
/// * admins can do this
/// * certain IC sources may be able to do this in the future
#define CHARACTER_RECORD_FLAG_SEALED (1<<0)
/// OOCly deleted
///
/// * only admins can do this
#define CHARACTER_RECORD_FLAG_DELETED (1<<1)
