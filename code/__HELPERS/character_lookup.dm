#define LOOKUP_TABLE character_lookup
/*
A character lookup is essentially connecting three things:
1. A character name, formatted using ckey() referred to as 'charactername'
2. The player's ckey, formatted using ckey() referred to as 'playerid'
3. A combination of both charactername and playerid, called 'characterid'

The reason being that multiple characters with the same name, will have the same characterid, and in turn can share persistence.
If a player wants two characters with different names to share persistence, we can then alter the characterid for one of the entries.

The helper methods below will serve to make these changes to the rp_character_lookup table
*/

/// DB Methods
/proc/get_character_lookup(player_id, character_name)
	var/formatted_player_id = ckey(player_id)
	var/formatted_character_name = ckey(character_name)

	/// In the unlikely scenario no such entry exists for the player, create one, and log that this happened
	var/sql = "SELECT characterid FROM [format_table_name(LOOKUP_TABLE)] WHERE playerid = :playerid AND charactername = :charactername"

	if(!SSdbcore.Connect())
		return

	var/datum/db_query/query = SSdbcore.RunQuery(
		sql,
		list(
			"playerid" = formatted_player_id,
			"charactername" = formatted_character_name
		)
	)

	if(query.NextRow())
		return query.item[1]
	else
		message_admins("No character lookup could be found for [formatted_player_id]")
		return

/proc/add_character_lookup(player_id, character_name)
	var/formatted_player_id = ckey(player_id)
	var/formatted_character_name = ckey(character_name)

	/// If an entry already exists, log that it happened and don't try to create one

/proc/update_character_lookup(player_id, old_character_name, new_character_name)
	var/formatted_player_id = ckey(player_id)
	var/formatted_old_character_name = ckey(old_character_name)
	var/formatted_new_character_name = ckey(new_character_name)

	/// Only update the character lookup table entry if no other entry exists with that player id AND new character id
	/// If such an entry exists, delete the current one instead, because the pairing of these values is the primary key, and should be unique


/// Misc Helpers
/proc/generate_character_id(formatted_player_id, formatted_character_name)


#undefine LOOKUP_TABLE
