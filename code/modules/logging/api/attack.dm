//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/proc/log_weapon_melee(datum/event_args/actor/clickchain/clickchain, clickchain_flags, datum/melee_attack/weapon/style, obj/item/weapon)
	// todo: log style?
	if(Configuration.get_entry(/datum/toml_config_entry/backend/logging/toggles/attack))
		var/str = "ITEM-MELEE: [clickchain.actor_log_string()] --> [clickchain.target] via [weapon] ([weapon.type]) \
		[clickchain_flags & CLICKCHAIN_ATTACK_MISSED ? "(MISSED) " : ""]\
		DMG [weapon.damage_force]-[weapon.damage_type]-[weapon.damage_flag] @ [weapon.damage_tier]m[weapon.damage_mode] \
		I [clickchain.using_intent] TZ [clickchain.target_zone] MUL [clickchain.attack_melee_multiplier] \
		[length(clickchain.data) ? "DATA [json_encode(clickchain.data)]" : ""]"
		WRITE_LOG(GLOB.world_attack_log, str)

/proc/log_unarmed_melee(datum/event_args/actor/clickchain/clickchain, clickchain_flags, datum/melee_attack/unarmed/style)
	if(Configuration.get_entry(/datum/toml_config_entry/backend/logging/toggles/attack))
		var/str = "UNARMED-MELEE: [clickchain.actor_log_string()] --> [clickchain.target] via [style.type] \
		[clickchain_flags & CLICKCHAIN_ATTACK_MISSED ? "(MISSED) " : ""]\
		TZ [clickchain.target_zone] MUL [clickchain.attack_melee_multiplier] \
		[length(clickchain.data) ? "DATA [json_encode(clickchain.data)]" : ""]"
		WRITE_LOG(GLOB.world_attack_log, str)
