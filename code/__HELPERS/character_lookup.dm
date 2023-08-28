#define LOOKUP_TABLE "character_lookup"
/*
A character lookup is essentially connecting four things:
1. A character name, formatted using ckey() referred to as 'charactername'
2. The player's ckey, formatted using ckey() referred to as 'playerid'
3. The character 'type', i.e. if it is for storing pAI data, AI data, human data, etc
4. A unique ID representing the connection between the above values, called 'characterid'

The reason being that multiple characters with the same name, will have the same characterid, and in turn can share persistence.
If a player wants two characters with different names to share persistence, we can then alter the characterid for one of the entries.

The helper methods below will serve to make these changes to the rp_character_lookup table
*/

/// DB Methods
/proc/get_character_lookup(player_id, character_name, character_type)
	var/formatted_player_id = ckey(player_id)
	var/formatted_character_name = ckey(character_name)

	/// Return character id for the combination of player id, character name, character type
	var/sql = "SELECT character_id FROM [format_table_name(LOOKUP_TABLE)] WHERE player_id = :playerid AND character_name = :charactername AND character_type = :charactertype"

	if(!SSdbcore.Connect())
		return

	var/datum/db_query/query = SSdbcore.RunQuery(
		sql,
		list(
			"playerid" = formatted_player_id,
			"charactername" = formatted_character_name,
			"charactertype" = character_type
		)
	)

	if(query.NextRow())
		return query.item[1]
	else
		return

/proc/add_character_lookup(player_id, character_name, character_type)
	var/formatted_player_id = ckey(player_id)
	var/formatted_character_name = ckey(character_name)

	/// If an entry already exists, don't try to create one
	var/lookup = get_character_lookup(player_id, character_name, character_type)
	if(lookup)
		return

	/// Entry does not exist, add it
	var/character_id = generate_character_id(character_type, character_name)
	var/sql = "INSERT INTO [format_table_name(LOOKUP_TABLE)] (player_id, character_id, character_name, character_type) VALUES (:playerid, :characterid, :charactername, :charactertype)"

	if(!SSdbcore.Connect())
		return

	SSdbcore.RunQuery(
		sql,
		list(
			"playerid" = formatted_player_id,
			"characterid" = character_id,
			"charactername" = formatted_character_name,
			"charactertype" = character_type
		)
	)

/proc/remove_character_lookup(player_id, character_name, character_type)
	var/formatted_player_id = ckey(player_id)
	var/formatted_character_name = ckey(character_name)

	/// If an entry does not exist, log that it happened, and don't try to delete it
	var/lookup = get_character_lookup(player_id, character_name, character_type)
	if(!lookup)
		message_admins("Attempted to remove lookup for [formatted_player_id] but it did not exist! (Character name: [formatted_character_name], Type: [character_type])")
		return

	/// Entry exists, delete it
	var/sql = "DELETE FROM [format_table_name(LOOKUP_TABLE)] WHERE player_id = :playerid AND character_name = :charactername AND character_type = :charactertype"

	if(!SSdbcore.Connect())
		return

	SSdbcore.RunQuery(
		sql,
		list(
			"playerid" = formatted_player_id,
			"charactername" = formatted_character_name,
			"charactertype" = character_type
		)
	)

// Misc Methods
/proc/generate_character_id(character_type, character_name)
	return ckey(character_type) + "-" + ckey(character_name)

#undef LOOKUP_TABLE
