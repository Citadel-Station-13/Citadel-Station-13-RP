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

//* /datum/character_record character_record_type *//

/// incident records, used by security and command staff of one's own faction, usually
#define CHARACTER_RECORD_TYPE_INCIDENT "incident"
/// medical record, used by medical staff of one's own faction, usually
#define CHARACTER_RECORD_TYPE_MEDICAL "medical"
/// employment record, used by leaders or heads of departments of one's own faction, usually
#define CHARACTER_RECORD_TYPE_EMPLOYMENT "employment"
/// exploitable info, used by factions hostile to one's self, usually
#define CHARACTER_RECORD_TYPE_INTELLIGENCE "intelligence"

//* /datum/character_record r_content_type's *//

/// text
#define CHARACTER_RECORD_CONTENT_TYPE_PLAINTEXT "text"
